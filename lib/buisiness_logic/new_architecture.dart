//Here we will have a completely new architecture for the table view of the database.

// ignore_for_file: camel_case_types, prefer_interpolation_to_compose_strings

/*
i want to use inheritance instead of composition. Please show me a clean architecture so that from each _Activity i am deriving the datedRec class, imageMap class and tagsMap class. also show me how to display these respective informations for every _Activity in the list of activities in the parent class
 */

abstract class _Activity {
  late bool isCountBased;
  bool shouldAppear = true;
  int totalRecords = 0;
  late String name;

  _Activity({required this.name, required this.isCountBased});

  @override
  String toString() {
    return "_Activity: $name, isCountBased: $isCountBased, shouldAppear: $shouldAppear, totalRecords: $totalRecords"; // Common string representation
  }
}

class DatedRecOf_Activity extends _Activity {
  Map<DateTime, int> datedRecs = {};

  DatedRecOf_Activity({required String name, required bool isCountBased}) : super(name: name, isCountBased: isCountBased);

  @override
  String toString() {
    return super.toString() + ", datedRecs: $datedRecs";
  }
}

class Image_Activity extends _Activity {
  Map<String, List<String>> imgMapArray = {};

  Image_Activity({required String name, required bool isCountBased}) : super(name: name, isCountBased: isCountBased);

  @override
  String toString() {
    return super.toString() + ", imgMapArray: $imgMapArray";
  }
}

class Tag_Activity extends _Activity {
  Map<String, List<String>> tagMapArray = {};

  Tag_Activity({required String name, required bool isCountBased}) : super(name: name, isCountBased: isCountBased);

  @override
  String toString() {
    return super.toString() + ", tagMapArray: $tagMapArray";
  }
}
