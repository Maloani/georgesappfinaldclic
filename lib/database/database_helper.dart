// database/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: 2, // migration déjà activée
      onCreate: (db, version) async {
        await _createUsersTable(db);
        await _createNotesTable(db);
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _upgradeUsersTableToV2(db);
        }
      },
    );
  }

  // ============================================
  // TABLE USERS (Version 2)
  // ============================================
  static Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullname TEXT,
        sex TEXT,
        phone TEXT UNIQUE,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');
  }

  // ============================================
  // TABLE NOTES
  // ============================================
  static Future<void> _createNotesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT
      )
    ''');
  }

  // ============================================
  // MIGRATION vers Version 2
  // ============================================
  static Future<void> _upgradeUsersTableToV2(Database db) async {
    // 1️⃣ Renommer l'ancienne table
    await db.execute('ALTER TABLE users RENAME TO users_old');

    // 2️⃣ Créer la nouvelle table
    await _createUsersTable(db);

    // 3️⃣ Copier les données compatibles
    try {
      await db.execute('''
        INSERT INTO users(fullname, sex, phone, email, password)
        SELECT fullname, sex, phone, email, password
        FROM users_old
      ''');
    } catch (_) {}

    // 4️⃣ Supprimer l’ancienne table
    await db.execute('DROP TABLE users_old');
  }
}
