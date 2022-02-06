import 'dart:io';
import 'package:kaizen/logger/CustomLogger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const defaultDifficulties = <Map<String, Object>>[
  {'name': 'easy', 'pts': 3},
  {'name': 'medium', 'pts': 5},
  {'name': 'hard', 'pts': 7},
  {'name': 'legendary', 'pts': 10}
];

const defaultExp = { 'exp': 0, 'maxPts': 10 };

/// singleton for the database connection
class Provider {
  static Database? _db;

  /// Creates a custom path for the db name if it doesn't exist
  static Future<String> getCustomDatabasesPath (String dbName) async {
    CustomLogger.logger.d({'Creating the custom path for the db:', dbName});

    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$dbName.db');

    // Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}

    return path;
  }

  /// Creates the databases, the constraints and the triggers that we want in our db
  static onCreate (Database db, int version) async {
    CustomLogger.logger.d('Creating the database');
    // execute doesn't let you have multiple statements separated with ; so we create
    // multiple execute statements for each table.
    await db.execute('PRAGMA foreign_keys = ON');

    // Create the Difficulties table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS difficulties (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE NOT NULL,
          pts INTEGER NOT NULL
      )
    ''');

    // Create the Tasks table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL collate NOCASE,
        createdAt DATETIME default current_timestamp,
        isFavorite BOOLEAN default FALSE,
        deletedAt DATETIME
      )
    ''');

    // Creates the Todos Table with FK constraints
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

    // Creating the progress Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS progress (
        exp INT,
        maxPts INT
      )
    ''');

    // populate the difficulty data
    Batch batch = db.batch();
    defaultDifficulties.forEach((diff) {
      batch.insert(
          'difficulties',
          diff,
          conflictAlgorithm: ConflictAlgorithm.ignore
      );
    });
    // initialize the progress to 0
    batch.insert('progress', defaultExp);
    await batch.commit(noResult: true);
  }

  // Get the singleton of the db connection object
  static Future<Database> getDbConnection ({String dbName='kaizen.db'}) async {
    if (_db == null) {
      // String path = await getDatabasePath();
      // print('database path: $path');
      _db = await openDatabase(
          await getCustomDatabasesPath(dbName),
          version: 1,
          onCreate: onCreate,
          onOpen: (Database db) async {
            CustomLogger.logger.i({ 'Database open in path: ', db.path });
          }
      );
    }

    return _db!;
  }
}