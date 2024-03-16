// table view for database:

import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';

class DBTableView extends StatefulWidget {
  final sqlServiceObject;
  final allActivities;
  const DBTableView({super.key, required this.sqlServiceObject, required this.allActivities});

  @override
  State<DBTableView> createState() => _DBTableViewState();
}

class _DBTableViewState extends State<DBTableView> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> getActivities() async {
    //filling the tables of the relational schema using the SQLService object
    try {
      await widget.sqlServiceObject.open();
      await widget.sqlServiceObject.fillTables(
        widget.allActivities,
      );
      records = await widget.sqlServiceObject.getAllDatedRecsFromTable();

      getImageMapRecords();
    } catch (e) {
      print(e);
    }

    foriegnKeysForActivities = getIndexes(records.keys.toList());

    print("finished loading on to db");
    setState(() {
      activities = widget.allActivities;
      print("here goes all the records" + records.toString());
      records = records;
    });

    widget.sqlServiceObject.printAllTables();
  }

  List<int> getIndexes(List records) {
    List<int> indexes = [];
    int numberOfRecords = records.length;
    int numberOfActivities = widget.allActivities.length;

    Random random = Random();

    for (int i = 0; i < numberOfRecords; i++) {
      if (random.nextDouble() < 0.9) {
        // 90% chance of index 4
        indexes.add(4);
      } else {
        indexes.add(random.nextInt(numberOfActivities - 1));
      }
    }
    return indexes;
  }

  List<Activity> activities = [];
  Map<int, int> records = {};
  List<int> foriegnKeysForActivities = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await getActivities();
            },
            icon: Icon(FluentIcons.cloud_arrow_down_48_regular),
          ),
        ],
        title: Text("Database Table View"),
        //increased height
        toolbarHeight: 70,
      ),
      body: ListView(
        children: [
          //the expandable list tile
          ExpansionTile(
            title: Text("Activities"),
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.01),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DataTable(
                      headingRowHeight: 35,
                      dataRowHeight: 35,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  FluentIcons.key_multiple_20_regular,
                                  size: 15,
                                ),
                              ),
                              Text('Name', style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Text('isCountBased', style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                      ],
                      rows: activities
                          .map(
                            (activity) => DataRow(
                              cells: [
                                DataCell(
                                  Text(activity.name),
                                ),
                                DataCell(
                                  Text(activity.isCountBased.toString()),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ExpansionTile(
            title: Text("Records"),
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.01),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DataTable(
                      headingRowHeight: 35,
                      dataRowHeight: 35,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  FluentIcons.key_multiple_20_regular,
                                  size: 15,
                                ),
                              ),
                              Text('Date', style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Text('Count', style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  FluentIcons.key_multiple_20_regular,
                                  size: 15,
                                ),
                              ),
                              Text('FK : Activity ID', style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ],
                      rows: records.entries
                          .map(
                            (record) => DataRow(
                              cells: [
                                DataCell(
                                  Text(DateTime.fromMillisecondsSinceEpoch(record.key).toString()),
                                ),
                                DataCell(
                                  Text(record.value.toString()),
                                ),
                                DataCell(
                                  Text(foriegnKeysForActivities[records.keys.toList().indexOf(record.key)].toString()),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),

          //another expansion tile for displaying the table of image map records which should contain the date , number of image urls and the foreign key to the activity table
          ExpansionTile(
            title: Text("Image Map Records"),
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.01),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DataTable(
                      headingRowHeight: 35,
                      dataRowHeight: 35,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  FluentIcons.key_multiple_20_regular,
                                  size: 15,
                                ),
                              ),
                              Text('Date', style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Text('Number of Image URLs', style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  FluentIcons.key_multiple_20_regular,
                                  size: 15,
                                ),
                              ),
                              Text('FK : Activity ID', style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ],
                      //display only the rows where the number of imageurls is not 0
                      rows: imageMapRecords
                          .where((element) => element.numberOfImageURLs != 0)
                          .map(
                            (record) => DataRow(
                              cells: [
                                DataCell(
                                  Text(record.date.toString()),
                                ),
                                DataCell(
                                  Text(record.numberOfImageURLs.toString()),
                                ),
                                DataCell(
                                  Text(record.foreignKeyToActivityTable.toString()),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),

          //another expansion tile for displaying the table of tagsMap which is similar to the imageMap but instead of image urls it contains tags which are strings

          ExpansionTile(
            title: Text("Tags Map Records"),
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.01),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DataTable(
                      headingRowHeight: 35,
                      dataRowHeight: 35,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  FluentIcons.key_multiple_20_regular,
                                  size: 15,
                                ),
                              ),
                              Text('Date', style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        DataColumn(
                          label: Text('Number of Tags', style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                        DataColumn(
                          label: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  FluentIcons.key_multiple_20_regular,
                                  size: 15,
                                ),
                              ),
                              Text('FK : Activity ID', style: TextStyle(fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ],
                      //display only the rows where the number of tags is not 0
                      //use the same data as the imageMapRecords
                      rows: imageMapRecords
                          .where((element) => element.numberOfImageURLs != 0)
                          .map(
                            (record) => DataRow(
                              cells: [
                                DataCell(
                                  Text(record.date.toString()),
                                ),
                                DataCell(
                                  Text(record.numberOfImageURLs.toString()),
                                ),
                                DataCell(
                                  Text(record.foreignKeyToActivityTable.toString()),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //similary add tow more list tiles with only single row of that says coming soon. one for image url and one for tag

          ExpansionTile(
            title: Text("Image URL Records"),
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.01),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DataTable(
                        headingRowHeight: 35,
                        dataRowHeight: 35,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    FluentIcons.key_multiple_20_regular,
                                    size: 15,
                                  ),
                                ),
                                Text('image url', style: TextStyle(fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    FluentIcons.key_multiple_20_regular,
                                    size: 15,
                                  ),
                                ),
                                Text('FK : image_map_id', style: TextStyle(fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                        ],
                        //only one record that says coming soon
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(
                                Text("Coming Soon"),
                              ),
                              DataCell(
                                Text("Coming Soon"),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),

          //exactly the same as above expansion tile but with tags
          ExpansionTile(
            title: Text("Tag Records"),
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.01),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DataTable(
                        headingRowHeight: 35,
                        dataRowHeight: 35,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    FluentIcons.key_multiple_20_regular,
                                    size: 15,
                                  ),
                                ),
                                Text('Tag', style: TextStyle(fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    FluentIcons.key_multiple_20_regular,
                                    size: 15,
                                  ),
                                ),
                                Text('FK : tags_map_id', style: TextStyle(fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                        ],
                        //only one record that says coming soon
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(
                                Text("Coming Soon"),
                              ),
                              DataCell(
                                Text("Coming Soon"),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<imageMapRow> imageMapRecords = [];
  List<tagsMapRow> tagsMapRecords = [];
  void getImageMapRecords() {
    for (int i = 0; i < records.length; i++) {
      imageMapRecords.add(
        imageMapRow(
          date: records.keys.toList()[i],
          foreignKeyToActivityTable: foriegnKeysForActivities[i],
        ),
      );
    }
  }

  void getTagsMapRecords() {
    for (int i = 0; i < records.length; i++) {
      tagsMapRecords.add(
        tagsMapRow(
          date: records.keys.toList()[i],
          foreignKeyToActivityTable: foriegnKeysForActivities[i],
        ),
      );
    }
  }
}

class imageMapRow {
  final int date;
  int numberOfImageURLs = 0;
  final int foreignKeyToActivityTable;

  imageMapRow({
    required this.date,
    required this.foreignKeyToActivityTable,
  }) {
    numberOfImageURLs = getnum();
  }
}

int getnum() {
  Random random = Random();
  return random.nextInt(3);
}

class tagsMapRow {
  final int date;
  int numberOfTags = 1;
  final int foreignKeyToActivityTable;

  tagsMapRow({
    required this.date,
    required this.foreignKeyToActivityTable,
  }) {
    numberOfTags = getnum();
  }
}
