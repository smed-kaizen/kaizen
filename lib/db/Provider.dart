import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const defaultDifficulties = <Map<String, Object>>[
  {'name': 'easy', 'pts': 3},
  {'name': 'medium', 'pts': 5},
  {'name': 'hard', 'pts': 7},
  {'name': 'legendary', 'pts': 10}
];

/// singleton for the database connection
class Provider {
  static Database? _db;

  static Future<String> getCustomDatabasesPath (String dbName) async {
    print({'Creating the custom path for the db:', dbName});

    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$dbName.db');

    print({'Creating the custom path for the db:', dbName});
    // Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}

    return path;
  }

  static onCreate (Database db, int version) async {
    print('Creating the database');
    // execute doesn't let you have multiple statements separated with ; so we create
    // multiple execute statements for each table.
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS difficulties (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE NOT NULL,
          pts INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL collate NOCASE,
        createdAt DATETIME default current_timestamp,
        isFavorite BOOLEAN default FALSE,
        deletedAt DATETIME
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER NOT NULL,
        difficultyId INTEGER NOT NULL,
        createdAt DATETIME default current_timestamp,
        isDone BOOLEAN default FALSE,
        description TEXT,
        FOREIGN KEY (taskId) REFERENCES tasks(id),
        FOREIGN KEY (difficultyId) REFERENCES difficulties(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS progress (
        experience INT
      )
    ''');

    // You shouldn't be able to update the data that is in the past
    await db.execute('''
      CREATE TRIGGER IF NOT EXISTS shouldnt_update_old_data BEFORE UPDATE ON
      todos FOR EACH ROW WHEN ( OLD.createdAt < strftime('%Y-%m-%d', 'now', 'start of day'))
      BEGIN
      	SELECT RAISE (FAIL, 'You can not change the history that is in the past');
      END
    ''');

    // You shouldn't be able to delete the data that is in the past
    await db.execute('''
      CREATE TRIGGER IF NOT EXISTS shouldnt_delete_old_data BEFORE DELETE ON
      todos FOR EACH ROW WHEN ( OLD.createdAt < strftime('%Y-%m-%d', 'now', 'start of day'))
      BEGIN
      	SELECT RAISE (FAIL, 'You can not delete the history that is in the past');
      END
    ''');

    var triggers = await db.rawQuery('''
      select * from sqlite_master where type = 'trigger'
    ''');

    print('triggers');
    print(triggers);

    // populate the difficulty data
    Batch batch = db.batch();
    defaultDifficulties.forEach((diff) {
      batch.insert(
          'difficulties',
          diff,
          conflictAlgorithm: ConflictAlgorithm.ignore
      );
    });
    await batch.commit(noResult: true);
  }

  static Future<Database> getDbConnection ({String dbName='kaizen.db'}) async {
    if (_db == null) {
      // String path = await getDatabasePath();
      // print('database path: $path');
      _db = await openDatabase(
          await getCustomDatabasesPath(dbName),
          version: 1,
          onCreate: onCreate,
          onOpen: (Database db) async {
            print({ 'Database open in path: ', db.path });
          }
      );
    }

    return _db!;
  }
}