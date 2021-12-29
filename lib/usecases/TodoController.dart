import 'package:kaizen/data-access/TaskDb.dart';
import 'package:kaizen/data-access/TodoDb.dart';
import 'package:kaizen/entities/Difficulty.dart';
import 'package:kaizen/entities/Task.dart';
import 'package:kaizen/entities/Todo.dart';

class TodoController {
  TaskDbProvider _taskDbProvider;
  TodoDbProvider _todoDbProvider;

  TodoController(this._todoDbProvider, this._taskDbProvider);

  Future<Todo> addTodo({
    required Difficulty difficulty,
    Task? task,
    String? taskName,
    String? description
  }) async {
    try {
      // if the user doesn't choose and already existing task
      if (task == null) {
        if (taskName == null) {
          throw Exception('Should provide a task name');
        }
        // double checking if the task doesn't exist in the database.
        Task? taskAlreadyExists = await _taskDbProvider.getTaskByName(taskName);
        if (taskAlreadyExists != null) {
          task = taskAlreadyExists;
        } else {
          task = await _taskDbProvider.createTask(Task(name: taskName));
        }
      }

      // the user provides an already existing Task from the drop down auto complete
      Todo newTodo = Todo(task: task, difficulty: difficulty);
      newTodo = await _todoDbProvider.saveTodo(newTodo);

      return newTodo;
    } catch (e) {
      print({'error Adding todo', e});
      throw e;
    }
  }

  Future<List<Todo>> getTodosOfToday () {
    try {
      return _todoDbProvider.getTodosOfToday();
    } catch (e) {
      print({'Failed to get todos of today', e});
      throw e;
    }
  }

  Future<Todo> markTodoAsDone (Todo todo, bool done) async {
    try {
      todo = await _todoDbProvider.markTodoAsDone(todo, done);
      return todo;
    } catch(e) {
      print({'Failed to mark todo as done:', done, e});
      throw e;
    }
  }

}