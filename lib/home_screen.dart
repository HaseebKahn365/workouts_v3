// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:workouts_v3/screens/category.dart';
import 'package:workouts_v3/screens/devlog.dart';
import 'package:workouts_v3/testing/mockclassStructures.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.showNavBottomBar});

  final bool showNavBottomBar;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initDEVLogs();
  }

  int selectedOption = 1;

  Widget build(BuildContext context) {
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

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setState) => AlertDialog(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            title: Center(
                                child: const Text(
                              "Create Category",
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

                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    labelText: 'Category Name',
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

                                    // Add more Radio widgets as needed
                                  ],
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
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
                  label: const Text("Add Category"),
                ),
              ),
            ),

            //creating a card for each category using expand operator for the list
            ...categories.map((category) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
                  child: Card(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: ListTile(
                      title: Text(category.name),
                      subtitle: Text(category.isCountBased ? "Count Based" : "Time Based"),
                      trailing: Text(category.activityList.length.toString()),
                      onTap: () {
                        //use material route to navigate to the activity screen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(category: category)));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      splashColor: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    elevation: 0,
                  ),
                )),

            //card for the DEVLogs
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
              child: Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: ListTile(
                  title: Text("DEVLogs"),
                  subtitle: Text("View the logs for all the apps"),
                  trailing: Text("${devLogs.getProjectCount()} Projects"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DEVLogScreen()));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  splashColor: Theme.of(context).colorScheme.secondaryContainer,
                ),
                elevation: 0,
              ),
            ),
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

class Dialogs extends StatefulWidget {
  const Dialogs({super.key});

  @override
  State<Dialogs> createState() => _DialogsState();
}

class _DialogsState extends State<Dialogs> {
  void openDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Basic Dialog Title"),
        content: const Text("A dialog is a type of modal window that appears in front of app content to provide critical information, or prompt for a decision to be made."),
        actions: <Widget>[
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Action'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextButton(
        child: const Text(
          "Open Dialog",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => openDialog(context),
      ),
    );
  }
}

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

const List<Widget> exampleBarDestinations = [
  NavigationDestination(
    tooltip: "",
    icon: Icon(Icons.explore_outlined),
    label: 'Explore',
    selectedIcon: Icon(Icons.explore),
  ),
  NavigationDestination(
    tooltip: "",
    icon: Icon(Icons.pets_outlined),
    label: 'Pets',
    selectedIcon: Icon(Icons.pets),
  ),
  NavigationDestination(
    tooltip: "",
    icon: Icon(Icons.account_box_outlined),
    label: 'Account',
    selectedIcon: Icon(Icons.account_box),
  )
];

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
      destinations: widget.isExampleBar ? exampleBarDestinations : appBarDestinations,
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
