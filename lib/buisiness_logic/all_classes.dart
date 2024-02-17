import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workouts_v3/main.dart';



class Parent extends ChangeNotifier {
  //there is only one parent object in the application that will consist of a list of Activity objects
  List<Activity> activities = [];
  int totalActivities = 0;
  bool isUpdate = true;
  // method to add an activity to the list
  void addActivity(Activity activity) {
    isUpdate = true;

    notifyListeners();
  }

  Future<List<Activity>> AllDocsToMap() async {
    List<Activity> activities = [];
    await FirebaseFirestore.instance.collection('users').doc(phoneId).collection('activities').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        activities.add(Activity.fromFirestore(doc.data() as Map<String, dynamic>));
      });
    });

    return activities;
  }

  Future<void> fetchActivities() async {
    if (isUpdate == false) return;
    activities = await AllDocsToMap();
    totalActivities = activities.length;
    isUpdate = false;
    print(activities[0]);
    notifyListeners();
  }

  Future<void> forceDownload() async {
    activities = await AllDocsToMap();
    totalActivities = activities.length;
    print(activities);
    print("activities downloaded forcefully");
  }
}

class Activity extends ChangeNotifier {
  late bool isCountBased;
  bool shouldAppear = true; //used to remove the activity from the list and firestore just by setting it to false
  DateTime createdOn = DateTime.now();
  int totalRecords = 0;
  late String name;
  Map<DateTime, int> datedRecs = {};
  Map<String, List<String>> imgMapArray = {};
  Map<String, List<String>> tagMapArray = {};

  Activity({required this.name, required this.isCountBased});

  void mockDelete() {
    shouldAppear = false;
    notifyListeners();
  }

  //named constructor to convert the firestore data to the Activity object

  Activity.fromFirestore(Map<String, dynamic> data) {
    // DateTime(epoch value milliseconds)
    // We first need to convert the string date and time from the epoch milliseconds string to DateTime object
    // Then we can convert the map to the Activity object

    // Converting the datedRecs map
    Map<DateTime, int> tempDatedRecs = {};
    (data['datedRecs'] as Map<String, dynamic>).forEach((key, value) {
      var nestedMap = value as Map<String, dynamic>;
      nestedMap.forEach((nestedKey, nestedValue) {
        tempDatedRecs[DateTime.fromMillisecondsSinceEpoch(int.parse(nestedKey))] = nestedValue as int;
      });
    });

    // Converting the imgMapArray
    Map<String, List<String>> tempImgMapArray = {};
    (data['imgMapArray'] as Map<String, dynamic>).forEach((key, value) {
      var nestedMap = value as Map<String, dynamic>;
      tempImgMapArray[key] = nestedMap.values.map((e) => e.toString()).toList();
    });

// Converting the tagMapArray
    Map<String, List<String>> tempTagMapArray = {};
    (data['tagMapArray'] as Map<String, dynamic>).forEach((key, value) {
      var nestedMap = value as Map<String, dynamic>;
      tempTagMapArray[key] = nestedMap.values.map((e) => e.toString()).toList();
    });

    // Setting the values
    name = data['name'];
    isCountBased = data['isCountBased'];
    shouldAppear = data['shouldAppear'];
    totalRecords = data['totalRecords'];
    datedRecs = tempDatedRecs;
    imgMapArray = tempImgMapArray;
    tagMapArray = tempTagMapArray;
    // this.createdOn = DateTime.fromMillisecondsSinceEpoch(int.parse(data['createdOn'])); //TODO this is not uploaded to the firestore yet
  }

  //overrriding toString
  @override
  String toString() {
    return "Printing activity: \nActivity: $name, \nisCountBased: $isCountBased, \nshouldAppear: $shouldAppear, \ntotalRecords: $totalRecords, \ndatedRecs: $datedRecs, \nimgMapArray: $imgMapArray, \ntagMapArray: $tagMapArray";
  }
}
