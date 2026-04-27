import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();

  static Database? _db;

  static Database get db {
    if (_db == null) {
      throw StateError('DatabaseService.init() henüz çağrılmadı.');
    }
    return _db!;
  }

  static Future<void> init() async {
    if (_db != null) return;
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'mirildan.db');
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> initInMemory() async {
    if (_db != null) return;
    _db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created_at INTEGER NOT NULL,
        type TEXT NOT NULL,
        color TEXT NOT NULL,
        audio_path TEXT,
        audio_duration_ms INTEGER,
        text TEXT,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE earned_badges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        badge_id TEXT NOT NULL UNIQUE,
        earned_at INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
