const mongoose = require('mongoose');

const inscriptionSchema = new mongoose.Schema({
  parentUid: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  parentEmail: { type: String, required: true },
  enfantNom: { type: String, required: true },
  age: { type: Number, required: true },
  ceinture: { type: String, required: true },
  telephone: { type: String },
  notes: { type: String },
  statut: { type: String, default: 'En attente' }, // 'En attente', 'Reçu', 'Recalé'
  score: { type: Number, default: null },
  commentaire: { type: String, default: '' },
  
  // Specific notes
  kata: { type: Number },
  kumite: { type: Number },
  kihon: { type: Number },
  
  // Admin who graded
  adminUid: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null },
  adminEmail: { type: String, default: null },
}, { timestamps: true });

module.exports = mongoose.model('Inscription', inscriptionSchema);
