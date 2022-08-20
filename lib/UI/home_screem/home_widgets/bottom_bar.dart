import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/regular_trade_controller.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/Services/database.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class TradeBottomWidget extends StatefulWidget {
  TradeBottomWidget({
    Key key,
    @required this.rate,
    @required this.title,
  }) : super(key: key);
  final double rate;
  final String title;

  @override
  _TradeBottomWidgetState createState() => _TradeBottomWidgetState();
}

class _TradeBottomWidgetState extends State<TradeBottomWidget> {
  TextEditingController tradeController = new TextEditingController();

  final userController = Get.put(UserController());
  final regularTradeController = Get.put(RegularTradeController());

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.24,
      color: bgColorLight,
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.screenHeight * 0.001,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Investment',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              //: Container(padding: EdgeInsets.zero),
              Text('Strike Rate',
                  style: TextStyle(color: Colors.grey, fontSize: 15))
            ],
          ),
          Row(
            children: [
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: tradeController,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white, fontSize: SizeConfig.defaultSize),
                  decoration: InputDecoration(
                      errorText: _validate ? 'Please Enter trade amount' : null,
                      fillColor: bgColor,
                      focusColor: bgColor,
                      focusedBorder: UnderlineInputBorder(),
                      // OutlineInputBorder(
                      //   borderSide: BorderSide(color: bgColor, width: 1.0),
                      //   // borderRadius: BorderRadius.circular(25.0)
                      // ),
                      prefixIcon: IconButton(
                        icon: Icon(
                          CupertinoIcons.minus,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      prefix: Text('\$ ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.defaultSize)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder()),
                ),
              )),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  enabled: false,
                  cursorColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white, fontSize: SizeConfig.defaultSize),
                  decoration: InputDecoration(
                      hintText: '${widget.rate}',
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.defaultSize),
                      prefixIcon: IconButton(
                        icon: Icon(
                          CupertinoIcons.down_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          CupertinoIcons.up_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      fillColor: bgColor,
                      focusColor: bgColor,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: bgColor, width: 1.0),
                        // borderRadius: BorderRadius.circular(25.0)
                      ),
                      border: OutlineInputBorder()),
                ),
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        tradeController.text.isEmpty
                            ? _validate = true
                            : _validate = false;
                      });
                      if (userController.user.investmentAmount <= 0) {
                        Get.snackbar('Alert', 'You have insufficent balance');
                      } else if (userController.user.investmentAmount <
                          double.parse(tradeController.text)) {
                        Get.snackbar('Alert',
                            'You balance lower then your trade amount');
                      } else {
                        regularTradeController.startTimer();
                        var investment = userController.user.investmentAmount;
                        investment =
                            investment - double.parse(tradeController.text);
                        MyDatabase().tradeUpdate(
                            investment, double.parse(tradeController.text));
                        MyDatabase().updateTradeNotation('rTrade', true,widget.title, true);
                        print('Title is :${widget.title}');
                        // MyDatabase().updateTradeNotation(widget.title, true);

                        Fluttertoast.showToast(
                            msg: 'Trade added please wait for result',
                            toastLength: Toast.LENGTH_LONG);
                        Timer(Duration(minutes: 1), () {
                          Get.back();
                          MyDatabase().getRegularTradeWinner(
                              name: widget.title, value: true);

                          //     .then((value) {
                          //   regularTradeController.isStart.value = true;
                          //   regularTradeController.callCountDown();
                          // });
                        });
                      }
                    },
                    child: Text(
                      'Down',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.defaultSize),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        tradeController.text.isEmpty
                            ? _validate = true
                            : _validate = false;
                      });
                      if (userController.user.investmentAmount <= 0) {
                        Get.snackbar('Alert', 'You have insufficent balance');
                      } else if (userController.user.investmentAmount <
                          double.parse(tradeController.text)) {
                        Get.snackbar('Alert',
                            'You balance lower then your trade amount');
                      } else {
                        regularTradeController.startTimer();
                        var investment = userController.user.investmentAmount;
                        investment =
                            investment - double.parse(tradeController.text);
                        MyDatabase().tradeUpdate(
                            investment, double.parse(tradeController.text));
                        MyDatabase().updateTradeNotation('cTrade', true,widget.title, true);
                        print('Title is :${widget.title}');
                        // MyDatabase().updateTradeNotation(widget.title, true);

                        Fluttertoast.showToast(
                            msg: 'Trade added please wait for result',
                            toastLength: Toast.LENGTH_LONG);
                        Timer(Duration(minutes: 1), () {
                          Get.back();
                          MyDatabase().getRegularTradeWinner(
                              name: widget.title, value: true);

                          //     .then((value) {
                          //   regularTradeController.isStart.value = true;
                          //   print('hello');
                          //   regularTradeController.callCountDown();
                          // });
                        });
                      }
                    },
                    child: Text(
                      'Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.defaultSize),
                    ),
                    color: Colors.green,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
