import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'weather_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE weather_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city TEXT,
        country TEXT,
        temperature REAL,
        weather_description TEXT,
        timestamp INTEGER
        );
      '''
    );
  }

  Future<int> insertWeatherData(Map<String, dynamic> weatherData) async {
    final db = await database;
    return await db.insert('weather_history', weatherData);
  }

  Future<List<Map<String, dynamic>>> getWeatherHistory() async {
    final db = await database;
    return await db.query('weather_history', orderBy: 'timeStamp DESC');
  }
}