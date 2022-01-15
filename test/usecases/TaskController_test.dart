import 'package:kaizen/data-access/TaskDb.dart';
import 'package:kaizen/entities/Task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';
import '../mixins/TestApi.dart';
import '../mixins/TestDbProvider.dart';

const List<String> taskNames = ['task', 'tas', 'Tasss', 'Goh', 'oh', 'OHOHHO', 'Tassking'];

void main () {
  late Database db;

  Future <void> insertTasks () async {
    TaskDbProvider taskDbProvider = TaskDbProvider(db);
    taskNames.forEach((name) async {
      await taskDbProvider.createTask(Task(name: name));
    });
  }

  setUp(() async {
    db = await TestDbProvider.getDbConnection();
    expect(db.isOpen, true);
    print('inserting the taks');
    await insertTasks();
    print('tasks inserted');
    await TestApi.init();
  });

  tearDown(() async {
    await db.delete('tasks');
  });

  group('Tasks searching', () {
    test('Getting the tasks using auto-complete and returns 3 results max', () async {
      List<Task> tasks = await TestApi.taskController.getTasksLike('tA');
      expect(tasks.length, 3); // notice there are 4 results that are like tA
      List<Task> tasks1 = await TestApi.taskController.getTasksLike('GO');
      expect(tasks1.length, 1);
      List<Task> tasks2 = await TestApi.taskController.getTasksLike('tASSS');
      expect(tasks2.length, 1);
    });
  });
}