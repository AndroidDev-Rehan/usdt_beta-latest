import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  bool firstDeposit;
  String name;
  String email;
  String uid;
  String refId;
  bool cTrade;
  bool rTrade;
  String password;
  double tradeAmount;
  double investmentAmount;
  String userImage;
  Timestamp timeCreated;
  bool rLiteCoin;
  bool rAmazon;
  bool rCrudeOil;
  bool rGold;
  bool rSilver;
  bool rCoinbase;

  // 2nd part
  UserModel(
      {this.rLiteCoin,
      this.rAmazon,
      this.rCrudeOil,
      this.rSilver,
      this.rGold,
      this.rCoinbase,
      this.userImage,
      this.refId,
      this.investmentAmount,
      this.timeCreated,
      this.name,
      this.cTrade,
      this.rTrade,
      this.password,
      this.email,
      this.uid,
      this.firstDeposit});

  //3rd creating map -- insert
  UserModel.fromDocumentSnapShot(DocumentSnapshot snapshot) {
    // print('Model id : ${snapshot.data()['uid']}');
    name = snapshot.data()['name'] ?? "";
    email = snapshot.data()['email'] ?? "";
    cTrade = snapshot.data()['cTrade'] ?? false;
    rTrade = snapshot.data()['rTrade'] ?? false;
    uid = snapshot.data()['uid'] ?? "";
    investmentAmount = double.parse(snapshot.data()['investmentAmount'].toString()) ?? 0.0;
    refId = snapshot.data()['refId'] ?? "";
    timeCreated = snapshot.data()['timeCreated'] ?? "";
    userImage = snapshot.data()['userImage'] ?? "";
    tradeAmount = snapshot.data()['tradeAmount'] ?? 0.0;
    password = snapshot.data()['password'] ?? "";
    rAmazon = snapshot.data()['rAmazon'] ?? false;
    rCoinbase = snapshot.data()['rCoinbase'] ?? false;
    rCrudeOil = snapshot.data()['rCrudeOil'] ?? false;
    rGold = snapshot.data()['rGold'] ?? false;
    rSilver = snapshot.data()['rSilver'] ?? false;
    rLiteCoin = snapshot.data()['rLiteCoin'] ?? false;
    firstDeposit = snapshot.data()['firstDeposit'] ?? false;
    print("name is $name");
  }
}
