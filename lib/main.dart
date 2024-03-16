// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';
import 'package:workouts_v3/today_screen.dart';
import 'package:workouts_v3/home_screen.dart';
import 'package:workouts_v3/firebase_options.dart';
import 'package:workouts_v3/overall_screen.dart';

final parentProvider = ChangeNotifierProvider((ref) => Parent());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      child: const Wrokouts(),
    ),
  );
}

String motivationalMessage = "Lets get this over with! (Default)";

class Wrokouts extends ConsumerStatefulWidget {
  const Wrokouts({super.key});

  @override
  _WrokoutsState createState() => _WrokoutsState();
}

// NavigationRail shows if the screen width is greater or equal to
// screenWidthThreshold; otherwise, NavigationBar is used for navigation.
const double narrowScreenWidthThreshold = 450;

const Color m3BaseColor = Color(0xff6750a4);
const List<Color> colorOptions = [m3BaseColor, Colors.blue, Colors.teal, Colors.green, Colors.yellow, Colors.orange, Colors.pink, Colors.lime];
const List<String> colorText = <String>["M3 Baseline", "Blue", "Teal", "Green", "Yellow", "Orange", "Pink", "Lime"];

String? phoneId;

class _WrokoutsState extends ConsumerState<Wrokouts> {
  bool useMaterial3 = true;
  bool useLightMode = true;
  int colorSelected = 0;
  int screenIndex = 0;

  late ThemeData themeData;

  //the following code saves the theme settings:
  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      useLightMode = prefs.getBool('useLightMode') ?? true;
      colorSelected = prefs.getInt('colorSelected') ?? 0;
      themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
      //load shared preferences under the name phoen id
      phoneId = prefs.getString('phoneId');
      motivationalMessage = prefs.getString('message') ?? "Lets get this over with! (Default)";
      print('Loaded the sharedPrefrences themeData');
    });
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('useLightMode', useLightMode);
    prefs.setInt('colorSelected', colorSelected);
    prefs.setString('message', motivationalMessage);
  }

  @override
  initState() {
    super.initState();
    _loadSettings();
    themeData = updateThemes(colorSelected, useMaterial3, useLightMode);

    // user = FirebaseAuth.instance.currentUser;
  }

  String getAppBarTitle(int screenIndex) {
    switch (screenIndex) {
      case 0:
        return "Home";
      case 1:
        return "Today";
      case 2:
        return "Overall";

      default:
        return "Home";
    }
  }

  Widget returnDrawer() {
    return Builder(builder: (context) {
      return Drawer(
        //reduce the height of the drawer header
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 150,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ),
            const ListTile(
              title: Text('Colors Picker'),
            ),

            //create a gridview of 7 colors having an icon at each index value: index, remove the scrolling

            Container(
              height: 120,
              child: GridView.count(
                scrollDirection: Axis.horizontal,
                crossAxisCount: 2,
                children: List.generate(colorOptions.length, (index) {
                  return Center(
                    child: IconButton(
                      icon: Icon(
                        index == colorSelected ? FluentIcons.checkmark_square_24_filled : FluentIcons.checkbox_unchecked_24_filled,
                        color: colorOptions[index],
                        size: 33,
                      ),
                      onPressed: () {
                        handleColorSelect(index);
                        _saveSettings();
                      },
                    ),
                  );
                }),
              ),
            ),

            const ListTile(
              title: Text('Dark Mode'),
            ),
            //creating a toggle button to turn on and off the dark theme
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 5, 0, 0),
                child: Switch(
                  value: !useLightMode,
                  onChanged: (value) {
                    handleBrightnessChange();
                    _saveSettings();
                  },
                ),
              ),
            ),

            //creating account settings:
            const ListTile(
              title: Text('Account Settings', style: TextStyle(fontSize: 17)),
            ),

            //creating a text button to launch the alert dialogue box
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12, top: 5, bottom: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        //create an alert dialogue box to change the name and picture of the user
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Change Profile'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      //create a container with a gesture detector with logic to pick an image from the gallery:

                                      // Container(
                                      //   height: 150,
                                      //   width: 150,
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //       //pick image from gallery
                                      //       print('tapped on the image');
                                      //       // _getFromGallery();
                                      //     },
                                      //     //create a rounded rectangle with a child of an icon
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.symmetric(
                                      //           horizontal: 30.0),

                                      //       //if the imageFile is not null then show the image else show the icon
                                      //       child: _tempImageFile != null
                                      //           ? ClipRRect(
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       10),
                                      //               child: Container(
                                      //                 color: Theme.of(context)
                                      //                     .colorScheme
                                      //                     .secondaryContainer
                                      //                     .withOpacity(1),
                                      //                 child: Image.file(
                                      //                     _tempImageFile!,
                                      //                     fit: BoxFit.cover),
                                      //               ))
                                      //           : ClipRRect(
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       10),
                                      //               child: Container(
                                      //                 color: Theme.of(context)
                                      //                     .colorScheme
                                      //                     .secondaryContainer,
                                      //                 child: Icon(
                                      //                     FluentIcons
                                      //                         .camera_add_48_filled,
                                      //                     color:
                                      //                         Theme.of(context)
                                      //                             .colorScheme
                                      //                             .primary),
                                      //               ),
                                      //             ),
                                      //     ),
                                      //   ),
                                      // ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      //creating a text field to enter the text
                                      // TextField(
                                      //   controller: userNameController,
                                      //   decoration: InputDecoration(
                                      //     contentPadding: EdgeInsets.all(10),
                                      //     border: OutlineInputBorder(),
                                      //     labelText: userName,
                                      //   ),
                                      //   onChanged: (value) {
                                      //     _tempUserName = value;
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  //create a cancel button
                                  // TextButton(
                                  //   child: const Text('Cancel'),
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       userNameController.clear();
                                  //       _tempImageFile = imageFile;
                                  //       Navigator.of(context).pop();
                                  //     });
                                  //   },
                                  // ),
                                  // //create a save button with rounded border outline

                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       if (_tempUserName.isNotEmpty) {
                                  //         userName = _tempUserName;
                                  //       }
                                  //       userNameController.clear();
                                  //       //change the user Image here
                                  //       imageFile = _tempImageFile;
                                  //     });
                                  //     Navigator.of(context).pop();
                                  //   },
                                  //   child: const Text('Save'),
                                  //   //make elevation 0 and rounded corners
                                  //   style: ElevatedButton.styleFrom(
                                  //     elevation: 0,
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(10),
                                  //     ),
                                  //     backgroundColor: Theme.of(context)
                                  //         .colorScheme
                                  //         .secondaryContainer
                                  //         .withOpacity(1),
                                  //   ),
                                  // ),
                                ],
                              );
                            });
                      },
                      child: const Text('Change Profile'),
                      //make elevation 0 and rounded corners
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                      ),
                    ),
                  ),
                  //icon for change
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Icon(FluentIcons.edit_16_filled, color: Theme.of(context).colorScheme.secondaryContainer),
                  )
                ],
              ),
            ), //end of the alert dialogue box

            //creating an alert dialogue box to send feedback in the same fashion as above

            const ListTile(
              title: Text('Motivational Message', style: TextStyle(fontSize: 17)),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12, top: 5, bottom: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        //alert dialogue box with a text field to enter the message
                        String oldMessage = motivationalMessage;
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Set Motivational Message'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      //creating a text field to enter the text
                                      TextField(
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(),
                                          labelText: motivationalMessage,
                                        ),
                                        onChanged: (value) {
                                          motivationalMessage = value;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  //create a cancel button
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      motivationalMessage = oldMessage;
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  //create a save button with rounded border outline
                                  ElevatedButton(
                                    onPressed: () {
                                      _saveSettings();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Save'),
                                    //make elevation 0 and rounded corners
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Text('Set Message'),
                      //make elevation 0 and rounded corners
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                      ),
                    ),
                  ),

                  //icon for feedback

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Icon(FluentIcons.alert_12_filled, color: Theme.of(context).colorScheme.secondaryContainer),
                  )
                ],
              ),
            ), //end of the feedback button

            //working on the reset button
            const ListTile(
              title: Text('Reset Everything'),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12, top: 5, bottom: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        //show simple dialogue box with logout button
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Are you sure you want to logout?'),
                                //content should have a logout icon
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FluentIcons.sign_out_24_filled,
                                      color: Theme.of(context).colorScheme.primary,
                                      size: 130,
                                    ),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'You are about to log out. ',
                                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                        children: <TextSpan>[
                                          TextSpan(text: '\n\nRemember your id:  '),
                                          TextSpan(text: phoneId, style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),

                                actions: <Widget>[
                                  //create a cancel button
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  //create a save button with rounded border outline
                                  ElevatedButton(
                                    onPressed: () {
                                      SharedPreferences.getInstance().then((prefs) {
                                        prefs.remove('phoneId');
                                      });
                                      //close the drawer
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Column(
                                          children: [
                                            Text("Remember your name: $phoneId"),
                                            const SizedBox(height: 10),
                                            Text("Please restart the app", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                            const SizedBox(height: 10),
                                            Icon(
                                              FluentIcons.info_24_filled,
                                              color: Theme.of(context).colorScheme.inversePrimary,
                                              size: 50,
                                            )
                                          ],
                                        ),
                                        duration: const Duration(seconds: 3),
                                      ));
                                    },
                                    child: const Text('Logout'),
                                    //make elevation 0 and rounded corners
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Text('Logout'),
                      //make elevation 0 and rounded corners
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                      ),
                    ),
                  ),

                  //icon for reset

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Icon(FluentIcons.delete_16_filled, color: Theme.of(context).colorScheme.secondaryContainer),
                  )
                ],
              ),
            ), //end of the reset button
          ],
        ),
      );
    });
  }

  ThemeData updateThemes(int colorIndex, bool useMaterial3, bool useLightMode) {
    return ThemeData(colorSchemeSeed: colorOptions[colorSelected], useMaterial3: useMaterial3, brightness: useLightMode ? Brightness.light : Brightness.dark);
  }

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void handleBrightnessChange() {
    setState(() {
      useLightMode = !useLightMode;
      themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelected = value;
      themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    });
  }

  Widget createScreenFor(int screenIndex, bool showNavBarExample, Parent parent) {
    switch (screenIndex) {
      case 0:
        return HomeScreen(showNavBottomBar: showNavBarExample, parent: parent);
      case 1:
        return Today(parent: parent);
      case 2:
        return Overall(parent: parent);

      default:
        return HomeScreen(showNavBottomBar: showNavBarExample, parent: parent);
    }
  }

  //creating a function that returns Widget of Introduction screen
  Widget StartUp() {
    return Builder(builder: (context) {
      return IntroductionScreen(
        pages: [
          PageViewModel(
            //make the background color adopt to the dark and light theme
            decoration: PageDecoration(
              pageColor: Theme.of(context).colorScheme.background,
              bodyTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              titleTextStyle: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color),
            ),
            titleWidget: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Text(
                    "Welcome to",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return Text(
                        "Workouts V3",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                  //Select your favourite color:
                  Text("\n\nSelect your favourite color:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ))
                ],
              ),
            ),
            bodyWidget: Column(
              children: [
                Container(
                  height: 100,
                  width: 250,
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    children: List.generate(colorOptions.length, (index) {
                      return Center(
                        child: IconButton(
                          icon: Icon(
                            index == colorSelected ? FluentIcons.checkmark_square_24_filled : FluentIcons.checkbox_unchecked_24_filled,
                            color: colorOptions[index],
                            size: 50,
                          ),
                          onPressed: () {
                            handleColorSelect(index);
                            // _saveSettings();
                          },
                        ),
                      );
                    }),
                  ),
                ),
                //create a toggle button for light and dark mode the icons should also be on both sides of the toggle button
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Icon(
                          FluentIcons.weather_sunny_24_filled,
                          size: 25,
                        ),
                      ),
                      Switch(
                        value: !useLightMode,
                        onChanged: (value) {
                          handleBrightnessChange();
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Icon(
                          FluentIcons.weather_moon_24_filled,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // PageViewModel(
          //   //create a page with a gesture detector container with child as google.png
          //   decoration: PageDecoration(
          //     pageColor: Theme.of(context).colorScheme.background,
          //     bodyTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          //     titleTextStyle: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color),
          //   ),
          //   titleWidget: Padding(
          //     padding: const EdgeInsets.only(top: 20.0),
          //     child: Column(
          //       children: [
          //         Text(
          //           "Sign in with ",
          //           style: TextStyle(
          //             fontSize: 40,
          //             fontWeight: FontWeight.w300,
          //           ),
          //         ),
          //         Builder(
          //           builder: (context) {
          //             return Text(
          //               "Google",
          //               style: TextStyle(
          //                 fontSize: 40,
          //                 fontWeight: FontWeight.w400,
          //                 color: Theme.of(context).colorScheme.primary,
          //               ),
          //             );
          //           },
          //         ),
          //         //Select your favourite color:
          //         Text("\n\nTap on the button to sign in",
          //             style: TextStyle(
          //               fontSize: 20,
          //               fontWeight: FontWeight.w300,
          //             )),
          //         const SizedBox(height: 50),
          //       ],
          //     ),
          //   ),
          //   bodyWidget: GestureDetector(
          //     onTap: () async {
          //       await signInWithGoogle();
          //       if (mounted) {
          //         setState(() {
          //           user = FirebaseAuth.instance.currentUser;
          //           print("User is signed in with credentials: $user");
          //         });
          //       }
          //     },
          //     child: Container(
          //         width: 200,
          //         //give it a rounded border
          //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).colorScheme.surface, boxShadow: [
          //           BoxShadow(
          //             color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          //             spreadRadius: 20,
          //             blurRadius: 30,
          //             offset: Offset(0, 3),
          //           )
          //         ]),
          //         child: Column(
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Image.asset("assets/images/google.png", fit: BoxFit.cover),
          //             ),
          //             Padding(
          //                 padding: const EdgeInsets.only(bottom: 15),
          //                 child: Text(
          //                   "Sign in with Google",
          //                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          //                 ))
          //           ],
          //         )),
          //   ),
          // ),
        ],
        onDone: () {
          //check if phone id is null. if it is then show an alert dialogue box to enter the username where length should be greater than 4 characters
          if (phoneId == null) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Enter your username'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          //creating a text field to enter the text
                          TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                            ),
                            onChanged: (value) {
                              phoneId = value;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      //create a cancel button
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      //create a save button with rounded border outline
                      ElevatedButton(
                        onPressed: () {
                          if (phoneId!.length > 4) {
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.setString('phoneId', phoneId!);
                            });
                            //show snakbar that remember $phoneId and use setState to set the phoneId
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Remember your name: $phoneId"),
                              duration: const Duration(seconds: 3),
                            ));

                            setState(() {
                              phoneId = phoneId;
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Save'),
                        //make elevation 0 and rounded corners
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(1),
                        ),
                      ),
                    ],
                  );
                });
          }
        },
        done: const Text("Done"),
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Text("Next"),
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).colorScheme.primary,
          size: Size(10, 10),
          activeSize: Size(30, 10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      );
    });
  }

  PreferredSizeWidget createAppBar() {
    return AppBar(
      title: Text(getAppBarTitle(screenIndex)),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final parent = ref.watch(parentProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workouts Project V3',
      themeMode: useLightMode ? ThemeMode.light : ThemeMode.dark,
      theme: themeData,
      home: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < narrowScreenWidthThreshold) {
          return phoneId == null
              ? StartUp()
              : Scaffold(
                  drawer: returnDrawer(),
                  appBar: createAppBar(),
                  body: Row(children: <Widget>[
                    createScreenFor(screenIndex, false, parent),
                  ]),
                  bottomNavigationBar: NavigationBars(
                    onSelectItem: handleScreenChanged,
                    selectedIndex: screenIndex,
                    isExampleBar: false,
                  ),
                );
        } else {
          return phoneId == null
              ? StartUp()
              : Scaffold(
                  drawer: returnDrawer(),
                  appBar: createAppBar(),
                  body: SafeArea(
                    bottom: false,
                    top: false,
                    child: Row(
                      children: <Widget>[
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: NavigationRailSection(onSelectItem: handleScreenChanged, selectedIndex: screenIndex)),
                        const VerticalDivider(thickness: 1, width: 1),
                        createScreenFor(screenIndex, true, parent),
                      ],
                    ),
                  ),
                );
        }
      }),
    );
  }
}
