import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:k_chart/chart_translations.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:usdt_beta/Controller/admin_controller.dart';
import 'package:usdt_beta/UI/home_screem/home_widgets/copy_bottomWidget.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

import '../../../Controller/userController.dart';
import '../../../Services/database.dart';

class CopyTradeScreen extends StatefulWidget {
  CopyTradeScreen({
    Key key,
    this.color,
    this.title,
    this.rate,
    @required this.commodityType,
    @required this.endTime,
  }) : super(key: key);
  final Color color;
  final String title;
  final double rate;
  final String commodityType;
  int endTime;

  @override
  _CopyTradeScreenState createState() => _CopyTradeScreenState();
}

class _CopyTradeScreenState extends State<CopyTradeScreen> {
  CountdownTimerController controller;
  final adminController = Get.put(AdminController());
  final userController = Get.put(UserController());

  final int maxTime = 
420;
  RxInt seconds = 
420.obs;

  int cancelTime;

  void onEnd() {
    print('back');
    // Get.back();
  }

  //syncfusion graph

  @override
  void initState() {
    super.initState();

    widget.endTime =
        DateTime.now().millisecondsSinceEpoch + 1000 * widget.endTime;

    // getData('1min');
    userController.getUser();

    rootBundle.loadString('assets/depth.json').then((result) {
      final parseJson = json.decode(result);
      final tick = parseJson['tick'] as Map<String, dynamic>;
      final List<DepthEntity> bids = (tick['bids'] as List<dynamic>)
          .map<DepthEntity>(
              (item) => DepthEntity(item[0] as double, item[1] as double))
          .toList();
      final List<DepthEntity> asks = (tick['asks'] as List<dynamic>)
          .map<DepthEntity>(
              (item) => DepthEntity(item[0] as double, item[1] as double))
          .toList();
      initDepth(bids, asks);
    });
  }

  void initDepth(List<DepthEntity> bids, List<DepthEntity> asks) {
    if (bids == null || asks == null || bids.isEmpty || asks.isEmpty) return;
    _bids = [];
    _asks = [];
    double amount = 0.0;
    bids.sort((left, right) => left.price.compareTo(right.price));

    bids.reversed.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      _bids.insert(0, item);
    });

    amount = 0.0;
    asks.sort((left, right) => left.price.compareTo(right.price));

    asks.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      _asks.add(item);
    });
    setState(() {});
  }

  List<KLineEntity> datas;

  // bool showLoading = true;
  MainState _mainState = MainState.MA;
  bool _volHidden = false;
  SecondaryState _secondaryState = SecondaryState.MACD;
  bool isLine = true;
  bool isChinese = true;
  bool _hideGrid = false;
  bool _showNowPrice = true;
  List<DepthEntity> _bids, _asks;
  bool isChangeUI = false;
  bool _isTrendLine = false;

  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CountdownTimer(
                endTime: widget.endTime,
                widgetBuilder: (_, CurrentRemainingTime time) {
                  if (time == null) {
                    // MyDatabase().getRegularTradeWinnder();
                    MyDatabase().updateValues(widget.commodityType, false);
                    Fluttertoast.showToast(
                        msg: 'Your time is up', toastLength: Toast.LENGTH_LONG);

                    MyDatabase().getCopyTradeWinner(
                        userController.user.uid, widget.commodityType, true);
                    // controller.dispose();
                    Get.back();
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
        backgroundColor: bgColor,
        bottomSheet: CopyTradeBottomWidget(
          rate: widget.rate,
          commodityType: widget.commodityType,
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Stack(children: <Widget>[
              Container(
                height: SizeConfig.screenHeight * 0.5,
                width: double.infinity,
                child: StreamBuilder<http.Response>(
                    stream: getStreamChartDataFromInternet('1min'),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        datas = solveChatData(snapshot.data.body);
                        return KChartWidget(
                          datas,
                          chartStyle,
                          chartColors,
                          isLine: isLine,
                          onSecondaryTap: () {
                            print('Secondary Tap');
                          },
                          isTrendLine: _isTrendLine,
                          mainState: _mainState,
                          volHidden: _volHidden,
                          secondaryState: _secondaryState,
                          fixedLength: 2,
                          timeFormat: TimeFormat.YEAR_MONTH_DAY,
                          translations: kChartTranslations,
                          showNowPrice: _showNowPrice,
                          //`isChinese` is Deprecated, Use `translations` instead.
                          isChinese: isChinese,
                          hideGrid: _hideGrid,
                          isTapShowInfoDialog: false,
                          maDayList: [1, 100, 1000],
                        );
                      } else {
                        return Container(
                            width: double.infinity,
                            height: 450,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator());
                      }
                    }),
              ),
              // if (showLoading)
              //   Container(
              //       width: double.infinity,
              //       height: 450,
              //       alignment: Alignment.center,
              //       child: const CircularProgressIndicator()),
            ]),
            //  buildButtons(),
            if (_bids != null && _asks != null)
              Container(
                height: 230,
                width: double.infinity,
                child: DepthChart(_bids, _asks, chartColors),
              )
          ],
        ));
  }

  Widget buildButtons() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: <Widget>[
        button("Time Mode", onPressed: () => isLine = true),
        button("K Line Mode", onPressed: () => isLine = false),
        button("TrendLine", onPressed: () => _isTrendLine = !_isTrendLine),
        button("Line:MA", onPressed: () => _mainState = MainState.MA),
        button("Line:BOLL", onPressed: () => _mainState = MainState.BOLL),
        button("Hide Line", onPressed: () => _mainState = MainState.NONE),
        button("Secondary Chart:MACD",
            onPressed: () => _secondaryState = SecondaryState.MACD),
        button("Secondary Chart:KDJ",
            onPressed: () => _secondaryState = SecondaryState.KDJ),
        button("Secondary Chart:RSI",
            onPressed: () => _secondaryState = SecondaryState.RSI),
        button("Secondary Chart:WR",
            onPressed: () => _secondaryState = SecondaryState.WR),
        button("Secondary Chart:CCI",
            onPressed: () => _secondaryState = SecondaryState.CCI),
        button("Secondary Chart:Hide",
            onPressed: () => _secondaryState = SecondaryState.NONE),
        button(_volHidden ? "Show Vol" : "Hide Vol",
            onPressed: () => _volHidden = !_volHidden),
        button("Change Language", onPressed: () => isChinese = !isChinese),
        button(_hideGrid ? "Show Grid" : "Hide Grid",
            onPressed: () => _hideGrid = !_hideGrid),
        button(_showNowPrice ? "Hide Now Price" : "Show Now Price",
            onPressed: () => _showNowPrice = !_showNowPrice),
        button("Customize UI", onPressed: () {
          setState(() {
            this.isChangeUI = !this.isChangeUI;
            if (this.isChangeUI) {
              chartColors.selectBorderColor = Colors.red;
              chartColors.selectFillColor = Colors.red;
              chartColors.lineFillColor = Colors.red;
              chartColors.kLineColor = Colors.yellow;
            } else {
              chartColors.selectBorderColor = Color(0xff6C7A86);
              chartColors.selectFillColor = Color(0xff0D1722);
              chartColors.lineFillColor = Color(0x554C86CD);
              chartColors.kLineColor = Color(0xff4C86CD);
            }
          });
        }),
      ],
    );
  }

  Widget button(String text, {VoidCallback onPressed}) {
    return TextButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
          setState(() {});
        }
      },
      child: Text(text),
      style: TextButton.styleFrom(
        primary: Colors.white,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void getData(String period) {
    /*
     */
    final Future<String> future = getChatDataFromInternet(period);
    // final Future<String> future = getChatDataFromJson();
    future.then((String result) {
      solveChatData(result);
    }).catchError((_) {
      // showLoading = false;
      setState(() {});
      print('### datas error $_');
    });
  }

  Future<String> getChatDataFromInternet(String period) async {
    var url =
        'https://api.huobi.br.com/market/history/kline?period=${period ?? '1min'}&size=300&symbol=btcusdt';
    String result;
    final response = await http.get(Uri.parse(url));
    // http.StreamedResponse streamedResponse = (await http.get(Uri.parse(url))) as http.StreamedResponse;
    // streamedResponse.stream.listen((value) {
    //   print(value.toString());
    // });
    if (response.statusCode == 200) {
      result = response.body;
    } else {
      print('Failed getting IP address');
    }
    return result;
  }

  Stream<http.Response> getStreamChartDataFromInternet(String period) async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return http.get((Uri.parse(
          'https://api.huobi.br.com/market/history/kline?period=${period ?? '1min'}&size=300&symbol=btcusdt')));
    }).asyncMap((event) async => await event);
  }

  // Stream<http.Response> getStreamChartDataFromInternet(String period) async* {
  //   yield* Stream.periodic(Duration(minutes: 1), (_) {
  //     return http.get((Uri.parse(
  //         'https://api.huobi.br.com/market/history/kline?period=${period ?? '1min'}&size=300&symbol=btcusdt')));
  //   }).asyncMap((event) async => await event);
  // }

  Future<String> getChatDataFromJson() async {
    return rootBundle.loadString('assets/chatData.json');
  }

  List<KLineEntity> solveChatData(String result) {
    final Map parseJson = json.decode(result) as Map<dynamic, dynamic>;
    final list = parseJson['data'] as List<dynamic>;
    datas = list
        .map((item) => KLineEntity.fromJson(item as Map<String, dynamic>))
        .toList()
        .reversed
        .toList()
        .cast<KLineEntity>()
        .obs;

    DataUtil.calculate(datas);
    // showLoading = false;
    // setState(() {});
    return datas;
  }
}