import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/admin_controller.dart';
import 'package:usdt_beta/Controller/all_user_controller.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/Services/database.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

import '../Model/count_down.dart';

class CopyTradeLite extends StatefulWidget {
  CopyTradeLite({Key key}) : super(key: key);

  @override
  _CopyTradeLiteState createState() => _CopyTradeLiteState();
}

class _CopyTradeLiteState extends State<CopyTradeLite> {
  void onEnd() {
    print('back');
    // Get.back();
  }

  final adController = Get.put(AdminController());
  final useController = Get.put(UserController());
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController profitController = new TextEditingController();

  // static const maxSeconds = 180;
  Timer timer;
  final int maxTime = 
420;
  RxInt seconds = 
420.obs;
  RxBool isRunning = false.obs;
  double profit = 0;

  @override
  void initState() {
    // adController.getVari();
    calculateTimer();

    super.initState();
  }

  void calculateTimer() {
    MyDatabase().getCountDownTime('rLiteCoin').then((value) {
      final startAt = value.startAt.toDate();
      final now = DateTime.now();

      final difference = startAt.difference(now).inSeconds;

      seconds.value = maxTime + difference;

      if (seconds.value < maxTime && seconds.value > 0) {
        startTimer();
        print('count down started');
      } else {
        seconds.value = maxTime;
        print('count down value reset');
      }
    });
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds.value--;
      if (seconds.value == 0 || seconds.value > maxTime) {
        timer.cancel();
        timer = null;

        // MyDatabase().insertCountDown(CountDown(commodityType: 'rLiteCoin'));

        seconds.value = maxTime;
        isRunning.value = false;
      }
    });
  }

  void updateDatabaseCountDownTimer(CountDown countDown) {
    MyDatabase().insertCountDown(countDown);
  }

  @override
  Widget build(BuildContext context) {
    isRunning.value = timer == null ? false : timer.isActive;
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: bgColor,
          title: Text('Copy Trade'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            GetX<AdminController>(
                init: Get.put<AdminController>(AdminController()),
                builder: (AdminController adminController) {
                  if (adminController != null &&
                      adminController.variablesModel != null) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5.0,
                        shadowColor: Colors.grey.shade500,
                        color: bgColorLight.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          padding: EdgeInsets.only(left: 8),
                          height: SizeConfig.screenHeight * 0.28,
                          width: SizeConfig.screenWidth * 1,
                          //color: Colors.red,
                          decoration: BoxDecoration(
                              color: bgColorLight.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: SizeConfig.screenHeight * 0.01,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 8),
                                    height: SizeConfig.screenHeight * 0.26,
                                    width: SizeConfig.screenWidth * 0.42,
                                    // padding: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/litecoin.jpeg'),
                                            fit: BoxFit.cover)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Obx(
                                    () => Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Text(
                                          '${seconds.value}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  SizeConfig.screenHeight *
                                                      0.05),
                                        )),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 12),
                                    width: SizeConfig.screenWidth * 0.35,
                                    height: SizeConfig.screenHeight * 0.06,
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(150)),
                                        color: Colors.red,
                                        onPressed: () {
                                          if (timer == null) {
                                            if (profit != 0) {
                                              isRunning.value = true;

                                              startTimer();

                                              adminController.variablesModel
                                                  .isAmazon?.value = true;

                                              MyDatabase().updateValues(
                                                  'rLiteCoin', true);


                                              DateTime endDateTime =
                                              DateTime.now().add(Duration(seconds: 420));

                                              Timestamp endTime =
                                              Timestamp.fromDate(
                                                  endDateTime);

                                              updateDatabaseCountDownTimer(
                                                CountDown(
                                                  startAt: Timestamp.now(),
                                                  endAt: endTime,
                                                  seconds: seconds.value,
                                                  commodityType: 'rLiteCoin',
                                                  profit: profit,
                                                ),
                                              );
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: 'Set profit first.',
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                            }
                                          }

                                          // Get.to(TradeScreen());
                                        },
                                        child: Obx(
                                          () => isRunning.value
                                              ? Text(
                                                  'Started',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 19),
                                                )
                                              : Text(
                                                  'Start ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 19),
                                                ),
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            GetX<AllUserController>(
                init: Get.put<AllUserController>(AllUserController()),
                builder: (AllUserController allUserController) {
                  // if (allUserController != null &&
                  //     allUserController.allUserTLite != null) {
                  return Container(
                    height: SizeConfig.screenHeight * 0.9,
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          child: Column(
                            children: [
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(150)),
                                color: Colors.blue,
                                child: Text(
                                  'Give Profit to this group',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Get.defaultDialog(
                                    barrierDismissible: false,
                                    title: 'Add Profit',
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Give profit to this User'),
                                        Container(
                                            width: SizeConfig.screenWidth * 0.3,
                                            child: Form(
                                              key: _key,
                                              child: TextFormField(
                                                validator: (value) => value
                                                        .isEmpty
                                                    ? 'Profit amount cannot be blank'
                                                    : null,
                                                controller: profitController,
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                            )),
                                      ],
                                    ),
                                    confirm: RaisedButton(
                                      onPressed: () {
                                        if (_key.currentState.validate()) {
                                          profit = double.parse(
                                              profitController.text);
                                          profitController.clear();
                                          Get.back();
                                        }
                                      },
                                      child: Text('Okay'),
                                    ),
                                    cancel: RaisedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  );
                                },
                              ),
                              (allUserController != null &&
                                      allUserController.allUserTLite != null)
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          allUserController.allUserTLite.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                                backgroundImage: allUserController
                                                            .allUserTLite[index]
                                                            .userImage !=
                                                        ""
                                                    ? NetworkImage(
                                                        allUserController
                                                            .allUserTLite[index]
                                                            .userImage)
                                                    : AssetImage(
                                                        'assets/images/man.png')),
                                            title: Text(allUserController
                                                .allUserTLite[index].name),
                                            subtitle: Text(allUserController
                                                .allUserTLite[index].email),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                    'Copy Trade Amount :\$ ${allUserController.allUserTLite[index].tradeAmount.toStringAsFixed(2)}'),
                                                Text(
                                                    'Investment Amount :\$ ${allUserController.allUserTLite[index].investmentAmount.toStringAsFixed(2)}')
                                              ],
                                            ),
                                            onTap: () {},
                                          ),
                                        );
                                      })
                                  : Center(
                                      child: Text(
                                        'No user is trading',
                                      style: TextStyle(fontSize: 20),
                                    ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                  // } else {
                  //   return Center(
                  //     child: Text(
                  //       'User Loading...',
                  //       style: TextStyle(fontSize: 20),
                  //     ),
                  //   );
                  // }
                })
          ],
        ));
  }

  @override
  void dispose() {
    // updateDatabaseCountDownTimer();
    super.dispose();
  }
}
