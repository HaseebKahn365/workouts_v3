
```markdown
# Workouts V3

## Introduction
Workouts V3 is a personal tracker designed to help users store records based on the categories they create. Categories can be of two types: interval or count. Interval categories track records in terms of duration (e.g., 30mins), while counting categories track activities in terms of counts (e.g., Pushups: 30).

## UI Walkthrough
At the home screen, there's a "Create Category" button allowing users to create a new category by entering its name and type in an alert dialogue box. Once a category is created, users can click on it to navigate to the respective category screen. Each category can have multiple activities (e.g., Physics, Math, Computer Science) created by clicking a "Create" button on the category screen. Tags can be added to these activities for different purposes. The activity container is then used to add details like duration or count, depending on the category type.

## Data Storage Strategy
The data is stored in CSV files for easy processing and analysis. There are two main files:
### CSV1
This file contains category details with a specific field "ActivityConnectUID" mapping the category to another file (CSV2).
```csv
Category Name, Category_Type, ActivityConnectUID
Study, Interval, Sjj12h312324kj
Workout, Count, Sdfoh12h23ihh
```

### CSV2 [Sjj12h312324kj]
Details of each activity under the "Study" category.
```csv
Name, Tags, createdOn, Map<TimeStamp, Count/Duration>
Math, Calculus, CVT, 20/1/2024, 20/1/2024 12:00: 30mins, 20/1/2024 1:00: 30mins
Physics, Thermodynamics, 20/1/2024, 20/1/2024 12:00: 30mins, 20/1/2024 1:00: 30mins
```

### CSV2 [Sdfoh12h23ihh]
Details of each activity under the "Workout" category.
```csv
Name, Tags, createdOn, Map<TimeStamp, Count/Duration>
Pushups, Diamond, 20/1/2024, 20/1/2024 12:00: 120, 20/1/2024 1:00: 30mins
Bench-press, 120kg, 20/1/2024, 20/1/2024 12:00: 100, 20/1/2024 1:00: 30mins
```

### DEVLogs Storage Strategy
DEVLogs interface is similar to other categories, with an optimized UI for project progress tracking. Data is stored in Cloud Firestore and Firebase Storage. Projects in DEVLogs have an "Add Image" button and a container for entering tags in the form of chips. Images can be uploaded individually or in batches.

Firestore data structure:
- Collection name: DEVLogs
- Document name: Project Workouts V3 + createdOn Timestamp
```markdown
Activity Date   Map<dateTime, imageURLs>   Description
20/1/2024 12:00    20/1/2024 12:00: firebaseStorage.com/imageurl1    Working on implementing UI
                     20/1/2024 12:00: firebaseStorage.com/imageurl2
20/1/2024 12:00    20/1/2024 2:00: firebaseStorage.com/imageurl    Implemented Cloud Firestore
```

## Probability Concept
The probability of doing an activity within an interval of 1 hour is calculated using the Poisson random variable formula. The formula involves fetching all records under the current time and a 1-hour interval from the CSV2 file. The average count is then calculated (total counts or intervals of activity / total number of records), serving as the lambda value for the Poisson formula. The probability of doing Average+50 activities is computed as:
\[ P(X=i) = \frac{e^{-\lambda} \cdot \lambda^i}{i!} \]
The probability value is used to display a linear progress indicator between 1 and 0.
```

You can now paste this Markdown content into your `README.md` file. If you have any specific formatting preferences or additional details to include, feel free to let me know!