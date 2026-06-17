const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '.env') });
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const User = require('./models/User');
const Inscription = require('./models/Inscription');

const app = express();
app.use(cors());
app.use(express.json());

const JWT_SECRET = process.env.JWT_SECRET;
const MONGO_URI = process.env.MONGO_URI;

if (!MONGO_URI) {
  console.error("FATAL ERROR: MONGO_URI environment variable is not defined in .env");
  process.exit(1);
}
if (!JWT_SECRET) {
  console.error("FATAL ERROR: JWT_SECRET environment variable is not defined in .env");
  process.exit(1);
}

mongoose.connect(MONGO_URI)
  .then(() => console.log('Connected to MongoDB!'))
  .catch(err => console.error('MongoDB connection error:', err));

// Middleware to verify JWT
const requireAuth = (req, res, next) => {
  const token = req.headers.authorization;
  if (!token) return res.status(401).json({ error: 'Unauthorized' });
  try {
    const decoded = jwt.verify(token.replace('Bearer ', ''), JWT_SECRET);
    req.user = decoded;
    next();
  } catch (e) {
    res.status(401).json({ error: 'Invalid token' });
  }
};

// 1. Auth: Register
app.post('/api/auth/register', async (req, res) => {
  try {
    const { nom, email, password } = req.body;
    if (!nom || !email || !password) return res.status(400).json({ error: 'All fields required' });

    let user = await User.findOne({ email });
    if (user) return res.status(400).json({ error: 'Email already in use' });

    const hashedPassword = await bcrypt.hash(password, 10);
    user = new User({ nom, email, password: hashedPassword });
    await user.save();

    const token = jwt.sign({ uid: user._id, email: user.email }, JWT_SECRET, { expiresIn: '30d' });
    res.json({ token, user: { uid: user._id, email: user.email, nom: user.nom } });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

// 2. Auth: Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Check if user exists
    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ error: 'User not found' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ error: 'Invalid credentials' });

    const token = jwt.sign({ uid: user._id, email: user.email }, JWT_SECRET, { expiresIn: '30d' });
    res.json({ token, user: { uid: user._id, email: user.email, nom: user.nom } });
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
});

// 3. Create Inscription (Page 2)
app.post('/api/inscriptions', requireAuth, async (req, res) => {
  try {
    const inscription = new Inscription({
      ...req.body,
      parentUid: req.user.uid,
      parentEmail: req.user.email
    });
    await inscription.save();
    res.json(inscription);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create inscription' });
  }
});

// 4. Get My Inscriptions (Last Page)
app.get('/api/inscriptions/my', requireAuth, async (req, res) => {
  try {
    const inscriptions = await Inscription.find({ parentUid: req.user.uid }).sort({ createdAt: -1 });
    res.json(inscriptions);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch inscriptions' });
  }
});

// 5. Get All Inscriptions (Admin Dashboard)
app.get('/api/inscriptions', requireAuth, async (req, res) => {
  try {
    // Only coach should access in a real app, but we will allow for demo
    const inscriptions = await Inscription.find().sort({ createdAt: -1 });
    res.json(inscriptions);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch all inscriptions' });
  }
});

// 6. Update Score (Admin Page)
app.put('/api/inscriptions/:id/score', requireAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    const inscription = await Inscription.findByIdAndUpdate(
      id,
      {
        ...updateData,
        statut: updateData.statut || 'En attente',
        adminUid: req.user.uid,
        adminEmail: req.user.email
      },
      { new: true }
    );
    res.json(inscription);
  } catch (error) {
    res.status(500).json({ error: 'Failed to update score' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
