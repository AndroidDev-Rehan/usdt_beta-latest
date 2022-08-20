import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/AdminScreen/copy_trade_amazon.dart';
import 'package:usdt_beta/AdminScreen/copy_trade_coinbase_global.dart';
import 'package:usdt_beta/AdminScreen/copy_trade_gold.dart';
import 'package:usdt_beta/AdminScreen/copy_trade_lite.dart';
import 'package:usdt_beta/AdminScreen/copy_trade_oil.dart';
import 'package:usdt_beta/AdminScreen/copy_trade_silver.dart';
import 'package:usdt_beta/style/color.dart';

import 'Widgets/copy_trade_card.dart';

class CopyTradeAdminHome extends StatefulWidget {
  CopyTradeAdminHome({Key key}) : super(key: key);

  @override
  _CopyTradeAdminHomeState createState() => _CopyTradeAdminHomeState();
}

class _CopyTradeAdminHomeState extends State<CopyTradeAdminHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: bgColor,
          title: Text('Copy Trade'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Wrap(
          direction: Axis.horizontal,
          children: [
            CurrencyCard(
              color: Colors.grey,
              onTap: () {
                Get.to(CopyTradeCoinbase());
              },
              image: 'assets/images/coinbase.jpg',
              title: 'Coinbase Global Inc.',
            ),
            CurrencyCard(
              color: Colors.grey,
              onTap: () {
                Get.to(CopyTradeAmazon());
              },
              image: 'assets/images/amazon.jpg',
              title: 'Amazon.com, Inc.',
            ),
            CurrencyCard(
              color: Colors.grey,
              onTap: () {
                Get.to(CopyTradeLite());
              },
              image: 'assets/images/litecoin.jpeg',
              title: 'Lite Coin',
            ),
            CurrencyCard(
              color: Colors.grey,
              onTap: () {
                Get.to(CopyTradeGold());
              },
              image: 'assets/images/gold.jpeg',
              title: 'Gold',
            ),
            CurrencyCard(
              color: Colors.grey,
              onTap: () {
                Get.to(CopyTradeSilver());
              },
              image: 'assets/images/silver.jpeg',
              title: 'Silver',
            ),
            CurrencyCard(
              color: Colors.grey,
              onTap: () {
                Get.to(CopyTradeOil());
              },
              image: 'assets/images/crudeoil.jpeg',
              title: 'Crude Oil WTI',
            )
          ],
        )));
  }
}
