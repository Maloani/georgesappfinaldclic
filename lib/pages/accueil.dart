// pages/accueil.dart
import 'package:flutter/material.dart';
import 'listNotes.dart';
import 'profil.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  final Database database;
  final Map<String, dynamic> user; // 🔥 Nouveau : on reçoit tout l'utilisateur

  const HomePage({super.key, required this.database, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      NotesListPage(database: widget.database),
      ProfilePage(
        database: widget.database,
        user: widget.user, // 🔥 Envoi des infos utilisateur
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        elevation: 12,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            label: "Notes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
