import 'package:kaizen/entities/Task.dart';
import 'package:sqflite/sqflite.dart';

class TaskDbProvider {
  Database db;
  TaskDbProvider (this.db);

  /// Get the tasks that are like the provided name
  Future<List<Task>> getTasksLike (String name) async {
    List<Map<String, Object?>> tasks = await db.query('tasks', where: 'name LIKE %?%', whereArgs: [name], limit: 3);
    print({'tests like', name, 'are: ', tasks});

    return tasks.map((task) => Task.fromMap(task)).toList();
  }

  /// Get favorite tasks
  Future<List<Task>> getFavoriteTasks () async {
    List<Map<String, Object?>> tasks = await db.query('tasks', where: 'isFavorite=TRUE');
    print({'tasks favorite are: ', tasks});

    return tasks.map((task) => Task.fromMap(task)).toList();
  }

  /// create a task
  Future<Task> createTask (Task task) async {
    int taskId = await db.insert('tasks', task.toMap());
    task.id = taskId;
    return task;
  }
}

