// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_function_declarations_over_variables

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';
import 'package:workouts_v3/buisiness_logic/firebase_uploader.dart';
import 'package:workouts_v3/main.dart';
import 'package:workouts_v3/screens/activity_screen.dart';
// import 'package:workouts_v3/screens/db_table_view.dart';

//creating Instance of the Parent Class as changeNotifierprovider using riverpod

//creating instance of the DEVLogs

class HomeScreen extends ConsumerStatefulWidget {
  final Parent parent;
  const HomeScreen({Key? key, required this.showNavBottomBar, required this.parent}) : super(key: key);

  final bool showNavBottomBar;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//download all the documents from the activities collection under the user document named as phoneId

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  int selectedOption = 1;

  Widget build(BuildContext context) {
    final callableHomeRefresh = () {
      print("Home Refreshed");
      setState(() {});
    };
    final parent = widget.parent;
    parent.fetchActivities();
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: ListView(
          shrinkWrap: false,
          children: [
            //create an outlined button that says create workout

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: 100, // Set the width of the Container
                alignment: Alignment.center, // Center the button within the Container
                child: OutlinedButton.icon(
                  onPressed: () {
                    //an alert dialogye box asking for the type and name of the category.
                    //the name is taken using text field and the type is taken using radio buttons
                    bool isCreatedPressed = false;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController _textFieldController = TextEditingController();
                        return StatefulBuilder(
                          builder: (context, setState) => AlertDialog(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            title: Center(
                                child: const Text(
                              "Create Activity",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            )),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  //center the text field
                                  textAlign: TextAlign.center,
                                  controller: _textFieldController,

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    labelText: 'Activity Name',
                                  ),
                                ),
                                //radio buttons for selecting the type of the category
                                const SizedBox(
                                  height: 10,
                                ),

                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: 2,
                                          groupValue: selectedOption,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedOption = value as int;
                                            });
                                          },
                                        ),
                                        const Text("Count Based (number)"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: selectedOption,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedOption = value as int;
                                            });
                                          },
                                        ),
                                        const Text("Time Based (mins)"),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {},
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  //disable the button
                                  //create a Category Object and add it to the list
                                  if (!isCreatedPressed) {
                                    isCreatedPressed = true;
                                    final activityItem = Activity(
                                      isCountBased: selectedOption == 1 ? false : true,
                                      name: _textFieldController.text,
                                    );

                                    if (_textFieldController.text.trim().isEmpty) {
                                      //show snakbar that activity was not added.
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Error: Activity name empty!"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      print("uploading the activity: $activityItem");
                                      final tempUploader = FirebaseUploader(
                                        activity: activityItem,
                                        imageFileList: [],
                                        recordCount: 0,
                                        tags: [],
                                        uploadTime: DateTime.now(),
                                      );

                                      bool uploadSuccess = await tempUploader.uploadTheRecord();

                                      // Show the appropriate SnackBar based on the upload result
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(uploadSuccess ? "Activity Added!" : "Error: Activity not added!"),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );

                                      // If upload was successful, update the state
                                      if (uploadSuccess) {
                                        setState(() {
                                          parent.addActivity(activityItem);
                                          callableHomeRefresh();
                                        });
                                      }
                                    }

                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text("Create"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                  //display the activities length we will remove it later

                  label: Text("Add Activity [ ${parent.activities.length} ]"),
                ),
              ),
            )
                .animate()
                .scale(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                )
                .then()
                .shake(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  hz: 2,
                ),

            const SizedBox(
              height: 10,
            ),

            Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 17),
              child: Text(motivationalMessage),
            )),

            const SizedBox(
              height: 10,
            ),

            //creating a card for each category using expand operator for the list
            ...parent.activities.map(
              (activity) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: ListTile(
                    title: Text(activity.name),
                    subtitle: Text(activity.isCountBased ? "Count Based" : "Time Based"),
                    trailing: Text(
                      //activity.datedRecs.length.toString(),
                      activity.totalRecords.toString(),
                    ),
                    onTap: () {
                      //navigate to the activity screen using material route
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ActivityScreen(
                            activity: activity,
                            callableRefresh: callableHomeRefresh,
                          ),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    splashColor: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  elevation: 0,
                )
                    .animate()
                    .slideY(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      begin: 1,
                    )
                    .then()
                    .shimmer(),
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            //create an elevated button that says View relational DB
            // Column(
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         //navigate to the activity screen using material route
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => DBTableView(
            //               sqlServiceObject: parent.sqlService,
            //               allActivities: parent.activities,
            //             ),
            //           ),
            //         );
            //       },
            //       child: const Text("View Relational DB"),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

const _rowDivider = SizedBox(width: 10);
const _colDivider = SizedBox(height: 10);
const double _cardWidth = 115;
const double _maxWidthConstraint = 400;

class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FloatingActionButton.small(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          _rowDivider,
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          _rowDivider,
          FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Create"),
          ),
          _rowDivider,
          FloatingActionButton.large(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

//bottom navigators and navigation rails code

const List<NavigationDestination> appBarDestinations = [
  NavigationDestination(
    tooltip: "",
    icon: Icon(FluentIcons.home_24_regular),
    label: 'Home',
    selectedIcon: Icon(FluentIcons.home_24_filled),
  ),
  NavigationDestination(
    tooltip: "",
    icon: Icon(FluentIcons.book_coins_24_regular, size: 28),
    label: 'Today',
    selectedIcon: Icon(FluentIcons.book_coins_24_filled, size: 28),
  ),
  NavigationDestination(
    tooltip: "",
    icon: Icon(FluentIcons.people_28_regular),
    label: 'Overall',
    selectedIcon: Icon(FluentIcons.people_28_filled),
  ),
];

final List<NavigationRailDestination> navRailDestinations = appBarDestinations
    .map(
      (destination) => NavigationRailDestination(
        icon: Tooltip(
          message: destination.label,
          child: destination.icon,
        ),
        selectedIcon: Tooltip(
          message: destination.label,
          child: destination.selectedIcon,
        ),
        label: Text(destination.label),
      ),
    )
    .toList();

class NavigationBars extends StatefulWidget {
  final void Function(int)? onSelectItem;
  final int selectedIndex;
  final bool isExampleBar;

  const NavigationBars({super.key, this.onSelectItem, required this.selectedIndex, required this.isExampleBar});

  @override
  State<NavigationBars> createState() => _NavigationBarsState();
}

class _NavigationBarsState extends State<NavigationBars> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
        if (!widget.isExampleBar) widget.onSelectItem!(index);
      },
      destinations: widget.isExampleBar ? [] : appBarDestinations,
    );
  }
}

class NavigationRailSection extends StatefulWidget {
  final void Function(int) onSelectItem;
  final int selectedIndex;

  const NavigationRailSection({super.key, required this.onSelectItem, required this.selectedIndex});

  @override
  State<NavigationRailSection> createState() => _NavigationRailSectionState();
}

class _NavigationRailSectionState extends State<NavigationRailSection> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      minWidth: 50,
      destinations: navRailDestinations,
      selectedIndex: _selectedIndex,
      useIndicator: true,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onSelectItem(index);
      },
    );
  }
}
