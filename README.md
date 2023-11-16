About the workouts project:
•	Tracks your daily, weekly, monthly and yearly progress. 
•	Cannot update more than 300+ because of the validator in form field.
•	Score is calculated based on the primary workouts.
•	Create your custom workouts. 
•	Shows your stats: it shows you all the score for the current day, week, month and year.
What is going to change in this version:
in this version of the app we are going to migrate our existing app that heavily relies on the cloud firestore to an SQL relational database using the sqflite package. We are doing so in order to localize the user data and avoid data corruption when the internet is not available. Before proceding here is a comparison of what data looks like in the previous version:
Database Structure (collections):
Collections:
Users
CommonData

Database Structure (documents):
user:
username
uid
isHaseeb //toggles request for cloud function
userImage
email
password
docDay
docDayRec
docWeek
docWeekRec
docMonth
docMonthRec
docYear
docYearRec
bestDay
bestWeek
bestMonth
isBlocked
allYearsRec
pullcount
pushcount



In this architecture all of the user’s data is stored in cloud firestore which makes it hard to read and write data quickly and it is also quite costly. We are going to fix this using the new localized relational database model with the help of SQFLite.

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

Creation of the workout:
when we create a workout it should get added to the workout table and it should also create a new row in the date and time table with the current date and time and the count should be set to 0. The nth time today should be set to 0, the workout type and score per count should be set to the default values, in their specified tables. The new workout instance in the database should have references to the workout type and score per count tables.
