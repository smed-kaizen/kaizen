import 'package:kaizen/db/Provider.dart';
import 'package:kaizen/logger/CustomLogger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class TestDbProvider {
  static Database? _db;

  static Future<Database> getDbConnection ({String dbName='kaizen_test.db'}) async {
    sqfliteFfiInit();
    if (_db == null) {
      String databasesPath = await databaseFactoryFfi.getDatabasesPath();
      String path = join(databasesPath, dbName);

      // Making sure the tests start with a clean db.
      if (await databaseFactoryFfi.databaseExists(path)) {
        CustomLogger.logger.i('Old Database was found, deleting ... ');
        await databaseFactoryFfi.deleteDatabase(path);
      }

      _db = await databaseFactoryFfi.openDatabase(
          // await Provider.getCustomDatabasesPath(dbName),
        dbName,
        options: OpenDatabaseOptions(
              version: 1,
              onCreate: Provider.onCreate,
              onOpen: (Database db) async {
                CustomLogger.logger.i('Test database is open');
              }
          ),
      );
    }

    return _db!;
  }
}