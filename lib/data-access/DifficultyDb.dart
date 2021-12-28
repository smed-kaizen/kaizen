import 'package:kaizen/entities/Difficulty.dart';
import 'package:sqflite/sqflite.dart';

class DifficultyDbProvider {
  Database db;
  DifficultyDbProvider (this.db);

  /// Get the difficulties defined in the system
  Future<List<Difficulty>> getDifficulties () async {
    List<Map<String, Object?>> difficulties = await db.query('difficulties');
    return difficulties.map((diff) => Difficulty.fromMap(diff)).toList();
  }

}

