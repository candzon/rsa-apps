import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/prediction.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'predictions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE predictions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        datetime TEXT NOT NULL,
        suhu_c REAL NOT NULL,
        curah_hujan_mm REAL NOT NULL,
        kode_cuaca INTEGER NOT NULL,
        y_pred REAL NOT NULL,
        unit TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertPrediction(Prediction prediction) async {
    final db = await database;
    return await db.insert('predictions', prediction.toMap());
  }

  Future<List<Prediction>> getAllPredictions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'predictions',
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Prediction.fromMap(maps[i]);
    });
  }

  Future<int> deletePrediction(int id) async {
    final db = await database;
    return await db.delete(
      'predictions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllPredictions() async {
    final db = await database;
    await db.delete('predictions');
  }
}
