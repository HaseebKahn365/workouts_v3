// //Here is all the logic for managing the local database
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:workouts_v3/buisiness_logic/all_classes.dart';

// Database? _db;

// Database _getDatabaseOrThrow() {
//   final db = _db;
//   if (db == null) {
//     throw 'Database not open';
//   } else {
//     return db;
//   }
// }

// class SQLService {
//   //opening the database if does not exist then create the following tables
//   /*
//   CREATE TABLE `Activity` (
// 	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
// 	`name`	TEXT NOT NULL,
//   `is_synced`	INTEGER NOT NULL,
// 	`is_count_based`	INTEGER NOT NULL
// );

// CREATE TABLE `DatedRecs` (
// 	`date`	INTEGER NOT NULL,
// 	`count`	INTEGER NOT NULL,
// 	`activity_id`	INTEGER NOT NULL,
// 	PRIMARY KEY(`date`),
// 	FOREIGN KEY(`activity_id`) REFERENCES `Activity`(`id`)
// );

// CREATE TABLE `ImageRecs` (
// 	`date`	INTEGER NOT NULL,
// 	`activity_id`	INTEGER NOT NULL,
// 	FOREIGN KEY(`activity_id`) REFERENCES `Activity`(`id`)
// );

// CREATE TABLE `ImageLink` (
// 	`image_id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
// 	`url`	TEXT NOT NULL,
// 	`image_recs_id`	INTEGER NOT NULL,
// 	FOREIGN KEY(`image_recs_id`) REFERENCES `ImageRecs`(`date`)
// );

// CREATE TABLE `TagRecs` (
// 	`date`	INTEGER NOT NULL UNIQUE,
// 	`activity_id`	INTEGER NOT NULL,
// 	PRIMARY KEY(`date`),
// 	FOREIGN KEY(`activity_id`) REFERENCES `Activity`(`id`)
// );

// CREATE TABLE `Tag` (
// 	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
// 	`tag`	TEXT NOT NULL,
// 	`tags_recs_id`	INTEGER NOT NULL,
// 	FOREIGN KEY(`tags_recs_id`) REFERENCES `TagRecs`(`date`)
// );
  
//    */

//   Future<void> open() async {
//     if (_db != null) {
//       return;
//     }

//     try {
//       print("creating a new database for Activities");

//       final docsPath = await getDatabasesPath();
//       final dbPath = join(docsPath, workoutsDb);

//       //creating new database
//       _db = await openDatabase(dbPath, version: 1, onCreate: (Database db, int version) async {
//         await db.execute('''
//         CREATE TABLE $activitiesTable (
//           $idField INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
//           $nameField TEXT NOT NULL,
//           $isSyncedField INTEGER NOT NULL,
//           $isCountBasedField INTEGER NOT NULL
//         );
//         ''');

//         print("creating new table for dated records");

//         await db.execute('''
//         CREATE TABLE $datedRecsTable (
//           $dateField INTEGER NOT NULL,
//           $countField INTEGER NOT NULL,
//           $activityIdField INTEGER NOT NULL,
//           PRIMARY KEY($dateField),
//           FOREIGN KEY($activityIdField) REFERENCES $activitiesTable($idField)
//         );
//         ''');

//         print("creating new table for image records");

//         await db.execute('''
//         CREATE TABLE $imageRecsTable (
//           $dateField INTEGER NOT NULL,
//           $activityIdField INTEGER NOT NULL,
//           FOREIGN KEY($activityIdField) REFERENCES $activitiesTable($idField)
//         );
//         ''');

//         print("creating new table for image links");

//         await db.execute('''
//         CREATE TABLE $imageLinkTable (
//           $imageIdField INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
//           $imageUrlField TEXT NOT NULL,
//           $imageRecsIdField INTEGER NOT NULL,
//           FOREIGN KEY($imageRecsIdField) REFERENCES $imageRecsTable($dateField)
//         );
//         ''');

//         print("creating new table for tag records");

//         await db.execute('''
//         CREATE TABLE $tagRecsTable (
//           $dateField INTEGER NOT NULL UNIQUE,
//           $activityIdField INTEGER NOT NULL,
//           PRIMARY KEY($dateField),
//           FOREIGN KEY($activityIdField) REFERENCES $activitiesTable($idField)
//         );
//         ''');

//         print("creating new table for tags");

//         await db.execute('''
//         CREATE TABLE $tagTable (
//           $tagIdField INTEGER PRIMARY KEY AUTOINCREMENT,
//           $tagField TEXT NOT NULL,
//           $tagsRecsIdField INTEGER NOT NULL,
//           FOREIGN KEY($tagsRecsIdField) REFERENCES $tagRecsTable($dateField)
//         );
//         ''');

//         print("All tables created successfully");
//       });
//     } catch (e) {
//       print("Error in opening the database: $e");
//     }
//   }

//   //closing the database
//   Future<void> close() async {
//     final db = _getDatabaseOrThrow();
//     await db.close();
//     _db = null;
//   }

//   //deleting all the database
//   Future<void> delete() async {
//     final docsPath = await getDatabasesPath();
//     final dbPath = join(docsPath, workoutsDb);
//     await deleteDatabase(dbPath);
//     print("Database deleted successfully");
//     _db = null;
//   }

//   //filling all the tables from the list of activities objects
//   Future<void> fillTables(List<Activity> activities) async {
//     final db = _getDatabaseOrThrow();
//     //filling the Activity table from the list of activities
//     //here is what the Activity looks like:
//     /* late bool isCountBased;
//   bool shouldAppear = true; //used to remove the activity from the list and firestore just by setting it to false

//   int totalRecords = 0;
//   late String name;
//   Map<DateTime, int> datedRecs = {};
//   Map<String, List<String>> imgMapArray = {};
//   Map<String, List<String>> tagMapArray = {};
// */

//     try {
//       activities.forEach((activity) async {
//         await db.insert(activitiesTable, {
//           nameField: activity.name,
//           isSyncedField: 1,
//           isCountBasedField: activity.isCountBased ? 1 : 0,
//         });
//       });
//     } catch (e) {
//       print("Error in filling the Activity table: $e");
//     }

//     //filling the DatedRecs table from the list of activities

//     try {
//       activities.forEach((activity) async {
//         activity.datedRecs.forEach((key, value) async {
//           await db.insert(datedRecsTable, {
//             dateField: key.millisecondsSinceEpoch,
//             countField: value,
//             activityIdField: activities.indexOf(activity) + 1,
//           });
//         });
//       });
//     } catch (e) {
//       print("Error in filling the DatedRecs table: $e");
//     }

//     //filling the ImageRecs table from the list of activities

//     try {
//       activities.forEach((activity) async {
//         activity.imgMapArray.forEach((key, value) async {
//           await db.insert(imageRecsTable, {
//             dateField: DateTime.parse(key).millisecondsSinceEpoch,
//             activityIdField: activities.indexOf(activity) + 1,
//           });
//         });
//       });
//     } catch (e) {
//       print("Error in filling the ImageRecs table: $e");
//     }

//     //filling the ImageLink table from the list of activities

//     try {
//       activities.forEach((activity) async {
//         activity.imgMapArray.forEach((key, value) async {
//           value.forEach((element) async {
//             await db.insert(imageLinkTable, {
//               imageUrlField: element,
//               imageRecsIdField: DateTime.parse(key).millisecondsSinceEpoch,
//             });
//           });
//         });
//       });
//     } catch (e) {
//       print("Error in filling the ImageLink table: $e");
//     }

//     //filling the TagRecs table from the list of activities
//     activities.forEach((activity) async {
//       activity.tagMapArray.forEach((key, value) async {
//         await db.insert(tagRecsTable, {
//           dateField: DateTime.parse(key).millisecondsSinceEpoch,
//           activityIdField: activities.indexOf(activity) + 1,
//         });
//       });
//     });

//     //filling the Tag table from the list of activities
//     activities.forEach((activity) async {
//       activity.tagMapArray.forEach((key, value) async {
//         value.forEach((element) async {
//           await db.insert(tagTable, {
//             tagField: element,
//             tagsRecsIdField: DateTime.parse(key).millisecondsSinceEpoch,
//           });
//         });
//       });
//     });
//   }

//   //Print all the Db's each table
//   Future<void> printAllTables() async {
//     final db = _getDatabaseOrThrow();

//     try {
//       final activities = await db.rawQuery('SELECT * FROM $activitiesTable LIMIT 200');
//       print("Activities: $activities");

//       final datedRecs = await db.rawQuery('SELECT * FROM $datedRecsTable LIMIT 200');
//       print("DatedRecs: $datedRecs");
//     } catch (e) {
//       print("Error in printing the tables: $e");
//     }
//   }

//   //querry all the activities and return list of activities
//   Future<List<Activity>> getAllActivitiesFromTable() async {
//     final db = _getDatabaseOrThrow();
//     List<Activity> activities = [];

//     try {
//       final rawActivity = await db.rawQuery('SELECT * FROM $activitiesTable');
//       rawActivity.forEach((element) {
//         activities.add(Activity(name: element[nameField] as String, isCountBased: element[isCountBasedField] == 1 ? true : false));
//       });
//       return activities;
//     } catch (e) {
//       print("Error in getting all activities from the table: $e");
//       return [];
//     }
//   }

//   //similarly querry all the dated records and return Map<String, date> of records for date and count
//   Future<Map<String, int>> getAllDatedRecsFromTable() async {
//     final db = _getDatabaseOrThrow();
//     Map<String, int> records = {};

//     try {
//       final rawRecords = await db.rawQuery('SELECT * FROM $datedRecsTable');
//       rawRecords.forEach((element) {
//         records[DateTime.fromMillisecondsSinceEpoch(element[dateField] as int).toString()] = element[countField] as int;
//       });
//       print("Printing the records: $records");
//       return records;
//     } catch (e) {
//       print("Error in getting all dated records from the table: $e");
//       return {};
//     }
//   }

//   //we need the List of all the foriegn keys in the dated records table
//   Future<List<int>> getAllActivityIds() async {
//     final db = _getDatabaseOrThrow();
//     List<int> ids = [];

//     try {
//       final rawIds = await db.rawQuery('SELECT $activityIdField FROM $datedRecsTable');
//       rawIds.forEach((element) {
//         ids.add(element[activityIdField] as int);
//       });
//       print("Printing the foreign ids of the activities found in datedRecords: $ids");
//       return ids;
//     } catch (e) {
//       print("Error in getting all activity ids from the table: $e");
//       return [];
//     }
//   }
// }

// //creating all the essential consts for the database and database tables

// const workoutsDb = 'workouts.db';
// const activitiesTable = 'Activity';
// const datedRecsTable = 'DatedRecs';
// const imageRecsTable = 'ImageRecs';
// const imageLinkTable = 'ImageLink';
// const tagRecsTable = 'TagRecs';
// const tagTable = 'Tag';

// //creating consts for fields of the tables
// //Activity table

// const idField = 'id';
// const nameField = 'name';
// const isSyncedField = 'is_synced';
// const isCountBasedField = 'is_count_based';

// //DatedRecs table
// const dateField = 'date';
// const countField = 'count';
// const activityIdField = 'activity_id';

// //ImageRecs table
// const imageIdField = 'image_id';
// const imageUrlField = 'url';
// const imageRecsIdField = 'image_recs_id';

// //TagRecs table
// const tagIdField = 'id';
// const tagField = 'tag';
// const tagsRecsIdField = 'tags_recs_id';
