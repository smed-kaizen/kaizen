import 'package:logger/logger.dart';

class CustomLogger {
  static Logger? _logger;

  static Logger get logger  {
    if (_logger == null) {
      Logger.level = Level.debug;

      _logger = Logger(
        printer: PrettyPrinter(
            methodCount: 3, // number of method calls to be displayed
            errorMethodCount: 8, // number of method calls if stacktrace is provided
            lineLength: 120, // width of the output
            colors: true, // Colorful log messages
            printEmojis: true, // Print an emoji for each log message
            printTime: false // Should each log print contain a timestamp
        ),
      );
    }
    return _logger!;
  }

}