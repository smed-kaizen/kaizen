import 'package:kaizen/entities/Todo.dart';
import 'package:sqflite/sqflite.dart';

class TodoDbProvider {
  Database db;
  TodoDbProvider(this.db);

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

    print({'Todos of today', todos});

    return todos.map((todo) => Todo.fromMap(todo)).toList();
  }

  /// Create a todo
  Future<Todo> saveTodo(Todo todo) async {
    int todoId = await db.insert('todos', todo.toMap());
    todo.id = todoId;
    return todo;
  }

  /// mark a todo as done or not done
  Future<Todo> markTodoAsDone(Todo todo, bool done) async {
    int changesMade = await db.update('todos', {'isDone': done}, where: 'id = ?', whereArgs: [todo.id!]);
    if (changesMade > 0) {
      todo.isDone = done;
    }
    return todo;
  }

  /// delete a todo.
  Future<void> deleteTodo(Todo todo) async {
    int deleted = await db.delete('todo', where: 'id = ?', whereArgs: [todo.id!]);
    print({'deleted row', deleted});
  }
}
