// ignore_for_file: prefer_const_constructors
/*
Documentation of the project:
In the last architecture all of the user’s data is stored in cloud firestore which makes it hard to read and write data quickly and it is also quite costly. We are going to fix this using the new localized relational database model with the help of SQFLite.

The Requirements:
We need to make sure that the new architecture allows the user to do the following:
•	Create either primary or custom workout during the time of creation
•	Select the scoring weightage for primary workouts. (scoring weightage simply means the score per count of the workout).
•	The user will be able to update the records of the workouts by input of the workout counts.
We need to keep track of every workout when ever it is updated or created. 
The new SQL architecture:
The following table shows what its like to see the data without normalization in a single table:
workout Name	total count today	date and time	workout type	score/count	nth time today	count precise
Push Ups	100	yesterday	primary	1	1	100
Pull Ups	25	yesterday	primary	3	1	25
Push Ups	150	yesterday	primary	1	2	50
Pull Ups	10	today	primary	3	1	10
Bicep Curls	110	today	custom	NULL	1	110
In the above data we can notice a couple of characteristics of data storage. Which are stated below:
•	Only primary workouts should have the score/count values.
•	The nth value for today increments for each update of the workout if the day is the same.
•	The count precise keeps track of the currently input count.
•	The input is added to the total count today if the day is the same.
Data Consistency and Data Backup:
We will upload the recorded data to firestore as the date changes. The date is check only when the home screen is being redrawn. We will check for the change in the date in the init method of the stateful widget and use the Boolean flag to identify the change in the date. 
Normalization and Entity Relation Diagrams:
The following normalization of the tables make sure that there is no duplication and will also help us in the retrieval of data for certain needs like displaying weekly progress etc. Following are the tables with fully normalized data:
The workout Table:
Name of workout
{Primary key} Workout uid
Total count (Today)
{Foreign key} Type of Workout uid
{Foreign key} Score per count uid
This table contains the workouts that is generated each time the user enters count in any field.
The Date and Time Table:
{Primary key} Date and time of workout
{Foreign key} Workout uid
{Foreign key} Nth time today uid
Count at this time


Nth time Table
{Primary key} Nth time today uid
Nth time 

The workout type Table:
{Primary key} Workout Type uid
Type name 

The score per count Table:
{Primary key} Score per count uid
Score per count 

From the above tables we can clearly identify the relations between the table and also avoid the duplication as much as possible.


 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workouts_v3/firebase_options.dart';
import 'package:workouts_v3/widgets/create_workout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workouts',
      theme: ThemeData(
        //use the dark theme
        brightness: Brightness.dark,
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Workouts'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //create a button that will be used to create a workout

            children: [
              ElevatedButton(
                onPressed: () {
                  //push the create workout screen
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return CreateWorkout();
                    },
                  ));
                },
                child: Text('Create Workout'),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
