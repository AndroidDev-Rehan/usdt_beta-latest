import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Model/manual_trade_model.dart';

class ManualTradeController extends GetxController {

  // Rx<bool> timerStarted = false.obs;
  // Rx<FlSpot> selectedSpot = FlSpot(0,0).obs;


  RxList<ManualTradeModel> currentManualTrades = <ManualTradeModel>[].obs;
  final String category;
  ManualTradeController(this.category);

  @override
  void onInit() async{
    await getTrades(category);
    // print("async in init completed");
    //
    // print("categor is : $category \nlist length is ${currentManualTrades.length}");
    super.onInit();
  }

  Future<void> getTrades(String category) async{
    currentManualTrades.bindStream(getAllManualTrades(category));
  }

  static Stream<List<ManualTradeModel>> getAllManualTrades(String category){
    // currentManualTrades =
    return FirebaseFirestore.instance.collection("mt$category").snapshots()
        .map((list) => list.docs.map((doc) => ManualTradeModel.fromMap(doc.data())).toList());
    // return currentManualTrades;
  }

  static removeTrade(String category) async{
    await FirebaseFirestore.instance.collection("mt$category").doc(FirebaseAuth.instance.currentUser.uid).delete();
  }

  static addTrade( String type, String category,double amount) async{
    await FirebaseFirestore.instance.collection("mt$category").doc(FirebaseAuth.instance.currentUser.uid).set(ManualTradeModel(timestamp: Timestamp.now(), type: type, amount: amount.toInt(),uid: FirebaseAuth.instance.currentUser.uid).toMap(),);
  }


}