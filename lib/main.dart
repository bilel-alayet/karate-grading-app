import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// ═══════════════════════════════════════════════════
//  CONFIG — remplace par tes vraies valeurs
// ═══════════════════════════════════════════════════
const _ejService  = 'TON_SERVICE_ID';
const _ejTemplate = 'TON_TEMPLATE_ID';
const _ejKey      = 'TON_PUBLIC_KEY';
const _coachEmail = 'coach@karatepro.com';

// ═══════════════════════════════════════════════════
//  PALETTE
// ═══════════════════════════════════════════════════
const kBg     = Color(0xFFF0F1FF);
const kWhite  = Colors.white;
const kV1     = Color(0xFF6B4FBB);
const kV2     = Color(0xFF9171E0);
const kV3     = Color(0xFFBBA4F5);
const kVLight = Color(0xFFE8E2FF);
const kTeal   = Color(0xFF3ECECE);
const kPink   = Color(0xFFE8579A);
const kAmber  = Color(0xFFFFB03E);
const kGreen  = Color(0xFF4FCB8D);
const kDark   = Color(0xFF1A1640);
const kMuted  = Color(0xFF8E8DB0);

const gViolet = LinearGradient(colors: [kV1, kV2],            begin: Alignment.topLeft, end: Alignment.bottomRight);
const gTeal   = LinearGradient(colors: [Color(0xFF3ECECE), Color(0xFF56B8E8)], begin: Alignment.topLeft, end: Alignment.bottomRight);
const gPink   = LinearGradient(colors: [Color(0xFFE8579A), Color(0xFFFF8BC0)], begin: Alignment.topLeft, end: Alignment.bottomRight);
const gAmber  = LinearGradient(colors: [Color(0xFFFFB03E), Color(0xFFFFD280)], begin: Alignment.topLeft, end: Alignment.bottomRight);
const gGreen  = LinearGradient(colors: [Color(0xFF4FCB8D), Color(0xFF8AEAB5)], begin: Alignment.topLeft, end: Alignment.bottomRight);

// ═══════════════════════════════════════════════════
//  MAIN
// ═══════════════════════════════════════════════════
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(KarateProApp());
}

class KarateProApp extends StatefulWidget {
  const KarateProApp({super.key});
  static _KarateProAppState? of(BuildContext context) => context.findAncestorStateOfType<_KarateProAppState>();
  @override
  State<KarateProApp> createState() => _KarateProAppState();
}

class _KarateProAppState extends State<KarateProApp> {
  void refreshApp() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Karate Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: kV1)),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return _Splash();
          if (snapshot.hasData) {
            final user = snapshot.data!;
            final Map<String, dynamic> userMap = {
              'uid': user.uid,
              'email': user.email,
              'nom': user.displayName ?? user.email?.split('@').first,
            };
            return user.email == _coachEmail ? CoachDashboard() : ParentHome(user: userMap);
          }
          return AuthScreen();
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  SPLASH
// ═══════════════════════════════════════════════════
class _Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gViolet),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.sports_martial_arts, size: 60, color: kWhite),
            SizedBox(height: 16),
            Text('Karate Pro', style: TextStyle(fontSize: 28,
                fontWeight: FontWeight.w800, color: kWhite)),
            SizedBox(height: 24),
            CircularProgressIndicator(color: kWhite, strokeWidth: 2),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  EMAIL
// ═══════════════════════════════════════════════════
Future<void> sendEmail({
  required String to,
  required String enfantNom,
  required String ceinture,
  required int score,
  required String statut,
  required String commentaire,
}) async {
  await http.post(
    Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'service_id':  _ejService,
      'template_id': _ejTemplate,
      'user_id':     _ejKey,
      'template_params': {
        'to_email':    to,
        'enfant_nom':  enfantNom,
        'ceinture':    ceinture,
        'score':       '$score',
        'statut':      statut,
        'commentaire': commentaire,
      },
    }),
  );
}

// ═══════════════════════════════════════════════════
//  WIDGETS RÉUTILISABLES
// ═══════════════════════════════════════════════════
class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: kV1.withOpacity(.08),
            blurRadius: 20, offset: Offset(0, 6))],
      ),
      child: child,
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final LinearGradient gradient;
  const _KpiCard({required this.label, required this.value,
      required this.icon, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(
              color: gradient.colors.first.withOpacity(.35),
              blurRadius: 12, offset: Offset(0, 5))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: kWhite.withOpacity(.9), size: 20),
          SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 22,
              fontWeight: FontWeight.w800, color: kWhite, height: 1)),
          SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10,
              color: kWhite.withOpacity(.85))),
        ]),
      ),
    );
  }
}

class _GradBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool loading;
  final LinearGradient gradient;
  const _GradBtn({required this.label, this.icon, this.onTap,
      this.loading = false, this.gradient = gViolet});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity, height: 56,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(
              color: gradient.colors.first.withOpacity(.4),
              blurRadius: 14, offset: Offset(0, 6))],
        ),
        child: Center(
          child: loading
              ? CircularProgressIndicator(color: kWhite, strokeWidth: 2)
              : Row(mainAxisSize: MainAxisSize.min, children: [
                  if (icon != null) ...[
                    Icon(icon, color: kWhite, size: 20),
                    SizedBox(width: 10),
                  ],
                  Text(label, style: TextStyle(color: kWhite,
                      fontSize: 14, fontWeight: FontWeight.w700,
                      letterSpacing: .5)),
                ]),
        ),
      ),
    );
  }
}

class _GradBar extends StatelessWidget {
  final double value;
  final LinearGradient gradient;
  final double height;
  const _GradBar({required this.value, required this.gradient,
      this.height = 8});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: Stack(children: [
        Container(height: height, color: kBg),
        FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
      ]),
    );
  }
}

class _Donut extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;
  final String center, sub;
  final double size;
  const _Donut({required this.values, required this.colors,
      required this.center, required this.sub, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: CustomPaint(
        painter: _DonutPainter(values: values, colors: colors),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(center, style: TextStyle(
                fontSize: size * .2, fontWeight: FontWeight.w800,
                color: kDark, height: 1)),
            Text(sub, style: TextStyle(
                fontSize: size * .1, color: kMuted)),
          ]),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  _DonutPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold(0.0, (a, b) => a + b);
    if (total == 0) return;
    final c  = Offset(size.width / 2, size.height / 2);
    final r  = size.shortestSide / 2 - 6;
    final sw = r * .38;
    double start = -math.pi / 2;
    for (int i = 0; i < values.length; i++) {
      if (values[i] <= 0) continue;
      final sweep = 2 * math.pi * values[i] / total * .92;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r - sw / 2),
        start, sweep, false,
        Paint()
          ..color = colors[i % colors.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = sw
          ..strokeCap = StrokeCap.round,
      );
      start += 2 * math.pi * values[i] / total;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter o) => false;
}

Widget _fieldWidget(TextEditingController ctrl, String hint, IconData icon,
    {bool pwd = false, TextInputType kb = TextInputType.text,
    String? error}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    TextField(
      controller: ctrl, obscureText: pwd, keyboardType: kb,
      style: TextStyle(fontSize: 14, color: kDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kMuted, fontSize: 14),
        prefixIcon: Icon(icon, size: 18,
            color: error != null ? kPink : kMuted),
        filled: true,
        fillColor: error != null ? kPink.withOpacity(.05) : kBg,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: kVLight)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
                color: error != null ? kPink : kVLight, width: 1.2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: kV1, width: 1.8)),
      ),
    ),
    if (error != null) ...[
      SizedBox(height: 5),
      Row(children: [
        Icon(Icons.error_outline, size: 12, color: kPink),
        SizedBox(width: 4),
        Text(error, style: TextStyle(fontSize: 11, color: kPink)),
      ]),
    ],
  ]);
}

Widget _secTitle(String t) {
  return Row(children: [
    Container(width: 4, height: 18,
        decoration: BoxDecoration(gradient: gViolet,
            borderRadius: BorderRadius.circular(2))),
    SizedBox(width: 10),
    Text(t, style: TextStyle(fontSize: 15,
        fontWeight: FontWeight.w700, color: kDark)),
  ]);
}

Widget _lbl(String t) {
  return Align(alignment: Alignment.centerLeft,
    child: Text(t, style: TextStyle(fontSize: 13,
        fontWeight: FontWeight.w600, color: kDark)));
}

// ═══════════════════════════════════════════════════
//  PAGE AUTH
// ═══════════════════════════════════════════════════
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  bool    isLogin = true;
  final   _ec = TextEditingController();
  final   _pc = TextEditingController();
  final   _nc = TextEditingController();
  String? _err;
  bool    _loading = false;

  bool _validEmail(String e) =>
      RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(e);

  Future<void> _submit() async {
    setState(() { _err = null; _loading = true; });
    try {
      if (!_validEmail(_ec.text.trim())) throw 'Adresse email invalide';
      if (_pc.text.length < 6) throw 'Mot de passe trop court (min 6 caractères)';
      
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _ec.text.trim(),
          password: _pc.text,
        );
      } else {
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _ec.text.trim(),
          password: _pc.text,
        );
        await cred.user?.updateDisplayName(_nc.text.trim());
        await FirebaseFirestore.instance.collection('Users').doc(cred.user!.uid).set({
          'email': _ec.text.trim(),
          'nom': _nc.text.trim(),
          'role': 'parent',
        });
      }
      
      if (!mounted) return;
      KarateProApp.of(context)?.refreshApp();
    } on FirebaseAuthException catch (e) {
      setState(() => _err = e.message ?? 'Erreur d\'authentification');
    } catch (e) {
      setState(() =>
          _err = e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            // Header dégradé
            Container(
              height: 240,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [kV1, kV2, Color(0xFFAA80FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
              ),
              child: Stack(children: [
                Positioned(top: -30, right: -30,
                    child: Container(width: 140, height: 140,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: kWhite.withOpacity(.07)))),
                Positioned(bottom: -20, left: 20,
                    child: Container(width: 90, height: 90,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            color: kWhite.withOpacity(.07)))),
                Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(width: 80, height: 80,
                      decoration: BoxDecoration(
                          color: kWhite.withOpacity(.15),
                          borderRadius: BorderRadius.circular(24)),
                      child: Icon(Icons.sports_martial_arts,
                          size: 44, color: kWhite)),
                  SizedBox(height: 14),
                  Text('Karate Pro', style: TextStyle(fontSize: 28,
                      fontWeight: FontWeight.w800, color: kWhite)),
                  SizedBox(height: 4),
                  Text('Espace Parent', style: TextStyle(
                      fontSize: 13, color: kWhite.withOpacity(.8))),
                ])),
              ]),
            ),

            Padding(
              padding: EdgeInsets.all(24),
              child: Column(children: [
                SizedBox(height: 8),
                // Toggle
                Container(height: 50,
                    decoration: BoxDecoration(color: kVLight,
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(children: [
                      _buildTab('Connexion', isLogin,
                          () => setState(() { isLogin = true; _err = null; })),
                      _buildTab('Inscription', !isLogin,
                          () => setState(() { isLogin = false; _err = null; })),
                    ])),
                SizedBox(height: 24),

                if (!isLogin) ...[
                  _lbl('Nom complet'),
                  SizedBox(height: 8),
                  _fieldWidget(_nc, 'Mohamed Ben Ali',
                      Icons.person_outline),
                  SizedBox(height: 16),
                ],
                _lbl('Email'),
                SizedBox(height: 8),
                _fieldWidget(_ec, 'exemple@gmail.com', Icons.mail_outline,
                    kb: TextInputType.emailAddress, error: _err),
                SizedBox(height: 16),
                _lbl('Mot de passe'),
                SizedBox(height: 8),
                _fieldWidget(_pc, '••••••••', Icons.lock_outline, pwd: true),
                SizedBox(height: 28),

                _GradBtn(
                  label: isLogin ? 'SE CONNECTER' : "S'INSCRIRE",
                  icon:  isLogin ? Icons.login : Icons.person_add,
                  onTap: _submit,
                  loading: _loading,
                ),
                SizedBox(height: 20),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(isLogin ? 'Pas de compte ? ' : 'Déjà inscrit ? ',
                      style: TextStyle(fontSize: 13, color: kMuted)),
                  GestureDetector(
                    onTap: () => setState(
                        () { isLogin = !isLogin; _err = null; }),
                    child: Text(
                      isLogin ? "S'inscrire" : 'Se connecter',
                      style: TextStyle(fontSize: 13,
                          fontWeight: FontWeight.w700, color: kV1),
                    ),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildTab(String l, bool active, VoidCallback fn) {
    return Expanded(
      child: GestureDetector(
        onTap: fn,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            gradient: active ? gViolet : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [BoxShadow(color: kV1.withOpacity(.3),
                    blurRadius: 8, offset: Offset(0, 3))]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(l, style: TextStyle(fontSize: 13,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? kWhite : kMuted)),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  PARENT HOME
// ═══════════════════════════════════════════════════
class ParentHome extends StatelessWidget {
  final Map<String, dynamic> user;
  const ParentHome({super.key, required this.user});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBg,
        body: Column(children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [kV1, kV2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32)),
            ),
            child: SafeArea(child: Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Bonjour !', style: TextStyle(
                        fontSize: 13, color: kWhite.withOpacity(.8))),
                    Text((user['nom'] ?? user['email']?.split('@').first) ?? 'Parent',
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.w800, color: kWhite)),
                  ]),
                  GestureDetector(
                    onTap: () => _logout(context),
                    child: Container(width: 40, height: 40,
                        decoration: BoxDecoration(
                            color: kWhite.withOpacity(.15),
                            borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.logout,
                            color: kWhite, size: 18)),
                  ),
                ]),
                SizedBox(height: 16),
                TabBar(
                  labelColor: kWhite,
                  unselectedLabelColor: kWhite.withOpacity(.55),
                  indicator: BoxDecoration(
                      color: kWhite.withOpacity(.18),
                      borderRadius: BorderRadius.circular(10)),
                  tabs: [
                    Tab(text: 'Inscrire mon enfant'),
                    Tab(text: 'Mes résultats'),
                  ],
                ),
              ]),
            )),
          ),
          Expanded(child: TabBarView(children: [
            InscriptionTab(parentUid: user['uid'],
                parentEmail: user['email'] ?? ''),
            ResultatsTab(parentUid: user['uid']),
          ])),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
//  ONGLET INSCRIPTION
// ═══════════════════════════════════════════════════
class InscriptionTab extends StatefulWidget {
  final String parentUid, parentEmail;
  const InscriptionTab({super.key, required this.parentUid,
      required this.parentEmail});

  @override
  State<InscriptionTab> createState() => _InscriptionState();
}

class _InscriptionState extends State<InscriptionTab> {
  final _nc = TextEditingController();
  final _ac = TextEditingController();
  final _tc = TextEditingController();
  final _oc = TextEditingController();
  String _ceinture = 'Blanche';
  bool   _loading  = false;

  final _ceintures = [
    {'label': 'Blanche', 'bg': Color(0xFFF0F0F0), 'fg': Color(0xFF555555)},
    {'label': 'Jaune',   'bg': Color(0xFFFFF9C4), 'fg': Color(0xFF8B6914)},
    {'label': 'Orange',  'bg': Color(0xFFFFE0B2), 'fg': Color(0xFF8B4000)},
    {'label': 'Verte',   'bg': Color(0xFFCCEFD4), 'fg': Color(0xFF1B5E20)},
    {'label': 'Bleue',   'bg': Color(0xFFBBDEFB), 'fg': Color(0xFF0D47A1)},
    {'label': 'Marron',  'bg': Color(0xFFD7CCC8), 'fg': Color(0xFF4E342E)},
    {'label': 'Noire',   'bg': Color(0xFF2C2C3E), 'fg': Colors.white},
  ];

  Future<void> _save() async {
    if (_nc.text.trim().isEmpty || _ac.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: kPink,
          content: Text('Nom et âge sont obligatoires',
              style: TextStyle(color: kWhite))));
      return;
    }
    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance.collection('inscriptions').add({
        'enfantNom': _nc.text.trim(),
        'age': int.parse(_ac.text.trim()),
        'ceinture': _ceinture,
        'telephone': _tc.text.trim(),
        'notes': _oc.text.trim(),
        'parentUid': widget.parentUid,
        'parentEmail': widget.parentEmail,
        'statut': 'En attente',
        'score': null,
        'commentaire': '',
        'adminUid': null,
        'adminEmail': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      _nc.clear(); _ac.clear(); _tc.clear(); _oc.clear();
      setState(() => _ceinture = 'Blanche');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: kGreen,
          content: Row(children: [
            Icon(Icons.check_circle, color: kWhite, size: 18),
            SizedBox(width: 8),
            Text('Inscription enregistrée !',
                style: TextStyle(color: kWhite)),
          ])));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 4),
        // Bannière
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              kV1.withOpacity(.08), kV3.withOpacity(.06)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kV3.withOpacity(.4)),
          ),
          child: Row(children: [
            Container(width: 42, height: 42,
                decoration: BoxDecoration(gradient: gViolet,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.info_outline, color: kWhite, size: 20)),
            SizedBox(width: 12),
            Expanded(child: Text(
                'Inscrivez votre enfant à l\'examen. Vous recevrez son résultat par email.',
                style: TextStyle(fontSize: 12, color: kV1, height: 1.5))),
          ]),
        ),
        SizedBox(height: 22),

        _secTitle('Informations de l\'enfant'),
        SizedBox(height: 12),
        _Card(child: Column(children: [
          _lbl('Nom et prénom *'),
          SizedBox(height: 8),
          _fieldWidget(_nc, 'Ex : Adam Ben Ali', Icons.person_outline),
          SizedBox(height: 16),
          _lbl('Âge *'),
          SizedBox(height: 8),
          _fieldWidget(_ac, 'Ex : 10', Icons.cake_outlined,
              kb: TextInputType.number),
        ])),
        SizedBox(height: 20),

        _secTitle('Ceinture actuelle'),
        SizedBox(height: 12),
        _Card(
          child: Wrap(
            spacing: 8, runSpacing: 8,
            children: _ceintures.map((c) {
              final sel = _ceinture == c['label'];
              return GestureDetector(
                onTap: () =>
                    setState(() => _ceinture = c['label'] as String),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: sel ? c['bg'] as Color : kBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: sel
                            ? (c['fg'] as Color).withOpacity(.5)
                            : kVLight,
                        width: sel ? 1.5 : 1),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (sel) ...[
                      Icon(Icons.check_circle_rounded, size: 13,
                          color: c['fg'] as Color),
                      SizedBox(width: 5),
                    ],
                    Text('Ceinture ${c['label']}',
                        style: TextStyle(fontSize: 12,
                            fontWeight: sel
                                ? FontWeight.w700 : FontWeight.w500,
                            color: sel
                                ? c['fg'] as Color : kMuted)),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),

        _secTitle('Contact'),
        SizedBox(height: 12),
        _Card(child: Column(children: [
          _lbl('Téléphone'),
          SizedBox(height: 8),
          _fieldWidget(_tc, '+216 22 345 678', Icons.phone_outlined,
              kb: TextInputType.phone),
          SizedBox(height: 16),
          _lbl('Notes pour le coach (optionnel)'),
          SizedBox(height: 8),
          TextField(
            controller: _oc, maxLines: 3,
            style: TextStyle(fontSize: 13, color: kDark),
            decoration: InputDecoration(
              hintText: 'Blessure, allergie...',
              hintStyle: TextStyle(color: kMuted, fontSize: 13),
              filled: true, fillColor: kBg,
              contentPadding: EdgeInsets.all(14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: kVLight)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: kVLight)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: kV1, width: 1.8)),
            ),
          ),
        ])),
        SizedBox(height: 28),

        _GradBtn(label: 'INSCRIRE MON ENFANT',
            icon: Icons.send_rounded, onTap: _save, loading: _loading),
        SizedBox(height: 28),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════
//  ONGLET RÉSULTATS
// ═══════════════════════════════════════════════════
class ResultatsTab extends StatelessWidget {
  final String parentUid;
  const ResultatsTab({super.key, required this.parentUid});

  Future<List<dynamic>> _fetchResults() async {
    final query = await FirebaseFirestore.instance
        .collection('inscriptions')
        .where('parentUid', isEqualTo: parentUid)
        .get();
    final docs = query.docs.map((d) {
      final data = d.data();
      data['_id'] = d.id;
      return data;
    }).toList();
    docs.sort((a, b) {
      final tA = a['createdAt'] as Timestamp?;
      final tB = b['createdAt'] as Timestamp?;
      if (tA == null && tB == null) return 0;
      if (tA == null) return 1;
      if (tB == null) return -1;
      return tB.compareTo(tA);
    });
    return docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _fetchResults(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: kV1));
        }
        final docs = snap.data ?? [];
        if (docs.isEmpty) {
          return Center(child: Column(mainAxisSize: MainAxisSize.min,
              children: [
            Container(width: 80, height: 80,
                decoration: BoxDecoration(color: kVLight,
                    borderRadius: BorderRadius.circular(24)),
                child: Icon(Icons.hourglass_empty_rounded,
                    size: 36, color: kV2)),
            SizedBox(height: 16),
            Text('Aucune inscription pour le moment',
                style: TextStyle(color: kMuted, fontSize: 14)),
          ]));
        }
        return ListView(
          padding: EdgeInsets.all(16),
          children: docs.map((doc) {
            final d      = doc as Map<String, dynamic>;
            final statut = d['statut'] as String? ?? 'En attente';
            final score  = d['score'] as int?;
            final gr = statut == 'Reçu' ? gGreen
                : statut == 'Recalé' ? gPink : gAmber;
            final sc = statut == 'Reçu' ? kGreen
                : statut == 'Recalé' ? kPink : kAmber;

            return Container(
              margin: EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(color: kWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                      color: sc.withOpacity(.12),
                      blurRadius: 16, offset: Offset(0, 5))]),
              child: Column(children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      kV1.withOpacity(.05), kV3.withOpacity(.03)]),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Row(children: [
                    Container(width: 46, height: 46,
                        decoration: BoxDecoration(gradient: gViolet,
                            borderRadius: BorderRadius.circular(14)),
                        alignment: Alignment.center,
                        child: Text(
                            (d['enfantNom'] as String? ?? '?')[0]
                                .toUpperCase(),
                            style: TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: kWhite))),
                    SizedBox(width: 12),
                    Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(d['enfantNom'] ?? '',
                          style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w700, color: kDark)),
                      Text('Ceinture ${d['ceinture']} • ${d['age']} ans',
                          style: TextStyle(fontSize: 12, color: kMuted)),
                    ])),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(gradient: gr,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(
                              color: sc.withOpacity(.3),
                              blurRadius: 8, offset: Offset(0, 3))]),
                      child: Text(statut,
                          style: TextStyle(fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: kWhite)),
                    ),
                  ]),
                ),
                if (score != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, children: [
                        Text('Score global', style: TextStyle(
                            fontSize: 12, color: kMuted)),
                        Text('$score / 100', style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800,
                            color: sc)),
                      ]),
                      SizedBox(height: 8),
                      _GradBar(value: score / 100, gradient: gr,
                          height: 10),
                      if ((d['commentaire'] ?? '').toString().isNotEmpty) ...[
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(color: kBg,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Icon(Icons.format_quote_rounded,
                                size: 16, color: kV2),
                            SizedBox(width: 8),
                            Expanded(child: Text(d['commentaire'] ?? '',
                                style: TextStyle(fontSize: 12,
                                    color: kDark, height: 1.5))),
                          ]),
                        ),
                      ],
                    ]),
                  )
                else
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: _GradBar(value: 0, gradient: gAmber,
                        height: 8),
                  ),
              ]),
            );
          }).toList(),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════
//  COACH DASHBOARD
// ═══════════════════════════════════════════════════
class CoachDashboard extends StatelessWidget {
  const CoachDashboard({super.key});

  Future<List<dynamic>> _fetchAll() async {
    final query = await FirebaseFirestore.instance.collection('inscriptions').get();
    final docs = query.docs.map((d) {
      final data = d.data();
      data['_id'] = d.id;
      return data;
    }).toList();
    docs.sort((a, b) {
      final tA = a['createdAt'] as Timestamp?;
      final tB = b['createdAt'] as Timestamp?;
      if (tA == null && tB == null) return 0;
      if (tA == null) return 1;
      if (tB == null) return -1;
      return tB.compareTo(tA);
    });
    return docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: FutureBuilder<List<dynamic>>(
        future: _fetchAll(),
    builder: (ctx, snap) {
          if (!snap.hasData) return _Splash();
          final docs    = snap.data ?? [];
          final total   = docs.length;
          final recus   = docs.where((d) =>
              d['statut'] == 'Reçu').length;
          final recales = docs.where((d) =>
              d['statut'] == 'Recalé').length;
          final attente = docs.where((d) =>
              d['statut'] == 'En attente').length;
          final scores  = docs
              .where((d) => d['score'] != null)
              .map((d) => (d['score'] as int).toDouble())
              .toList();
          final avg = scores.isEmpty
              ? 0.0
              : scores.reduce((a, b) => a + b) / scores.length;

          return Column(children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [kV1, kV2, Color(0xFFAA7FFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36)),
              ),
              child: SafeArea(child: Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(children: [
                  Row(mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      Container(width: 42, height: 42,
                          decoration: BoxDecoration(
                              color: kWhite.withOpacity(.15),
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.sports_martial_arts,
                              color: kWhite, size: 22)),
                      SizedBox(width: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Espace Coach', style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800,
                            color: kWhite)),
                        Text('Tableau de bord', style: TextStyle(
                            fontSize: 11,
                            color: kWhite.withOpacity(.7))),
                      ]),
                    ]),
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      child: Container(width: 40, height: 40,
                          decoration: BoxDecoration(
                              color: kWhite.withOpacity(.15),
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.logout,
                              color: kWhite, size: 18)),
                    ),
                  ]),
                  SizedBox(height: 20),
                  Row(children: [
                    _KpiCard(label: 'Inscrits', value: '$total',
                        icon: Icons.group_rounded, gradient: gViolet),
                    SizedBox(width: 10),
                    _KpiCard(label: 'Reçus', value: '$recus',
                        icon: Icons.check_circle_rounded,
                        gradient: gGreen),
                    SizedBox(width: 10),
                    _KpiCard(label: 'Moy.', value: '${avg.round()}%',
                        icon: Icons.bar_chart_rounded, gradient: gTeal),
                    SizedBox(width: 10),
                    _KpiCard(label: 'Recalés', value: '$recales',
                        icon: Icons.cancel_rounded, gradient: gPink),
                  ]),
                ]),
              )),
            ),

            Expanded(child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(children: [
                SizedBox(height: 4),

                // Donut + barres
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Expanded(flex: 5,
                    child: _Card(padding: EdgeInsets.all(18),
                      child: Column(children: [
                        Align(alignment: Alignment.centerLeft,
                            child: Text('Résultats',
                                style: TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: kDark))),
                        SizedBox(height: 16),
                        _Donut(
                          values: [
                            recus.toDouble(),
                            attente.toDouble(),
                            recales.toDouble(),
                          ],
                          colors: [kGreen, kAmber, kPink],
                          center: '$total',
                          sub: 'élèves',
                          size: 110,
                        ),
                        SizedBox(height: 14),
                        _dotLegend(kGreen,  'Reçus',      recus),
                        SizedBox(height: 6),
                        _dotLegend(kAmber,  'En attente', attente),
                        SizedBox(height: 6),
                        _dotLegend(kPink,   'Recalés',    recales),
                      ]),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(flex: 6,
                    child: _Card(padding: EdgeInsets.all(18),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Score par ceinture',
                            style: TextStyle(fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kDark)),
                        SizedBox(height: 16),
                        ..._beltStats(docs),
                      ]),
                    ),
                  ),
                ]),
                SizedBox(height: 14),

                // Liste élèves
                _Card(padding: EdgeInsets.all(18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, children: [
                      Text('Liste des élèves',
                          style: TextStyle(fontSize: 14,
                              fontWeight: FontWeight.w700, color: kDark)),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: kVLight,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('$total inscrits',
                            style: TextStyle(fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: kV1)),
                      ),
                    ]),
                    SizedBox(height: 14),
                    if (docs.isEmpty)
                      Center(child: Padding(padding: EdgeInsets.all(20),
                          child: Text('Aucun élève inscrit',
                              style: TextStyle(color: kMuted))))
                    else
                      ...docs.map((doc) {
                        final d  = doc as Map<String, dynamic>;
                        final st = d['statut'] as String? ?? 'En attente';
                        final sc = st == 'Reçu' ? kGreen
                            : st == 'Recalé' ? kPink : kAmber;
                        final gr = st == 'Reçu' ? gGreen
                            : st == 'Recalé' ? gPink : gAmber;
                        return GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  CoachNoteScreen(
                                      docId: doc['_id'],
                                      data: d))),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: kBg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: kVLight, width: 1)),
                            child: Row(children: [
                              Container(width: 40, height: 40,
                                  decoration: BoxDecoration(
                                      gradient: gViolet,
                                      borderRadius:
                                      BorderRadius.circular(12)),
                                  alignment: Alignment.center,
                                  child: Text(
                                      (d['enfantNom'] as String? ??
                                          '?')[0].toUpperCase(),
                                      style: TextStyle(fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: kWhite))),
                              SizedBox(width: 12),
                              Expanded(child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start, children: [
                                Text(d['enfantNom'] ?? '',
                                    style: TextStyle(fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: kDark)),
                                Text('Ceinture ${d['ceinture']} • ${d['age']} ans',
                                    style: TextStyle(
                                        fontSize: 11, color: kMuted)),
                              ])),
                              if (d['score'] != null)
                                Text('${d['score']}%',
                                    style: TextStyle(fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: sc)),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    gradient: gr,
                                    borderRadius:
                                    BorderRadius.circular(20)),
                                child: Text(st,
                                    style: TextStyle(fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: kWhite)),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.chevron_right,
                                  color: kMuted, size: 18),
                            ]),
                          ),
                        );
                      }),
                  ]),
                ),
                SizedBox(height: 16),
              ]),
            )),
          ]);
        },
      ),
    );
  }

  Widget _dotLegend(Color c, String l, int v) {
    return Row(children: [
      Container(width: 10, height: 10,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
      SizedBox(width: 8),
      Text(l, style: TextStyle(fontSize: 11, color: kMuted)),
      Spacer(),
      Text('$v', style: TextStyle(fontSize: 12,
          fontWeight: FontWeight.w700, color: kDark)),
    ]);
  }

  List<Widget> _beltStats(List<dynamic> docs) {
    final Map<String, List<int>> map = {};
    for (final doc in docs) {
      final d = doc as Map<String, dynamic>;
      final b = d['ceinture'] as String? ?? '?';
      final s = d['score'] as int?;
      map.putIfAbsent(b, () => []);
      if (s != null) map[b]!.add(s);
    }
    if (map.isEmpty) {
      return [Text('Aucune donnée',
          style: TextStyle(color: kMuted, fontSize: 12))];
    }
    final grads = [gViolet, gTeal, gPink, gAmber, gGreen];
    int i = 0;
    return map.entries.map((e) {
      final avg = e.value.isEmpty
          ? 0.0
          : e.value.reduce((a, b) => a + b) / e.value.length;
      final g = grads[i++ % grads.length];
      return Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Text(e.key, style: TextStyle(fontSize: 11, color: kMuted)),
            Text('${avg.round()}%',
                style: TextStyle(fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: g.colors.first)),
          ]),
          SizedBox(height: 5),
          _GradBar(value: avg / 100, gradient: g, height: 8),
        ]),
      );
    }).toList();
  }
}

// ═══════════════════════════════════════════════════
//  COACH NOTE SCREEN
// ═══════════════════════════════════════════════════
class CoachNoteScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;
  const CoachNoteScreen({super.key, required this.docId,
      required this.data});

  @override
  State<CoachNoteScreen> createState() => _CoachNoteState();
}

class _CoachNoteState extends State<CoachNoteScreen> {
  late Map<String, double> _notes;
  final _cc      = TextEditingController();
  bool  _loading = false;

  final _specs = [
    {'key': 'kata',   'label': 'Kata',   'icon': Icons.sports_martial_arts,              'grad': gViolet},
    {'key': 'kumite', 'label': 'Kumité', 'icon': Icons.shield_outlined,                  'grad': gTeal},
    {'key': 'kihon',  'label': 'Kihon',  'icon': Icons.precision_manufacturing_outlined, 'grad': gPink},
  ];

  @override
  void initState() {
    super.initState();
    _notes = {
      for (var s in _specs)
        s['key'] as String:
            (widget.data[s['key']] as num?)?.toDouble() ?? 50.0
    };
    _cc.text = widget.data['commentaire'] as String? ?? '';
  }

  int get _total =>
      (_notes.values.reduce((a, b) => a + b) / _notes.length).round();
  String get _statut =>
      _total >= 70 ? 'Reçu' : _total >= 50 ? 'En attente' : 'Recalé';
  LinearGradient get _sg =>
      _statut == 'Reçu' ? gGreen
      : _statut == 'Recalé' ? gPink : gAmber;

  Future<void> _valider() async {
    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance.collection('inscriptions').doc(widget.docId).update({
        ..._notes.map((k, v) => MapEntry(k, v.round())),
        'score':       _total,
        'statut':      _statut,
        'commentaire': _cc.text.trim(),
        'adminUid':    FirebaseAuth.instance.currentUser?.uid,
        'adminEmail':  FirebaseAuth.instance.currentUser?.email,
      });
      await sendEmail(
        to:          widget.data['parentEmail'] as String? ?? '',
        enfantNom:   widget.data['enfantNom']   as String? ?? '',
        ceinture:    widget.data['ceinture']    as String? ?? '',
        score:       _total,
        statut:      _statut,
        commentaire: _cc.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: kGreen,
            content: Row(children: [
              Icon(Icons.check_circle, color: kWhite, size: 18),
              SizedBox(width: 8),
              Text('Envoyé ! Email transmis au parent.',
                  style: TextStyle(color: kWhite)),
            ])));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        // Header
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [kV1, kV2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32)),
          ),
          child: SafeArea(child: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(children: [
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(width: 38, height: 38,
                      decoration: BoxDecoration(
                          color: kWhite.withOpacity(.15),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: kWhite, size: 16)),
                ),
                SizedBox(width: 14),
                Text('Notation', style: TextStyle(fontSize: 17,
                    fontWeight: FontWeight.w800, color: kWhite)),
              ]),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: kWhite.withOpacity(.12),
                    borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  Container(width: 48, height: 48,
                      decoration: BoxDecoration(
                          color: kWhite.withOpacity(.2),
                          borderRadius: BorderRadius.circular(14)),
                      alignment: Alignment.center,
                      child: Text(
                          (widget.data['enfantNom'] as String? ??
                              '?')[0].toUpperCase(),
                          style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: kWhite))),
                  SizedBox(width: 14),
                  Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(widget.data['enfantNom'] as String? ?? '',
                        style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w700, color: kWhite)),
                    Text('Ceinture ${widget.data['ceinture']} • ${widget.data['age']} ans',
                        style: TextStyle(fontSize: 12,
                            color: kWhite.withOpacity(.75))),
                  ])),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(gradient: _sg,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(
                            color: _sg.colors.first.withOpacity(.4),
                            blurRadius: 8, offset: Offset(0, 3))]),
                    child: Text('$_total%',
                        style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w800, color: kWhite)),
                  ),
                ]),
              ),
            ]),
          )),
        ),

        Expanded(child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(children: [
            SizedBox(height: 4),

            // Sliders
            _Card(padding: EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Notes par spécialité',
                    style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w700, color: kDark)),
                SizedBox(height: 16),
                ..._specs.map((s) {
                  final key = s['key'] as String;
                  final gr  = s['grad'] as LinearGradient;
                  final col = gr.colors.first;
                  return Column(children: [
                    Row(mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        Container(width: 28, height: 28,
                            decoration: BoxDecoration(gradient: gr,
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(s['icon'] as IconData,
                                size: 14, color: kWhite)),
                        SizedBox(width: 10),
                        Text(s['label'] as String,
                            style: TextStyle(fontSize: 13,
                                fontWeight: FontWeight.w600, color: kDark)),
                      ]),
                      Text('${_notes[key]!.round()}',
                          style: TextStyle(fontSize: 16,
                              fontWeight: FontWeight.w800, color: col)),
                    ]),
                    SizedBox(height: 6),
                    _GradBar(value: _notes[key]! / 100,
                        gradient: gr, height: 6),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.transparent,
                        thumbColor: col,
                        overlayColor: col.withOpacity(.15),
                        thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 8),
                      ),
                      child: Slider(
                        value: _notes[key]!,
                        min: 0, max: 100, divisions: 100,
                        onChanged: (v) =>
                            setState(() => _notes[key] = v),
                      ),
                    ),
                    SizedBox(height: 4),
                  ]);
                }),
              ]),
            ),
            SizedBox(height: 14),

            // Score live
            _Card(padding: EdgeInsets.all(18),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Résultat calculé', style: TextStyle(
                      fontSize: 12, color: kMuted)),
                  SizedBox(height: 4),
                  Text('$_total / 100', style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800,
                      color: _sg.colors.first)),
                ]),
                _Donut(
                  values: _notes.values.toList(),
                  colors: [kV1, kTeal, kPink],
                  center: '$_total',
                  sub: '/100',
                  size: 80,
                ),
              ]),
            ),
            SizedBox(height: 14),

            // Commentaire
            _Card(padding: EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Commentaire pour le parent',
                    style: TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w700, color: kDark)),
                SizedBox(height: 12),
                TextField(
                  controller: _cc, maxLines: 4,
                  style: TextStyle(fontSize: 13, color: kDark),
                  decoration: InputDecoration(
                    hintText: 'Retour sur la prestation de l\'enfant...',
                    hintStyle: TextStyle(color: kMuted, fontSize: 13),
                    filled: true, fillColor: kBg,
                    contentPadding: EdgeInsets.all(14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: kVLight)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: kVLight)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: kV1, width: 1.8)),
                  ),
                ),
              ]),
            ),
            SizedBox(height: 24),

            _GradBtn(
              label: 'VALIDER ET ENVOYER L\'EMAIL',
              icon: Icons.send_rounded,
              onTap: _valider,
              loading: _loading,
            ),
            SizedBox(height: 28),
          ]),
        )),
      ]),
    );
  }
}