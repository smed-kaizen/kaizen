import 'package:kaizen/data-access/DifficultyDb.dart';
import 'package:kaizen/data-access/ProgressDb.dart';
import 'package:kaizen/data-access/TaskDb.dart';
import 'package:kaizen/data-access/TodoDb.dart';
import 'package:kaizen/usecases/DifficultyController.dart';
import 'package:kaizen/usecases/ProgressController.dart';
import 'package:kaizen/usecases/TaskController.dart';
import 'package:kaizen/usecases/TodoController.dart';
import 'package:sqflite/sqflite.dart';

import 'TestDbProvider.dart';

class TestApi {
  static late Database _db;
  static late TodoDbProvider todoDbProvider;
  static late TaskDbProvider taskDbProvider;
  static late DifficultyDbProvider difficultyDbProvider;
  static late ProgressDbProvider progressDbProvider;
  static late TodoController todoController;
  static late TaskController taskController;
  static late DifficultyController difficultyController;
  static late ProgressController progressController;

  static init() async {
    _db = await TestDbProvider.getDbConnection();
    todoDbProvider = TodoDbProvider(_db);
    taskDbProvider = TaskDbProvider(_db);
    difficultyDbProvider = DifficultyDbProvider(_db);
    progressDbProvider = ProgressDbProvider(_db);
    todoController = TodoController(todoDbProvider, taskDbProvider, progressDbProvider);
    taskController = TaskController(taskDbProvider);
    difficultyController = DifficultyController(difficultyDbProvider);
    progressController = ProgressController(progressDbProvider);
  }
}