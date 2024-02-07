//here the user can upload a new devlog entry

// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';
import 'package:workouts_v3/home_screen.dart';

class DEVLogScreen extends ConsumerStatefulWidget {
  const DEVLogScreen({Key? key, required this.callableHomeRefresh}) : super(key: key);
  final callableHomeRefresh;

  @override
  _DEVLogScreenState createState() => _DEVLogScreenState();
}

class _DEVLogScreenState extends ConsumerState<DEVLogScreen> {
  void refresh() {
    setState(() {});
  }

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
                            TextEditingController _textFieldController = TextEditingController();
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
                                      controller: _textFieldController,

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
                                      //create a new Project object and add it to the project list using provider
                                      if (_textFieldController.text.trim().isNotEmpty) {
                                        ref.read(parentProvider).devLogs.addToProjectList(
                                              Project(
                                                name: _textFieldController.text,
                                                createdOn: DateTime.now(),
                                              ),
                                            );
                                      } else {
                                        //show a snackbar
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Error: Project name cannot be empty'),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                      refresh();
                                      widget.callableHomeRefresh();

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

                ...ref.watch(parentProvider).devLogs.projectList.map((project) {
                  TextEditingController descriptionController = TextEditingController();

                  final ImagePicker imagePicker = ImagePicker();
                  List<XFile> imageFileList = []; // Moved this list outside the map function to prevent resetting on every iteration

                  void selectImages() async {
                    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
                    if (selectedImages != null) {
                      imageFileList.addAll(selectedImages);
                      refresh();
                    }
                    print("${imageFileList.length} images selected");
                  }

                  descriptionController.text = ""; // Set initial description

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
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        minimumSize: Size(0, 0),
                                        side: BorderSide.none,
                                      ),
                                      child: Text(
                                        project.createdOn.day.toString() + '/' + project.createdOn.month.toString() + '/' + project.createdOn.year.toString(),
                                      ),
                                      onPressed: () {
                                        // Navigate to the project screen
                                      },
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        minimumSize: Size(0, 0),
                                        side: BorderSide.none,
                                      ),
                                      onPressed: () {
                                        // Navigate to the project screen
                                      },
                                      child: Text(
                                        "Logs " + project.projectRecordList.length.toString(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        foregroundColor: Theme.of(context).colorScheme.primary,
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                        minimumSize: Size(0, 0),
                                      ),
                                      onPressed: () {
                                        selectImages();
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
                                    Wrap(spacing: 20, children: [
                                      ...imageFileList.map((image) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context).colorScheme.primary,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.file(
                                                File(image.path),
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ]),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                child: TextField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Description',
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10, left: 10, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        minimumSize: Size(0, 0),
                                        side: BorderSide.none,
                                      ),
                                      child: Text(
                                        'Cancel',
                                      ),
                                      onPressed: () {
                                        // Clear the image list and reset description
                                        imageFileList.clear();
                                        descriptionController.text = "";
                                      },
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        minimumSize: Size(0, 0),
                                      ),
                                      onPressed: () {
                                        // Save the changes
                                        project.projectRecordList.add(
                                          ProjectRecord(
                                            description: descriptionController.text,
                                            images: imageFileList
                                                .map((image) => Image.file(
                                                      //conver the XFile to File
                                                      File(image.path),
                                                    ))
                                                .toList(),
                                            createdOn: DateTime.now(),
                                          ),
                                        );

                                        // Clear the image list and reset description
                                        imageFileList.clear();
                                        descriptionController.text = "";
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
