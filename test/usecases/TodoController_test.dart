import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';
import '../mixins/TestApi.dart';
import '../mixins/TestDbProvider.dart';

void main () {
  late Database db;

  setUp(() async {
    db = await TestDbProvider.getDbConnection();
    expect(db.isOpen, true);
    await TestApi.init();
  });

  tearDown(() async {
    await db.delete('tasks');
    await db.delete('todos');
  });

  group('Todo Creation', () {
    const taskName = 'task1';

    // test('Can Create a task with the name', () async {
    //   TestApi.todoController.addTodo(difficulty: difficulty)
    // });
  });
}