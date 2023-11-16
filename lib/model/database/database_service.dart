import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:workouts_v3/model/wrokout.dart';

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

  //create the initalize function
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

  Future<int> getWorkoutTypeUid(String workoutType) async {
    // Implement the method...
    try {
      //get the database
      final db = await database;

      //get the workout type uid
      final workoutTypeUid = await db.query(
        'workoutTypes',
        where: 'workoutType = ?',
        whereArgs: [workoutType],
      );

      //return the workout type uid
      return workoutTypeUid[0]['workoutTypeUid'] as int;
    } catch (e) {
      print('Error occurred while getting workout type uid: $e');
      return 0;
    }
  }

  //create a method to get the score per count uid, nth set uid
  Future<int> getScorePerCountUid(int scorePerCount) async {
    // Implement the method...
    try {
      //get the database
      final db = await database;

      //get the score per count uid
      final scorePerCountUid = await db.query(
        'scorePerCount',
        where: 'scorePerCount = ?',
        whereArgs: [scorePerCount],
      );

      //return the score per count uid
      return scorePerCountUid[0]['scorePerCountUid'] as int;
    } catch (e) {
      print('Error occurred while getting score per count uid: $e');
      return 0;
    }
  }

  Future<int> getNthSetUid(int nthSet) async {
    // Implement the method...
    try {
      //get the database
      final db = await database;

      //get the nth set uid
      final nthSetUid = await db.query(
        'nthSet',
        where: 'nthSet = ?',
        whereArgs: [nthSet],
      );

      //return the nth set uid
      return nthSetUid[0]['nthSetUid'] as int;
    } catch (e) {
      print('Error occurred while getting nth set uid: $e');
      return 0;
    }
  }

  Future<void> createWorkout(String workoutTitle, String workoutType) async {
    try {
      //get the database
      final db = await database;

      //get the workout type uid
      final workoutTypeUid = await getWorkoutTypeUid(workoutType);

      //get the score per count uid
      final scorePerCountUid = await getScorePerCountUid(0);

      //get the current date and time
      final dateAndTime = DateTime.now().toString();

      //get the nth set uid
      final nthSetUid = await getNthSetUid(0);

      //insert the workout into the workout table
      final workoutId = await db.insert(
        'workouts',
        {
          'workoutTitle': workoutTitle,
          'totalCount': 0,
          'workoutTypeUid': workoutTypeUid,
          'scorePerCountUid': scorePerCountUid,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      //insert the date and time into the date and time table
      await db.insert(
        'dateAndTime',
        {
          'dateAndTime': dateAndTime,
          'workoutUid': workoutId,
          'nthSetUid': nthSetUid,
          'instanceCount': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('workout created successfully');
    } catch (e) {
      print('Error occurred while creating workout: $e');
    }
  }

  //Fetching all the created workouts

  Future<List<Workout>> fetchAll() async {
    try {
      //get the database
      final db = await database;

      //get the workouts
      final workouts = await db.query('workouts');

      //get the workout types
      final workoutTypes = await db.query('workoutTypes');

      //get the score per count
      final scorePerCount = await db.query('scorePerCount');

      //get the date and time
      final dateAndTime = await db.query('dateAndTime');

      //get the nth set
      final nthSet = await db.query('nthSet');

      //create a list of workouts
      final List<Workout> workoutList = [];

      //loop through the workouts
      for (var workout in workouts) {
        //get the workout type
        final workoutType = workoutTypes.firstWhere(
          (element) => element['workoutTypeUid'] == workout['workoutTypeUid'],
        );

        //get the score per count
        final scorePerCountValue = scorePerCount.firstWhere(
          (element) =>
              element['scorePerCountUid'] == workout['scorePerCountUid'],
        );

        //get the date and time
        final dateAndTimeValue = dateAndTime.firstWhere(
          (element) => element['workoutUid'] == workout['workoutUid'],
        );

        //get the nth set
        final nthSetValue = nthSet.firstWhere(
          (element) => element['nthSetUid'] == dateAndTimeValue['nthSetUid'],
        );

        //create a workout object
        final workoutObject = Workout(
          workoutName: workout['workoutTitle'] as String,
          totalCountToday: workout['totalCount'] as int,
          dateAndTime:
              DateTime.parse(dateAndTimeValue['dateAndTime'] as String),
          workoutType: workoutType['workoutType'] as String,
          scorePerCount: scorePerCountValue['scorePerCount'] as int,
          nthTimeToday: nthSetValue['nthSet'] as int,
          countPrecise: dateAndTimeValue['instanceCount'] as int,
        );

        //add the workout object to the workout list
        workoutList.add(workoutObject);
      }

      //return the workout list
      return workoutList;
    } catch (e) {
      print('Error occurred while fetching all workouts: $e');
      return [];
    }
  }
}
