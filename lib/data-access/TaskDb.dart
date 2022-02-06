import 'package:kaizen/entities/Task.dart';
import 'package:sqflite/sqflite.dart';

class TaskDbProvider {
  Database db;
  TaskDbProvider (this.db);

  /// Get a Difficulty by its id
  Future<Task> getTaskById (int id) async {
    List<Map<String, Object?>> tasksObject = await db.query('tasks', where: "id=?", whereArgs: [id]);
    return Task.fromMap(tasksObject.single);
  }

  /// Get the tasks that are like the provided name
  Future<List<Task>> getTasksLike (String name) async {
    List<Map<String, Object?>> tasks = await db.query('tasks', where: "name LIKE ?", whereArgs: ['%$name%'], limit: 3);
    return tasks.map((task) => Task.fromMap(task)).toList();
  }

  /// Get favorite tasks
  Future<List<Task>> getFavoriteTasks () async {
    List<Map<String, Object?>> tasks = await db.query('tasks', where: 'isFavorite=TRUE');
    return tasks.map((task) => Task.fromMap(task)).toList();
  }

  /// get a task by name
  Future<Task?> getTaskByName (String name) async {
    List<Map<String, Object?>> tasks = await db.query('tasks', where: 'name=?', whereArgs: [name], limit: 1);
    if (tasks.length == 0) {
      return null;
    }
    return tasks.map((task) => Task.fromMap(task)).single;
  }

  /// create a task
  Future<Task> createTask (Task task, { Transaction? tx }) async {
    var executor = tx == null? db : tx;
    int taskId = await executor.insert('tasks', task.toMap());
    task.id = taskId;
    return task;
  }

  /// Finds or creates a task by name. Case insensitive
  Future<Task> findOrCreateTaskByName(String taskName, { Transaction? tx }) async {
    // checking if the task doesn't exist in the database.
    Task? taskAlreadyExists = await getTaskByName(taskName);
    if (taskAlreadyExists != null) {
      return taskAlreadyExists;
    }

    return createTask(Task(name: taskName), tx: tx );
  }

}

