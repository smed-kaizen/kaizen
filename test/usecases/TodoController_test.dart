import 'package:kaizen/entities/Difficulty.dart';
import 'package:kaizen/entities/Progress.dart';
import 'package:kaizen/entities/Todo.dart';
import 'package:kaizen/logger/CustomLogger.dart';
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

  group('Todo Utils:', () {
    const String taskName = 'task1';
    late Todo todo;
    late Difficulty easyDiff, mediumDiff, hardDiff;

    setUp(() async {
      easyDiff = await TestApi.difficultyController.getDifficultyByName('easy');
      mediumDiff = await TestApi.difficultyController.getDifficultyByName('medium');
      hardDiff = await TestApi.difficultyController.getDifficultyByName('hard');
    });

    Future<void> assertTotalOfUsedPts (int expectedValue) async {
      int total = await TestApi.todoDbProvider.getTotalUsedPtsOfToday();
      expect(total, expectedValue);
    }

    test('Can Create a todo with a name', () async {
      await assertTotalOfUsedPts(0);

      todo = await TestApi.todoController.addTodo(
        taskName: taskName,
        difficulty: easyDiff
      );

      assert(todo.id != null);
      expect(todo.difficulty.name, easyDiff.name);
      assert(todo.description == null);
      expect(todo.task.name, taskName);
      expect(todo.isDone, false);

      // the number of pts for today should be equal to the difficulty easy
      await assertTotalOfUsedPts(easyDiff.pts);
    });

    test('Creating a todo with the same taskName will result in a todo with the same taskId', () async {
      Todo newTodo = await TestApi.todoController.addTodo(
          taskName: taskName,
          difficulty: mediumDiff
      );

      expect(newTodo.task.id, todo.task.id);
      await assertTotalOfUsedPts(easyDiff.pts + mediumDiff.pts);
    });

    test('Can Mark a todo as done', () async {
      todo = await TestApi.todoController.markTodoAsDone(todo, true);
      expect(todo.isDone, true);
    });

    test('Exp should increase after marking the todo as done', () async {
      Progress progress = await TestApi.progressController.getProgress();
      expect(progress.exp, todo.difficulty.pts);
    });

    test('Shouldnt be able to delete a done todo', () async {
      expect(() async => await TestApi.todoController.deleteTodo(todo), throwsException);
    });

    test('Can mark the todo as not done', () async {
      expect(() async => await TestApi.todoController.markTodoAsDone(todo, false), returnsNormally);
    });

    test('The exp should decrease', () async {
      Progress progress = await TestApi.progressController.getProgress();
      expect(progress.exp, 0);
    });

    test('Creating a hard difficulty with the easy and medium should throw pts not enough exception', () async {
      expect(() async => await TestApi.todoController.addTodo(difficulty: hardDiff, taskName: 'hard todo'),  throwsException);
    });

    test('Can delete the todo when it is not done', () async {
      expect(() async => await TestApi.todoController.deleteTodo(todo), returnsNormally);
    });
  });
}