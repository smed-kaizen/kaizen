import 'package:kaizen/entities/Difficulty.dart';
import 'package:sqflite/sqflite.dart';

class DifficultyDbProvider {
  Database db;
  DifficultyDbProvider (this.db);

  /// Get a task by its id
  Future<Difficulty> getDifficultyById (int id) async {
    List<Map<String, Object?>> difficultyObjects = await db.query('difficulties', where: "id=?", whereArgs: [id]);
    return Difficulty.fromMap(difficultyObjects.single);
  }

  /// Get the difficulty by name
  Future<Difficulty> getDifficultyByName (String name) async {
    List<Map<String, Object?>> difficultyObjects = await db.query('difficulties', where: "name=?", whereArgs: [name]);
    return Difficulty.fromMap(difficultyObjects.single);
  }

  /// Get the difficulties defined in the system
  Future<List<Difficulty>> getDifficulties () async {
    List<Map<String, Object?>> difficulties = await db.query('difficulties');
    return difficulties.map((diff) => Difficulty.fromMap(diff)).toList();
  }

}

