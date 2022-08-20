import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class VariablesModel {
  RxBool isAmazon = false.obs;
  RxBool isCoinbase = false.obs;
  RxBool isGold = false.obs;
  RxBool isLite = false.obs;
  RxBool isCrudeOil = false.obs;
  RxBool isSilver = false.obs;

  VariablesModel({
   this.isAmazon,
   this.isCoinbase,
   this.isGold,
   this.isLite,
   this.isCrudeOil,
   this.isSilver,
  });
  VariablesModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    isAmazon.value = snapshot.data()['rAmazon'];
    isCoinbase.value = snapshot.data()['rCoinbase'];
    isGold.value = snapshot.data()['rGold'];
    isLite.value = snapshot.data()['rLiteCoin'];
    isCrudeOil.value = snapshot.data()['rCrudeOil'];
    isSilver.value = snapshot.data()['rSilver'];
  }
}
