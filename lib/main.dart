//This is the material 3 demo app but we are now gonna modify it to make it a workouts app.
//First we chech if the user exists using firestore and if not then take the user to startup screen.

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:workouts_v3/color_palettes_screen.dart';
import 'package:workouts_v3/component_screen.dart';
import 'package:workouts_v3/elevation_screen.dart';
import 'package:workouts_v3/firebase_options.dart';
import 'package:workouts_v3/typography_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Wrokouts());
}

class Wrokouts extends StatefulWidget {
  const Wrokouts({super.key});

  @override
  State<Wrokouts> createState() => _WrokoutsState();
}

// NavigationRail shows if the screen width is greater or equal to
// screenWidthThreshold; otherwise, NavigationBar is used for navigation.
const double narrowScreenWidthThreshold = 450;

const Color m3BaseColor = Color(0xff6750a4);
const List<Color> colorOptions = [
  m3BaseColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
  Colors.lime
];
const List<String> colorText = <String>[
  "M3 Baseline",
  "Blue",
  "Teal",
  "Green",
  "Yellow",
  "Orange",
  "Pink",
  "Lime"
];

class _WrokoutsState extends State<Wrokouts> {
  User? user;
  bool useMaterial3 = true;
  bool useLightMode = true;
  int colorSelected = 0;
  int screenIndex = 0;

  late ThemeData themeData;

  @override
  initState() {
    super.initState();
    themeData = updateThemes(colorSelected, useMaterial3, useLightMode);
    //check for user and assign to variable

    user = FirebaseAuth.instance.currentUser;
  }

  ThemeData updateThemes(int colorIndex, bool useMaterial3, bool useLightMode) {
    return ThemeData(
        colorSchemeSeed: colorOptions[colorSelected],
        useMaterial3: useMaterial3,
        brightness: useLightMode ? Brightness.light : Brightness.dark);
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

  Widget createScreenFor(int screenIndex, bool showNavBarExample) {
    switch (screenIndex) {
      case 0:
        return ComponentScreen(showNavBottomBar: showNavBarExample);
      case 1:
        return const ColorPalettesScreen();
      case 2:
        return const TypographyScreen();
      case 3:
        return const ElevationScreen();
      default:
        return ComponentScreen(showNavBottomBar: showNavBarExample);
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
              bodyTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              titleTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.displayLarge?.color),
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
                            index == colorSelected
                                ? FluentIcons.checkmark_square_24_filled
                                : FluentIcons.checkbox_unchecked_24_filled,
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
          PageViewModel(
            //create a page with a gesture detector container with child as google.png
            decoration: PageDecoration(
              pageColor: Theme.of(context).colorScheme.background,
              bodyTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              titleTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.displayLarge?.color),
            ),
            titleWidget: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Text(
                    "Sign in with ",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return Text(
                        "Google",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                  //Select your favourite color:
                  Text("\n\nTap on the button to sign in",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            bodyWidget: GestureDetector(
              onTap: () async {
                var localContext = context;
                //sign in with google
                await FirebaseAuth.instance.signInWithPopup(
                    GoogleAuthProvider()); //this will open a popup for google sign in
                //check if user is null then take to startup screen other wise load the app
                setState(() {
                  user = FirebaseAuth.instance.currentUser;
                });
                //Show snackbar that error occured
                ScaffoldMessenger.of(localContext).showSnackBar(SnackBar(
                  content: Text("Error occured"),
                  duration: Duration(seconds: 2),
                ));
              },
              child: Container(
                  width: 200,
                  //give it a rounded border
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.5),
                          spreadRadius: 20,
                          blurRadius: 30,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("assets/images/google.png",
                            fit: BoxFit.cover),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            "Sign in with Google",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ))
                    ],
                  )),
            ),
          ),
        ],
        onDone: () {},
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
      title: useMaterial3 ? const Text("Workouts") : const Text("Material 2"),
      actions: [
        IconButton(
          icon: useLightMode
              ? const Icon(Icons.wb_sunny_outlined)
              : const Icon(Icons.wb_sunny),
          onPressed: handleBrightnessChange,
          tooltip: "Toggle brightness",
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          itemBuilder: (context) {
            return List.generate(colorOptions.length, (index) {
              return PopupMenuItem(
                  value: index,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          index == colorSelected
                              ? Icons.color_lens
                              : Icons.color_lens_outlined,
                          color: colorOptions[index],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(colorText[index]))
                    ],
                  ));
            });
          },
          onSelected: handleColorSelect,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workouts Project V3',
      themeMode: useLightMode ? ThemeMode.light : ThemeMode.dark,
      theme: themeData,
      home: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < narrowScreenWidthThreshold) {
          return
              //check if user is null then take to startup screen other wise load the app
              user == null
                  ? StartUp()
                  : Scaffold(
                      appBar: createAppBar(),
                      body: Row(children: <Widget>[
                        createScreenFor(screenIndex, false),
                      ]),
                      bottomNavigationBar: NavigationBars(
                        onSelectItem: handleScreenChanged,
                        selectedIndex: screenIndex,
                        isExampleBar: false,
                      ),
                    );
        } else {
          return user == null
              ? StartUp()
              : Scaffold(
                  appBar: createAppBar(),
                  body: SafeArea(
                    bottom: false,
                    top: false,
                    child: Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: NavigationRailSection(
                                onSelectItem: handleScreenChanged,
                                selectedIndex: screenIndex)),
                        const VerticalDivider(thickness: 1, width: 1),
                        createScreenFor(screenIndex, true),
                      ],
                    ),
                  ),
                );
        }
      }),
    );
  }
}
