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

  List<Map<String, int>> lineChartDataList = [];

  List<Map<String, int>> getLineChartDataList() {
    List<Map<String, int>> lineChartDataList = [];

    List<Activity> activitiesThisWeek = [];
    //get the activities that were active this week by going through every activity in the list of activities in the parent and checking if its DateTime is in the current week by using the DateTime.subtract() method along wih the DateTime.isAfter() method
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

    //we will go through each activity present in the list of t
    return lineChartDataList;
  }

  Widget build(BuildContext context) {
    getLineChartDataList();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 16),
            Text('  Weekly\'s Progress ', style: Theme.of(context).textTheme.headlineMedium).animate().scale(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
            //here we will have the weekly report of the user's devlogs showing how much time he spent on developement.
            //we will have a bar chart to show the progress of the user in the week.
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
              child: LineChartWidget(
                lineDataMap: {
                  'Mon': 5,
                  'Tue': 6,
                  'Wed': 7,
                  'Thu': 8,
                  'Fri': 9,
                  'Sat': 10,
                  'Sun': 11,
                },
              ).animate().slide(
                    duration: const Duration(milliseconds: 500),
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                    curve: Curves.easeInOut,
                  ),
            ),
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
      padding: EdgeInsets.only(left: 20, right: 35, top: 20, bottom: 20),
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
      ),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  interval: 1,
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text(
                        lineDataMap.keys.toList()[value.toInt()],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )),
            ),

            //only showw the titles on the bottom
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                //50% of the max in the map
                interval: lineDataMap.values.reduce((value, element) => value > element ? value : element).toDouble() * 0.3,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: (value == 0) ? Colors.amber.withOpacity(0) : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
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
