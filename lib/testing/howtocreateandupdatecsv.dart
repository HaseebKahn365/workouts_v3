
  // Future<void> _loadCSV() async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final workoutDirectory = '${directory.path}/workout_v3_data';
  //     final categoriesFile = File('$workoutDirectory/categories.csv');
  //     final activitiesFile = File('$workoutDirectory/activity.csv');

  //     // Check if the workout directory exists, if not, create it
  //     if (!await Directory(workoutDirectory).exists()) {
  //       await Directory(workoutDirectory).create(recursive: true);
  //       print('Workout directory created!');
  //     }

  //     // Check if CSV files exist, if not, create new ones
  //     if (!await categoriesFile.exists() || !await activitiesFile.exists()) {
  //       await _createNewCSVFiles(categoriesFile, activitiesFile);
  //       print('CSV files not found! Creating new CSV files.');
  //     }

  //     // Load existing data
  //     String categoriesCSV = await categoriesFile.readAsString();
  //     String activitiesCSV = await activitiesFile.readAsString();

  //     // Convert existing data to lists
  //     categories = CsvToListConverter().convert(categoriesCSV);
  //     activities = CsvToListConverter().convert(activitiesCSV);

  //     setState(() {
  //       print(categories);
  //       print(activities);
  //     });
  //   } catch (error) {
  //     print('Error loading CSV: $error');
  //   }
  // }

  // Future<void> _createNewCSVFiles(File categoriesFile, File activitiesFile) async {
  //   // CSV data for categories
  //   String categoriesData = '"Category Name","Category_Type","ActivityConnectUID"\n"Reading","Interval","Rt9pOqzA2VdH"\n"Coding","Count","C8p5rT3iNjH"\n"Running","Interval","Ru7sXw2pBqLm"\n"Yoga","Count","Yo3gA1cBvFzZ"';

  //   // CSV data for activities
  //   String activitiesData = 'Name,Tags,createdOn,Map<TimeStamp, Count/Duration>\n' + 'Running,Cardio,20/01/2024,"20/01/2024 12:00: 45mins, 20/01/2024 13:00: 40mins"\n' + 'Coding,Dart,20/01/2024,"20/01/2024 14:00: 2hrs, 20/01/2024 16:00: 1hr"\n' + 'Yoga,Meditation,20/01/2024,"20/01/2024 18:00: 30mins, 20/01/2024 18:30: 30mins"\n' + 'Reading,Books,20/01/2024,"20/01/2024 20:00: 1hr, 20/01/2024 21:00: 45mins"';

  //   // Write data to files
  //   await categoriesFile.writeAsString(categoriesData);
  //   await activitiesFile.writeAsString(activitiesData);
  // }

  // Future<void> _updateCSV() async {
  //   try {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final workoutDirectory = '${directory.path}/workout_v3_data';
  //     final categoriesFile = File('$workoutDirectory/categories.csv');
  //     final activitiesFile = File('$workoutDirectory/activity.csv');

  //     // Check if the workout directory exists, if not, create it
  //     if (!await Directory(workoutDirectory).exists()) {
  //       await Directory(workoutDirectory).create(recursive: true);
  //       print('Workout directory created!');
  //     }

  //     // Check if CSV files exist, if not, create new ones
  //     if (!await categoriesFile.exists() || !await activitiesFile.exists()) {
  //       await _createNewCSVFiles(categoriesFile, activitiesFile);
  //       print('CSV files not found! Creating new CSV files.');
  //       return;
  //     }

  //     // Update data in CSV files
  //     List<dynamic> newCategory1 = ['NewCategory1', 'Interval', 'NewActivityConnectUID1'];
  //     List<dynamic> newCategory2 = ['NewCategory2', 'Count', 'NewActivityConnectUID2'];

  //     List<dynamic> newActivity1 = ['NewActivity1', 'Tag1', '20/01/2024', '20/01/2024 12:00', '30mins'];
  //     List<dynamic> newActivity2 = ['NewActivity2', 'Tag2', '20/01/2024', '20/01/2024 14:00', '1hr'];

  //     categories.add(newCategory1);
  //     categories.add(newCategory2);

  //     activities.add(newActivity1);
  //     activities.add(newActivity2);

  //     // Write the updated data back to files
  //     await _writeToFile(categoriesFile, categories);
  //     await _writeToFile(activitiesFile, activities);

  //     // Load and print updated data
  //     final updatedCategoriesCSV = await categoriesFile.readAsString();
  //     final updatedActivitiesCSV = await activitiesFile.readAsString();
  //     List<List<dynamic>> updatedCategories = CsvToListConverter().convert(updatedCategoriesCSV);
  //     List<List<dynamic>> updatedActivities = CsvToListConverter().convert(updatedActivitiesCSV);

  //     setState(() {
  //       print(updatedCategories);
  //       print(updatedActivities);
  //     });
  //     print("Data updated successfully");
  //   } catch (error) {
  //     print('Error updating CSV: $error');
  //   }
  // }

  // Future<void> _writeToFile(File file, List<dynamic> data) async {
  //   String csvContent = ListToCsvConverter().convert([data]);
  //   await file.writeAsString(csvContent);
  // }