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

  ProjectRecord({required this.lastUpdated, required this.images});

  int getImageCount() {
    return images.length;
  }
}

//creating thhe mock data for testing

List<Category> categories = [
  Category(
    isCountBased: true,
    name: 'Reading',
    ActivityConnectUID: 'Rt9pOqzA2VdH',
    createdOn: DateTime(2021, 1, 20),
    activityList: [
      Activity(
        name: 'Reading',
        tags: ['Books'],
        createdOn: DateTime(2021, 1, 20),
        countMap: {
          DateTime(2021, 1, 20, 20, 0): 60,
          DateTime(2021, 1, 20, 21, 0): 45,
        },
      ),
    ],
  ),
  Category(
    isCountBased: false,
    name: 'Coding',
    ActivityConnectUID: 'C8p5rT3iNjH',
    createdOn: DateTime(2021, 1, 20),
    activityList: [
      Activity(
        name: 'Coding',
        tags: ['Dart'],
        createdOn: DateTime(2021, 1, 20),
        countMap: {
          DateTime(2021, 1, 20, 14, 0): 120,
          DateTime(2021, 1, 20, 16, 0): 60,
        },
      ),
    ],
  ),
  Category(
    isCountBased: true,
    name: 'Running',
    ActivityConnectUID: 'Ru7sXw2pBqLm',
    createdOn: DateTime(2021, 1, 20),
    activityList: [
      Activity(
        name: 'Running',
        tags: ['Cardio'],
        createdOn: DateTime(2021, 1, 20),
        countMap: {
          DateTime(2021, 1, 20, 12, 0): 45,
          DateTime(2021, 1, 20, 13, 0): 40,
        },
      ),
    ],
  ),
  Category(
    isCountBased: false,
    name: 'Yoga',
    ActivityConnectUID: 'Yo3gA1cBvFzZ',
    createdOn: DateTime(2021, 1, 20),
    activityList: [
      Activity(
        name: 'Yoga',
        tags: ['Meditation'],
        createdOn: DateTime(2021, 1, 20),
        countMap: {
          DateTime(2021, 1, 20, 18, 0): 30,
          DateTime(2021, 1, 20, 18, 30): 30,
        },
      ),
    ],
  ),
];

DEVLogs devLogs = DEVLogs();
void initDEVLogs() {
  devLogs.projects = [
    Project(
      name: 'Project 1',
      createdOn: DateTime(2021, 1, 20),
    ),
    Project(
      name: 'Project 2',
      createdOn: DateTime(2021, 1, 20),
    ),
    Project(
      name: 'Project 3',
      createdOn: DateTime(2021, 1, 20),
    ),
  ];
  devLogs.projects[0].logs = [
    ProjectRecord(
      lastUpdated: DateTime(2021, 1, 20),
      images: [
        Image.asset('assets/images/google.png'),
        Image.asset('assets/images/login.png'),
        Image.asset('assets/images/stretch.png'),
      ],
    ),
    ProjectRecord(
      lastUpdated: DateTime(2021, 1, 18),
      images: [
        Image.asset('assets/images/google.png'),
        Image.asset('assets/images/login.png'),
        Image.asset('assets/images/stretch.png'),
      ],
    ),
  ];
}
