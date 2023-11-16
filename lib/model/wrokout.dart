//a workout class should contain all the essential attributes of the workout which are as follows:
//workout Name	total count today	date and time	workout type	score/count	nth time today	count precise

class Workout {
  String workoutName;
  int totalCountToday;
  DateTime dateAndTime;
  String workoutType;
  int scorePerCount;
  int nthTimeToday;
  int countPrecise;

  Workout(
      {required this.workoutName,
      required this.totalCountToday,
      required this.dateAndTime,
      required this.workoutType,
      required this.scorePerCount,
      required this.nthTimeToday,
      required this.countPrecise});

  Workout.fromMap(Map<String, dynamic> map)
      : workoutName = map['workoutName'],
        totalCountToday = map['totalCountToday'],
        dateAndTime = map['dateAndTime'],
        workoutType = map['workoutType'],
        scorePerCount = map['scorePerCount'],
        nthTimeToday = map['nthTimeToday'],
        countPrecise = map['countPrecise'];

  Map<String, dynamic> toMap() {
    return {
      'workoutName': workoutName,
      'totalCountToday': totalCountToday,
      'dateAndTime': dateAndTime,
      'workoutType': workoutType,
      'scorePerCount': scorePerCount,
      'nthTimeToday': nthTimeToday,
      'countPrecise': countPrecise,
    };
  }

  //all of the above details of the workout should be retrieved by performing querry on each table and then combining the results.

  //the workout class should also contain the methods to perform the CRUD operations on the workout table.
}
