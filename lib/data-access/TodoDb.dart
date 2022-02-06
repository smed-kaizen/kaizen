import 'package:kaizen/entities/Todo.dart';
import 'package:kaizen/logger/CustomLogger.dart';
import 'package:sqflite/sqflite.dart';

class TodoDbProvider {
  Database db;
  TodoDbProvider(this.db);

  /// get a Todo by its Id
  Future<Todo> getTodoById (int id) async {
    CustomLogger.logger.d('Returning the todo with id $id');
    List<Map<String, Object?>> todosObjects = await db.rawQuery('''
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
        todos.id = ?
    ''', [id]);
    CustomLogger.logger.d({'todo found', todosObjects.single});
    return Todo.fromMap(todosObjects.single);
  }


  /// Get the tasks of Today
  Future<List<Todo>> getTodosOfToday () async {
    List<Map<String, Object?>> todos = await db.rawQuery('''
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

    CustomLogger.logger.d({'Todos of today', todos});

    return todos.map((todo) => Todo.fromMap(todo)).toList();
  }

  /// Get total used pts of today
  Future <int> getTotalUsedPtsOfToday () async {
    List<Map<String, Object?>> totalPts = await db.rawQuery('''
      SELECT
        SUM(difficulties.pts) as total
      FROM
        todos JOIN tasks ON todos.taskId = tasks.id
        JOIN difficulties ON todos.difficultyId = difficulties.id
      WHERE
        todos.createdAt BETWEEN strftime('%Y-%m-%d %H:%M:%S', 'now', 'start of day') AND strftime('%Y-%m-%d %H:%M:%S', 'now', '+1 day', 'start of day');
    ''');

    CustomLogger.logger.d({'Total of used pts today', totalPts});
    CustomLogger.logger.d({'Single Total of used pts today', totalPts.single['total']});
    var total = totalPts.single['total'];
    return total == null ? 0 : int.parse(total.toString());
  }

  /// Create a todo
  Future<Todo> saveTodo(Todo todo, { Transaction? tx }) async {
    var executor = tx == null? db : tx;
    int todoId = await executor.insert('todos', todo.toMap());
    todo.id = todoId;
    return todo;
  }

  /// mark a todo as done or not done
  Future<Todo> markTodoAsDone(Todo todo, bool done, { Transaction? tx }) async {
    var executor = tx == null? db : tx;
    String isDone =  done? 'TRUE' : 'FALSE';
    int changesMade = await executor.update('todos', {'isDone': isDone}, where: 'id=?', whereArgs: [todo.id!]);
    if (changesMade > 0) {
        todo.isDone = done;
    }
    return todo;
  }

  /// delete a todo.
  Future<void> deleteTodo(Todo todo, { Transaction? tx }) async {
    var executor = tx == null? db : tx;
    int deleted = await executor.delete('todos', where: 'id = ?', whereArgs: [todo.id!]);
    CustomLogger.logger.d({'Deleted row', deleted});
  }
}
