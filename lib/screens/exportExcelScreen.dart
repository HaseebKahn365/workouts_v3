// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart';
// import 'package:workouts_v3/buisiness_logic/all_classes.dart';

// class ExportAsExcelScreen extends StatefulWidget {
//   final Activity activity;
//   const ExportAsExcelScreen({required this.activity});

//   @override
//   State<ExportAsExcelScreen> createState() => _ExportAsExcelScreenState();
// }

// class _ExportAsExcelScreenState extends State<ExportAsExcelScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Export as Excel'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await createExcel();
//           },
//           style: ButtonStyle(
//             elevation: MaterialStateProperty.all(10),
//             backgroundColor: MaterialStateProperty.all(Colors.blue),
//             shape: MaterialStateProperty.all(RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             )),
//           ),
//           child: const Text('Export'),
//         ),
//       ),
//     );
//   }
// }
