import 'package:kaizen/data-access/TaskDb.dart';
import 'package:kaizen/entities/Task.dart';
import 'package:kaizen/logger/CustomLogger.dart';


class TaskController {
  TaskDbProvider _taskDbProvider;

  TaskController(this._taskDbProvider);

  Future<List<Task>> getTasksLike (String name) async{
    try {
      return _taskDbProvider.getTasksLike(name);
    } catch (e) {
      CustomLogger.logger.e('Failed to get Tasks that are like $name', e);
      throw e;
    }
  }

  Future<Task> getTaskById (int taskId) async {
    try {
      return _taskDbProvider.getTaskById(taskId);
    } catch (e) {
      CustomLogger.logger.e('Failed to get Task with id $taskId', e);
      throw e;
    }
  }

  /// Finds or creates a task by name. Case insensitive
  Future<Task> findOrCreateTaskByName(String taskName) async {
    return _taskDbProvider.findOrCreateTaskByName(taskName);
  }
}