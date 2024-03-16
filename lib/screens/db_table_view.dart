// table view for database:

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
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
    // TODO: implement initState
    super.initState();
  }

  Future<void> getActivities() async {
    //filling the tables of the relational schema using the SQLService object
    await widget.sqlServiceObject.open();
    await widget.sqlServiceObject.fillTables(
      widget.allActivities,
    );
    setState(() {
      activities = widget.allActivities;
    });
  }

  List<Activity> activities = [];
  Map<String, int> records = {};
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
            icon: Icon(FluentIcons.reward_24_filled),
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
                                  Text(record.key),
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
        ],
      ),
    );
  }
}
