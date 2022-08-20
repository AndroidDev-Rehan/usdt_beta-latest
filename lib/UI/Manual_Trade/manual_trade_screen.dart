import 'dart:async';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_k_chart/utils/date_format_util.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:usdt_beta/Controller/ManualTradeController.dart';
import 'package:usdt_beta/Model/manual_trade_model.dart';
import 'package:usdt_beta/Services/database.dart';
import 'package:usdt_beta/UI/Manual_Trade/result.dart';
import 'package:usdt_beta/style/color.dart';
import '../home_screem/home_screen.dart';

class ManualTradeScreen extends StatefulWidget {
  final String category;
  final int enteredAmount;
  final String type;
  const ManualTradeScreen(this.category, this.enteredAmount, this.type,
      {Key key})
      : super(key: key);

  @override
  State<ManualTradeScreen> createState() => _ManualTradeScreenState();
}

class _ManualTradeScreenState extends State<ManualTradeScreen> {
  CurrentRemainingTime timeLeft;
  ManualTradeController manualTradeController;
  bool success = true;
  // List<_ChartData> chartData = <_ChartData>[];
  // Timer newTimer;
  Timer timer;
  Stopwatch _stopwatch = Stopwatch();
// Redraw the series with updating or creating new points by using this controller.
  ChartSeriesController _chartSeriesController;
// Count of type integer which binds as x value for the series
  int count = 19;

  //Initialize the data source
  List<_ChartData> chartData = <_ChartData>[
    _ChartData(0, 0),
    _ChartData(1, 47),
    _ChartData(2, 60),
    _ChartData(3, 49),
    _ChartData(4, 54),
    _ChartData(5, 41),
    _ChartData(6, 58),
    _ChartData(7, 51),
    _ChartData(8, 68),
    _ChartData(9, 41),
    _ChartData(10, 53),
    _ChartData(11, 52),
    _ChartData(12, 66),
    _ChartData(13, 52),
    _ChartData(14, 34),
    _ChartData(15, 62),
    _ChartData(16, 46),
    _ChartData(17, 50),
    _ChartData(18, 64),
  ];

  bool loading = false;
  SfCartesianChart _sfCartesianChart;
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true, shouldAlwaysShow: true);

  // Duration newTimer;


  @override
  void initState() {
    _stopwatch.start();
    super.initState();
  }

  void show() {
    // In the show method, you can pass the x and y values
    // _tooltipBehavior.show(chartData[18].country.toDouble(),chartData[18].sales.toDouble());
    _tooltipBehavior.showByIndex(0, 10);
  }

  @override
  Widget build(BuildContext context) {

    _sfCartesianChart = SfCartesianChart(
      borderWidth: 0,
      enableAxisAnimation: true,
      selectionType: SelectionType.point,
      tooltipBehavior: _tooltipBehavior,
      primaryXAxis: NumericAxis(
        isVisible: false,
        borderWidth: 0,
          labelStyle: TextStyle(
              color: Colors.white,
              // fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500)),
      primaryYAxis: NumericAxis(
        isVisible: false,
        borderWidth: 0,
          // axisLabelFormatter: (AxisLabelRenderDetails a){
          //   return ChartAxisLabel(a.value.toString(), TextStyle());
          // },
          // arrangeByIndex: false,
          maximum: 100,
          minimum: 0,
          visibleMaximum: 100,
          visibleMinimum: 0,
          labelStyle: TextStyle(
              color: Colors.white,
              // fontSize: 14,
              fontWeight: FontWeight.w500)),
      backgroundColor: bgColor,
      borderColor: Colors.white,
      // plotAreaBackgroundColor: Colors.white,
      plotAreaBorderColor: Colors.white,

      series: [
        AreaSeries<_ChartData, int>(
          animationDuration: 2000,
          enableTooltip: true,
          onRendererCreated: (ChartSeriesController controller) {
            // Assigning the controller to the _chartSeriesController.
            _chartSeriesController = controller;
          },
          // Binding the chartData to the dataSource of the line series.
          dataSource: chartData,
          borderColor: Colors.blue,
          markerSettings: MarkerSettings(
            shape: DataMarkerType.circle,
            isVisible: false,
          ),
          borderWidth: 3,
          legendIconType: LegendIconType.circle,
          xValueMapper: (_ChartData sales, _) => sales.country,
          yValueMapper: (_ChartData sales, _) => sales.sales,
          color: Colors.blue.withOpacity(0.2),
          xAxisName: "Duration",
          yAxisName: "Investment",
          // trendlines: [Trendline(
          //   intercept: 50 ,
          //     type: TrendlineType.polynomial,
          //     enableTooltip: true,
          //     markerSettings: MarkerSettings(isVisible: true)
          // )]
        ),
      ],
    );

    // Here the _updateDataSource method is called for every second.
    timer = Timer.periodic(
        const Duration(milliseconds: 2000), (t){
          if(_stopwatch.elapsedMilliseconds > 1000*80)
            {
              // _updateDataSource();
              // Future.delayed(Duration(seconds: 10));
              print("cancelling");
              t.cancel();
            }
          else {
        _updateDataSource();
      }
    }
    );
    manualTradeController = ManualTradeController(widget.category);

    return loading ? Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white,),
      ),
    ): Scaffold(
      backgroundColor: bgColor,
        appBar:
        AppBar(
          title: Text("${widget.category}"),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CountdownTimer(
                onEnd: () async {
                  int amountWon = (widget.enteredAmount * (_getRandomInt(50, 80) / 100.0)).toInt();
                  setState(() {
                    loading = true;
                  });
                  await ManualTradeController.removeTrade(
                      widget.category);
                  if(success){
                    await MyDatabase().addInvestmentAmount(amountWon.toDouble());
                  }else {
                    await MyDatabase().addInvestmentAmount((0-widget.enteredAmount).toDouble());
                  }

                  Get.off(ManualTradeResultScreen(
                      amount: success
                          ? amountWon.toString()
                          : widget.enteredAmount.toString(),
                      success: success));
                  timer?.cancel();
                  loading = false;

                },
                endTime:
                DateTime.now().millisecondsSinceEpoch + 1000 * 60,
                widgetBuilder: (_, CurrentRemainingTime time) {
                  timeLeft = time;
                  if (time == null) {
                    // Fluttertoast.showToast(
                    //     msg: 'Trade finished',
                    //     toastLength: Toast.LENGTH_LONG);
                    print("finished");
                    Future.delayed(Duration(seconds: 0),
                            ()async{
                          // Get.off(ManualTradeResultScreen(
                          //     amount: success
                          //         ? (widget.enteredAmount *
                          //         (_getRandomInt(50, 80) / 100.0)).toInt()
                          //         .toString()
                          //         : widget.enteredAmount.toString(),
                          //     success: success));
                        }
                    );
                  }
                  return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          'Count down: ${time?.min == null ? 00 : time?.min}:${time?.sec == null ? 00 : time?.sec}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ));
                },
              ),
            ),
          ],
          backgroundColor: bgColorDark,
        ),
      body: FutureBuilder(
        future: manualTradeController.getTrades(widget.category),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          return Column(
            children: [
              SizedBox(height: 70,),
              _sfCartesianChart,
              ElevatedButton(
                  onPressed: (){
                    show();
                    },
                  child: Text("show")),
            ],
          );
        }
      ),
    );
  }

  bool showMarker = false;

  // int negCount = 30;

  void bringDownGraph() {
    print("adding down value");
    if (timeLeft?.sec == null || timeLeft.sec < 5) {
      chartData.add(_ChartData(count, random.nextInt(5)));
      // negCount = negCount - 2;
    }
    else
    //  if (timeLeft?.sec == null || timeLeft.sec < 10)

    {
      chartData.add(_ChartData(count, random.nextInt(20)));
      // negCount = negCount - 2;
    }
  }

  void bringUpGraph() {
    print("adding up value");
    if (timeLeft?.sec == null || timeLeft.sec < 5) {
      chartData.add(_ChartData(count, 90 + random.nextInt(10)));
      // negCount = negCount - 2;
    } else
  //    if (timeLeft?.sec == null || timeLeft.sec < 10)
      {
      chartData.add(_ChartData(count, 80 + random.nextInt(20)));
      // negCount = negCount - 2;
    }
  }

  bool filled = false;
  bool filledAgain = false;
  List<ManualTradeModel> actualList = [];

  void _updateDataSource() async {
    print("yes");
    print(_stopwatch.elapsedMilliseconds/1000);
    // print(newTimer?.inSeconds);

    // if (timeLeft.sec == 0 || timeLeft.sec == null || timeLeft.sec < 0 || timeLeft == null){
    //   print("returning");
    //   return;
    // }
    //
    if(manualTradeController == null){
      manualTradeController = ManualTradeController(widget.category);
    }
    print("current manualtrades list length is ${manualTradeController.currentManualTrades.length}");
    print("current chardata list length is ${chartData.length}");
    print("actualList length is ${actualList.length}");


    if (filled == false){
      print("adding value to actual list;");
      for (int i=0; i<manualTradeController.currentManualTrades.length; i++){
        actualList.add(manualTradeController.currentManualTrades[i]);
      }
      filled = true;
    }



    // if(timeLeft?.sec==null ||  timeLeft.sec < 5){
    //   chartData.add(_ChartData(count, random.nextInt(5)));
    //   // negCount = negCount - 2;
    // }
    // else if(timeLeft?.sec==null ||  timeLeft.sec < 10){
    //   chartData.add(_ChartData(count, random.nextInt(20)));
    //   // negCount = negCount - 2;
    // }
    // else {
    //   chartData.add(_ChartData(count, 10 + random.nextInt(100 - 10)));
    // }

    if (timeLeft?.sec == null || timeLeft.sec < 10) {
      // List<ManualTradeModel> list = await ManualTradeController.currentManualTrades.single;

      if (filledAgain == false){
        for (int i=0; i<manualTradeController.currentManualTrades.length; i++){
          bool added = false;
          for (int j = 0; j<actualList.length; j++)
            {
              if(actualList[j].uid == manualTradeController.currentManualTrades[i].uid)
                {
                  added = true;
                  break;
                }
            }
          if(!added) {
            actualList.add(manualTradeController.currentManualTrades[i]);
          }
        }
        filledAgain = true;
      }


      bool allSame = true;

      for (int i =0; i< actualList.length; i++){
        if(actualList[i].type != widget.type){
          allSame =false;
          break;
        }
      }

      if (actualList.length == 1) {
        success = false;
      }
      else if(allSame){
        success = false;
      }
      else {
        int myAmount = widget.enteredAmount;
        for (int i = 0;
            i < manualTradeController.currentManualTrades.length;
            i++) {
          if (actualList[i].amount < myAmount &&
              actualList[i].uid !=
                  FirebaseAuth.instance.currentUser.uid) {
            success = false;
            break;
          }
        }
      }

      if (success) {
        if (widget.type == "up") {
          bringUpGraph();
        } else {
          bringDownGraph();
        }
      } else {
        ///NO SUCCESS
        if (widget.type == "down") {
          bringUpGraph();
        } else {
          bringDownGraph();
        }
      }
    }
    else {
      print("adding random value");
      if(previousRandomDigit < 20){
        previousRandomDigit = _getRandomInt(previousRandomDigit+10, previousRandomDigit+20);
      }
      else if (previousRandomDigit > 80){
        previousRandomDigit = _getRandomInt(previousRandomDigit-10, previousRandomDigit-20);
      }
      else {
        previousRandomDigit =
            _getRandomInt(previousRandomDigit - 10, previousRandomDigit + 10);
        if(previousRandomDigit < 40){
          showMarker = true;
        }
      }
      chartData.add(_ChartData(count,previousRandomDigit));
    }

    // if(true)
    // bringDownGraph();
    // else {
    //   bringUpGraph();
    // }

    if (chartData.length == 20) {
      // Removes the last index data of data source.
      chartData.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1],
          removedDataIndexes: <int>[0]
      );
    }
    count = count + 1;
  }

  int previousRandomDigit = 50;

  int _getRandomInt(int min, int max) {
    print("min value is $min");
    print("max value is $max");
    final math.Random _random = math.Random();
    return min + _random.nextInt(max - min);
  }

  @override
  void dispose() {
    super.dispose();
    // Cancelling the timer.
    timer?.cancel();
  }
}

class _ChartData {
  _ChartData(this.country, this.sales);
  final int country;
  final num sales;
}

