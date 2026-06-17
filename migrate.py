import re

with open('lib/main.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# CoachDashboard StreamBuilder -> FutureBuilder
content = re.sub(
    r"body: StreamBuilder<QuerySnapshot>\(\s*stream: FirebaseFirestore\.instance\s*\.collection\('inscriptions'\)\s*\.snapshots\(\),\s*builder: \(ctx, snap\) \{",
    r'''
  Future<List<dynamic>> _fetchAll() async {
    final res = await http.get(Uri.parse('$_apiBaseUrl/inscriptions'), headers: {'Authorization': 'Bearer $authToken'});
    if (res.statusCode == 200) return jsonDecode(res.body);
    return [];
  }

  body: FutureBuilder<List<dynamic>>(
    future: _fetchAll(),
    builder: (ctx, snap) {''',
    content
)

# CoachDashboard docs mapping
content = content.replace("final docs    = snap.data!.docs;", "final docs    = snap.data ?? [];")
content = content.replace("(d.data() as Map)", "d")
content = content.replace("final d  = doc.data() as Map<String, dynamic>;", "final d  = doc as Map<String, dynamic>;")
content = content.replace("docId: doc.id,", "docId: doc['_id'],")

# _beltStats docs mapping
content = content.replace("final d = doc.data() as Map<String, dynamic>;", "final d = doc as Map<String, dynamic>;")

# CoachDashboard logout
content = content.replace("onTap: () => FirebaseAuth.instance.signOut(),", """onTap: () async {
                        authToken = null;
                        currentUser = null;
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        KarateProApp.of(context)?.refreshApp();
                      },""")

# CoachNoteScreen updating logic
old_update = """      await FirebaseFirestore.instance
          .collection('inscriptions')
          .doc(widget.docId)
          .update({
        ..._notes.map((k, v) => MapEntry(k, v.round())),
        'score':       _total,
        'statut':      _statut,
        'commentaire': _cc.text.trim(),
        'noteLe':      FieldValue.serverTimestamp(),
      });"""

new_update = """      final res = await http.put(
        Uri.parse('$_apiBaseUrl/inscriptions/${widget.docId}/score'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $authToken'},
        body: jsonEncode({
          ..._notes.map((k, v) => MapEntry(k, v.round())),
          'score':       _total,
          'statut':      _statut,
          'commentaire': _cc.text.trim()
        })
      );
      if (res.statusCode != 200) throw 'Erreur serveur';"""

content = content.replace(old_update, new_update)

with open('lib/main.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Migration completed.")
