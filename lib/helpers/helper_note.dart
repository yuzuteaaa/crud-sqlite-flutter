import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/model_note.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  static Database? _database;
  DBHelper._internal();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
 CREATE TABLE notes(
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 title TEXT,
 description TEXT
 )
 ''');
      },
    );
  }

  // Insert Note
  Future<int> insert(Note note) async {
    Database db = await database;
    return await db.insert('notes', note.toMap());
  }

  // Get all Notes
  Future<List<Note>> getNotes() async {
    Database db = await database;
    var result = await db.query('notes');
    return result.map((map) => Note.fromMap(map)).toList();
  }

  // Update Note
  Future<int> update(Note note) async {
    Database db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Delete Note
  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
