import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';
import '__setup__/TestDbProvider.dart';

const String testDbName = 'kaizen_test.db';

void main () {
  group('Db Provider', () {
    test('Should create the database', () async {
      Database db = await TestDbProvider.getDbConnection(dbName: testDbName);
     expect(db.isOpen, true);
    });
  });
}