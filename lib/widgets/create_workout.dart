//here is the page for creating a workout

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CreateWorkout extends StatefulWidget {
  const CreateWorkout({super.key});

  @override
  State<CreateWorkout> createState() => _CreateWorkoutState();
}

class _CreateWorkoutState extends State<CreateWorkout> {
  String dropdownValue = 'custom';
  bool isScorePerCountEnabled = false;

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
              onPressed: () {},
              child: Text('Create Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
