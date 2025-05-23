import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';
import 'package:workouts_v3/buisiness_logic/probability_utils.dart';
import 'package:workouts_v3/main.dart';

const Widget divider = SizedBox(height: 10);

// If screen content width is greater or equal to this value, the light and dark
// color schemes will be displayed in a column. Otherwise, they will
// be displayed in a row.
const double narrowScreenWidthThreshold = 400;

//creating a list of DemoCategoryData objects
// List<DemoCategoryData> demoCategoryData = [
//   DemoCategoryData(name: 'Workout', count: 24),
//   DemoCategoryData(name: 'Coding', count: 12),
//   DemoCategoryData(name: 'Reading', count: 6),
//   DemoCategoryData(name: 'Meditation', count: 2),
//   DemoCategoryData(name: 'Programming', count: 24),
// ];

//now we will replace the above list with the actual data from the parent

class Today extends ConsumerStatefulWidget {
  final Parent parent;
  Today({super.key, required this.parent});

  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends ConsumerState<Today> {
  // List<ProgressObjects> progressObjects = [
  //   ProgressObjects(name: 'math', progress: 24, probability: 0.6),
  //   ProgressObjects(name: 'science', progress: 12, probability: 0.3),
  //   ProgressObjects(name: 'computer science', progress: 6, probability: 0.1),
  //   ProgressObjects(name: 'homework', progress: 2, probability: 0.5),
  // ];

  List<ProgressObjects> progressObjects = [];

  //only today's activities:
  List<Activity> todayActivities = [];

  List<Activity> getOnlyTodaysActivities(List<Activity> allActivities) {
    List<Activity> todayActivities = [];

    DateTime today = DateTime.now();

    for (Activity activity in allActivities) {
      //check if the day and year matches
      activity.datedRecs.forEach((key, value) {
        if (key.day == today.day && key.month == today.month && key.year == today.year) {
          if (!todayActivities.contains(activity)) {
            todayActivities.add(activity);
          }
        }
      });
    }
    print("length of found" + todayActivities.length.toString());
    print(todayActivities);

    return todayActivities;
  }

  int getBestValue(Activity activity) {
    int bestSummedValue = 0; // Initialize the best sum of values ever recorded for a day

    // Create a map to store the summed values for each day
    Map<DateTime, int> dailySummedValues = {};

    // Iterate over the dated records
    activity.datedRecs.forEach((key, value) {
      // Calculate the date without time components
      DateTime date = DateTime(key.year, key.month, key.day);

      // Add the value to the sum of the corresponding day
      dailySummedValues[date] = (dailySummedValues[date] ?? 0) + value;

      // Update the bestSummedValue if needed
      if (dailySummedValues[date]! > bestSummedValue) {
        bestSummedValue = dailySummedValues[date]!;
      }
    });

    // Print the result
    print('The best recorded value for a single day for ${activity.name} is $bestSummedValue');

    return bestSummedValue;
  }

  //for each activity in today's activities, we will create a progress object and add it to the list of progress objects
  List<ProgressObjects> createProgressObjects() {
    List<ProgressObjects> temp = [];
    for (Activity activity in todayActivities) {
      int bestValue = getBestValue(activity);
      print("best value for " + activity.name + " is " + bestValue.toString());
      //assign yesterday to the nearest date
      int totalCountToday = 0;
      DateTime nearestDate = DateTime.now().subtract(Duration(days: 1));
      int todaysRecent = 0;
      activity.datedRecs.forEach((key, value) {
        if (nearestDate == DateTime.now().subtract(Duration(days: 1))) {
          nearestDate = key;
        } else if (key.isAfter(nearestDate)) {
          nearestDate = key;
        }

        //logic for calcualting the total count today
        if (key.day == DateTime.now().day && key.month == DateTime.now().month && key.year == DateTime.now().year) {
          totalCountToday += value;
          print("total count today for " + activity.name + " is " + totalCountToday.toString());
        }
      });

      //todaysRecent is the sum of count today
      DateTime now = DateTime.now();
      activity.datedRecs.forEach((key, value) {
        if (key.day == now.day && key.month == now.month && key.year == now.year) {
          todaysRecent += value;
        }
      });
      //

      print("todays recent for " + activity.name + " is " + todaysRecent.toString());

      //the progress objects are for the display of the linear progress indicators we should populate the totalCountToday later which is optional parameter. modifying it in the above code is hard :(

      double probability = 0;
      List<int> validRecords = [];
      //only collect the records that are not in todays date but should be in the same hour or next hour
      activity.datedRecs.forEach((key, value) {
        if (key.day != DateTime.now().day) {
          if (key.hour == DateTime.now().hour || key.hour == DateTime.now().hour + 1) {
            validRecords.add(value);
          }
        }
      });
      String? errorMessage;
      int validRecordsSum = 0;
      //calculating lambda
      int lambda = 0;
      if (validRecords.isEmpty) {
        errorMessage = "Can't calculate probability. Insufficient records";
      } else {
        lambda = validRecords.reduce((value, element) => value + element);
        lambda = (activity.isCountBased) ? (lambda / 50).round() : (lambda / 20).round();
      }
      try {
        probability = calculateProbability(activity, lambda);
        //in case if the thrown message is "insufficient records" we will catch it and assign it to the errorMessage else other errors will be thrown and assigned to the errorMessage
        validRecordsSum = validRecords.reduce((value, element) => value + element);
      } catch (e) {
        errorMessage = e.toString();
      }

      temp.add(ProgressObjects(name: activity.name, bestValue: bestValue, todaysRecent: todaysRecent, totalToday: totalCountToday, errorMessage: errorMessage, probability: probability, isCountBased: activity.isCountBased, validRecordsSum: validRecordsSum));
    }

    return temp;
  }

  late final parent = widget.parent;
  late List<DemoCategoryData> demoCategoryDataTime;
  late List<DemoCategoryData> demoCategoryDataCount;

  /*
  now we will get the acutal data for the pie chart.
  for each activity in the todayActivities list, we will get only the activites which is time based. in this list we will get the total time spent on each activity. we will store the name of the activity and the total time spent on it in a list of DemoCategoryData objects.
   */

  List<DemoCategoryData> getDemoCategoryDataForTime() {
    List<DemoCategoryData> temp = [];
    for (Activity activity in todayActivities) {
      if (activity.isCountBased == false) {
        int totalTime = 0;
        activity.datedRecs.forEach((key, value) {
          //only if the year and day matches
          if (key.day == DateTime.now().day && key.year == DateTime.now().year) {
            totalTime += value;
          }
        });
        temp.add(DemoCategoryData(name: activity.name, count: totalTime));
      }
    }
    return temp;
  }

  List<DemoCategoryData> getDemoCategoryDataForCount() {
    List<DemoCategoryData> temp = [];
    for (Activity activity in todayActivities) {
      if (activity.isCountBased == true) {
        int totalCount = 0;
        activity.datedRecs.forEach((key, value) {
          //only if the year and day matches
          if (key.day == DateTime.now().day && key.month == DateTime.now().month && key.year == DateTime.now().year) {
            totalCount += value;
          }
        });
        temp.add(DemoCategoryData(name: activity.name, count: totalCount));
      }
    }

    return temp;
  }

  void initState() {
    super.initState();
    parent.forceDownload();
    todayActivities = getOnlyTodaysActivities(parent.activities);
    progressObjects = createProgressObjects();
    demoCategoryDataTime = getDemoCategoryDataForTime();
    // print("Printing demoCategoryDataTime\n" + demoCategoryDataTime.toString());
    demoCategoryDataCount = getDemoCategoryDataForCount();
  }

  void refresher() async {
    await parent.forceDownload();
    demoCategoryDataTime = getDemoCategoryDataForTime();
    // print("Printing demoCategoryDataTime\n" + demoCategoryDataTime.toString());
    demoCategoryDataCount = getDemoCategoryDataForCount();

    //we should make sure that the above functions run first to populate the today progress objects (linearprogresses) from this data.
    todayActivities = getOnlyTodaysActivities(parent.activities);
    progressObjects = createProgressObjects();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print("progress objects: " + progressObjects.toString());

    return Expanded(
        child: ListView(
      padding: EdgeInsets.symmetric(horizontal: (isWeb) ? 210 : 10),
      children: [
        //elevated button to refresh
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0),
          child: ElevatedButton(
            onPressed: refresher,
            child: Text("Refresh"),
          ),
        ),

        const SizedBox(height: 16),
        ...progressObjects.map((progressObject) {
          return Column(
            children: [
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                  child: Column(
                    children: [
                      Text(progressObject.name + "\n", style: Theme.of(context).textTheme.headlineSmall),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Today: ${progressObject.todaysRecent}"),
                          Text('Best: ${progressObject.bestValue}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(10),
                        //check for /0 error by making the min best value 1
                        value: progressObject.todaysRecent / (progressObject.bestValue == 0 ? 1 : progressObject.bestValue),
                        minHeight: 10,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                      const SizedBox(height: 20),
                      Center(
                          child: Text(
                        "You have done ${progressObject.validRecordsSum} within these 2 Hrs",
                        style: TextStyle(fontSize: 15),
                      )),
                      const SizedBox(height: 8),
                      Center(
                          child: Text(
                        //upto 2 decimal places
                        (progressObject.errorMessage == null) ? "Probability: ${(progressObject.probability * 100).toStringAsFixed(2)} %" : "Can't calculate probability. Insufficient records",
                        style: TextStyle(fontSize: 11),
                      )),
                      const SizedBox(height: 8),

                      //displaying a linear progress indicator in case if errorMessage is not null
                      if (progressObject.errorMessage == null)
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(10),
                          //check for /0 error by making the min best value 1
                          value: progressObject.probability + 0.5,
                          minHeight: 10,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                    ],
                  ),
                ),
              ).animate().slide(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
            ],
          );
        }),
        const SizedBox(height: 16),
        Center(child: Text("Time Based Activities", style: Theme.of(context).textTheme.headlineSmall)),
        PiechartWidget(demoCategoryData: demoCategoryDataTime, isCountBased: false),
        const SizedBox(height: 16),
        Center(child: Text("Count Based Activities", style: Theme.of(context).textTheme.headlineSmall)),
        PiechartWidget(demoCategoryData: demoCategoryDataCount),
      ],
    ));
  }
}

class PiechartWidget extends StatelessWidget {
  final List<DemoCategoryData> demoCategoryData;
  final bool isCountBased;
  const PiechartWidget({super.key, required this.demoCategoryData, this.isCountBased = true});

  @override
  Widget build(BuildContext context) {
    return (demoCategoryData.isEmpty)
        ? Center(
            child: Text("No " + (isCountBased ? "count-based" : "time-based") + " Activities Today! 🥺",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                )),
          )
        : Container(
            height: 350,
            width: 200,
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0),
            child: PieChart(
              PieChartData(
                sections: demoCategoryData.map((demoCategoryData) {
                  return PieChartSectionData(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    value: demoCategoryData.count.toDouble(),
                    title: demoCategoryData.name + "\n(" + demoCategoryData.count.toString() + (isCountBased ? ")" : " mins)"),
                    radius: 100,
                    titleStyle: TextStyle(
                      fontSize: 10, // Adjust the font size as needed
                      color: Theme.of(context).colorScheme.primary, // Customize the color
                    ),
                  );
                }).toList(),
                sectionsSpace: 0.5, // You can adjust the space between sections
                centerSpaceRadius: 50, // Adjust the size of the center space
              ),
            ));
  }
}

//this is just a temporary class for the UI
class ProgressObjects {
  String? errorMessage;
  String name;
  int bestValue;
  int todaysRecent;
  int totalToday;
  final double probability;
  final bool isCountBased;
  final int validRecordsSum;

  ProgressObjects({required this.validRecordsSum, required this.isCountBased, required this.name, required this.bestValue, required this.todaysRecent, this.totalToday = 0, required this.errorMessage, required this.probability});
}

class DemoCategoryData {
  final String name;
  final int count;

  const DemoCategoryData({required this.name, required this.count});

  @override
  String toString() {
    return 'DemoCategoryData{name: $name, count: $count}';
  }
}
