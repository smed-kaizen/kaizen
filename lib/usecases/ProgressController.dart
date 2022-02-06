import 'package:kaizen/data-access/ProgressDb.dart';
import 'package:kaizen/entities/Progress.dart';

class ProgressController {
  ProgressDbProvider _progressDbProvider;

  ProgressController(this._progressDbProvider);

  /// Get the progress
  Future<Progress> getProgress () {
    return _progressDbProvider.getProgress();
  }
}