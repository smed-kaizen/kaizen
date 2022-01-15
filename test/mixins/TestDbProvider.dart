import 'package:kaizen/db/Provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TestDbProvider {
  static Database? _db;

  static Future<Database> getDbConnection ({String dbName='kaizen_test.db'}) async {
    if (_db == null) {
      // String path = await getDatabasePath();
      // print('database path: $path');
      _db = await databaseFactoryFfi.openDatabase(
          // await Provider.getCustomDatabasesPath(dbName),
        dbName,
        options: OpenDatabaseOptions(
              version: 1,
              onCreate: Provider.onCreate,
              onOpen: (Database db) async {
                print('Test Database is open');
                // print({'Database paths: ', await Provider.getCustomDatabasesPath(dbName)});
              }
          ),
      );
    }

    return _db!;
  }
}