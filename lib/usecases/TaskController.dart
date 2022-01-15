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
}