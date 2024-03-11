// // table view for database:

// /*
//  Map<String, dynamic> getAllActivitiesFromTable() {
//     final db = _getDatabaseOrThrow();
//     try {
//       final activities = db.rawQuery('SELECT * FROM $activitiesTable');
//       return activities as Map<String, dynamic>;
//     } catch (e) {
//       print("Error in getting all activities from the table: $e");
//       return {};
//     }
//   }
//    */

// import 'package:fluentui_system_icons/fluentui_system_icons.dart';
// import 'package:flutter/material.dart';
// import 'package:workouts_v3/buisiness_logic/all_classes.dart';

// class DBTableView extends StatefulWidget {
//   final sqlServiceObject;
//   const DBTableView({super.key, required this.sqlServiceObject});

//   @override
//   State<DBTableView> createState() => _DBTableViewState();
// }

// class _DBTableViewState extends State<DBTableView> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getActivities();
//   }

//   void getActivities() {
//     widget.sqlServiceObject.getAllActivitiesFromTable().then((value) {
//       setState(() {
//         activities = value;
//       });
//     });

//     widget.sqlServiceObject.getAllDatedRecsFromTable().then((value) {
//       setState(() {
//         records = value;
//       });
//     });

//     widget.sqlServiceObject.getAllActivityIds().then((value) {
//       setState(() {
//         foriegnKeys = value;
//       });
//     });
//   }

//   List<Activity> activities = [];
//   Map<String, int> records = {};
//   List<int> foriegnKeys = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Database Table View"),
//         //increased height
//         toolbarHeight: 70,
//       ),
//       body: ListView(
//         children: [
//           // Text("Activities:"),
//           TableTitle(title: "Activities:"),

//           Container(
//             padding: EdgeInsets.all(8),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Theme.of(context).colorScheme.primary.withOpacity(0.01),
//                       spreadRadius: 5,
//                       blurRadius: 10,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: DataTable(
//                   headingRowHeight: 35,
//                   dataRowHeight: 35,
//                   columns: const <DataColumn>[
//                     DataColumn(
//                       label: Row(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0),
//                             child: Icon(
//                               FluentIcons.key_multiple_20_regular,
//                               size: 15,
//                             ),
//                           ),
//                           Text('Name', style: TextStyle(fontStyle: FontStyle.italic)),
//                         ],
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text('isCountBased', style: TextStyle(fontStyle: FontStyle.italic)),
//                     ),
//                   ],
//                   rows: activities
//                       .map(
//                         (activity) => DataRow(
//                           cells: [
//                             DataCell(
//                               Text(activity.name),
//                             ),
//                             DataCell(
//                               Text(activity.isCountBased.toString()),
//                             ),
//                           ],
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ),
//             ),
//           ),
//           TableTitle(title: "Records:"),
//           Container(
//             padding: EdgeInsets.all(8),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Theme.of(context).colorScheme.primary.withOpacity(0.01),
//                       spreadRadius: 5,
//                       blurRadius: 10,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: DataTable(
//                   headingRowHeight: 35,
//                   dataRowHeight: 35,
//                   columns: const <DataColumn>[
//                     DataColumn(
//                       label: Row(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0),
//                             child: Icon(
//                               FluentIcons.key_multiple_20_regular,
//                               size: 15,
//                             ),
//                           ),
//                           Text('Date', style: TextStyle(fontStyle: FontStyle.italic)),
//                         ],
//                       ),
//                     ),
//                     DataColumn(
//                       label: Text('Count', style: TextStyle(fontStyle: FontStyle.italic)),
//                     ),
//                     DataColumn(
//                       label: Row(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(right: 8.0),
//                             child: Icon(
//                               FluentIcons.key_multiple_20_regular,
//                               size: 15,
//                             ),
//                           ),
//                           Text('FK : Activity ID', style: TextStyle(fontStyle: FontStyle.italic)),
//                         ],
//                       ),
//                     ),
//                   ],
//                   rows: records.entries
//                       .map(
//                         (record) => DataRow(
//                           cells: [
//                             DataCell(
//                               Text(record.key),
//                             ),
//                             DataCell(
//                               Text(record.value.toString()),
//                             ),
//                             DataCell(
//                               Text(foriegnKeys[records.keys.toList().indexOf(record.key)].toString()),
//                             ),
//                           ],
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TableTitle extends StatelessWidget {
//   final String title;
//   const TableTitle({
//     super.key,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
//           boxShadow: [
//             BoxShadow(
//               color: Theme.of(context).colorScheme.primary.withOpacity(0.01),
//               spreadRadius: 5,
//               blurRadius: 10,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
