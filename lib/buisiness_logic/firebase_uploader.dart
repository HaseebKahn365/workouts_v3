//Here we define a class that will be responsible for the upload of the activity record.

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';
import 'package:workouts_v3/main.dart';

class FirebaseUploader {
  DateTime uploadTime;
  List<String> tags = [];
  List<XFile> imageFileList = [];
  Activity activity;
  late String activityName = activity.name;
  int recordCount;

  FirebaseUploader({
    required this.uploadTime,
    required this.tags,
    required this.imageFileList,
    required this.activity,
    required this.recordCount,
  });

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

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    DocumentReference userDoc = users.doc(phoneId); //phoneId is a global variable

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
      for (int i = 0; i < imageFileList.length; i++) {
        File file = File(imageFileList[i].path);

        // Upload the image to Firebase Storage and get the URL
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('phoneId/$activityName/$uploadTime/$i.jpg');
        await ref.putFile(file); // Wait for the upload operation to complete
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

      //! This is the line that is causing the error

      DocumentSnapshot activityDoc = await userDoc.collection('activities').doc(activityName).get();
      if (!activityDoc.exists) {
        print("Setting for the first time");
        await userDoc.collection('activities').doc(activityName).set({
          'isCountBased': false,
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

//! This is the line that is causing the error

      // I/flutter (19543): future finished with error type '_Map<dynamic, dynamic>' is not a subtype of type 'Map<String, dynamic>' of 'data'

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
}
