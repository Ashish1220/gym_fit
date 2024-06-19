import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE my_table (
        id INTEGER PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  Future<int> insertItem(String value) async {
    Database db = await database;
    return await db.insert('my_table', {'value': value});
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    Database db = await database;
    return await db.query('my_table');
  }

  Future<int> updateFirstItem(String newValue) async {
    Database db = await database;
    // Get the id of the first row (assuming id starts from 1)
    List<Map<String, dynamic>> result = await db.query('my_table', limit: 1);
    int idToUpdate = result.isNotEmpty ? result[0]['id'] : -1;

    if (idToUpdate != -1) {
      return await db.update(
        'my_table',
        {'value': newValue},
        where: 'id = ?',
        whereArgs: [idToUpdate],
      );
    } else {
      throw Exception('No rows found in the table.');
    }
  }
}
