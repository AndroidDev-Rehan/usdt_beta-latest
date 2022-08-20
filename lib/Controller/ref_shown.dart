///New Code Version 25.3

class RefShown{
  List<bool> shownList;

  RefShown({this.shownList});

  Map<String, dynamic> toMap() {
    return {
      'shownList': this.shownList,
    };
  }

  factory RefShown.fromMap(Map<String, dynamic> map) {

    List<bool> tempList = [];
    tempList = map['shownList'].map((a) => true).toList();

    return RefShown(
      shownList: tempList,
    );
  }
}