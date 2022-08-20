import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/UI/Manual_Trade/ManualTSNew.dart';
import 'package:usdt_beta/UI/Manual_Trade/bit_up_down.dart';
import 'package:usdt_beta/UI/home_screem/home_widgets/currency_card.dart';
import 'package:usdt_beta/sizeConfig.dart';
import '../home_screen.dart';


class ManualTradeRow extends StatelessWidget {
  const ManualTradeRow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Text('Manual Trading',
        //       style: TextStyle(
        //           fontSize: 28,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.white)),
        // ),
        Flexible(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                        width: SizeConfig.screenWidth * 0.03),
                    CurrencyCard(
                      color: Colors.red,
                      onTap: () {
                        Get.to(ManualTSNew("coinbase"));
//                        Get.to(BitUpDownScreen("coinbase"));
                      },
                      image: 'assets/images/coinbase.jpg',
                      title: 'Coinbase Global Inc.',
                      value: random4,
                    ),
                    SizedBox(
                        width: SizeConfig.screenWidth * 0.03),
                    CurrencyCard(
                      color: Colors.red,
                      onTap: () {
                        Get.to(ManualTSNew("amazon"));
                      },
                      image: 'assets/images/amazon.jpg',
                      title: 'Amazon.com, Inc.',
                      value: random4,
                    ),
                    SizedBox(
                        width: SizeConfig.screenWidth * 0.03),
                    CurrencyCard(
                      color: Colors.red,
                      onTap: () {
                        Get.to(ManualTSNew("litecoin"));
                      },
                      image: 'assets/images/litecoin.jpeg',
                      title: 'Lite Coin',
                      value: random4,
                    ),
                    SizedBox(
                        width: SizeConfig.screenWidth * 0.03),
                    CurrencyCard(
                      color: Colors.red,
                      onTap: () {
                      },
                      image: 'assets/images/coinbase.jpg',
                      title: 'Coinbase Global Inc.',
                      value: random4,
                    ),
                    SizedBox(
                        width: SizeConfig.screenWidth * 0.03),
                    CurrencyCard(
                      color: Colors.red,
                      onTap: () {
                        Get.to(ManualTSNew("gold"));
                      },
                      image: 'assets/images/gold.jpeg',
                      title: 'Gold',
                      value: random4,
                    ),
                    SizedBox(
                        width: SizeConfig.screenWidth * 0.03),
                    CurrencyCard(
                      color: Colors.red,
                      onTap: () {
                        Get.to(ManualTSNew("silver"));
                      },
                      image: 'assets/images/silver.jpeg',
                      title: 'Silver',
                      value: random4,
                    ),
                    SizedBox(
                        width: SizeConfig.screenWidth * 0.03),

                    CurrencyCard(
                      color: Colors.red,
                      onTap: () {
                        Get.to(ManualTSNew("crudeoil"));
                      },
                      image: 'assets/images/crudeoil.jpeg',
                      title: 'Crude Oil WTI',
                      value: random4,
                    ),
                    SizedBox(
                        width: SizeConfig.screenWidth * 0.03),

                  ],
                )))
      ],
    );
  }
}
