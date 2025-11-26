import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../domain/model/todo_model.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;
  final String _table = "todoTasks";

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        status TEXT,
        time int
      )
    ''');
  }

  Future<int> insertTodo(TodoModel todo) async {
    final db = await instance.database;

    return await db.insert(
      _table,
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoModel>> getTodos() async {
    final db = await instance.database;
    final maps = await db.query(_table);
    return maps.map((m) => TodoModel.fromJson(m)).toList();
  }

  Future<void> updateTodo(TodoModel todo) async {
    final db = await instance.database;
    await db.update(
      _table,

      todo.toJson(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> updateTodoStatus(TodoModel todo) async {
    final db = await instance.database;
    return await db.update(
      _table,
      todo.toJson(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteTodo(int id) async {
    final db = await instance.database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}
