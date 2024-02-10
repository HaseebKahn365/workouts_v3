// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Overall extends StatelessWidget {
  const Overall({super.key});

  @override
  Widget build(BuildContext context) {
    // Compare this snippet from lib\main.dart:

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
              child: LineChartWidget().animate().slide(
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

Map<String, int> devData = {
  '7': 3,
  '6': 2,
  '5': 1,
  '4': 2,
  '3': 3,
  '2': 6,
  '1': 1,
};

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 35, top: 20, bottom: 20),
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
      ),
      // child: LineChart(LineChartData()));
      child: Text("fl chart not supported"),
    );
  }
}
