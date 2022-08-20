import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/UI/Manual_Trade/result.dart';
import '../../Controller/ManualTradeController.dart';
import '../../Model/manual_trade_model.dart';
import '../../Services/database.dart';
import '../../Widgets/auth_button.dart';
import '../../sizeConfig.dart';
import '../../style/color.dart';
import 'newMTGraphController.dart';

class ManualTSNew extends StatefulWidget {
  final String category;
  const ManualTSNew(this.category);

  @override
  State<ManualTSNew> createState() => _ManualTSNewState();
}

class _ManualTSNewState extends State<ManualTSNew> {
  final GlobalKey<FormState> _key = new GlobalKey<FormState>();
  TextEditingController investController = TextEditingController();
  UserController userController = Get.find();
  bool loading = false;
  CurrentRemainingTime timeLeft = CurrentRemainingTime(sec: 100);
  ManualTradeController manualTradeController;
  String type;
  bool success = true;

  bool startedBid = false;

  bool filled = false;
  bool filledAgain = false;
  List<ManualTradeModel> actualList = [];

  var marker = 0;
  final GraphController _controller = Get.put(GraphController());

  // bool timerStarted = false;

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  bool selected = false;
  final int maxX = 50;
  final int maxY = 50;

  double latestRandomValue;

  FlSpot selectedSpot = const FlSpot(0, 0);

  List<FlSpot> listData;
  int count = 0;

  @override
  void initState() {
    print("device height is: ${Get.height}");

    timer = Timer.periodic(
        const Duration(milliseconds: 700), (Timer t) => generateRandomValue());
    listData = [];

    latestRandomValue = (Random().nextDouble() * maxY - 5);

    for (int i = 0; i < maxX / 1.4; i++) {
      if (latestRandomValue >= (maxY - 10)) {
        latestRandomValue =
            _getRandomInt(latestRandomValue - 10, latestRandomValue - 5);
      } else if (latestRandomValue <= 10) {
        latestRandomValue =
            _getRandomInt(latestRandomValue + 5, latestRandomValue + 10);
      } else {
        latestRandomValue =
            _getRandomInt(latestRandomValue - 5, latestRandomValue + 5);
      }

      // latestRandomValue = (Random().nextDouble()*maxY - 5);
      listData.add(FlSpot(count.toDouble(), latestRandomValue));
      count++;
    }

    manualTradeController = ManualTradeController(widget.category);
    print("mt screen oninit completed");
    super.initState();
  }

  /// Get the random value.
  double _getRandomInt(double min, double max) {
    final Random _random = Random();
    return (min.toInt() + _random.nextInt(max.toInt() - min.toInt()))
        .toDouble();
  }

  Timer timer;

  @override
  Widget build(BuildContext context) {
    print(selectedSpot);
    return SafeArea(
      child: loading
          ? Scaffold(
              backgroundColor: bgColor,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                  backgroundColor: bgColorDark,
                  title: Text("${widget.category.toUpperCase()}"),
                  actions: [
                    Obx(() => _controller.timerStarted.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CountdownTimer(
                              ///ON ENDING OF TIMER

                              onEnd: () async {
                                int amountWon =
                                    (double.parse(investController.text) *
                                            (_getRandomInt(50, 80) / 100.0))
                                        .toInt();
                                if (mounted) {
                                  setState(() {
                                    loading = true;
                                  });
                                }
                                await ManualTradeController.removeTrade(
                                    widget.category);
                                if (success) {
                                  await MyDatabase().addInvestmentAmount(
                                      amountWon.toDouble());
                                } else {
                                  await MyDatabase().addInvestmentAmount(
                                      (0 - double.parse(investController.text))
                                          .toDouble());
                                }

                                Get.off(ManualTradeResultScreen(
                                    amount: success
                                        ? amountWon.toString()
                                        : investController.text.toString(),
                                    success: success));
                                timer?.cancel();
                                loading = false;
                              },

                              endTime: DateTime.now().millisecondsSinceEpoch +
                                  1000 * 60,
                              widgetBuilder: (_, CurrentRemainingTime time) {
                                timeLeft = time;
                                if (time == null) {
                                  // Fluttertoast.showToast(
                                  //     msg: 'Trade finished',
                                  //     toastLength: Toast.LENGTH_LONG);
                                  print("finished");
                                  Future.delayed(Duration(seconds: 0),
                                      () async {
                                    // Get.off(ManualTradeResultScreen(
                                    //     amount: success
                                    //         ? (widget.enteredAmount *
                                    //         (_getRandomInt(50, 80) / 100.0)).toInt()
                                    //         .toString()
                                    //         : widget.enteredAmount.toString(),
                                    //     success: success));
                                  });
                                }
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                    'Count down: ${time?.min == null ? 00 : time?.min}:${time?.sec == null ? 00 : time?.sec}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ));
                              },
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                'Count down: 01:00',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )),
                          ))
                  ]),
              backgroundColor: bgColor,
              body: FutureBuilder(
                  future: manualTradeController.getTrades(widget.category),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("loading");
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    print(
                        "category is : ${manualTradeController.category} \nlist length is ${manualTradeController.currentManualTrades.length}");
                    print(snapshot.connectionState);
                    print(snapshot.hasData);
                    return ListView(
                      children: [
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // IconButton(
                        //     onPressed: () {
                        //       marker = listData.length-1;
                        //       selected = true;
                        //     },
                        //     icon: const Icon(Icons.gradient)),
                        Container(
                            height: 500,
                            width: 500,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage("assets/images/graph.jpg"),
                              fit: BoxFit.cover,
                            )),
                            child: GetBuilder(
                                init: GraphController(),
                                builder: (data) {
                                  return LineChart(
                                    LineChartData(
                                      showingTooltipIndicators:
                                          (_controller.selectedSpot.value.x >
                                                  10)
                                              ? [
                                                  ShowingTooltipIndicators(
                                                    [
                                                      LineBarSpot(
                                                        LineChartBarData(),
                                                        0,
                                                        _controller
                                                            .selectedSpot.value,
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                              : null,
                                      lineTouchData: LineTouchData(
                                          enabled: false,
                                        touchTooltipData: (_controller.selectedSpot.value.x !=
                                            0)
                                            ?  LineTouchTooltipData(

                                          ///Optional, to show amount on tool tip uncomment below line

                                          // getTooltipItems: getToolTipItems

                                        ) : null,
                                      ),
                                      minX: 0,
                                      maxX: maxX.toDouble(),
                                      minY: 0,
                                      maxY: maxY.toDouble(),
                                      gridData: FlGridData(
                                        horizontalInterval: 2,
                                        verticalInterval: 2,

                                        ///background grid lines
                                        show: false,
                                        getDrawingHorizontalLine: (value) {
                                          return FlLine(
                                            color: const Color(0xff37434d),
                                            strokeWidth: 1,
                                          );
                                        },

                                        drawVerticalLine: true,
                                        getDrawingVerticalLine: (value) {
                                          return FlLine(
                                            color: const Color(0xff37434d),
                                            strokeWidth: 1,
                                          );
                                        },
                                      ),
                                      clipData: FlClipData.all(),
                                      titlesData: FlTitlesData(show: false),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border.all(
                                            color: const Color(0xff110d0d),
                                            width: 5),
                                      ),
                                      lineBarsData: [
                                        LineChartBarData(
                                            dotData: FlDotData(
                                              show: true,
                                              getDotPainter: (FlSpot flSpot,
                                                  double x,
                                                  LineChartBarData
                                                      lineChartBarData,
                                                  int y) {
                                                return FlDotCirclePainter(
                                                  color: Colors.white,
                                                  radius: 6.5,
                                                );
                                              },
                                              checkToShowDot: (FlSpot data,
                                                  LineChartBarData lineData) {
                                                if (data ==
                                                    _controller.selectedSpot
                                                        .value) return true;
                                                return false;
                                              },
                                            ),
                                            spots: listData,
                                            gradient: LinearGradient(
                                                colors: gradientColors),
                                            barWidth: 3.5,
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                  colors: gradientColors
                                                      .map((color) => color
                                                          .withOpacity(0.3))
                                                      .toList()),
                                            ),
                                            curveSmoothness: 100),
                                      ],
                                    ),
                                  );
                                })),
                        // SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            height: SizeConfig.screenHeight * 0.16,
                            child: Row(
                              children: [
                                Flexible(
                                    child: Form(
                                  key: _key,
                                  child: TextFormField(
                                    controller: investController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter some amount';
                                      } else if (value.isNumericOnly) {
                                        if (int.parse(value) <= 29) {
                                          return 'Investment amount must be at least 30\$';
                                        }
                                      } else
                                        return 'It is not a number';
                                      final n = num.tryParse(value);
                                      if (n == null) {
                                        return '"$value" is not a valid number';
                                      }
                                      if (int.parse(value) >
                                          userController.usermodel.value
                                              .investmentAmount) {
                                        return "you don't have enough balance in account";
                                      }
                                      return null;
                                    },
                                    cursorColor: Colors.white,
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        labelText:
                                            'Enter Amount you want to invest',
                                        labelStyle: TextStyle(
                                            color: Colors.grey, fontSize: 20),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 14),
                                        border: InputBorder.none,
                                        // focusedBorder: OutlineInputBorder(),
                                        hintText: '879.0',
                                        hintStyle: TextStyle(
                                            fontSize: 42,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        prefix: Text(
                                          '\$ ',
                                          style: TextStyle(
                                            fontSize: 42,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        )),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => AuthButton(
                                  width: 150,
                                  label: 'Bit Up',
                                  onTap: (!_controller.timerStarted.value)
                                      ? () async {
                                          if (_key.currentState.validate()) {
                                            Get.snackbar(
                                                "Success", "Bid Started",
                                                backgroundColor: Colors.white);
                                            type = "up";
                                            _controller.timerStarted.value =
                                                true;
                                            marker = listData.length - 1;
                                            selected = true;
                                            await ManualTradeController
                                                .addTrade(
                                                    type,
                                                    widget.category,
                                                    double.parse(
                                                        investController.text));
                                          }
                                        }
                                      : null,
                                  color: (!_controller.timerStarted.value)
                                      ? Colors.green
                                      : Colors.grey,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Obx(() => AuthButton(
                                  width: 150,
                                  color: (!_controller.timerStarted.value)
                                      ? Colors.red
                                      : Colors.grey,
                                  label: 'Bit Down',
                                  onTap: (!_controller.timerStarted.value)
                                      ? () async {
                                          if (_key.currentState.validate()) {
                                            Get.snackbar(
                                                "Success", "Bid Started",
                                                backgroundColor: Colors.white);
                                            type = "down";
                                            _controller.timerStarted.value =
                                                true;
                                            marker = listData.length - 1;
                                            selected = true;
                                            await ManualTradeController
                                                .addTrade(
                                                    type,
                                                    widget.category,
                                                    double.parse(
                                                        investController.text));
                                          }
                                        }
                                      : null,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  }),
            ),
    );
  }

  List<LineTooltipItem> getToolTipItems(List<LineBarSpot> touchedSpots){

    return touchedSpots.map((LineBarSpot touchedSpot) {
      final textStyle = TextStyle(
        color: touchedSpot.bar.gradient?.colors?.first ??
            touchedSpot.bar.color ??
            Colors.blueGrey,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      return LineTooltipItem(investController.text, textStyle);
    }).toList();
  }

  // List<LineTooltipItem> defaultLineTooltipItem(List<LineBarSpot> touchedSpots) {
  //   return touchedSpots.map((LineBarSpot touchedSpot) {
  //     final textStyle = TextStyle(
  //       color: touchedSpot.bar.gradient?.colors.first ??
  //           touchedSpot.bar.color ??
  //           Colors.blueGrey,
  //       fontWeight: FontWeight.bold,
  //       fontSize: 14,
  //     );
  //     return LineTooltipItem(touchedSpot.y.toString(), textStyle);
  //   }).toList();
  // }


  generateRandomValue() async {
    listData.removeAt(0);

    if (manualTradeController == null) {
      manualTradeController = ManualTradeController(widget.category);
    }

    if (filled == false) {
      print("adding value to actual list;");
      for (int i = 0;
          i < manualTradeController.currentManualTrades.length;
          i++) {
        actualList.add(manualTradeController.currentManualTrades[i]);
      }
      filled = true;
    }

    if (timeLeft?.sec == null || timeLeft.sec < 10) {
      // List<ManualTradeModel> list = await ManualTradeController.currentManualTrades.single;

      if (filledAgain == false) {
        for (int i = 0;
            i < manualTradeController.currentManualTrades.length;
            i++) {
          bool added = false;
          for (int j = 0; j < actualList.length; j++) {
            if (actualList[j].uid ==
                manualTradeController.currentManualTrades[i].uid) {
              added = true;
              break;
            }
          }
          if (!added) {
            actualList.add(manualTradeController.currentManualTrades[i]);
          }
        }
        filledAgain = true;
      }

      bool allSame = true;

      for (int i = 0; i < actualList.length; i++) {
        if (actualList[i].type != type) {
          allSame = false;
          break;
        }
      }

      if (actualList.length == 1) {
        success = false;
      } else if (allSame) {
        success = false;
      } else {
        int myAmount = int.parse(investController.text);
        for (int i = 0;
            i < manualTradeController.currentManualTrades.length;
            i++) {
          if (actualList[i].amount < myAmount &&
              actualList[i].uid != FirebaseAuth.instance.currentUser.uid) {
            success = false;
            break;
          }
        }
      }

      if (success) {
        if (type == "up") {
          bringUpGraph();
        } else {
          bringDownGraph();
        }
      } else {
        ///NO SUCCESS
        if (type == "down") {
          bringUpGraph();
        } else {
          bringDownGraph();
        }
      }
    } else {
      if (latestRandomValue >= (maxY - 10)) {
        latestRandomValue =
            _getRandomInt(latestRandomValue - 10, latestRandomValue - 5);
      } else if (latestRandomValue <= 10) {
        latestRandomValue =
            _getRandomInt(latestRandomValue + 5, latestRandomValue + 10);
      } else {
        latestRandomValue =
            _getRandomInt(latestRandomValue - 2, latestRandomValue + 2);
      }
    }

    // double y = Random().nextInt(maxY-5).toDouble();
    // var add = Random().nextDouble();
    // y += add;
    if (latestRandomValue == 0) latestRandomValue = 1;
    List<FlSpot> temp = [];

    for (var element in listData) {
      temp.add(FlSpot((element.x - 1), element.y));
    }

    listData = temp;

    // print(latestRandomValue);

    listData.add(FlSpot(count.toDouble(), latestRandomValue));
    if (selected) {
      _controller.selectedSpot.value =
          FlSpot(count.toDouble(), latestRandomValue);
      selected = false;
    } else {
      _controller.selectedSpot.value = FlSpot(
          (_controller.selectedSpot.value.x - 1),
          _controller.selectedSpot.value.y);
    }

    _controller.update();
  }

  void bringDownGraph() {
    print("adding down value");
    if (latestRandomValue <= 5) latestRandomValue = 30;
    latestRandomValue =
        _getRandomInt(latestRandomValue - 2, latestRandomValue - 1);
    print(latestRandomValue);

    // if (timeLeft?.sec == null || timeLeft.sec < 5) {
    //   chartData.add(_ChartData(count, random.nextInt(5)));
    //   // negCount = negCount - 2;
    // }
    // else
    //   //  if (timeLeft?.sec == null || timeLeft.sec < 10)
    //
    //     {
    //   chartData.add(_ChartData(count, random.nextInt(20)));
    //   // negCount = negCount - 2;
    // }
  }

  void bringUpGraph() {
    print("adding up value");

    if (latestRandomValue >= 45) latestRandomValue = 30;
    latestRandomValue =
        _getRandomInt(latestRandomValue + 1, latestRandomValue + 2);

    // if (timeLeft?.sec == null || timeLeft.sec < 5) {
    //   chartData.add(_ChartData(count, 90 + random.nextInt(10)));
    //   // negCount = negCount - 2;
    // } else
    //   //    if (timeLeft?.sec == null || timeLeft.sec < 10)
    //     {
    //   chartData.add(_ChartData(count, 80 + random.nextInt(20)));
    //   // negCount = negCount - 2;
    // }
  }


  @override
  void dispose() async {
    super.dispose();
    if (timeLeft != null) {
      if (timeLeft.sec != null) {
        if (timeLeft.sec > 0) {
          await ManualTradeController.removeTrade(widget.category);
        }
      }
    } // Cancelling the timer.

    print("cancelling the timer");
    timer?.cancel();
  }
}
