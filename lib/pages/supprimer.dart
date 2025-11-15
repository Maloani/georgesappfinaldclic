// pages/supprimer.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SupprimerPage extends StatelessWidget {
  final Database database;
  final int id;
  final String title;

  const SupprimerPage({
    super.key,
    required this.database,
    required this.id,
    required this.title,
  });

  Future<void> _delete(BuildContext context) async {
    await database.delete('notes', where: 'id = ?', whereArgs: [id]);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supprimer"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 70,
              ),
              const SizedBox(height: 10),
              Text(
                "Voulez-vous vraiment supprimer :",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),
              Text(
                '"$title"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text(
                  "Supprimer",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                onPressed: () => _delete(context),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  "Annuler",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
