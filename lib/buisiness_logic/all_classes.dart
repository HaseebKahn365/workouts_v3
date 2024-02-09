import 'package:flutter/material.dart';

//this application is primarily connected to the firebase for reading and writing data.
//activites are tracked by the user and stored in the cloud firestore in the following manner:
/*
users collection
  - user document {uid = phoneId aka username}
    - activities collection
      - activity document {uid = activityName}
        - bool: isCountBased
        - bool: shouldAppear
        - name: string
        - isCountBased: bool
        - int: totalRecords
        - datedRecs: Map<DateTime, int>
        - imgMapArray: Map<String(DateTime), Array<String (images urls)>>
        - tagMapArray: Map<String(DateTime), Array<String (tags)>>

 */

class Parent extends ChangeNotifier {
  //there is only one parent object in the application that will consist of a list of Activity objects
  List<Activity> activities = [];
  int totalActivities = 0;
  // method to add an activity to the list
  void addActivity(Activity activity) {
    activities.add(activity);
    totalActivities++;
    notifyListeners();
  }
}

class Activity extends ChangeNotifier {
  bool isCountBased;
  bool shouldAppear = true; //used to remove the activity from the list and firestore just by setting it to false
  DateTime createdOn = DateTime.now();
  int totalRecords = 0;
  String name;
  Map<DateTime, int> datedRecs = {};
  Map<String, List<String>> imgMapArray = {};
  Map<String, List<String>> tagMapArray = {};

  Activity({required this.name, required this.isCountBased});

  void mockDelete() {
    shouldAppear = false;
    notifyListeners();
  }
}
