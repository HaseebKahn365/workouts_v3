//here the user can upload a new devlog entry

// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:workouts_v3/testing/mockclassStructures.dart';

class DEVLogScreen extends StatefulWidget {
  const DEVLogScreen({super.key});

  @override
  State<DEVLogScreen> createState() => _DEVLogScreenState();
}

class _DEVLogScreenState extends State<DEVLogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('DEVLog'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                //create project button
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
                                  "Create Project",
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
                                        labelText: 'Project Name',
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
                      label: const Text("Add Project"),
                    ),
                  ).animate().scale(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                ), //end of the project creation button

                //display all the projects here using cards
                //each card will have a title, date, and a button to add a new log

                ...devLogs.projects.map((project) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, right: 15.0, left: 15.0),
                    child: Card(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            children: [
                              Center(
                                child: Text('${project.name}',
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
                                        //display only the date of the project ie dd:mm:yy
                                        // project.getLastUpdated()?.day.toString() + '/' + project.getLastUpdated()?.month.toString() + '/' + project.getLastUpdated().year.toString(),
                                        project.createdOn.day.toString() + '/' + project.createdOn.month.toString() + '/' + project.createdOn.year.toString(),
                                      ),
                                      onPressed: () {
                                        //navigate to the project screen
                                        // Navigator.pushNamed(context, '/project', arguments: project);
                                      },
                                    ),
                                    //wrap the following Text in an outline button
                                    // Text("Logs " + project.logs.length.toString())
                                    OutlinedButton(
                                      //reduce the content padding and hieght of the button
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        minimumSize: Size(0, 0),
                                        side: BorderSide.none,
                                      ),

                                      onPressed: () {
                                        //navigate to the project screen
                                        Navigator.pushNamed(context, '/project', arguments: project);
                                      },
                                      child: Text(
                                        "Logs " + project.logs.length.toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //create a container widget that will have an add image icon outlined button and label add image

                              Container(
                                child: Column(
                                  children: [
                                    //add a label here
                                    //add an outlined button here
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
                                      onPressed: () {
                                        //add an image to the project
                                        // Navigator.pushNamed(context, '/project', arguments: project);
                                      },
                                      child: Column(
                                        children: [
                                          Icon(FluentIcons.add_circle_24_regular, size: 30),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Text('Add Image'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //we will implement the wrap widget for images here later

                              //here will be big textfield for adding description of the project
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Description',
                                  ),
                                  maxLines: 2,
                                ),
                              ),

                              //here we will have the save and cancel buttons
                              Padding(
                                padding: EdgeInsets.only(right: 10, left: 10, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                        'Cancel',
                                      ),
                                      onPressed: () {
                                        //navigate to the project screen
                                        // Navigator.pushNamed(context, '/project', arguments: project);
                                      },
                                    ),
                                    //wrap the following Text in an outline button
                                    // Text("Logs " + project.logs.length.toString())
                                    OutlinedButton(
                                      //reduce the content padding and hieght of the button
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        minimumSize: Size(0, 0),
                                      ),

                                      onPressed: () {
                                        //navigate to the project screen
                                        Navigator.pushNamed(context, '/project', arguments: project);
                                      },
                                      child: Text(
                                        "Save",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 0,
                    ).animate().scale(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
