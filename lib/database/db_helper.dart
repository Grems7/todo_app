import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_getx/model/todo_model.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper db = DBHelper._();
  static final dataBaseName = "todo.db";
  static final tableTodoName = "myTodo";
  static final columnTodoId = "todoId";
  static final columnTodoTitle = "todoTitle";
  static final columnTodoMsg = "todoMsg";
  static final columnTodoIsdone = "todoIsdone";

  static Database? _database;

  Future<Database> get myDataBase async {
    if (_database != null) return _database!;
    _database = await _initDataBase();
    return _database!;
  }

  Future<Database> _initDataBase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, tableTodoName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTodoName(
      $columnTodoId Integer PRIMARY KEY AUTOINCREMENT,
      $columnTodoTitle TEXT NOT NULL,
      $columnTodoMsg TEXT NOT NULL,
      $columnTodoIsdone INTEGER
      )
      ''');
  }
    /// add todos
    Future<int> addTodo(TodoModel todoModel) async {
      final db = await myDataBase;
      return await db.insert(tableTodoName, todoModel.toMap());
    }

    /// fetch All todos
    Future<List<TodoModel>> getAllTodos() async {
      final db = await myDataBase;
      final List<Map<String, dynamic>> maps = await db.query(tableTodoName);
      return List.generate(maps.length, (index) {
        return TodoModel.fromMap(maps[index]);
      });
    }

    /// delete todos
    Future<void> deleteTodo(int id) async {
      final db = await myDataBase;
      await db
          .delete(tableTodoName, where: '$columnTodoId = ?', whereArgs: [id]);
    }

    /// edite todos
    Future<void> updateTodo(TodoModel todoModel) async {
      final db = await myDataBase;
      await db.update(
        tableTodoName,
        todoModel.toMap(),
        where: '$columnTodoId = ?',
        whereArgs: [todoModel.id],
      );
    }
  }

