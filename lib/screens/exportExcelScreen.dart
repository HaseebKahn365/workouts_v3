import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:workouts_v3/buisiness_logic/all_classes.dart';

class ExportAsExcelScreen extends StatefulWidget {
  final Activity activity;
  const ExportAsExcelScreen({super.key, required this.activity});

  @override
  State<ExportAsExcelScreen> createState() => _ExportAsExcelScreenState();
}

class _ExportAsExcelScreenState extends State<ExportAsExcelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export as Excel'),
      ),
      body: const Center(
        child: Text('This feature is still under development'),
      ),
    );
  }
}

Future<void> createExcel() async {
  final workbook = Workbook();
  final List<int> bytes = workbook.saveAsStream();

  final directory = await getExternalStorageDirectory();

  workbook.dispose();
}
