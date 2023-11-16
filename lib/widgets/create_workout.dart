//here is the page for creating a workout

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:workouts_v3/model/database/database_service.dart';

class CreateWorkout extends StatefulWidget {
  const CreateWorkout({super.key});

  @override
  State<CreateWorkout> createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends State<CreateWorkout> {
  String dropdownValue = 'custom';
  bool isScorePerCountEnabled = false;
  TextEditingController workoutTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            //create a text field for the workout title
            TextField(
              controller: workoutTitleController,
              decoration: InputDecoration(
                labelText: 'Workout Title',
              ),
            ),

            //create a dropdown button for the workout type
            //the dropdown button should have two options: primary and custom
            //if the user selects primary then the score per count field should be enabled otherwise it should be disabled.
            SizedBox(
              height: 20.0,
            ),
            Text('Select the workout type:'),
            DropdownButton<String>(
              value: dropdownValue,
              items: [
                DropdownMenuItem(
                  child: Text('Primary'),
                  value: 'primary',
                ),
                DropdownMenuItem(
                  child: Text('Custom'),
                  value: 'custom',
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  isScorePerCountEnabled = newValue == 'primary';
                });
              },
            ),

            TextField(
              enabled: isScorePerCountEnabled,
              decoration: InputDecoration(
                labelText: 'Score Per Count',
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            //create a button that will be used to create a workout
            ElevatedButton(
              onPressed: () async {
                //Here we will create a new workout based on the above specified details and navigate to the home screen. In the home screen, the initState method will be called and the workouts will be retrieved from the database and displayed in the list view.

                //calling the createWorkout method from the database service class
                //add some validation rules
                if (workoutTitleController.text.isEmpty) {
                  return;
                }
                await DatabaseService().createWorkout(
                  workoutTitleController.text,
                  dropdownValue,
                );

                //navigate to the home screen
                Navigator.pop(context);
              },
              child: Text('Create Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
