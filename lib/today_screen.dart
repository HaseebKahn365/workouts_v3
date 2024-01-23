import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  List<ProgressObjects> progressObjects = [
    ProgressObjects(name: 'math', progress: 24, probability: 0.6),
    ProgressObjects(name: 'science', progress: 12, probability: 0.3),
    ProgressObjects(name: 'computer science', progress: 6, probability: 0.1),
    ProgressObjects(name: 'homework', progress: 2, probability: 0.05),
  ];

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
    // Color selectedColor = Theme.of(context).primaryColor;
    // ThemeData lightTheme = ThemeData(colorSchemeSeed: selectedColor, brightness: Brightness.light);
    // ThemeData darkTheme = ThemeData(colorSchemeSeed: selectedColor, brightness: Brightness.dark);

    return Expanded(
        child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        const SizedBox(height: 16),
        Text(' Today\'s Activities ', style: Theme.of(context).textTheme.headlineMedium).animate().scale(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),

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
                      Text(progressObject.name, style: Theme.of(context).textTheme.headlineSmall),
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

                      //doing the same for probability

                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Probability', style: Theme.of(context).textTheme.bodyText1),
                          Text('${(progressObject.probability * 100).toStringAsFixed(0)}%'),
                        ],
                      ),

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

class HorizontalBars extends StatelessWidget {
  const HorizontalBars({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
