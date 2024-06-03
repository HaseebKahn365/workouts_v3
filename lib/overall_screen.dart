// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:html' as html;

import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';
import 'package:workouts_v3/main.dart';

class Overall extends ConsumerStatefulWidget {
  final Parent parent;
  Overall({super.key, required this.parent});

  @override
  _OverallState createState() => _OverallState();
}

class _OverallState extends ConsumerState<Overall> {
  late final parent = widget.parent;

//On this screen we will display all the activities that we have done in the week. following is the way to construct the the line charts for every activity that was active this week

  // List<Map<String, int>> lineChartDataList = [];

  List<Activity> getWeeklyActivities() {
    //get the activities that were active this week by going through every activity in the list of activities in the parent and checking if its DateTime is in the current week by using the DateTime.subtract() method along wih the DateTime.isAfter() method

    List<Activity> activitiesThisWeek = [];
    for (var activity in parent.activities) {
      DateTime lastWeek = DateTime.now().subtract(Duration(days: 7));
      for (var k in activity.datedRecs.keys) {
        if (k.isAfter(lastWeek)) {
          activitiesThisWeek.add(activity);
          break;
        }
      }
    }
    print("activities this week found :${activitiesThisWeek.length}  \n$activitiesThisWeek");
    return activitiesThisWeek;
  }

  List<Map<String, int>> getLineChartDataList(List<Activity> activitiesThisWeek) {
    List<Map<String, int>> lineChartDataList = [];

    //we will go through each activity present in the list of and find the following data to construct the lineChartDataList
    // [ //List[0] aka first activity of the list of activities
    //let suppose today is 28 date
    //   {
    //     '28': 5,//each value is the sum of records of datedRecs for the activity found on this date
    //     '27': 6,
    //     '26': 7,
    //     '25': 0,
    //     '24': 0,//in case if no records
    //     '23': 10,
    //     '22': 11,
    //   },
    //   {
    //     '28': 5,
    //     '27': 6,
    //     '26': 7,
    //     '25': 8,
    //     '24': 9,
    //     '23': 10,
    //     '22': 11,
    //   },
    //   {
    //     '28': 5,
    //     '27': 6,
    //     '26': 7,
    //     '25': 8,
    //     '24': 9,
    //     '23': 10,
    //     '22': 11,
    //   }
    // ];

    for (var activity in activitiesThisWeek) {
      Map<String, int> activityDataThisWeek = {};
      for (var i = 6; i >= 0; i--) {
        DateTime tempday = DateTime.now().subtract(Duration(days: i));
        String formattedDate = tempday.day.toString();
        //check if there are records falling under this tempday. we sum all the records
        int total = 0;
        activity.datedRecs.forEach((key, value) {
          //check if there are records falling under this tempday. we sum all the records
          if (key.day == tempday.day && key.month == tempday.month && key.year == tempday.year) {
            total += value;
          }
        });
        activityDataThisWeek[formattedDate] = total;
      }
      lineChartDataList.add(activityDataThisWeek);
    }
    print("lineChartDataList : $lineChartDataList");

    return lineChartDataList;
  }

  Widget build(BuildContext context) {
    final activitiesThisWeek = getWeeklyActivities();
    final lineChartDataList = getLineChartDataList(activitiesThisWeek);
    return (isWeb)
        ? CreateScreenForWeb(
            parent: parent,
          )
        : Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 16),
                  Center(child: Text('  Weekly\'s Progress \n', style: Theme.of(context).textTheme.headlineMedium)).animate().scale(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                  for (var i = 0; i < activitiesThisWeek.length; i++)
                    Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                        child: Column(
                          children: [
                            Text("${activitiesThisWeek[i].name} ${(activitiesThisWeek[i].isCountBased) ? "" : "(mins)"}", style: Theme.of(context).textTheme.headlineSmall),
                            LineChartWidget(
                              lineDataMap: lineChartDataList[i],
                            ),
                          ],
                        ).animate().scale(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            )),
                ],
              ),
            ),
          );
  }
}

class LineChartWidget extends StatelessWidget {
  LineChartWidget({super.key, required this.lineDataMap});
  final Map<String, int> lineDataMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 35, top: 20, bottom: 5),
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
      ),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            //styling for the touch tooltip
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.9),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  return LineTooltipItem(
                    barSpot.y.toString(),
                    TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(show: false),
          //show the titles on the bottom
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  interval: 1,
                  showTitles: true,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: Text(
                          lineDataMap.keys.toList()[value.toInt()],
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      )),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 28,
                interval: lineDataMap.values.reduce((value, element) => value > element ? value : element) == 0 ? 10 : lineDataMap.values.reduce((value, element) => value > element ? value : element).toDouble() * 0.3,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 9,
                    color: (value == 0) ? Colors.amber.withOpacity(0.0) : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                showTitles: true,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),

          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                ...lineDataMap.entries.map((e) => FlSpot(lineDataMap.keys.toList().indexOf(e.key).toDouble(), e.value.toDouble())),
              ],
              isCurved: true,
              barWidth: 5,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.9),
                    Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.01),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
          // find the max value in the map and + 5 to it
          maxY: lineDataMap.values.reduce((value, element) => value > element ? value : element).toDouble() + 1,
          minY: 0,
        ),
      ),
    );
  }
}

//create a simple widget for now to display all the activities in and their records in the entire history.

/*
Here is what the buisiness logic looks like
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workouts_v3/main.dart';

class Parent extends ChangeNotifier {
  //there is only one parent object in the application that will consist of a list of Activity objects

  //creating an instance of the SQLService to manage all the activities here
  // final SQLService sqlService = SQLService();

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
    List<Activity> temp = [];
    activities.forEach((element) {
      if (element.shouldAppear == true) {
        temp.add(element);
      }
    });
    activities = temp;
    totalActivities = activities.length;
    isUpdate = false;
    print(activities[0]);
    notifyListeners();
  }

  Future<void> forceDownload() async {
    activities = await AllDocsToMap();
    List<Activity> temp = [];
    activities.forEach((element) {
      if (element.shouldAppear == true) {
        temp.add(element);
      }
    });
    activities = temp;
    totalActivities = activities.length;
    print(activities);
    print("activities downloaded forcefully");
  }
}

class Activity extends ChangeNotifier {
  late bool isCountBased;
  bool shouldAppear = true; //used to remove the activity from the list and firestore just by setting it to false

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


 */

class CreateScreenForWeb extends StatelessWidget {
  final Parent parent;
  const CreateScreenForWeb({
    super.key,
    required this.parent,
  });

  //creating a beautiful dashboard displaying all the activities and their records in the entire history

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          // do not use the flutter charts. we are simply gonna use the table widget to display all the stats

          children: <Widget>[
            const SizedBox(height: 16),
            Center(child: Text('  All Activities \n', style: Theme.of(context).textTheme.headlineMedium)).animate().scale(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
            DataTable(
              columns: [
                DataColumn(label: Text('Activity')),
                DataColumn(label: Text('Total Records')),
                DataColumn(label: Text('Total Count')),
              ],
              rows: [
                for (var activity in parent.activities)
                  DataRow(
                    cells: [
                      DataCell(Text(activity.name)),
                      DataCell(Text(activity.totalRecords.toString())),
                      DataCell(Text(activity.datedRecs.values.reduce((value, element) => value + element).toString())),
                    ],
                  ),
              ],
            ),

            Center(
              child: Text('\n\nActivity Details', style: Theme.of(context).textTheme.headlineMedium).animate().scale(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
            ),

            //I have changed my mind. Lets convert the above to expandable tiles and show all the records of the activity in the table format

            for (var activity in parent.activities)
              ExpansionTile(
                title: Text(activity.name),
                children: [
                  DataTable(
                    columns: [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Records')),
                    ],
                    rows: [
                      for (var k in activity.datedRecs.keys)
                        DataRow(
                          cells: [
                            DataCell(Text(k.toString())),
                            DataCell(Text(activity.datedRecs[k].toString())),
                          ],
                        ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      List<List<dynamic>> rows = [];
                      for (var k in activity.datedRecs.keys) {
                        List<dynamic> row = [];
                        row.add(k);
                        row.add(activity.datedRecs[k]);
                        rows.add(row);
                      }
                      String csv = const ListToCsvConverter().convert(rows);

                      final bytes = utf8.encode(csv);
                      final blob = html.Blob([bytes]);
                      final url = html.Url.createObjectUrlFromBlob(blob);
                      final anchor = html.AnchorElement(href: url)
                        ..setAttribute('download', 'activity.csv')
                        ..click();
                    },
                    child: Text('Export to CSV'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
