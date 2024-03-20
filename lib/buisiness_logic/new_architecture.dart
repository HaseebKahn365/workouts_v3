//Here we will have a completely new architecture for the table view of the database.

// ignore_for_file: camel_case_types, prefer_interpolation_to_compose_strings

/*
i want to use inheritance instead of composition.
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

class DatedRecs extends _Activity {
  Map<DateTime, int> datedRecs = {};

  DatedRecs({required String name, required bool isCountBased}) : super(name: name, isCountBased: isCountBased);

  @override
  String toString() {
    return super.toString() + ", datedRecs: $datedRecs";
  }
}

class ImageMap extends _Activity {
  Map<String, List<String>> imgMapArray = {};

  ImageMap({required String name, required bool isCountBased}) : super(name: name, isCountBased: isCountBased);

  @override
  String toString() {
    return super.toString() + ", imgMapArray: $imgMapArray";
  }
}

class TagMap extends _Activity {
  Map<String, List<String>> tagMapArray = {};

  TagMap({required String name, required bool isCountBased}) : super(name: name, isCountBased: isCountBased);

  @override
  String toString() {
    return super.toString() + ", tagMapArray: $tagMapArray";
  }
}

class imageUrl extends ImageMap {
  final String url;
  int fkImageMapID;
  imageUrl({required String name, required bool isCountBased, required this.fkImageMapID, required this.url}) : super(name: name, isCountBased: isCountBased);

  @override
  String toString() {
    return super.toString() + ", url: $url";
  }
}

class Tag extends TagMap {
  final String tag;
  int fkTagMapID;
  Tag({required String name, required bool isCountBased, required this.fkTagMapID, required this.tag}) : super(name: name, isCountBased: isCountBased);

  @override
  String toString() {
    return super.toString() + ", tag: $tag";
  }
}
