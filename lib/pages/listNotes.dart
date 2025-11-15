// pages/listNotes.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class NotesListPage extends StatefulWidget {
  final Database database;
  const NotesListPage({super.key, required this.database});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await widget.database.query('notes', orderBy: 'id DESC');
    setState(() => _notes = data);
  }

  Future<void> _addNote() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await widget.database.insert('notes', {'title': text});
    _controller.clear();
    _loadNotes();
  }

  Future<void> _editNoteDialog(Map<String, dynamic> note) async {
    final TextEditingController editController = TextEditingController(
      text: note['title'],
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier la note"),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(
            labelText: "Entrez la nouvelle note",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              await widget.database.update(
                'notes',
                {'title': editController.text},
                where: 'id = ?',
                whereArgs: [note['id']],
              );
              Navigator.pop(context);
              _loadNotes();
            },
            child: const Text(
              "Enregistrer",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(int id) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer la note"),
        content: const Text("Voulez-vous vraiment supprimer cette note ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Non"),
          ),
          TextButton(
            onPressed: () async {
              await widget.database.delete(
                'notes',
                where: 'id = ?',
                whereArgs: [id],
              );
              Navigator.pop(context);
              _loadNotes();
            },
            child: const Text(
              "Oui, supprimer",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Georges Projet Final DCLI"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ajouter une note",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue, size: 30),
                  onPressed: _addNote,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        note['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.grey),
                            onPressed: () => _editNoteDialog(note),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => _confirmDelete(note['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
