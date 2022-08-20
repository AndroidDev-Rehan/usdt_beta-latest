import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Model/newRefShown.dart';
import 'package:usdt_beta/Model/referance_model.dart';
import 'package:usdt_beta/Model/user_model.dart';
import 'package:usdt_beta/Services/database.dart';
import 'package:usdt_beta/UI/BottomNavBar/bottom_nav_bar.dart';
import 'package:usdt_beta/UI/VerificationPage/verification_page.dart';

import '../Model/user_model_list.dart';

class UserController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController resetPasswordController = new TextEditingController();
  TextEditingController upNameController = TextEditingController();
  TextEditingController upEmailController = TextEditingController();
  TextEditingController upRefIdController = new TextEditingController();
  TextEditingController adminController = TextEditingController();
  File img;

  var firebaseFirestore = FirebaseFirestore.instance;
  ReferenceModelList referanceModelList;
  Rx<UserModel> usermodel = UserModel().obs;

  UserModel get user => usermodel.value;
  Rx<UserModel> userTmodel = UserModel().obs;

  UserModel get userT => usermodel.value;
  FirebaseAuth auth = FirebaseAuth.instance;
  Rxn<User> firbaseUser = Rxn<User>();

  String get users => firbaseUser.value?.email;

  set user(UserModel value) => this.usermodel.value = value;

  set userT(UserModel value) => this.usermodel.value = value;

  @override
  void onInit() {
    firbaseUser.bindStream(auth.authStateChanges());
    // usermodel.bindStream(getUserStream());
    super.onInit();
  }

  Future<void> getUser() async {
    user = await MyDatabase().getUser(firbaseUser.value.uid);
  }

  Future<UserModel> getUserById(String id) async {
   UserModel user1 = await MyDatabase().getUser(id);
   return user1;
  }


  Stream<UserModel> getUserStream() {
    return firebaseFirestore
        .collection('user')
        .doc(firbaseUser.value.uid)
        .snapshots()
        .map((event) => UserModel.fromDocumentSnapShot(event));
  }

  // void getTrade(uid) async {
  //   userT = await MyDatabase().copyTUser(uid);
  // }

  RxBool isLoading = true.obs;
  User verifyUser;

  //final auth = FirebaseAuth.instance;
  Timer timer;

  void signUp() {
    log("chal rha hhu me");
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((user) {
      // sign up
      postUserDataToDb();
    }).catchError((onError) {
      isLoading.value = false;

      Fluttertoast.showToast(msg: "error " + onError.toString());
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void login() async {
    isLoading.value = true;
    try {
      //authresult = await
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: loginEmailController.text,
              password: loginPasswordController.text)
          .then((value) async {
        print('value is ${value.user.uid}');
        print('firbaseUser is: {firbaseUser.value.uid}');
        print("value is ${value.user.uid}");

        Fluttertoast.showToast(msg: "Login Success");

        print(" my user is ${user.email}");
        Get.offAll(BottomNavBar());
        isLoading.value = true;
        // then((value) {
        //   isLoading.value = false;
        //   Get.offAll(BottomNavBar());
        // });
      });
      // Get.put<UserController>(UserController()).
      //print('idddd: ${authresult.user.uid}');

      //   Get.offAll(BottomNavBar());
      //   Fluttertoast.showToast(msg: "Login Success");
      // }).catchError((onError) {
      //   isLoading.value = false;

      //   Fluttertoast.showToast(msg: "error " + onError.toString());
      // });
    } catch (e) {
      Get.snackbar('Error', e.message.toString());
    }
  }

  void postUserDataToDb() async {
    isLoading.value = true;

    //FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    //  firebaseUser = FirebaseAuth.instance.currentUser;

    UserModel userModel = new UserModel();
    userModel.email = emailController.text;
    userModel.name = nameController.text;

    userModel.uid = firbaseUser.value.uid;
    userModel.investmentAmount = 0.0;
    userModel.refId = idController.text;
    userModel.userImage = "";
    userModel.tradeAmount = 0.0;
    userModel.timeCreated = Timestamp.now();
    userModel.rAmazon = false;
    userModel.rCoinbase = false;
    userModel.rCrudeOil = false;
    userModel.rGold = false;
    userModel.rSilver = false;
    userModel.rLiteCoin = false;

    try {
      await firebaseFirestore
          .collection("user")
          .doc(firbaseUser.value.uid)
          .set({
        'name': userModel.name,
        'email': userModel.email,
        'uid': userModel.uid,
        'investmentAmount': userModel.investmentAmount ?? 0.0,
        'tradeAmount': userModel.tradeAmount ?? 0.0,
        'refId': userModel.refId,
        'userImage': userModel.userImage,
        'cTrade': false,
        'rTrade': false,
        'password': passwordController.text,
        'timeCreated': userModel.timeCreated,
        'rAmazon': userModel.rAmazon,
        'rCoinbase': userModel.rCoinbase,
        'rCrudeOil': userModel.rCrudeOil,
        'rGold': userModel.rGold,
        'rSilver': userModel.rSilver,
        'rLiteCoin': userModel.rLiteCoin,
      }).then((value) => sendVerificationEmail());



      // DocumentReference docRef =
      //     firebaseFirestore.collection('user').doc(idController.text);
      // print('id :${firbaseUser.value.uid}');
      // docRef.get().then((value) async {
      //   if (value.exists) {
      //     await firebaseFirestore
      //         .collection("user")
      //         .doc(firbaseUser.value.uid)
      //         .set({
      //       'name': userModel.name,
      //       'email': userModel.email,
      //       'uid': userModel.uid,
      //       'investmentAmount': userModel.investmentAmount ?? 0.0,
      //       'tradeAmount': userModel.tradeAmount ?? 0.0,
      //       'refId': userModel.refId == null? "no ref":userModel.refId,
      //       'userImage': userModel.userImage,
      //       'cTrade': false,
      //       'rTrade': false,
      //       'password': passwordController.text,
      //       'timeCreated': userModel.timeCreated,
      //       'rAmazon': userModel.rAmazon,
      //       'rCoinbase': userModel.rCoinbase,
      //       'rCrudeOil': userModel.rCrudeOil,
      //       'rGold': userModel.rGold,
      //       'rSilver': userModel.rSilver,
      //       'rLiteCoin': userModel.rLiteCoin,
      //     }).then((value) {
      //       DocumentReference userReferal =
      //           firebaseFirestore.collection('user').doc(firbaseUser.value.uid);
      //
      //       firebaseFirestore
      //           .collection('user')
      //           .doc(idController.text)
      //           .collection('referals')
      //           .doc(firbaseUser.value.uid)
      //           .set({
      //         'referalsId': userReferal,
      //       });
      //     }).then((value) {
      //       sendVerificationEmail();
      //       Fluttertoast.showToast(msg: "Referal Register Success");
      //     });
      //
      //     isLoading.value = false;
      //   } else {
      //     await firebaseFirestore
      //         .collection("user")
      //         .doc(firbaseUser.value.uid)
      //         .set({
      //       'name': userModel.name,
      //       'email': userModel.email,
      //       'uid': userModel.uid,
      //       'investmentAmount': userModel.investmentAmount ?? 0.0,
      //       'tradeAmount': userModel.tradeAmount ?? 0.0,
      //       'refId': userModel.refId,
      //       'userImage': userModel.userImage,
      //       'cTrade': false,
      //       'rTrade': false,
      //       'password': passwordController.text,
      //       'timeCreated': userModel.timeCreated,
      //       'rAmazon': userModel.rAmazon,
      //       'rCoinbase': userModel.rCoinbase,
      //       'rCrudeOil': userModel.rCrudeOil,
      //       'rGold': userModel.rGold,
      //       'rSilver': userModel.rSilver,
      //       'rLiteCoin': userModel.rLiteCoin,
      //     }).then((value) {
      //       sendVerificationEmail();
      //       Fluttertoast.showToast(msg: "User Register Success");
      //     });
      //
      //     isLoading.value = false;
      //   }
      // });
    } catch (e) {
      Get.snackbar('Error', e.message.toString());
    }
  }

  void sendVerificationEmail() async {
    User firebaseUser = FirebaseAuth.instance.currentUser;
    await firebaseUser.sendEmailVerification();

    Fluttertoast.showToast(
        msg: "email verifcation link has sent to your email.");
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkVerifiedEmail();
    });
  }

  Future<void> checkVerifiedEmail() async {
    verifyUser = auth.currentUser;
    await verifyUser.reload();
    if (verifyUser.emailVerified) {
      timer.cancel();
      Get.to(VerificationPage());
    }
  }

  Future<void> uploadReference(String value) async{

    print("into upload reference");
    UserModel userModel = await getUserById(FirebaseAuth.instance.currentUser.uid);

    ReferenceModelList temp;
    if(userModel.refId != null && userModel.refId.isNotEmpty){
      print("ref id not null");
      final doc = await FirebaseFirestore.instance.collection("References").doc(userModel.refId).get();
      Map map = doc.data();
      if(map == null){
        temp = ReferenceModelList(list: []);
      }
      else {
        temp = ReferenceModelList.fromMap(map);
      }

      //checking if first time reference is used
      bool contains = false;

      for(int i=0; i<temp.list.length; i++){
        print("reference $i userid is ${temp.list[i].userId}");
        if(temp.list[i].userId == FirebaseAuth.instance.currentUser.uid){
          contains = true;
          break;
        }
      }

      if (!contains)
      {
        print("adding value because contains $contains");
        temp.list.add(ReferanceModel(
            userId: firbaseUser.value.uid,
            userName: userModel.name,
            value: value
        ));

        await FirebaseFirestore.instance.collection("References").doc(
            userModel.refId).set(temp.toMap());
      }
      else {
        print("value of contains is $contains");
      }
    }
    else {
      print("ref id is ${userModel.refId}");
    }
  }

  Future<void> resetPassword(context) async {
    if (resetPasswordController.text != null &&
        resetPasswordController.text.isNotEmpty) {
      if (resetPasswordController.text.isEmail) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => Center(
                  child: CircularProgressIndicator(),
                ));
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(
              email: resetPasswordController.text.trim());
          Get.snackbar('Check', 'Password reset email is sent');
          Navigator.of(context).popUntil((route) => route.isFirst);
          resetPasswordController.clear();
        } on FirebaseAuthException catch (e) {
          Get.snackbar('Error', e.toString());
          Navigator.of(context).pop();
        }
      } else {
        Get.snackbar('Error', 'Please Enter a valid email');
      }
    } else {
      Get.snackbar('Error', 'Please Enter a email');
    }
  }

  getReferalInfo() async {
    //await Future.delayed(Duration(seconds: 10));
    log("entered into referal model info");
    DocumentSnapshot documentSnapshot = await firebaseFirestore
        .collection('References')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    final Map map = documentSnapshot.data();
    log("my current uid: ${FirebaseAuth.instance.currentUser.uid}");
    log(map.toString());
    if (map == null) {
      referanceModelList = ReferenceModelList(list: []);
    } else {
      referanceModelList = ReferenceModelList.fromMap(map);
    }

    print("list length is : ${referanceModelList.list.length}");

    NewRefShown newRefShown;

    final snap1 =
    await firebaseFirestore.collection('refShown').doc(user.uid).get();
    log(snap1.data().toString());

    if (snap1.data() == null) {
      newRefShown = NewRefShown(count: 0);
    } else {
      newRefShown = NewRefShown.fromMap(snap1.data());
    }

    if( (referanceModelList.list.length - newRefShown.count) >= 5) {
      log("length is :  " + referanceModelList.list.length.toString());
      double totalAdd = 0;

      log("newRefShown.count: " + newRefShown.count.toString());
      for (int i = newRefShown.count; i < 5 * ((referanceModelList.list.length)~/5); i++) {
        totalAdd = totalAdd + 0.10 * double.parse(referanceModelList.list[i].value);
      }
      log(totalAdd.toString());

      print("setting count");
      newRefShown.count = 5 * ((referanceModelList.list.length)~/5);
      await firebaseFirestore
          .collection('refShown')
          .doc(user.uid)
          .set(newRefShown.toMap());

      print("count set completed");

      user.investmentAmount = user.investmentAmount + totalAdd;
      await firebaseFirestore.collection('user').doc(user.uid).set(
          {"investmentAmount": user.investmentAmount}, SetOptions(merge: true));
    }
  }


  ///old working function
  getReferalInfoOld() async {
    //await Future.delayed(Duration(seconds: 10));
    log("entered into referal model info");
    DocumentSnapshot documentSnapshot = await firebaseFirestore
        .collection('References')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    final Map map = documentSnapshot.data();
    log("my current uid: ${FirebaseAuth.instance.currentUser.uid}");
    log(map.toString());
    if (map == null) {
      referanceModelList = ReferenceModelList(list: []);
    } else {
      referanceModelList = ReferenceModelList.fromMap(map);
    }

    NewRefShown newRefShown;

    final snap1 =
        await firebaseFirestore.collection('refShown').doc(user.uid).get();
    log(snap1.data().toString());

    if (snap1.data() == null) {
      newRefShown = NewRefShown(count: 0);
    } else {
      newRefShown = NewRefShown.fromMap(snap1.data());
    }

    ///d=saif
    if (referanceModelList.list.length % 5 == 0 &&
        (newRefShown.count < referanceModelList.list.length)) {
      log("length is :  " + referanceModelList.list.length.toString());
      double totalAdd = 0;

      log("newRefShown.count: " + newRefShown.count.toString());
      for (int i = newRefShown.count; i < referanceModelList.list.length; i++) {
        totalAdd =
            totalAdd + 0.10 * double.parse(referanceModelList.list[i].value);
      }
      log(totalAdd.toString());

      newRefShown.count = referanceModelList.list.length;
      await firebaseFirestore
          .collection('refShown')
          .doc(user.uid)
          .set(newRefShown.toMap());

      user.investmentAmount = user.investmentAmount + totalAdd;
      await firebaseFirestore.collection('user').doc(user.uid).set(
          {"investmentAmount": user.investmentAmount}, SetOptions(merge: true));
    }

    ///rehan code

    // log("length is ${referanceModelList.list.length}" );
    // log("wtfffffffffffff");
    //
    // final snap = await firebaseFirestore.collection('refShown').doc(user.uid).get();
    //
    // final Map map2 = snap.data();
    // log(map2.toString());
    //
    // RefShown refShown;
    //
    // if(map2 == null){
    //   refShown = RefShown(shownList: []);
    // }
    // else {
    //   // refShown = RefShown.fromMap({"shownList": [true]});
    //   RefShown(shownList: [true]);
    //   log(refShown.toString());
    //
    // }
    //
    //
    // int unrewardedReferals = referanceModelList.list.length - (refShown.shownList.length*5);
    // log("unrewardedReferals : $unrewardedReferals");
    //
    // int startingIndex = refShown.shownList.length*5;
    // int rewardAbleReferralsCount = unrewardedReferals-unrewardedReferals%5;
    // int rewardAbleReferralsLastIndex = referanceModelList.list.length-(unrewardedReferals%5);  ///last index
    // double totalAdd = 0;
    // for (int i=startingIndex;i<rewardAbleReferralsLastIndex;i++){
    //   totalAdd = totalAdd + 0.10*double.parse(referanceModelList.list[i].value);
    // }
    //
    //
    // if(unrewardedReferals>4 ){
    //   user.investmentAmount = user.investmentAmount+totalAdd;
    //   await firebaseFirestore.collection('user').doc(user.uid).set({"investmentAmount" : user.investmentAmount},SetOptions(merge: true));
    //
    //   List<bool> newRefShown = [];
    //
    //   for (int i=0; i<rewardAbleReferralsCount/5; i++){
    //     newRefShown.add(true);
    //   }
    //
    //   refShown.shownList.addAll(newRefShown);
    //
    //   await firebaseFirestore.collection('refShown').doc(user.uid).set(refShown.toMap());
    // }
  }
}
