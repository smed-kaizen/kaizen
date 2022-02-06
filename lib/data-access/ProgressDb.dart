import 'package:kaizen/entities/Progress.dart';
import 'package:sqflite/sqflite.dart';

class ProgressDbProvider {
  Database db;
  ProgressDbProvider (this.db);

  /// Get a task by its id
  Future<Progress> getProgress ({ Transaction? tx }) async {
    var executor = tx == null? db : tx;
    List<Map<String, Object?>> progressObjects = await executor.query('progress');
    return Progress.fromMap(progressObjects.single);
  }

  /// Get the difficulty by name
  Future<Progress> setExp (int exp, { Transaction? tx }) async {
    var executor = tx == null? db : tx;
    await executor.update('progress', {'exp': exp});
    return getProgress(tx: tx);
  }
}

