// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class StartUp extends StatelessWidget {
  const StartUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
          //Ask for theme settings and Google sign in
          "Welcome to Workouts V3!"),
    );
  }
}
