// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
  }

  bool radioSelection = false;

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
                        return AlertDialog(
                          title: const Text("Create Category"),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(5.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Category Name',
                                ),
                              ),
                              //create two radio buttons for the type of category
                              Column(
                                children: [
                                  Radio(
                                    value: false,
                                    groupValue: radioSelection,
                                    onChanged: (value) {
                                      setState(() {
                                        radioSelection = value as bool;
                                      });
                                    },
                                  ),
                                  const Text("Count Based"),
                                  Radio(
                                    value: true,
                                    groupValue: radioSelection,
                                    onChanged: (value) {
                                      setState(() {
                                        radioSelection = value as bool;
                                      });
                                    },
                                  ),
                                  const Text("Time Based"),
                                ],
                              ),
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
                        // Navigator.pushNamed(context, '/category', arguments: category);
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
                  trailing: Text("0"),
                  onTap: () {
                    // Navigator.pushNamed(context, '/category', arguments: category);
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

void Function()? handlePressed(BuildContext context, bool isDisabled, String buttonName) {
  return isDisabled
      ? null
      : () {
          final snackBar = SnackBar(
            content: Text(
              'Yay! $buttonName is clicked!',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
            action: SnackBarAction(
              textColor: Theme.of(context).colorScheme.surface,
              label: 'Close',
              onPressed: () {},
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        };
}

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: const <Widget>[
        ButtonsWithoutIcon(isDisabled: false),
        _rowDivider,
        ButtonsWithIcon(),
        _rowDivider,
        ButtonsWithoutIcon(isDisabled: true),
      ],
    );
  }
}

class ButtonsWithoutIcon extends StatelessWidget {
  final bool isDisabled;

  const ButtonsWithoutIcon({super.key, required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElevatedButton(
            onPressed: handlePressed(context, isDisabled, "ElevatedButton"),
            child: const Text("Elevated"),
          ),
          _colDivider,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // Foreground color
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              // Background color
              primary: Theme.of(context).colorScheme.primary,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            onPressed: handlePressed(context, isDisabled, "FilledButton"),
            child: const Text('Filled'),
          ),
          _colDivider,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // Foreground color
              onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
              // Background color
              primary: Theme.of(context).colorScheme.secondaryContainer,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            onPressed: handlePressed(context, isDisabled, "FilledTonalButton"),
            child: const Text('Filled Tonal'),
          ),
          _colDivider,
          OutlinedButton(
            onPressed: handlePressed(context, isDisabled, "OutlinedButton"),
            child: const Text("Outlined"),
          ),
          _colDivider,
          TextButton(onPressed: handlePressed(context, isDisabled, "TextButton"), child: const Text("Text")),
        ],
      ),
    );
  }
}

class ButtonsWithIcon extends StatelessWidget {
  const ButtonsWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElevatedButton.icon(
            onPressed: handlePressed(context, false, "ElevatedButton with Icon"),
            icon: const Icon(Icons.add),
            label: const Text("Icon"),
          ),
          _colDivider,
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              // Foreground color
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              // Background color
              primary: Theme.of(context).colorScheme.primary,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            onPressed: handlePressed(context, false, "FilledButton with Icon"),
            label: const Text('Icon'),
            icon: const Icon(Icons.add),
          ),
          _colDivider,
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              // Foreground color
              onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
              // Background color
              primary: Theme.of(context).colorScheme.secondaryContainer,
            ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
            onPressed: handlePressed(context, false, "FilledTonalButton with Icon"),
            label: const Text('Icon'),
            icon: const Icon(Icons.add),
          ),
          _colDivider,
          OutlinedButton.icon(
            onPressed: handlePressed(context, false, "OutlinedButton with Icon"),
            icon: const Icon(Icons.add),
            label: const Text("Icon"),
          ),
          _colDivider,
          TextButton.icon(
            onPressed: handlePressed(context, false, "TextButton with Icon"),
            icon: const Icon(Icons.add),
            label: const Text("Icon"),
          )
        ],
      ),
    );
  }
}

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

class Cards extends StatelessWidget {
  const Cards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: _cardWidth,
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: const [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.more_vert),
                    ),
                    SizedBox(height: 35),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("Elevated"),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: _cardWidth,
            child: Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: const [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.more_vert),
                    ),
                    SizedBox(height: 35),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("Filled"),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: _cardWidth,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: const [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.more_vert),
                    ),
                    SizedBox(height: 35),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("Outlined"),
                    )
                  ],
                ),
              ),
            ),
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
    label: 'Stats',
    selectedIcon: Icon(FluentIcons.book_coins_24_filled, size: 28),
  ),
  NavigationDestination(
    tooltip: "",
    icon: Icon(FluentIcons.people_28_regular),
    label: 'Competition',
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
