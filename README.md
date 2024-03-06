this is a simplified application that allows the user to track activities using firebase as a server.

This is a mojor update to the Workouts_V3 app. this is the newer version: 1.1.0+1. here we are going to migrate to a local and persistent storage using the flutter packages: sqflite and path_provider.

All the functionalities will be the same with the only difference that we are going to use a local database to store the data. This will allow the user to have access to the data even when the user is offline. Here are the steps to migrate to a local database:

1. Designing the database schema
2. Creating methods and testing them to interact with the database and also converting the data to and from the database
3. Migrating the app to use the local database along with syncing boolean to keep track of the data that has been synced to the server.
4.