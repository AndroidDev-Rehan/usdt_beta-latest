import 'referance_model.dart';

class ReferenceModelList {
  final List<ReferanceModel> list;

  ReferenceModelList({
    this.list,
  });

// Map<String, dynamic> toMap() {
//     return {
//       'reference': this.list,
//     };
//   }

  factory ReferenceModelList.fromMap(Map<String, dynamic> map) {
    final List<ReferanceModel> secondList = [];

    // liost.map((e) => ReferanceModel.fromMap(e));

    final List newList = map['reference'];
    for (int i = 0; i < newList.length; i++) {
      secondList.add(ReferanceModel.fromMap(newList[i]));
    }

    return ReferenceModelList(
      list: secondList,
    );
  }

  toMap(){
    List<Map> mapsList = [];

    for (int i = 0; i<list.length; i++){
      mapsList.add(list[i].toMap());
    }

    return {
      "reference": mapsList
    };
  }
}
