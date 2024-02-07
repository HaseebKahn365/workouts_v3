/*
Parent:
List<Category> categoryList;
addToCategoryList(); //with notifyListeners();
.toString //overloaded

Category:
Bool isCountBased;
String name;
String ActivityConnectUID;
DateTime createdOn;
List<Activities> activityList;
addToActivityList(); //with notifyListeners();
.toString //overloaded

Activity:
String name;
DateTime createdOn;
List<String> tags;
DateTime lastUpdated;
Map<DateTime, Value> countMap;
addToCountMap(); //with notifyListeners();
.toString //overloaded

DEVLogs:
List<Project> projectList;
addToProjectList(); //with notifyListeners();
.toString //overloaded

Project:
String name;
DateTime createdOn;
Future<bool> uploadToFirestore(); 
List<ProjectRecord> projectRecordList;
addToProjectRecordList(); //with notifyListeners();

ProjectRecord:
List<Image> images;
DateTime createdOn;
String description;
.toString //overloaded


 */

import 'package:flutter/material.dart';

//lets implement all the classes along with their constructors and methods

class Parent extends ChangeNotifier {
  List<Category> categoryList = [];
  DEVLogs devLogs = DEVLogs();

  Parent() {
    print('Parent constructor called');
  }

  void addToCategoryList(Category category) {
    categoryList.add(category);
    notifyListeners();
  }

  @override
  String toString() {
    return 'Parent: ${categoryList.length} \n ${devLogs.toString()}';
  }
}

class Category extends ChangeNotifier {
  bool isCountBased;
  String name;
  String ActivityConnectUID;
  DateTime createdOn;
  List<Activity> activityList = [];

  Category({
    required this.isCountBased,
    required this.name,
    required this.ActivityConnectUID,
    required this.createdOn,
  });

  //overload the == operator to compare two categories on the bases of name and createdOn
  bool operator ==(Object other) {
    if (other is Category) {
      return (this.name == other.name && this.createdOn == other.createdOn);
    } else {
      return false;
    }
  }

  void addToActivityList(Activity activity) {
    activityList.add(activity);
    notifyListeners();
  }

  @override
  String toString() {
    return 'Category: $name \n ${activityList.length} activities';
  }
}

class Activity extends ChangeNotifier {
  String name;
  DateTime createdOn;
  List<String> tags = [];
  DateTime lastUpdated;
  Map<DateTime, int> countMap = {};

  Activity({
    required this.name,
    required this.createdOn,
    required this.lastUpdated,
  });

  void addToCountMap(int value, DateTime date) {
    countMap[date] = value;

    notifyListeners();
  }

  @override
  String toString() {
    return 'Activity: $name';
  }
}

class DEVLogs extends ChangeNotifier {
  List<Project> projectList = [];

  void addToProjectList(Project project) {
    projectList.add(project);
    notifyListeners();
  }

  @override
  String toString() {
    return 'DEVLogs: ${projectList.length} projects';
  }
}

class Project extends ChangeNotifier {
  String name;
  DateTime createdOn;
  Future<bool> uploadToFirestore() async {
    return true;
  }

  Project({
    required this.name,
    required this.createdOn,
  });

  List<ProjectRecord> projectRecordList = [];

  void addToProjectRecordList(ProjectRecord projectRecord) {
    projectRecordList.add(projectRecord);
    notifyListeners();
  }

  @override
  String toString() {
    return 'Project: $name, ${projectRecordList.length} records';
  }
}

class ProjectRecord extends ChangeNotifier {
  List<Image> images = [];
  DateTime createdOn;
  String description;

  ProjectRecord({
    required this.createdOn,
    required this.description,
  });

  @override
  String toString() {
    return 'ProjectRecord: $description \n ${images.length} images';
  }
}
