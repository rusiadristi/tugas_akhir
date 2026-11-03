import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  // Private constructor
  DatabaseHelper._privateConstructor();

  // Static instance (singleton)
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // Getter to access the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Get the path to the database directory
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tugas_akhir.db');

    // Open or create the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Called only once when the database is created for the first time
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE example (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
  }

  // Example: Insert data
  Future<int> insertExample(String name) async {
    final db = await instance.database;
    return await db.insert('example', {'name': name});
  }

  // Example: Fetch all data
  Future<List<Map<String, dynamic>>> getAllExamples() async {
    final db = await instance.database;
    return await db.query('example');
  }

  // Example: Delete all data
  Future<int> deleteAllExamples() async {
    final db = await instance.database;
    return await db.delete('example');
  }

  getProducts() {}
}
