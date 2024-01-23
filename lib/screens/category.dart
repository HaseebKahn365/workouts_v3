//this is a stateful widget that recieves the activity data from the activityListScreen and displays it

// ignore_for_file: prefer_is_empty, sort_child_properties_last, prefer_const_constructors, avoid_print

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workouts_v3/testing/mockclassStructures.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _Tagcontroller = TextEditingController();
  List<String> tags = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.category.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                //create button for activity creation in a category:
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
                      label: const Text("Add Activity"),
                    ),
                  ),
                ),
                //end of adding activity

                if (widget.category.activityList.isEmpty)
                  Text("No activities found")
                else
                  ...widget.category.activityList.map((activity) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 13.0, right: 13.0, top: 4.0, bottom: 4.0),
                      child: Card(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Column(
                          children: [
                            Center(
                              child: Text('${activity.name}',
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton(
                                    //reduce the content padding and hieght of the button
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      minimumSize: Size(0, 0),
                                      //make the border invisible
                                      side: BorderSide.none,
                                    ),
                                    child: Text(
                                      activity.createdOn.day.toString() + '/' + activity.createdOn.month.toString() + '/' + activity.createdOn.year.toString(),
                                    ),
                                    onPressed: () {},
                                  ),
                                  OutlinedButton(
                                    //reduce the content padding and hieght of the button
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      minimumSize: Size(0, 0),
                                      side: BorderSide.none,
                                    ),

                                    onPressed: () {},
                                    child: Text(
                                      //length of the map
                                      "Records " + activity.countMap.length.toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //this is the interface to enter the count/time interval
                            OutlinedButton(
                              //reduce the border radius

                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                minimumSize: Size(0, 0),
                              ),
                              onPressed: () async {
                                // In case the category is time-based, show the time picker
                                if (!widget.category.isCountBased) {
                                  // Get the current time
                                  TimeOfDay currentTime = TimeOfDay.now();

                                  // Show time picker and wait for user input
                                  TimeOfDay? selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: currentTime,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                                        child: child!,
                                      );
                                    },
                                  );

                                  // Check if the user selected a time
                                  if (selectedTime != null) {
                                    // Calculate the difference in minutes
                                    int mins = (selectedTime.hour * 60 + selectedTime.minute) - (currentTime.hour * 60 + currentTime.minute);

                                    // Use the mins as needed
                                    print("Selected time: $selectedTime, Difference in minutes: $mins");

                                    if (mins > 1) {
                                      setState(() {
                                        activity.countMap[DateTime.now()] = mins;
                                        //add to the records
                                      });
                                    } else {
                                      //show a snackbar to tell the user "Selected Time has passed. Please try again"
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Selected Time has passed. Sorry!"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  }
                                }
                                //it is count based
                                else {
                                  //count picker with validation
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Add Count"),
                                        content: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: _controller,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.digitsOnly,
                                                    TextInputFormatter.withFunction((oldValue, newValue) {
                                                      if (newValue.text.isEmpty) {
                                                        return newValue;
                                                      }

                                                      try {
                                                        final int value = int.parse(newValue.text);
                                                        return value > 0 && value <= 5000 ? newValue : oldValue;
                                                      } catch (e) {
                                                        return oldValue;
                                                      }
                                                    }),
                                                  ],
                                                  decoration: InputDecoration(
                                                    //make sure to use overflow ellipses and also +activityname

                                                    hintText: 'Enter Count for ' + activity.name,
                                                  ),
                                                  onChanged: (value) {
                                                    // You can perform additional actions here if needed
                                                  },
                                                ),

                                                //use a single child scrollview to display the tags
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      for (int i = tags.length - 1; i >= 0; i--)
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                          child: Chip(
                                                            label: Text(tags[i]),
                                                            onDeleted: () {
                                                              setState(() {
                                                                tags.removeAt(i);
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),

                                                //tag controller

                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                                  child: TextField(
                                                    controller: _Tagcontroller,
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Add Tags',
                                                      suffixIcon: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: OutlinedButton(
                                                          onPressed: () {
                                                            if (_Tagcontroller.text.isNotEmpty) {
                                                              setState(() {
                                                                tags.add(_Tagcontroller.text);
                                                                _Tagcontroller.text = "";
                                                              });
                                                            }
                                                          },
                                                          style: OutlinedButton.styleFrom(
                                                            foregroundColor: Theme.of(context).colorScheme.primary,
                                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                            minimumSize: Size(0, 0),
                                                          ),
                                                          child: Icon(Icons.add),
                                                        ),
                                                      ),
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              _controller.text = "";
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              int? count = int.tryParse(_controller.text);

                                              if (count != null && count > 0 && count <= 5000) {
                                                print('Valid count: $count');
                                              } else {
                                                print('Invalid input');
                                              }
                                              _controller.text = "";
                                              //clear the tags controller
                                              _Tagcontroller.text = "";
                                              //empty the tag list
                                              tags = [];

                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },

                              child: Column(
                                children: [
                                  Icon((widget.category.isCountBased == true) ? FluentIcons.add_circle_24_regular : FluentIcons.timer_24_regular, size: 30),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      (widget.category.isCountBased == true) ? "Add Count " : "Add Time",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Here is just a place holder for now but later it will be replace with a linear progress indicator
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 10,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ], //end of the entire coontainer widget
                        ),
                        elevation: 0,
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
