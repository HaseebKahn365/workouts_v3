**Workouts V3**

**Introduction:**

This is a personal tracker that allows the user to store records based on the categories that he creates. A category can be of type interval or count. An interval category is the one that keeps records in terms of the duration i.e. 30mins etc. whereas in the counting category we keep track of the activity in terms of the count i.e. Pushups: 30 etc.

**UI Walkthrough:**

At the home screen there is a create category button on the top that allows the user to create a new category by entering the name and the type of the category in the alert dialogue box.

After the category has been created, the user can click on the category and will be navigated to the respective screen of the category. A single category ie. Study will be able to have many activities ie. Physics, math, computer science etc. These activities can be created by a Create button on the category screen. On clicking this button an alert dialogue box will appear that will ask for the activity name and tags for the activity. These tags can later be used for different purposes. After the activity is created, we can now use the activity container to add our activity ie. Duration or the count depending on the type of the category. The detailed data collection is described in the data demo.

At last we will have a DEVLogs object in the listview that will be responsible for tracking the progress of the software projects that the user has been working on. This is similar to the category object because it will have the same interface on the home screen however. When we click on it we will see a list of projects that we have been working on instead of the activities. A project in the DEVLogs will have an add image button and a container for entering tags in the form of chips. Add image button allows the user to select batch or single image file.
 It is important to know that DEVLogs will upload the data directly to firestore along with notifying the user upon successful completion of upload. The data of DEVLogs will be mocked int the data storage strategy section.

**Data storage strategy:**

The data will be stored in the form of CSV files that will make it easy to process and analyze the data later. Following are the files and their purposes:

| CSV1: | There is only one CSV1 file. This file will contain the category details of all the categories that have been created. It will store the information of the categories along with a specific field "ActivityConnectUID" this will map the category to another file i.e. CSV2. There is a single CSV2 file for every category. |
| --- | --- |
| CSV2: | This file will contain all the details of each activity. This includes the names of the activities the lie under the category along with other info of the activity such as the createdOn, tags, activity record. Activity record is a Map\<TimeStamp, Count/Duration\>. |

**Data demo:**

The following is the general overview of what the data looks like in the CSV files.

CSV1:

| Category Name | Category\_Type | ActivityConnectUID |
| --- | --- | --- |
| Study | Interval | Sjj12h312324kj |
| Workout | Count | Sdfoh12h23ihh |

CSV2 [Sjj12h312324kj]:

| Name | Tags | createdOn | Map\<TimeStamp, Count/Duration\> |
| --- | --- | --- | --- |
| Math | Calculus, CVT | 20/1/2024 | 20/1/2024 12:00 : 30mins , 20/1/2024 1:00 : 30mins |
| Physics | Thermodynamics | 20/1/2024 | 20/1/2024 12:00 : 30mins , 20/1/2024 1:00 : 30mins |

CSV2 [Sdfoh12h23ihh]:

| Name | Tags | createdOn | Map\<TimeStamp, Count/Duration\> |
| --- | --- | --- | --- |
| Pushups | diamond | 20/1/2024 | 20/1/2024 12:00 : 120 ,
 20/1/2024 1:00 : 30mins |
| Bench-press | 120kg | 20/1/2024 | 20/1/2024 12:00 : 100 ,
 20/1/2024 1:00 : 30mins |

**DEVLogs storage strategy:**

The interface of the DEVLogs is a lot like that of the other categories but in the activity screen of the DEVLogs we will have an optimized user interface for entering the description and photos from the gallery. All the data of the DEVLogs will be stored on the cloud firestore and the firebase storage. The main interface of the activity page of DEVLogs allow the user to create projects and then upload batch of images and description of the project. The following table shows how the data is going to be stored in the firestore:

Collection name: DEVLogs

Document name: Project Workouts V3 + createdOn Timestamp

| Activity Date | Map\<dateTime, imageURLs\> | Description |
| --- | --- | --- |
| 20/1/2024 12:00 | 20/1/2024 12:00 : firebaseStorage.com/imageurl1 | Working on implementing ui |
|
 | 20/1/2024 12:00 : firebaseStorage.com/imageurl2 |
 |
| 20/1/2024 12:00 | 20/1/2024 2:00 : firebaseStorage.com/imageurl | Implemented cloud firestore |

And similarly, we can store the progress of other projects in separate documents of the firestore collection.

**Probability Concept:**

Now that we have stored the data in a format that is easy to filter and analyze we are going to calculate the probability of doing an activity within an interval of 1 hour. We calculate this probability using the Poisson random variable formula for probability. The following shows how to calculate the probability.

We first read the entire csv2 file of the activity and fetch all the records that lie under current time and the interval of 1 hour. We then calculate the average count by (total counts or intervals of activity / total number of records.) which will be the value of lambda for the Poisson formula. we calculate the probability of doing Average+50 (call it i) activity using the formula:

P(X=i) = ( e^-lambda . lambda^i ) / i!

Using this formula, we will calculate the probability and use its value between 1 and 0 to display a linear progress indicator.

**Class-Diagram Concept:**

![](RackMultipart20240124-1-sbq7q3_html_30894b0da35a26f2.png)

classCategory {

  boolisCountBased;

  Stringname;

  StringActivityConnectUID;

  DateTimecreatedOn;

  List\<Activity\> activityList;

  Category({requiredthis.isCountBased, requiredthis.name, requiredthis.ActivityConnectUID, requiredthis.createdOn, requiredthis.activityList});

  voidaddToActivityList(Activityactivity) {

    activityList.add(activity);

  }

}

classActivity {

  Stringname;

  List\<String\> tags;

  DateTimecreatedOn;

  Map\<DateTime, int\> countMap;

  Activity({requiredthis.name, requiredthis.tags, requiredthis.createdOn, requiredthis.countMap});

}

classDEVLogs {

  List\<Project\> projects= [];

  intgetProjectCount() {

    returnprojects.length;

  }

}

classProject {

  Stringname;

  DateTimecreatedOn;

  List\<ProjectRecord\> logs= [];

  Project({requiredthis.name, requiredthis.createdOn});

  intgetLogCount() {

    returnlogs.length;

  }

}

classProjectRecord {

  DateTimelastUpdated;

  List\<Image\> images= [];

  ProjectRecord({requiredthis.lastUpdated, requiredthis.images});

  intgetImageCount() {

    returnimages.length;

  }

}

**State Management with Provider.**

Provider package is chosen for state management. The following methods and members show the updated data structures and business logic with state management implemented.

**Parent:**

This is a newly introduced class that will contain a list of categories and addToCategoryList() method. It will also contain an instance of DEVLogs. There will only be one instance of the parent class. It will provide all the state to the entire application form the main function. The .toString method should also be overloaded for this class to observe the number of items in the list of categories. Following tables show all the hierarchy of the classes and methods and data members inside each class.

| Parent: |
| --- |
| List\<Category\> categoryList; |
| addToCategoryList(); //with notifyListeners(); |
| .toString //overloaded |

| Category: |
| --- |
| Bool isCountBased; |
| String name; |
| String ActivityConnectUID; |
| DateTime createdOn; |
| List\<Activities\> activityList; |
| addToActivityList(); //with notifyListeners(); |
| .toString //overloaded |

| Activity: |
| --- |
| String name; |
| DateTime createdOn; |
| List\<String\> tags; |
| DateTime lastUpdated; |
| Map\<DateTime, Value\> countMap; |
| addToCountMap(); //with notifyListeners(); |
| .toString //overloaded |

| DEVLogs: |
| --- |
| List\<Project\> projectList; |
| addToProjectList(); //with notifyListeners(); |
| .toString //overloaded |

| Project: |
| --- |
| String name; |
| DateTime createdOn; |
| Future\<bool\> uploadToFirestore(); |
| List\<ProjectRecord\> projectRecordList; |
| addToProjectRecordList(); //with notifyListeners(); |

| ProjectRecord: |
| --- |
| List\<Image\> images; |
| DateTime createdOn; |
| String description; |
| .toString //overloaded |

![](RackMultipart20240124-1-sbq7q3_html_54b76b325af5c819.png)
