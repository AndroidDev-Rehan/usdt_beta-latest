import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Model/user_model.dart';

class AllUserController extends GetxController {
  Rxn<List<UserModel>> allUserList = Rxn<List<UserModel>>();

  List<UserModel> get allUser => allUserList.value;

  Rxn<List<UserModel>> allUserListT = Rxn<List<UserModel>>();

  final List<UserModel> searchedUsersList = <UserModel>[];

  Rxn<List<UserModel>> allUserListTCoinbase = Rxn<List<UserModel>>();
  Rxn<List<UserModel>> allUserListTAmazon = Rxn<List<UserModel>>();
  Rxn<List<UserModel>> allUserListTLite = Rxn<List<UserModel>>();
  Rxn<List<UserModel>> allUserListTGold = Rxn<List<UserModel>>();
  Rxn<List<UserModel>> allUserListTSilver = Rxn<List<UserModel>>();
  Rxn<List<UserModel>> allUserListTOil = Rxn<List<UserModel>>();

  List<UserModel> get allUserT => allUserListT.value;

  List<UserModel> get allUserTCoinbase => allUserListTCoinbase.value;

  List<UserModel> get allUserTAmazon => allUserListTAmazon.value;

  List<UserModel> get allUserTLite => allUserListTLite.value;

  List<UserModel> get allUserTGold => allUserListTGold.value;

  List<UserModel> get allUserTSilver => allUserListTSilver.value;

  List<UserModel> get allUserTOil => allUserListTOil.value;

  @override
  void onInit() {
    allUserList.bindStream(allUserStream());
    allUserListT.bindStream(allCopyTradeUserStream());

    allUserListTCoinbase.bindStream(copyTradeUserStream('rCoinbase', true));
    allUserListTAmazon.bindStream(copyTradeUserStream('rAmazon', true));
    allUserListTLite.bindStream(copyTradeUserStream('rLiteCoin', true));
    allUserListTGold.bindStream(copyTradeUserStream('rGold', true));
    allUserListTSilver.bindStream(copyTradeUserStream('rSilver', true));
    allUserListTOil.bindStream(copyTradeUserStream('rCrudeOil', true));

    super.onInit();
  }

  updateSearchList(String searchText){
    searchedUsersList.clear();
    for (int i = 0; i<allUser.length; i++){
      if(allUser[i].name.startsWith(RegExp(searchText))){
        searchedUsersList.add(allUser[i]);
      }
    }
  }

  Stream<List<UserModel>> allUserStream() {
    print("enter in all user stream funtion");
    return FirebaseFirestore.instance
        .collection('user')
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(UserModel.fromDocumentSnapShot(element));
      });

      print('lenght of all users is ${retVal.length}');
      return retVal;
    });
  }

  Stream<List<UserModel>> allCopyTradeUserStream() {
    print("Enter in copy trade user");
    return FirebaseFirestore.instance
        .collection('user')
        .where('cTrade', isEqualTo: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(UserModel.fromDocumentSnapShot(element));
      });

      print('lenght of all copy trade users is ${retVal.length}');
      return retVal;
    });
  }

  Stream<List<UserModel>> copyTradeUserStream(String trade, bool value) {
    print("Enter in copy trade user");
    return FirebaseFirestore.instance
        .collection('user')
        .where('cTrade', isEqualTo: true)
        .where(trade, isEqualTo: value)
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(UserModel.fromDocumentSnapShot(element));
      });

      print('lenght of all copy trade users is ${retVal.length}');
      return retVal;
    });
  }
}
