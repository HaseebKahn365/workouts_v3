// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';

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
    return Expanded(
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
