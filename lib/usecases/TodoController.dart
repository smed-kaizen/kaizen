import 'package:kaizen/data-access/ProgressDb.dart';
import 'package:kaizen/data-access/TaskDb.dart';
import 'package:kaizen/data-access/TodoDb.dart';
import 'package:kaizen/entities/Difficulty.dart';
import 'package:kaizen/entities/Progress.dart';
import 'package:kaizen/entities/Task.dart';
import 'package:kaizen/entities/Todo.dart';
import 'package:kaizen/logger/CustomLogger.dart';

class TodoController {
  TaskDbProvider _taskDbProvider;
  TodoDbProvider _todoDbProvider;
  ProgressDbProvider _progressDbProvider;

  TodoController(this._todoDbProvider, this._taskDbProvider, this._progressDbProvider);

  /// Creating a new todo.
  /// Can be created from an already existing or a new task
  /// Can be created only if there is enough points left for today
  Future<Todo> addTodo({
    required Difficulty difficulty,
    Task? task,
    String? taskName,
    String? description
  }) async {
    try {
      // checking how many pts are left
      Progress progress = await _progressDbProvider.getProgress();
      int totalPtsToday = await _todoDbProvider.getTotalUsedPtsOfToday();
      int ptsLeft = progress.maxPts - totalPtsToday;
      if (ptsLeft < difficulty.pts) {
        throw new Exception('Not enough pts left');
      }

      // if the user doesn't choose and already existing task
      if (task == null) {
        if (taskName == null) {
          throw Exception('Should provide a task name');
        }
        task = await _taskDbProvider.findOrCreateTaskByName(taskName);
      }

      // Create the todo with the task
      Todo newTodo = Todo(task: task, difficulty: difficulty);

      CustomLogger.logger.d({'Saving the new Todo', newTodo.toMap()});
      newTodo = await _todoDbProvider.saveTodo(newTodo);

      return newTodo;
    } catch (e) {
      CustomLogger.logger.e('Failed to add todo', e);
      throw e;
    }
  }

  /// Get the todos of today
  Future<List<Todo>> getTodosOfToday () {
    try {
      return _todoDbProvider.getTodosOfToday();
    } catch (e) {
      CustomLogger.logger.e('Failed to get Todos of today', e);
      throw e;
    }
  }

  /// Mark a todo as done, Can be true or false
  /// if done is true add the
  Future<Todo> markTodoAsDone (Todo todo, bool done) async {
    try {
      // todo should not be in the past
      if (todo.inPast()) {
        throw Exception('Todo is in the past, cannot be changed');
      }
      CustomLogger.logger.d('Marking todo with id ${todo.id} as done: $done} ');
      await _todoDbProvider.db.transaction((txn) async {
        await _todoDbProvider.markTodoAsDone(todo, done, tx: txn);
        CustomLogger.logger.d('getting progress');
        Progress progress = await _progressDbProvider.getProgress(tx: txn);
        CustomLogger.logger.d('progress $progress');
        int newExp = done? progress.exp + todo.difficulty.pts : progress.exp - todo.difficulty.pts;
        CustomLogger.logger.d('Setting exp from ${progress.exp} to $newExp}');
        await _progressDbProvider.setExp(newExp, tx: txn);
      });
      return await _todoDbProvider.getTodoById(todo.id!);
    } catch(e) {
      CustomLogger.logger.e('Failed to mark Todo as done: $done', e);
      throw e;
    }
  }

  /// deleting the todo
  Future<void> deleteTodo (Todo todo) async {
    try {
      if (todo.inPast() || todo.isDone ) {
        throw Exception('Todo is either in the past or is done, cannot delete');
      }
      await _todoDbProvider.deleteTodo(todo);
    } catch (e) {
      CustomLogger.logger.e('Failed to delete todo ${todo.toString()}', e);
      throw e;
    }
  }

}