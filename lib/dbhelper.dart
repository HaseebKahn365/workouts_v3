import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static const _databasename = "workouts.db";
  static const _databaseversion = 1;

  static const table = "my_table";
  static const columnId = "id";
  static const columnTitle = "title";
  static const type = "type";
  static const count = "count";
  static const scorePerCount = "scorePerCount";

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = await getDatabasesPath();
    path = path + _databasename;
    return await openDatabase(path,
        version: _databaseversion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
         CREATE TABLE my_table (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  type TEXT NOT NULL,
  count INTEGER NOT NULL,
  scorePerCount INTEGER NOT NULL
)
          ''');
  }

  //Functions for insert query update and delete

//the insert function returns and int which is the id of the row inserted

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

//querry all rows:
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(table);
  }

//querry by id greater than:

  Future<List<Map<String, dynamic>>> queryId(int id) async {
    Database db = await instance.database;
    return await db.query(table, where: '$columnId > ?', whereArgs: [id]);
  }
  //delete all the data

  Future<int> deleteAll() async {
    Database db = await instance.database;
    print('Deleted all the data\n\n');
    return await db.delete(table);
  }
}




/*About the workouts project:
•	Tracks your daily, weekly, monthly and yearly progress. 
•	Cannot update more than 300+ because of the validator in form field.
•	Score is calculated based on the primary workouts.
•	Create your custom workouts. 
•	Shows your stats: it shows you all the score for the current day, week, month and year.
What is going to change in this version:
in this version of the app we are going to migrate our existing app that heavily relies on the cloud firestore to an SQL relational database using the sqflite package. We are doing so in order to localize the user data and avoid data corruption when the internet is not available. Before proceding here is a comparison of what data looks like in the previous version:
Database Structure (collections):
Collections:
Users
CommonData

Database Structure (documents):
user:
username
uid
isHaseeb //toggles request for cloud function
userImage
email
password
docDay
docDayRec
docWeek
docWeekRec
docMonth
docMonthRec
docYear
docYearRec
bestDay
bestWeek
bestMonth
isBlocked
allYearsRec
pullcount
pushcount



In this architecture all of the user’s data is stored in cloud firestore which makes it hard to read and write data quickly and it is also quite costly. We are going to fix this using the new localized relational database model with the help of SQFLite.

The Requirements:
We need to make sure that the new architecture allows the user to do the following:
•	Create either primary or custom workout during the time of creation
•	Select the scoring weightage for primary workouts. (scoring weightage simply means the score per count of the workout).
•	The user will be able to add new records of the workout as he inputs the count.
We need to keep track of every workout when ever it is updated or created. 
The new SQL architecture:
workout Name	date and time	workout type	score/count	count 
Push Ups		primary	1	100
Pull Ups		primary	3	25
Push Ups		primary	1	50
Pull Ups		primary	3	10
Bicep Curls		custom	NULL	110

Creating a new workout:
When a new workout is created, it will be added to the database. There is only a single table of data we can perform the querries later based on our needs
 */