import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';
import 'mixins/TestDbProvider.dart';


void main () {
  group('Db Provider', () {
    test('Should create the database', () async {
     Database db = await TestDbProvider.getDbConnection();
     expect(db.isOpen, true);
    });
  });
}