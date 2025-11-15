// pages/notes.dart
import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  final int id;
  final String title;

  const NotesPage({super.key, required this.id, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de la note"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(Icons.sticky_note_2, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Text(
                "ID de la note : $id",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
