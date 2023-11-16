import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initalize();
    return _database!;
  }

  //create a full path getter

  Future<String> get fullPath async {
    //get the path to the database
    const name = 'workouts.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initalize() async {
    //get the path to the database
    final path = await fullPath;

    //open the database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    //Here we create all the tables that we have specified in the database schema
    /*the tables with fully normalized data:
Following is the actual layout :
The workout Table:
workoutTitle
workoutUid (autoincrement int)
totalCount (int)
workoutTypeUid
scorePerCountUid
This table contains the workouts that is generated each time the user enters count in any field.

The Date and Time Table:
dateAndTime (precise date and time)
workoutUid
nthSetUid
instanceCount


Nth time Table
nthSetUid (autoincrement int)
nthSet 

The workout type Table:
workoutTypeUid (autoincrement int)
workoutType

The score per count Table:
scorePerCountUid (autoincrement int)
scorePerCount

  */

    //create the workout table

    await db.execute('''
  CREATE TABLE workouts(
    workoutUid INTEGER PRIMARY KEY AUTOINCREMENT,
    workoutTitle TEXT NOT NULL,
    totalCount INTEGER NOT NULL,
    workoutTypeUid INTEGER NOT NULL,
    scorePerCountUid INTEGER NOT NULL,
    FOREIGN KEY (workoutTypeUid) REFERENCES workoutTypes(workoutTypeUid),
    FOREIGN KEY (scorePerCountUid) REFERENCES scorePerCount(scorePerCountUid)
  )
  ''');

    //create the date and time table

    await db.execute('''
  CREATE TABLE dateAndTime(
    dateAndTime TEXT PRIMARY KEY,
    workoutUid INTEGER NOT NULL,
    nthSetUid INTEGER NOT NULL,
    instanceCount INTEGER NOT NULL,
    FOREIGN KEY (workoutUid) REFERENCES workouts(workoutUid),
    FOREIGN KEY (nthSetUid) REFERENCES nthSet(nthSetUid)
  )
  ''');

    //create the nth set table

    await db.execute('''
  CREATE TABLE nthSet(
    nthSetUid INTEGER PRIMARY KEY AUTOINCREMENT,
    nthSet INTEGER NOT NULL
  )
  ''');

    //create the workout type table

    await db.execute('''
  CREATE TABLE workoutTypes(
    workoutTypeUid INTEGER PRIMARY KEY AUTOINCREMENT,
    workoutType TEXT NOT NULL
  )
  ''');

    //create the score per count table

    await db.execute('''
  CREATE TABLE scorePerCount(
    scorePerCountUid INTEGER PRIMARY KEY AUTOINCREMENT,
    scorePerCount INTEGER NOT NULL
  )
  ''');
  }
}
