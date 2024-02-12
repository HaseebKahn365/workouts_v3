import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workouts_v3/main.dart';

//this application is primarily connected to the firebase for reading and writing data.
//activites are tracked by the user and stored in the cloud firestore in the following manner:
/*
users collection
  - user document {uid = phoneId aka username}
    - activities collection
      - activity document {uid = activityName}
        - bool: isCountBased
        - bool: shouldAppear
        - name: string
        - isCountBased: bool
        - int: totalRecords
        - datedRecs: Map<DateTime(epoch value milliseconds), int>
        - imgMapArray: Map<String(DateTime(epoch value milliseconds)), Array<String (images urls)>>
        - tagMapArray: Map<String(DateTime(epoch value milliseconds)), Array<String (tags)>>

this is how we are storing the activities in the firestore. we need to a named constructor in the Activity class to convert the firestore data to the Activity object
we will first dowwnload the entire activity document and then convert it to the Activity object.

The following is the way we uploaded the activity to the firestore:

 FirebaseStorage storage = FirebaseStorage.instance;
  late String timeEpochCode = uploadTime.millisecondsSinceEpoch.toString();
  Future<bool> uploadTheRecord() async {
    //this method will be responsible for the upload of the record to the cloud firestore
    //it will return a boolean value to indicate the success or failure of the upload

    //check if there is a document in the firestoore under the name of the phoneId
    //if not, create one

    //check connection and immediatly return false if there is no connection to the internet or the cloud firestore
    if (!(await checkInternetConnection())) {
      throw "No internet connection";
    }

    //upload the images

    if (!(await uploadTheimagesAndRecord())) {
      throw "Error uploading images";
    }

    return true;
  }

  Future<bool> uploadTheimagesAndRecord() async {
    List<String> imageUrls = [];

    // Uploading all the images to Firebase Storage and getting the URLs
    try {
      for (int i = 0; i < 15 && i < imageFileList.length; i++) {
        // Compress the image using image_compression
        File file = File(imageFileList[i].path);
        ImageFile input = ImageFile(
          rawBytes: file.readAsBytesSync(),
          filePath: file.path,
        );
        ImageFile output = await compressInQueue(ImageFileConfiguration(input: input));

        print("Image [$i] compressed to size ${output.rawBytes.length} bytes");

        // Upload the compressed image to Firebase Storage and get the URL
        Reference ref = storage.ref().child('$activityName/$uploadTime/$i.jpg');
        await ref.putData(output.rawBytes); // Upload compressed image data
        String imageUrl = await ref.getDownloadURL(); // Get the URL of the uploaded image
        imageUrls.add(imageUrl); // Add the URL to the list
        print("Image $i uploaded");
      }

      print("All images uploaded successfully");

      print(imageUrls);
      //upload the record to firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('users');
      DocumentReference userDoc = users.doc(phoneId); //phoneId is a global variable
      /*
     users collection
  - user document {uid = phoneId aka username}
    - activities collection
      - activity document {uid = activityName}
        - bool: isCountBased
        - bool: shouldAppear
        - name: string
        - isCountBased: bool
        - int: totalRecords
        - datedRecs: Map<DateTime, int>
        - imgMapArray: Map<String(DateTime), Array<String (images urls)>>
        - tagMapArray: Map<String(DateTime), Array<String (tags)>>
     
      */

      // Create a new map to store the record
      //check if the activity document exists otherwise create one
      // Check if the activity document exists; otherwise, create one

      //! creating/ modifying the activity document

      DocumentSnapshot activityDoc = await userDoc.collection('activities').doc(activityName).get();
      if (!activityDoc.exists) {
        print("Setting for the first time");
        await userDoc.collection('activities').doc(activityName).set({
          'isCountBased': activity.isCountBased,
          'shouldAppear': true,
          'name': activityName,
          'totalRecords': 0,
        });
      }

// Prepare the update data
      Map<String, dynamic> updateData = {};

// Update imgMapArray
      Map<String, dynamic> imgMapNestedMap = {};
      imgMapNestedMap[timeEpochCode] = imageUrls;
      updateData['imgMapArray.$timeEpochCode'] = imgMapNestedMap;

// Update tagMapArray
      Map<String, dynamic> tagMapNestedMap = {};
      tagMapNestedMap[timeEpochCode] = tags;
      updateData['tagMapArray.$timeEpochCode'] = tagMapNestedMap;

      // Update datedRecs
      Map<String, dynamic> tempDataRec = {};
      tempDataRec[timeEpochCode] = recordCount;
      updateData['datedRecs.$timeEpochCode'] = tempDataRec;

      //incrementing the record count
      updateData['totalRecords'] = FieldValue.increment(1);

// Perform the update
      await userDoc.collection('activities').doc(activityName).update(updateData);

      return true; // Return true on success
    } catch (e) {
      print("Error uploading images: $e");
      return false; // Return false on failure
    }
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet connection is available
      }
    } on SocketException catch (_) {
      return false; // No internet connection
    }
    return false; // Default to no connection112
  }



 */

class Parent extends ChangeNotifier {
  //there is only one parent object in the application that will consist of a list of Activity objects
  List<Activity> activities = [];
  int totalActivities = 0;
  bool isUpdate = true;
  // method to add an activity to the list
  void addActivity(Activity activity) {
    isUpdate = true;

    notifyListeners();
  }

  Future<List<Activity>> AllDocsToMap() async {
    List<Activity> activities = [];
    await FirebaseFirestore.instance.collection('users').doc(phoneId).collection('activities').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        activities.add(Activity.fromFirestore(doc.data() as Map<String, dynamic>));
      });
    });

    return activities;
  }

  Future<void> fetchActivities() async {
    if (isUpdate == false) return;
    activities = await AllDocsToMap();
    totalActivities = activities.length;
    isUpdate = false;
    print(activities[0]);
    notifyListeners();
  }

  Future<void> forceDownload() async {
    activities = await AllDocsToMap();
    totalActivities = activities.length;
    print(activities);
    print("activities downloaded forcefully");
  }
}

class Activity extends ChangeNotifier {
  late bool isCountBased;
  bool shouldAppear = true; //used to remove the activity from the list and firestore just by setting it to false
  DateTime createdOn = DateTime.now();
  int totalRecords = 0;
  late String name;
  Map<DateTime, int> datedRecs = {};
  Map<String, List<String>> imgMapArray = {};
  Map<String, List<String>> tagMapArray = {};

  Activity({required this.name, required this.isCountBased});

  void mockDelete() {
    shouldAppear = false;
    notifyListeners();
  }

  //named constructor to convert the firestore data to the Activity object

  Activity.fromFirestore(Map<String, dynamic> data) {
    // DateTime(epoch value milliseconds)
    // We first need to convert the string date and time from the epoch milliseconds string to DateTime object
    // Then we can convert the map to the Activity object

    // Converting the datedRecs map
    Map<DateTime, int> tempDatedRecs = {};
    (data['datedRecs'] as Map<String, dynamic>).forEach((key, value) {
      var nestedMap = value as Map<String, dynamic>;
      nestedMap.forEach((nestedKey, nestedValue) {
        tempDatedRecs[DateTime.fromMillisecondsSinceEpoch(int.parse(nestedKey))] = nestedValue as int;
      });
    });

    // Converting the imgMapArray
    Map<String, List<String>> tempImgMapArray = {};
    (data['imgMapArray'] as Map<String, dynamic>).forEach((key, value) {
      var nestedMap = value as Map<String, dynamic>;
      tempImgMapArray[key] = nestedMap.values.map((e) => e.toString()).toList();
    });

// Converting the tagMapArray
    Map<String, List<String>> tempTagMapArray = {};
    (data['tagMapArray'] as Map<String, dynamic>).forEach((key, value) {
      var nestedMap = value as Map<String, dynamic>;
      tempTagMapArray[key] = nestedMap.values.map((e) => e.toString()).toList();
    });

    // Setting the values
    name = data['name'];
    isCountBased = data['isCountBased'];
    shouldAppear = data['shouldAppear'];
    totalRecords = data['totalRecords'];
    datedRecs = tempDatedRecs;
    imgMapArray = tempImgMapArray;
    tagMapArray = tempTagMapArray;
    // this.createdOn = DateTime.fromMillisecondsSinceEpoch(int.parse(data['createdOn'])); //TODO this is not uploaded to the firestore yet
  }

  //overrriding toString
  @override
  String toString() {
    return "Printing activity: \nActivity: $name, \nisCountBased: $isCountBased, \nshouldAppear: $shouldAppear, \ntotalRecords: $totalRecords, \ndatedRecs: $datedRecs, \nimgMapArray: $imgMapArray, \ntagMapArray: $tagMapArray";
  }
}
