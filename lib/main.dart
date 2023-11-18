import 'package:flutter/material.dart';
import 'package:workouts_v3/dbhelper.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final dbhelper = DatabaseHelper.instance;

  void insertData() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: 'Workout 1',
      DatabaseHelper.type: 'Pushups',
      DatabaseHelper.count: 31,
      DatabaseHelper.scorePerCount: 1,
    };
    final id = await dbhelper.insert(row);
    print('inserted row id: $id');
  }

  void queryAll() async {
    final allRows = await dbhelper.queryAll();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void querySpecific() async {
    final allRows = await dbhelper.queryId(40);
    print('query specific rows:');
    allRows.forEach((row) => print(row));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  // queryAll();
                  querySpecific();
                },
                child: Text('Query'),
                //make it runded corner
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)))),
            Container(
              height: 200,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  insertData();
                },
                child: Text('Insert'),
                //make it runded corner
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
