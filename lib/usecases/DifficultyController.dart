import 'package:kaizen/data-access/DifficultyDb.dart';
import 'package:kaizen/entities/Difficulty.dart';


class DifficultyController {
  DifficultyDbProvider _difficultyDbProvider;

  DifficultyController(this._difficultyDbProvider);

  Future<List<Difficulty>> getDifficulties () async{
    try {
      return _difficultyDbProvider.getDifficulties();
    } catch (e) {
      print({'Failed to get Difficulties reason:', e});
      throw e;
    }
  }
}