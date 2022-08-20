import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReferalModel {
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString uid = ''.obs;
  RxString refId = ''.obs;
  RxString password = ''.obs;
  RxDouble investmentAmount = 0.0.obs;
  RxDouble tradeAmount = 0.0.obs;
  RxString userImage = ''.obs;
  DocumentReference documentReference;
  RxBool cTrade = false.obs;
  RxBool rTrade = false.obs;
  Timestamp timeCreated = Timestamp.now();
  RxBool rGold = false.obs;
  RxBool rCrudeOil = false.obs;
  RxBool rSilver = false.obs;
  RxBool rCoinbase = false.obs;
  RxBool rAmazon = false.obs;
  RxBool rLiteCoin = false.obs;
  // 2nd part
  ReferalModel(
      {this.rAmazon,
      this.rCoinbase,
      this.rGold,
      this.rSilver,
      this.rCrudeOil,
      this.rLiteCoin,
      this.userImage,
      this.refId,
      this.investmentAmount,
      this.name,
      this.email,
      this.tradeAmount,
      this.cTrade,
      this.rTrade,
      this.password,
      this.documentReference,
      this.timeCreated,
      this.uid});
  //3rd creating map -- insert
  ReferalModel.fromDocumentSnapShot(DocumentSnapshot snapshot) {
    documentReference = snapshot.data()['referalsId'];
    documentReference.get().then((data) {
      if (data.exists) {
        print('Model id : ${data.data()['uid']}');
        // documentReference = data.data()['documentReference'] ?? "";
        name.value = data.data()['name'] ?? "";
        email.value = data.data()['email'] ?? "";
        cTrade.value = data.data()['cTrade'] ?? false;
        rTrade.value = data.data()['rTrade'] ?? false;
        uid.value = data.data()['uid'] ?? "";
        password.value = data.data()['password'] ?? "";
        investmentAmount.value = data.data()['investmentAmount'] ?? 0.0;
        tradeAmount.value = data.data()['tradeAmount'] ?? 0.0;
        refId.value = data.data()['refId'] ?? "";
        userImage.value = data.data()['userImage'] ?? "";
        timeCreated = data.data()['timeCreated'] ?? Timestamp.now();
        rAmazon.value = snapshot.data()['rAmazon'] ?? false;
        rCoinbase.value = snapshot.data()['rCoinbase'] ?? false;
        rCrudeOil.value = snapshot.data()['rCrudeOil'] ?? false;
        rGold.value = snapshot.data()['rGold'] ?? false;
        rSilver.value = snapshot.data()['rSilver'] ?? false;
        rLiteCoin.value = snapshot.data()['rLiteCoin'] ?? false;
        print(name);
      } else {
        print('Erorr... not data found');
      }
    });
  }
}
