import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/admin_controller.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/Model/count_down.dart';
import 'package:usdt_beta/Model/trade_model.dart';
import 'package:usdt_beta/Model/user_model.dart';
import 'package:usdt_beta/Model/variable_model.dart';

class MyDatabase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //final authController = Get.put(AuthController());
  final userController = Get.put(UserController());
  final adminController = Get.put(AdminController());
  UserModel usermodel;

  Future<UserModel> getUser(String uid) async {
    // print("user id ${userController.firbaseUser.value.uid}");
    try {
      print("Get function uid $uid");
      DocumentSnapshot doc = await _firestore.collection('user').doc(uid).get();
      return UserModel.fromDocumentSnapShot(doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Future<UserModel> copyTUser(String uid) async {
  //   print("Trading users are");
  //   try {
  //     print("Get function Trading user uid $uid");
  //     DocumentSnapshot doc = (await _firestore
  //         .collection('user')
  //         .where('cTrade', isEqualTo: true)
  //         .get()) as DocumentSnapshot;
  //     return UserModel.fromDocumentSnapShot(doc);
  //   } catch (e) {
  //     print(" $e");
  //     rethrow;
  //   }
  // }

  getRegularTradeWinner({String name, bool value}) {
    try {
      _firestore
          .collection('user')
          .where('rTrade', isEqualTo: true)
          .where(name, isEqualTo: value)
          .get()
          .then((value) {
        if (value.docs.length == 1) {
          Get.defaultDialog(
              barrierDismissible: false,
              title: 'Try Again',
              content: Text('You loss! please try again'),
              cancel: RaisedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Okay')));
        } else {
          Get.defaultDialog(
              barrierDismissible: false,
              title: 'Wait',
              content: Text('Calculating your result'),
              cancel: RaisedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Okay')));
        }
        print('copy trade lenght : ${value.docs.length}');
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // getCopyTradeWinner(String uid, String commodityType, bool commodityValue) {
  //   try {
  //     _firestore
  //         .collection('user')
  //         .where('uid', isEqualTo: uid)
  //         .where('cTrade', isEqualTo: true)
  //         .where(commodityType, isEqualTo: commodityValue)
  //         .get()
  //         .then((value) {
  //       print('database user');
  //
  //       _firestore.collection('CountDown').doc(commodityType).get().then(
  //         (value1) {
  //           print('database count down');
  //
  //           if (value1.data().isNotEmpty) {
  //             print('database count down');
  //
  //             FirebaseFirestore.instance
  //                 .collection('user')
  //                 .where('cTrade', isEqualTo: true)
  //                 .where(commodityType, isEqualTo: commodityValue)
  //                 .get()
  //                 .then((value) {
  //               print('database user');
  //
  //               value.docs.forEach((element) {
  //                 if ((value1.data()['profit'] ?? 0) != 0) {
  //                   // Get.snackbar('Update', 'Profit Added');
  //                   Get.defaultDialog(
  //                       barrierDismissible: false,
  //                       title: 'Result',
  //                       content: Text(
  //                           'You Won ${calculatePercentage(element['tradeAmount'], value1.data()['profit']) ?? 0} from $commodityType'),
  //                       cancel: RaisedButton(
  //                           onPressed: () {
  //                             Get.back();
  //                           },
  //                           child: Text('Okay')));
  //
  //                   _firestore.collection('user').doc(element['uid']).update(
  //                     {
  //                       'investmentAmount': calculatePercentage(
  //                               element['tradeAmount'],
  //                               value1.data()['profit']) +
  //                           element['investmentAmount'],
  //                       commodityType: false,
  //                     },
  //                   );
  //                 }
  //
  //                 // _firestore.collection('CountDown').doc(commodityType).set(
  //                 //   {
  //                 //     'startAt': '',
  //                 //   },
  //                 //   SetOptions(merge: true),
  //                 // );
  //               });
  //             }).then((value) {});
  //           }
  //         },
  //       );
  //     });
  //   } catch (e) {
  //     print('database ${e.toString()}');
  //     rethrow;
  //   }
  // }
  getCopyTradeWinner(String uid, String commodityType, bool commodityValue) {
    try {

      _firestore.collection('user').doc(uid).get().then((value) {
        _firestore
            .collection('CountDown')
            .doc(commodityType)
            .get()
            .then((countDownValue) {
          print('database count down');

          if (countDownValue.data().isNotEmpty) {
            print('database count down');

            double profit = countDownValue['profit'];

            _firestore
                .collection('trade')
                .doc('$uid$commodityType')
                .get()
                .then((trade) {
              double tradeAmount = trade['tradeAmount'];

              _firestore
                  .collection('user')
                  .where('uid', isEqualTo: uid)
                  .where(commodityType, isEqualTo: true)
                  .get()
                  .then((value) {
                // value.docs.forEach((element) {
                if (value.docs.first[commodityType] == true) {
                  Get.defaultDialog(
                    barrierDismissible: false,
                    title: 'Result',
                    content: Text(
                        'You Won ${calculatePercentage(tradeAmount, profit) ?? 0} from $commodityType'),
                    cancel: RaisedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Okay'),
                    ),
                  );

                  _firestore.collection('user').doc(uid).get().then((user) {
                    _firestore.collection('user').doc(uid).update(
                      {
                        'investmentAmount':
                            calculatePercentage(tradeAmount, profit) +
                                user['investmentAmount'],
                        commodityType: false,
                        // 'cTrade': false,
                      },
                    );
                  });

                  // _firestore
                  //     .collection('trade')
                  //     .doc('$uid$commodityType')
                  //     .delete();
                }
                // });
              });
            });
          }
        });

        updateValues(commodityType, false);
      });
    } catch (e) {
      print('database ${e.toString()}');
      rethrow;
    }
  }

  updateUser() async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user-images')
          .child(userController.firbaseUser.value.uid);
      await ref.putFile(userController.img);
      final url = await ref.getDownloadURL();
      print("Get function uid ${userController.firbaseUser.value.uid}");
      await _firestore
          .collection('user')
          .doc(userController.firbaseUser.value.uid)
          .update({
        'name': userController.upNameController.text,
        'userImage': url != null ? url : userController.user.userImage
      }).then((value) => userController.isLoading.value = true);
      Get.snackbar('Success', 'User data updated successfully');
    } catch (e) {
      Get.snackbar('Error', e.message.toString());
      rethrow;
    }
  }

  copyTradeProfitUpdate(
    uid,
    double updatedInvestment,
    double profitAmount,
  ) async {
    try {
      await _firestore.collection('user').doc(uid).update({
        // 'investmentAmount': calculatePercentage(updatedInvestment, profitAmount),
        // 'investmentAmount':
        //     calculatePercentage(updatedInvestment, profitAmount),
        'profitAmount': percentage(updatedInvestment, profitAmount),
      }).then((value) {
        Get.back();
        Get.snackbar('Update', 'Profit Added');
      });
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    }
  }

  double calculatePercentage(double amount, double percentage) {
    return percentage.isNegative
        ? subtractPercentage(amount, percentage)
        : addPercentage(amount, percentage);
  }

  double percentage(double value, double percentage) {
    return (value * percentage / 100);
  }

  double subtractPercentage(double value, double percentage) {
    percentage = percentage.abs();
    return value - (value * percentage / 100);
  }

  double addPercentage(double value, double percentage) {
    return value + (value * percentage / 100);
  }

  tradeUpdate(double updatedInvestment, double tradeAmount) async {
    try {
      await _firestore
          .collection('user')
          .doc(userController.firbaseUser.value.uid)
          .update({
        'investmentAmount': updatedInvestment,
        'tradeAmount': tradeAmount
      }).then((value) => Get.snackbar(
              'Update', 'You invested successfully amount: $tradeAmount'));
    } catch (e) {
      Get.snackbar('Error', e.message.toString());
    }
  }

  void insetTradeAmount(TradeModel tradeModel) async {
    await _firestore
        .collection('trade')
        .doc('${tradeModel.uid}${tradeModel.commodityType}')
        .set(
      {
        'uid': tradeModel.uid,
        'commodityType': tradeModel.commodityType,
        'tradeAmount': tradeModel.tradeAmount,
      },
      SetOptions(merge: true),
    );
  }

  Future<VariablesModel> getVariValues(String uid) async {
    // print("user id ${userController.firbaseUser.value.uid}");
    try {
      print("Get variable function uid $uid");
      DocumentSnapshot doc =
          await _firestore.collection('Admin').doc(uid).get();
      return VariablesModel.fromDocumentSnapshot(doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }


  Future<bool> getTypeStatus2(String coinType) async{
    final DocumentSnapshot snapshot = await _firestore.collection('CountDown').doc(coinType).get();
    final Map<String,dynamic> map = snapshot.data();
    Timestamp timestamp = map['endAt'] as Timestamp;
    if(timestamp.millisecondsSinceEpoch < Timestamp.now().millisecondsSinceEpoch)
      return false;
    return true;

  }

  Future<bool> getTypeStatus (String coinType) async {
    final DocumentSnapshot snapshot = await _firestore.collection('Admin').doc('s0bkpSrG6x9gwvdzNM2n').get();
    final Map<String,bool> map = snapshot.data();

    return map[coinType];

    // if(map[coinType]) {
    //   log("map[coinType] is ${map[coinType]}");
    //   return true;
    // }
    // log("map[coinType] is ${map[coinType]}");
    // return false;
  }

  updateValues(String commodityType, bool value) async {
    // await _firestore
    //     .collection('Admin')
    //     .doc('s0bkpSrG6x9gwvdzNM2n')
    //     .update({'rAmazon': value});
    await _firestore.collection('Admin').doc('s0bkpSrG6x9gwvdzNM2n').set({
      commodityType: value,
    }, SetOptions(merge: true));
    // Get.snackbar('Success', 'User data updated successfully');
  }

  addInvestmentAmount(double newValue) async {
    double total = newValue + userController.user.investmentAmount;
    await _firestore
        .collection('user')
        .doc(userController.firbaseUser.value.uid)
        .update({'investmentAmount': total}).then(
            (value) => debugPrint('Updated'));
  }

  updateTradeNotation(
      String name, bool value1, String commodityType, bool value2) async {
    try {
      await _firestore
          .collection('user')
          .doc(userController.firbaseUser.value.uid)
          .update({
        name: value1,
        commodityType: value2,
      }).then((value) => userController.isLoading.value = true);
      // Get.snackbar('Success', 'User data updated successfully');
    } catch (e) {
      Get.snackbar('Error', e.message.toString());
      rethrow;
    }
  }

  void insertCountDown(CountDown countDown) async {
    try {
      await _firestore
          .collection('CountDown')
          .doc(countDown.commodityType)
          .set({
        'startAt': countDown.startAt,
        'endAt': countDown.endAt,
        'seconds': countDown.seconds,
        'commodityType': countDown.commodityType,
        'profit': countDown.profit,
      }).then((value) => userController.isLoading.value = true);
      // Get.snackbar('Success', 'User data updated successfully');
    } catch (e) {
      Get.snackbar('Error', e.message.toString());
      rethrow;
    }
  }

  Future<CountDown> getCountDownTime(String commodityType) async {
    return await _firestore
        .collection('CountDown')
        .doc(commodityType)
        .get()
        .then((value) => CountDown(
              startAt: value.data()['startAt'],
              endAt: value.data()['endAt'],
              seconds: value.data()['seconds'],
              commodityType: value.data()['commodityType'],
              profit: value.data()['profit'],
            ));
  }
}
