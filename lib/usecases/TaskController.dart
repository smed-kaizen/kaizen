import 'package:kaizen/data-access/TaskDb.dart';
import 'package:kaizen/entities/Task.dart';


class TaskController {
  TaskDbProvider _taskDbProvider;

  TaskController(this._taskDbProvider);

  Future<List<Task>> getTasksLike (String name) async{
    try {
      return _taskDbProvider.getTasksLike(name);
    } catch (e) {
      print({'Failed to get Tasks that are like', name, 'reason:', e});
      throw e;
    }
  }
}