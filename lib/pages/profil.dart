// pages/profil.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ProfilePage extends StatefulWidget {
  final Database database;
  final Map<String, dynamic> user;

  const ProfilePage({super.key, required this.database, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _noteCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNoteCount();
  }

  Future<void> _loadNoteCount() async {
    final result = await widget.database.rawQuery(
      'SELECT COUNT(*) as total FROM notes',
    );

    setState(() {
      _noteCount = Sqflite.firstIntValue(result) ?? 0;
    });
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }

  // WIDGET POUR AFFICHAGE DES INFOS
  Widget infoBox(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Photo ou icône
            const Icon(Icons.account_circle, size: 110, color: Colors.blue),

            const SizedBox(height: 15),

            // NOM COMPLET
            Text(
              user['fullname'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 30),

            // INFORMATIONS DETAILLEES
            infoBox("Sexe", user["sex"], Icons.person),
            infoBox("Téléphone", user["phone"], Icons.phone),
            infoBox("Email", user["email"], Icons.email),
            infoBox("Nombre de notes", "$_noteCount", Icons.note_alt),

            const SizedBox(height: 30),

            // BOUTON DECONNEXION
            ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Se déconnecter",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
