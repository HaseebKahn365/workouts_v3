import 'package:flutter/material.dart';

class Category {
  bool isCountBased;
  String name;
  String ActivityConnectUID;
  DateTime createdOn;

  List<Activity> activityList;

  Category({required this.isCountBased, required this.name, required this.ActivityConnectUID, required this.createdOn, required this.activityList});

  void addToActivityList(Activity activity) {
    activityList.add(activity);
  }
}

class Activity {
  String name;
  List<String> tags;
  DateTime createdOn;
  Map<DateTime, int> countMap;

  Activity({required this.name, required this.tags, required this.createdOn, required this.countMap});
}

class DEVLogs {
  List<Project> projects = [];

  int getProjectCount() {
    return projects.length;
  }
}

class Project {
  String name;
  DateTime createdOn;
  List<ProjectRecord> logs = [];

  Project({required this.name, required this.createdOn});

  int getLogCount() {
    return logs.length;
  }
}

class ProjectRecord {
  DateTime lastUpdated;
  List<Image> images = [];

  ProjectRecord({required this.lastUpdated});

  int getImageCount() {
    return images.length;
  }
}
