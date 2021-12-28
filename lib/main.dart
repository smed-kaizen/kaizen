import 'package:flutter/material.dart';
import 'package:kaizen/db/Provider.dart';
import 'package:kaizen/pages/home.dart';
import 'package:kaizen/pages/loading.dart';
import 'package:kaizen/pages/settings.dart';
import 'package:kaizen/pages/stats.dart';
import 'package:sqflite/sqflite.dart';

late Database dbProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  dbProvider = await Provider.getDbConnection();

  dbProvider.query('difficulties');
  List<Map<String, Object?>> records = await dbProvider.query('difficulties');
  print(records);

  int insertedTask = await dbProvider.insert('tasks', {'name': 'task1'}, conflictAlgorithm: ConflictAlgorithm.ignore);
  var task = await dbProvider.query('tasks', where: 'name="task1"');
  print({'insertedTask', task.single });
  var insertedTodoId = await dbProvider.insert('todos', { 'taskId': task.single['id'], 'difficultyId': 2, 'description': 'mama mia', /*'createdAt': '2021-12-15 15:22:17'*/});
  // print({'insertedTodoId', insertedTodoId});
  var normalQuery = await dbProvider.query('todos', orderBy: 'createdAt');
  print({'normalQuery', normalQuery.length, normalQuery.first, normalQuery.last });
  var result = await dbProvider.rawQuery('''
    SELECT 
      difficulties.*,
      tasks.*,
      difficulties.name as difficulty,
      tasks.name as task,
      tasks.createdAt as task_createdAt,
      todos.* -- the order is very important to keep the createdAt of the todo
    FROM
      todos JOIN tasks ON todos.taskId = tasks.id
      JOIN difficulties ON todos.difficultyId = difficulties.id
    WHERE
      todos.createdAt BETWEEN strftime('%Y-%m-%d %H:%M:%S', 'now', 'start of day') AND strftime('%Y-%m-%d %H:%M:%S', 'now', '+1 day', 'start of day');
  ''');
  print({'result', result.length, result});
  var changed = await dbProvider.update('todos', {'difficultyId': 3}, where: 'id = ?', whereArgs: [1]);
  print(changed);



  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/settings': (context) => Settings(),
      '/loading': (context) => Loading(),
      '/stats': (context) => Stats(),
    },
  ));
}
