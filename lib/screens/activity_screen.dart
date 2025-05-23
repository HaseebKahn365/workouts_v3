// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xy;
import 'package:url_launcher/url_launcher.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';
import 'package:workouts_v3/buisiness_logic/firebase_uploader.dart';

/*Here is what the class looks like for the activity:
class Activity extends ChangeNotifier {
  late bool isCountBased;
  bool shouldAppear = true; //used to remove the activity from the list and firestore just by setting it to false

  int totalRecords = 0;
  late String name;
  Map<DateTime, int> datedRecs = {};
  Map<String, List<String>> imgMapArray = {};
  Map<String, List<String>> tagMapArray = {};

  }

  we need to share all the dateRecs in the form of a CSV file 
  */

class ActivityScreen extends ConsumerStatefulWidget {
  final Activity activity;
  final Function callableRefresh;
  ActivityScreen({required this.activity, required this.callableRefresh});
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  int todayCount = 0;
  int weekCount = 0;
  int monthCount = 0;
  int yearCount = 0;
  @override
  void initState() {
    super.initState();
    //Here are the variables for storing the counter values for today, week , month and year. They are assigned by calling their respective methods
    todayCount = totalCountToday();
    weekCount = totalCountThisWeek();
    monthCount = totalCountThisMonth();
    yearCount = totalCountThisYear();

    //
  }

  final List<Image> images = [];

  void screenRefresh() {
    setState(() {});
  }

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = []; // Moved this list outside the map function to prevent resetting on every iteration

  void selectImages() async {
    //pick the image from camera and add it to the list

// Assuming you're inside an async function
    XFile? imageFile = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 25);
    if (imageFile != null) {
      imageFileList.add(imageFile);
      setState(() {
        images.add(
          Image.file(
            File(imageFile.path),
            fit: BoxFit.cover,
          ),
        );
      });
    } else {
      // Handle the case where no image was picked
      print("no image selected");
    }

    print("${imageFileList.length} images selected");
    //print the size of each image
    imageFileList.forEach((element) {
      print(File(element.path).lengthSync());
    });
  }

  TextEditingController _Tagcontroller = TextEditingController();
  TextEditingController _countController = TextEditingController();
  List<String> tags = [];
  DateTime first = DateTime.now();
  String getFirstDate() {
    widget.activity.datedRecs.forEach((key, value) {
      if (key.isBefore(first)) {
        first = key;
      }
    });
    return (first.day.toString() + "/" + first.month.toString() + "/" + first.year.toString());
  }

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
                                  // created on
                                  // widget.activity.createdOn.day.toString() + '/' + widget.activity.createdOn.month.toString() + '/' + widget.activity.createdOn.year.toString(),
                                  getFirstDate(),
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
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              //use a full screen dialog to display the image similar to WhatsApp
                                              return Dialog(
                                                child: Container(
                                                  height: MediaQuery.of(context).size.height * 0.8,
                                                  width: MediaQuery.of(context).size.width,
                                                  child: InteractiveViewer(
                                                    maxScale: 10,
                                                    child: Image(
                                                      image: image.image,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
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

                          const SizedBox(
                            height: 20,
                          ),

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
                                  onPressed: () async {
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

                                                    int tempCount = _countController.text.isEmpty ? 0 : int.parse(_countController.text);

                                                    todayCount += tempCount;
                                                    weekCount += tempCount;
                                                    monthCount += tempCount;
                                                    yearCount += tempCount;

                                                    //call resetters after 1 second
                                                    Future.delayed(Duration(milliseconds: 500)).then((value) {
                                                      resetter();
                                                      widget.callableRefresh();
                                                    });

                                                    Future.delayed(Duration(milliseconds: 200)).then((value) => Navigator.pop(context));
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

                                    screenRefresh();
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

                          const SizedBox(
                            height: 20,
                          ),

                          //color group and color chip widgets for displaying daily, weekly, monthly and yearly counts of this activity.
                          ColorGroup(
                            children: [
                              ColorChip(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                label: 'Today',
                                number: todayCount.toString(),
                              ),
                              ColorChip(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                label: 'This Week',
                                number: weekCount.toString(),
                              ),
                              ColorChip(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                label: 'This Month',
                                number: monthCount.toString(),
                              ),
                              ColorChip(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                label: 'This Year',
                                number: yearCount.toString(),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
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

                //Here is the button to export the entire datedRec of the activity as an excel file using the syncfusion flutter xlsio package

                //A SIMPLE ICON TEXT BUTTON WITH SHARE ICON
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: FilledButton.tonal(
                    onPressed: () async {
                      //try to launch url else shoow snackbar
                      try {
                        String phoneNumber = '923151936044'; // Country code prefix is required
                        String message = 'Hello, this is a test message!';
                        launchWhatsApp(phone: phoneNumber, message: message);
                      } catch (e) {
                        //display snackbar with error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FluentIcons.window_28_regular,
                          color: Colors.white,
                          size: 20,
                        ),
                        const Text("  Export the Activity Data"),
                      ],
                    ),
                  ),
                ),

                //end
              ],
            ),
          ),
        ],
      ),
    );
  }

  void launchWhatsApp({
    required String phone,
    required String message,
  }) async {
    String url = 'https://wa.me/$phone?text=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch WhatsApp.';
    }
  }

  //method to create excel fiile

  //method to create excel fiile

  int totalCountToday() {
    int count = 0;
    widget.activity.datedRecs.forEach((key, value) {
      if (key.day == DateTime.now().day && key.month == DateTime.now().month && key.year == DateTime.now().year) {
        count += value;
      }
    });
    return count;
  }

  int totalCountThisWeek() {
    int count = 0;
    widget.activity.datedRecs.forEach((key, value) {
      if (key.isAfter(DateTime.now().subtract(Duration(days: 7)))) {
        count += value;
      }
    });
    return count;
  }

  int totalCountThisMonth() {
    int count = 0;
    widget.activity.datedRecs.forEach((key, value) {
      if (key.month == DateTime.now().month && key.year == DateTime.now().year) {
        count += value;
      }
    });
    return count;
  }

  int totalCountThisYear() {
    int count = 0;
    widget.activity.datedRecs.forEach((key, value) {
      if (key.year == DateTime.now().year) {
        count += value;
      }
    });
    return count;
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

//creating color group and color chip widgets for displaying daily, weekly, monthly and yearly counts of this activity.

class ColorGroup extends StatelessWidget {
  const ColorGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }
}

class ColorChip extends StatelessWidget {
  const ColorChip({
    super.key,
    required this.color,
    required this.number,
    required this.label,
    this.onColor,
  });

  final Color color;
  final Color? onColor;
  final String label;
  final String number;

  static Color contrastColor(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    switch (brightness) {
      case Brightness.dark:
        return Colors.white;
      case Brightness.light:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor = onColor ?? contrastColor(color);

    return Container(
      width: 320,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          children: [
            Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Text(
                    label,
                    style: TextStyle(color: labelColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Text(
                    number,
                    style: TextStyle(color: labelColor),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
