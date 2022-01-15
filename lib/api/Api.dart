
import 'package:kaizen/data-access/DifficultyDb.dart';
import 'package:kaizen/data-access/TaskDb.dart';
import 'package:kaizen/data-access/TodoDb.dart';
import 'package:kaizen/db/Provider.dart';
import 'package:kaizen/usecases/DifficultyController.dart';
import 'package:kaizen/usecases/TaskController.dart';
import 'package:kaizen/usecases/TodoController.dart';
import 'package:sqflite/sqflite.dart';

class Api {
  static late Database _db;
  static late TodoDbProvider _todoDbProvider;
  static late TaskDbProvider _taskDbProvider;
  static late DifficultyDbProvider _difficultyDbProvider;
  static late TodoController todoController;
  static late TaskController taskController;
  static late DifficultyController difficultyController;

  static init() async {
    _db = await Provider.getDbConnection();
    _todoDbProvider = TodoDbProvider(_db);
    _taskDbProvider = TaskDbProvider(_db);
    _difficultyDbProvider = DifficultyDbProvider(_db);
    todoController = TodoController(_todoDbProvider, _taskDbProvider);
    taskController = TaskController(_taskDbProvider);
    difficultyController = DifficultyController(_difficultyDbProvider);
  }
}