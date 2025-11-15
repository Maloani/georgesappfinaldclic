// pages/modifier.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ModifierPage extends StatefulWidget {
  final Database database;
  final int id;
  final String oldTitle;

  const ModifierPage({
    super.key,
    required this.database,
    required this.id,
    required this.oldTitle,
  });

  @override
  State<ModifierPage> createState() => _ModifierPageState();
}

class _ModifierPageState extends State<ModifierPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.oldTitle);
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await widget.database.update(
      'notes',
      {'title': text},
      where: 'id = ?',
      whereArgs: [widget.id],
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier la note"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Modifier le contenu",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                "Enregistrer",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
