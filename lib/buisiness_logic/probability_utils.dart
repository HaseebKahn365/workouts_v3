import 'dart:math';

import 'package:workouts_v3/buisiness_logic/all_classes.dart';

//these functions are used for calculating the probability of reaching a lambda number of records in the next hour

double calculateProbability(Activity activity, int lambda) {
  double probability = 0;
  if (activity.isCountBased) {
    List<int> validRecords = [];
    //only collect the records that are not in todays date but should be in the same hour or next hour
    activity.datedRecs.forEach((key, value) {
      if (key.day != DateTime.now().day) {
        if (key.hour == DateTime.now().hour || key.hour == DateTime.now().hour + 1) {
          validRecords.add(value);
        }
      }
    });
    //calculating the probability to reach lambda
    print("The valid records for count based activity ${activity.name} are: $validRecords whose times were: ${activity.datedRecs.keys.toList()}");

    probability = poissonProbability(lambda);
  } else {
    //repeating the same logic for time based activities
    List<int> validRecords = [];
    activity.datedRecs.forEach((key, value) {
      if (key.day != DateTime.now().day) {
        if (key.hour == DateTime.now().hour || key.hour == DateTime.now().hour + 1) {
          validRecords.add(value);
        }
      }
    });
    print("The valid records for time based activity ${activity.name} are: $validRecords");

    probability = poissonProbability(lambda);
  }
  print("Printing 0^0: " + pow(0, 0).toString());
  if (probability >= 1 || probability <= 0) {
    throw "insufficient records";
  } else {
    return probability;
  }
}

double poissonProbability(int lambda) {
// P(x=lambda=2) = (e^-2 . 2^2) / 2 ! //for example if lambda is 2
  return (pow(2.718, -lambda) * pow(lambda, lambda)) / factorial(lambda);
}

int factorial(int n) {
  if (n == 0) {
    return 1;
  }
  return n * factorial(n - 1);
}
