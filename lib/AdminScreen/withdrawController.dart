import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usdt_beta/Model/withdraw_model.dart';

class WithdrawController{
  static List<WithDrawModel> list = [];

  static fillList() async{
    final collection = await FirebaseFirestore.instance.collection("WithdrawRequests").get();
    list = collection.docs.map((e) => WithDrawModel.fromMap(e.data())).toList();
  }

}