// services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

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
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        startDate INTEGER NOT NULL,
        endDate INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL,
        category TEXT NOT NULL
      )
    ''');
  }

  // CRUD Operations
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> getTodayTasks() async {
    final db = await database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'startDate >= ? AND startDate <= ?',
      whereArgs: [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch],
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<List<Task>> getCompletedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getAssignedTasksCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM tasks');
    return result.first['count'] as int;
  }

  Future<int> getCompletedTasksCount() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM tasks WHERE isCompleted = 1'
    );
    return result.first['count'] as int;
  }
}