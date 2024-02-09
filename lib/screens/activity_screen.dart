// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';
import 'package:workouts_v3/buisiness_logic/firebase_uploader.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  final Activity activity;
  final Function callableRefresh;
  ActivityScreen({required this.activity, required this.callableRefresh});
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<Image> images = [];

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = []; // Moved this list outside the map function to prevent resetting on every iteration

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null) {
      imageFileList.addAll(selectedImages);
      setState(() {
        images.addAll(
          selectedImages.map(
            (e) => Image.file(
              File(e.path),
              fit: BoxFit.cover,
            ),
          ),
        );
      });
    }
    print("${imageFileList.length} images selected");
  }

  TextEditingController _Tagcontroller = TextEditingController();
  TextEditingController _countController = TextEditingController();
  List<String> tags = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.activity.name,
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 9.0, right: 9.0, top: 4.0, bottom: 10.0),
                  child: Card(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
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
                                  //created on
                                  widget.activity.createdOn.day.toString() + '/' + widget.activity.createdOn.month.toString() + '/' + widget.activity.createdOn.year.toString(),
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
                                  //total records
                                  widget.activity.totalRecords.toString() + ' Records',
                                ),
                              ),
                            ],
                          ),

                          //text field for entering count
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: _countController,
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
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),

                                labelText: 'Count' + (widget.activity.isCountBased ? '' : ' (mins)'),
                                floatingLabelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                floatingLabelAlignment: FloatingLabelAlignment.center,
                                //center the label
                                alignLabelWithHint: true,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  //set it as controller text
                                  _countController.text = value;
                                });
                              },
                            ),
                          ),

                          // icon button for adding count for adding images
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: OutlinedButton(
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
                          ),

                          //wrap widget for displaying list of images
                          (images.isEmpty)
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Selected Images: ${images.length}',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                                      ),
                                      (imageFileList.length >= 10)
                                          ? Text(
                                              '(Only the first 10 images will be uploaded)',
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                          SingleChildScrollView(
                            //display each image iin a conatiner
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              //reverse the elements

                              children: images.reversed
                                  .map(
                                    (image) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.primary,
                                            width: 2,
                                          ),
                                        ),
                                        height: 100,
                                        width: 100,
                                        child: ClipOval(
                                          child: image,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),

                          //adding and displaying tags
                          //use a single child scrollview to display the tags
                          const SizedBox(
                            height: 10,
                          ),
                          (tags.isEmpty)
                              ? Container()
                              : SingleChildScrollView(
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

                          TextField(
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

                          //Here is just a place holder for now but later it will be replace with a linear progress indicator
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
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
                          ),

                          //adding action buttons

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                                child: OutlinedButton(
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
                                    resetter();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: (tags.isNotEmpty || _countController.text.isNotEmpty || imageFileList.isNotEmpty) ? Theme.of(context).colorScheme.primary.withOpacity(0.09) : Theme.of(context).colorScheme.onSurface.withOpacity(0.03),
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    minimumSize: Size(0, 0),
                                  ),
                                  onPressed: () {
                                    // Save the changes
                                    if (tags.isNotEmpty || _countController.text.isNotEmpty || imageFileList.isNotEmpty) {
                                      DateTime now = DateTime.now();
                                      final FirebaseUploader uploaderInstance = FirebaseUploader(
                                        uploadTime: now,
                                        tags: tags.isNotEmpty ? tags : [""],
                                        imageFileList: imageFileList,
                                        activity: widget.activity,
                                        recordCount: _countController.text.isNotEmpty ? int.parse(_countController.text) : 0,
                                      );

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: FutureBuilder(
                                              future: uploaderInstance.uploadTheRecord(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.done) {
                                                  if (snapshot.hasError) {
                                                    print("future finished with error ${snapshot.error}");

                                                    return Text('Error: ${snapshot.error}');
                                                  } else {
                                                    print("future finished executing");
                                                    //incrementing the record count
                                                    widget.activity.totalRecords++;

                                                    //call resetters after 1 second
                                                    Future.delayed(Duration(milliseconds: 1000)).then((value) {
                                                      resetter();
                                                      widget.callableRefresh();
                                                    });

                                                    Future.delayed(Duration(milliseconds: 500)).then((value) => Navigator.pop(context));
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Text(
                                                          'Saved',
                                                          style: TextStyle(fontSize: 20),
                                                        ),
                                                        Icon(Icons.check_circle, size: 50, color: Theme.of(context).colorScheme.primary),
                                                      ],
                                                    );
                                                  }
                                                } else {
                                                  print("future running");
                                                  return const SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Center(child: Text('Saving...')),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      );

                                      // resetter();
                                      // widget.callableRefresh();
                                    }
                                  },
                                  child: Text(
                                    "Save",
                                    //change the color of the text to the primary color if any of the controller or the image list is not empty
                                    style: TextStyle(
                                      color: tags.isNotEmpty || _countController.text.isNotEmpty || imageFileList.isNotEmpty ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ], //end of the entire coontainer widget
                      ),
                    ),
                    elevation: 0,
                  ).animate().scale(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  resetter() {
    setState(() {
      _countController.clear();
      _Tagcontroller.clear();
      tags.clear();
      imageFileList.clear();
      images.clear();
    });
  }
}
