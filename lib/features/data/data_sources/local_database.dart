import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'progress_tracker.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tracks table
        await db.execute('''
          CREATE TABLE tracks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            start_date TEXT NOT NULL,
            end_date TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');

        // Progress entries table
        await db.execute('''
          CREATE TABLE progress_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            track_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            is_done INTEGER NOT NULL,
            note TEXT,
            UNIQUE(track_id, date)
          )
        ''');
      },
    );
  }
}
