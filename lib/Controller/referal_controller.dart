import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/Model/referal_model.dart';

class ReferalController extends GetxController {
  Rxn<List<ReferalModel>> referalList = Rxn<List<ReferalModel>>();
  List<ReferalModel> get referal => referalList.value;
  Rxn<List<ReferalModel>> referalList1 = Rxn<List<ReferalModel>>();
  List<ReferalModel> get referal1 => referalList1.value;

  var firebaseFirestore = FirebaseFirestore.instance;
  final userController = Get.put(UserController());
  // @override
  // void onInit() {
  //   // referalList.bindStream(referalStream(userController.firbaseUser.value.uid));

  //   super.onInit();
  // }
  void get() {}

  void getRef(uid) async {
    referalList1.bindStream(referalStream(uid));
  }

  Stream<List<ReferalModel>> referalStream(uid) {
    print("enter in referal stream funtion");
    return firebaseFirestore
        .collection('user')
        .doc(uid)
        .collection('referals')
        .snapshots()
        .map((QuerySnapshot query) {
      List<ReferalModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(ReferalModel.fromDocumentSnapShot(element));
      });

      print('Referal lenght is ${retVal.length}');
      return retVal;
    });
  }
}
