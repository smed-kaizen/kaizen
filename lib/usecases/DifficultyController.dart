import 'package:kaizen/data-access/DifficultyDb.dart';
import 'package:kaizen/entities/Difficulty.dart';
import 'package:kaizen/logger/CustomLogger.dart';


class DifficultyController {
  DifficultyDbProvider _difficultyDbProvider;

  DifficultyController(this._difficultyDbProvider);

  Future<List<Difficulty>> getDifficulties () {
    try {
      return _difficultyDbProvider.getDifficulties();
    } catch (e) {
      CustomLogger.logger.e('Failed to get difficulties', e);
      throw e;
    }
  }

  Future<Difficulty> getDifficultyByName (String name) {
    try {
      return _difficultyDbProvider.getDifficultyByName(name);
    } catch (e) {
      CustomLogger.logger.e('Failed to get the difficulty with the name $name', e);
      throw e;
    }
  }
}