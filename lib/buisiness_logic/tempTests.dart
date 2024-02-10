// Future<void> activityTest() async {
//   print(await DocToMap());
//   Activity testActivity = Activity.fromFirestore(await DocToMap());
//   print(testActivity);
// }

// Future<void> allActivitiesTest() async {
//   List<Activity> testActivities = await AllDocsToMap();
//   testActivities.forEach((element) {
//     print("\n\n" + element.toString());
//   });
// }

// Future<List<Activity>> AllDocsToMap() async {
//   List<Activity> activities = [];
//   await FirebaseFirestore.instance.collection('users').doc('haseeb').collection('activities').get().then((querySnapshot) {
//     querySnapshot.docs.forEach((doc) {
//       activities.add(Activity.fromFirestore(doc.data() as Map<String, dynamic>));
//     });
//   });

//   return activities;
// }

// Future<Map<String, dynamic>> DocToMap() async {
//   Map<String, dynamic> map = {};
//   await FirebaseFirestore.instance.collection('users').doc('haseeb').collection('activities').doc('yns').get().then((doc) {
//     map = doc.data() as Map<String, dynamic>;
//   });

//   return map;
// }






  //test printing the map of strin and list of string
  // Map<String, List<String>> testMap = {
  //   "test": ["test1", "test2", "test3"]
  // };
  // print(testMap); //{test: [test1, test2, test3]}

  //running activity conversion test from firestore document:
  // await activityTest();

  //running the activity conversioon test for all the activitiese iin the collection fo the user:
  // await allActivitiesTest();
