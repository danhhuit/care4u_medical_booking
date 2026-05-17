import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CacheModel {
  final String key;
  final String value;
  final int timestamp;

  CacheModel({
    required this.key,
    required this.value,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'timestamp': timestamp,
    };
  }

  factory CacheModel.fromMap(Map<String, dynamic> map) {
    return CacheModel(
      key: map['key'],
      value: map['value'],
      timestamp: map['timestamp'],
    );
  }
}

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cache.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cache_data (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        keyword TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  // Example cache methods
  Future<void> saveCache(String key, String value) async {
    final db = await instance.database;
    final model = CacheModel(
      key: key, 
      value: value, 
      timestamp: DateTime.now().millisecondsSinceEpoch
    );
    
    await db.insert(
      'cache_data', 
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getCache(String key) async {
    final db = await instance.database;
    final maps = await db.query(
      'cache_data',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      return CacheModel.fromMap(maps.first).value;
    } else {
      return null;
    }
  }

  Future<void> saveSearchKeyword(String keyword) async {
    final db = await instance.database;
    await db.insert('search_history', {
      'keyword': keyword,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<String>> getSearchHistory() async {
    final db = await instance.database;
    final maps = await db.query(
      'search_history',
      orderBy: 'timestamp DESC',
      limit: 10,
    );
    return maps.map((e) => e['keyword'] as String).toList();
  }
  
  Future<void> clearSearchHistory() async {
    final db = await instance.database;
    await db.delete('search_history');
  }
}
