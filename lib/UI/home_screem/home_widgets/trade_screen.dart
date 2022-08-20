import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:usdt_beta/Controller/LiveTradeController.dart';
import 'package:usdt_beta/Controller/regular_trade_controller.dart';
import 'package:usdt_beta/UI/home_screem/home_widgets/bottom_bar.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;

class Trade {
  static final String AMAZON = "rAmazon";
  static final String GOLD = "rGold";
  static final String CRUIDE_OIL = "rCrudeOil";
  static final String SILVER = "rSilver";
  static final String COINABASE = "rCoinbase";
  static final String LITE_COIN = "rLiteCoin";
}

class TradeScreen extends StatefulWidget {
  TradeScreen({Key key, this.color, this.title, this.rate}) : super(key: key);
  final Color color;
  final String title;
  final double rate;

  @override
  State<StatefulWidget> createState() {
    return _TradeScreenState();
  }
}

List<ChartSampleData> chartData;
final regularTradeController = Get.put(RegularTradeController());

class _TradeScreenState extends State<TradeScreen> {
  TrackballBehavior _trackballBehavior;
  Random random = new Random(100);
  int randomNumber = 2;
  int random2;
  int random3;
  LiveTradeController liveTrade = Get.find();
  //syncfusion graph

  bool isCardView = false;
  Rx<Timer> tradeTimer = Rxn();
  list() {
    chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Amazon',
          y: 32,
          yValue: 56,
          secondSeriesYValue: 72,
          thirdSeriesYValue: 44),
      ChartSampleData(
          x: 'Lite coin',
          y: randomNumber,
          yValue: random2,
          secondSeriesYValue: random3,
          thirdSeriesYValue: random2),
      ChartSampleData(
          x: 'Crude oil',
          y: 78,
          yValue: 37,
          secondSeriesYValue: 45,
          thirdSeriesYValue: 44),
      ChartSampleData(
          x: 'Clothes',
          y: 41,
          yValue: 70,
          secondSeriesYValue: 67,
          thirdSeriesYValue: 10),
      ChartSampleData(
          x: 'Books',
          y: 48,
          yValue: 18,
          secondSeriesYValue: 43,
          thirdSeriesYValue: 78),
      ChartSampleData(
          x: 'Others',
          y: 76,
          yValue: 54,
          secondSeriesYValue: 33,
          thirdSeriesYValue: randomNumber),
      ChartSampleData(
          x: 'new',
          y: 90,
          yValue: 34,
          secondSeriesYValue: 33,
          thirdSeriesYValue: randomNumber),
      ChartSampleData(
          x: 'you',
          y: random3,
          yValue: randomNumber,
          secondSeriesYValue: random3,
          thirdSeriesYValue: random2),
    ];
  }

  @override
  void initState() {
    super.initState();
    liveTrade.startTimer(this.widget.title);
    tradeTimer = liveTrade.getTimer(widget.title);
    tradeTimer.listen((p0) {
    });
    _trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    randomNumber = random.nextInt(100);
    random2 = random.nextInt(100);
    random3 = random.nextInt(100);
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        list();
        print(randomNumber);
        setState(() => print('Data updated'));
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? ""),
          actions: [
            Obx(
                  () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${
420 - tradeTimer.value.tick} Sec',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
          backgroundColor: bgColorDark,
        ),
        backgroundColor: bgColor,
        bottomSheet: TradeBottomWidget(title: widget.title, rate: widget.rate),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
                height: SizeConfig.screenHeight * 0.73,
                width: double.infinity,
                child: _buildStackedLineChart(),
              ),
            ]),
          ],
        ));
  }

  Widget _buildStackedLineChart() {
    return Container(
      child: CustomPaint(painter: GraphPainter()),
    );

    // return Obx(
    //   ()=> Sparkline(

    //                   gridLinelabelPrefix: '\$',
    //                   gridLineLabelPrecision: 3,
    //                   useCubicSmoothing: true,

    //                   cubicSmoothingFactor: 0.2,
    //                   pointsMode: PointsMode.last,

    //                   fillColor: Colors.red[200],
    //                   pointColor: Colors.white,

    //                   data: liveTrade.data,
    //                 ),);

    // SfCartesianChart(
    //   plotAreaBorderWidth: 0,
    //   title: ChartTitle(text: isCardView ? '' : 'Graph for ${widget.title}'),
    //   legend: Legend(isVisible: !isCardView),
    //   primaryXAxis: CategoryAxis(
    //     majorGridLines: const MajorGridLines(width: 0),
    //     labelRotation: isCardView ? 0 : -45,
    //   ),
    //   primaryYAxis: NumericAxis(
    //       maximum: 200,
    //       axisLine: const AxisLine(width: 0),
    //       labelFormat: r'${value}',
    //       majorTickLines: const MajorTickLines(size: 0)),
    //       series: [AreaSeries<_ChartData, String>(
    //     dataSource: liveTrade.data.map((data)=>
    //         AreaSeries<_ChartData, String>(
    //             dataSource: data,
    //             xValueMapper: (_ChartData data, _) => data.x,
    //             yValueMapper: (_ChartData data, _) => data.y,
    //             name: 'Gold',
    //             color: Color.fromRGBO(8, 142, 255, 1))
    //        ).toList(),
    //     xValueMapper: (_ChartData sales, _) => sales.x as String,
    //     yValueMapper: (_ChartData sales, _) => sales.y,
    //     // name: 'Father',
    //     markerSettings: const MarkerSettings(isVisible: true))] ,
    //   //series: liveTrade.data.map((data)=> ),
    //   trackballBehavior: _trackballBehavior,
    // ),
    //);
  }

  List<StackedLineSeries<ChartSampleData, String>> _getStackedLineSeries() {
    return [
      StackedLineSeries<ChartSampleData, String>(
          dataSource: chartData,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          // name: 'Father',
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class ChartSampleData {
  ChartSampleData(
      {this.x,
        this.y,
        this.yValue,
        this.secondSeriesYValue,
        this.thirdSeriesYValue});
  final String x;
  final int y;
  final int yValue;
  final int secondSeriesYValue;
  final int thirdSeriesYValue;
}

class GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.white, BlendMode.src);
    drawYAxis(canvas, size);
    drawXAxis(canvas, size);
    drawXLabels(canvas, size);
    drawYLabels(canvas, size);
    drawLineGraph(canvas, size);

    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  void drawYAxis(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.black;
    canvas.drawLine(Offset(40, 10), Offset(40, size.height * 0.8), paint);
  }

  void drawXAxis(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.black;
    canvas.drawLine(Offset(40, size.height * 0.8),
        Offset(size.width * 0.9, size.height * 0.8), paint);
  }

  void drawXLabels(Canvas canvas, Size size, {int count = 8}) {
    Paint paint = Paint();
    paint.color = Colors.black;
    for (int i = 0; i < count; i++) {
      TextSpan span = new TextSpan(
          style: new TextStyle(color: Colors.black), text: (i + 1).toString());
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(size.width * 0.1 * (i + 1.5), size.height * 0.8));
    }
  }

  void drawYLabels(Canvas canvas, Size size, {int count = 8}) {
    Paint paint = Paint();
    paint.color = Colors.black;
    for (int i = 0; i < count; i++) {
      TextSpan span = new TextSpan(
          style: new TextStyle(color: Colors.black),
          text: (count - i).toString());
      TextPainter tp = new TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
          canvas, Offset(size.width * 0.05, size.height * 0.1 * (i + 0.5)));
    }
  }

  void drawLineGraph(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.polygon;

    var points = List.generate(10,
            (i) => Offset(size.width * 0.2 * i, size.height * 0.1 + (i * 0.2)))
        .toList();

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }
}