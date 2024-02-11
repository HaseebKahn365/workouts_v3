import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';
import 'package:workouts_v3/home_screen.dart';

const Widget divider = SizedBox(height: 10);

// If screen content width is greater or equal to this value, the light and dark
// color schemes will be displayed in a column. Otherwise, they will
// be displayed in a row.
const double narrowScreenWidthThreshold = 400;

//create a list of DemoCategoryData objects
List<DemoCategoryData> demoCategoryData = [
  DemoCategoryData(name: 'Workout', count: 24),
  DemoCategoryData(name: 'Coding', count: 12),
  DemoCategoryData(name: 'Reading', count: 6),
  DemoCategoryData(name: 'Meditation', count: 2),
  DemoCategoryData(name: 'Programming', count: 24),
];

//now we will replace the above list with the actual data from the parent

class Today extends ConsumerStatefulWidget {
  const Today({super.key});

  @override
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends ConsumerState<Today> {
  @override
  // List<ProgressObjects> progressObjects = [
  //   ProgressObjects(name: 'math', progress: 24, probability: 0.6),
  //   ProgressObjects(name: 'science', progress: 12, probability: 0.3),
  //   ProgressObjects(name: 'computer science', progress: 6, probability: 0.1),
  //   ProgressObjects(name: 'homework', progress: 2, probability: 0.5),
  // ];

  //now creating a list of progress objects from the activities in the parent object:
  late List<ProgressObjects> progressObjects;

  /*the parent object contains the list of all the activities. we should look throw all the activites and find the activities whose datedRecs contains at least one key with Date matching today's day
    the following are the members of activity object
    late bool isCountBased;
  bool shouldAppear = true; //used to remove the activity from the list and firestore just by setting it to false
  DateTime createdOn = DateTime.now();
  int totalRecords = 0;
  late String name;
  Map<DateTime, int> datedRecs = {};
  Map<String, List<String>> imgMapArray = {};
  Map<String, List<String>> tagMapArray = {};

  



    
    */
  List<Activity> getOnlyTodaysActivities(List<Activity> allActivities) {
    List<Activity> todayActivities = [];

    DateTime today = DateTime.now();
    DateTime todayDate = DateTime(today.year, today.month, today.day);

    for (Activity activity in allActivities) {
      //check if the day and year matches
      activity.datedRecs.forEach((key, value) {
        if (key.day == today.day && key.year == today.year) {
          todayActivities.add(activity);
        }
      });
    }

    return todayActivities;
  }

  //converting activities into progress objects
  //the progress objects should first filter all the records whose dates match with todays date then in these records we find best value in all the map of data recs
  //we use the best value as to pass to the argument of the 
  /*
   String name; //activity name
  int progress; //best value
  double probability;// today's best value

  the created progress object is added to the list of the progressObjects.
   */

  

  late Parent parent;

  int getMaxProgress() {
    int max = 0;
    for (int i = 0; i < progressObjects.length; i++) {
      if (progressObjects[i].progress > max) {
        max = progressObjects[i].progress;
      }
    }
    return max;
  }

  double getMaxProbability() {
    double max = 0;
    for (int i = 0; i < progressObjects.length; i++) {
      if (progressObjects[i].probability > max) {
        max = progressObjects[i].probability;
      }
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    parent = ref.read(parentProvider);

   

    return Expanded(
        child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        const SizedBox(height: 16),

        //here we will use the spread operator on the list of progress objects
        //to create a list of widgets
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
                          Text(progressObject.name, style: Theme.of(context).textTheme.bodyText1),
                          Text('${progressObject.progress} / ${getMaxProgress()}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(10),
                        value: progressObject.probability,
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

              // Here we will have a pie chart to display the contribution to each category. ie. DemoCategoryData list
            ],
          );
        }),
        PiechartWidget(demoCategoryData: demoCategoryData),
      ],
    ));
  }
}

class PiechartWidget extends StatelessWidget {
  final List<DemoCategoryData> demoCategoryData;
  const PiechartWidget({super.key, required this.demoCategoryData});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 350,
        width: 200,
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0),
        child: PieChart(
          PieChartData(
            sections: demoCategoryData.map((demoCategoryData) {
              return PieChartSectionData(
                color: Theme.of(context).colorScheme.secondaryContainer,
                value: demoCategoryData.count.toDouble(),
                title: demoCategoryData.name,
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
  String name;
  int progress;
  double probability;

  ProgressObjects({required this.name, required this.progress, required this.probability});
}

class DemoCategoryData {
  final String name;
  final int count;

  const DemoCategoryData({required this.name, required this.count});
}
