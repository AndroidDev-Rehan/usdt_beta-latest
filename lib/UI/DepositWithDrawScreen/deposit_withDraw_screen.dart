import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:usdt_beta/UI/DepositWithDrawScreen/choose_option_screen.dart';
import 'package:usdt_beta/UI/InvestmentScreen/insvestment_screen.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class DepositWithDrawScreen extends StatefulWidget {
  const DepositWithDrawScreen({Key key}) : super(key: key);

  @override
  _DepositWithDrawScreenState createState() => _DepositWithDrawScreenState();
}

class _DepositWithDrawScreenState extends State<DepositWithDrawScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthButton(
              label: 'Deposit',
              onTap: () {
                Get.to(InvestmentScreen());
              },
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            AuthButton(
              label: 'WithDraw',
              onTap: () {
                Get.to(ChooseOptionScreen());
//                Get.to(WithDrawWidget());
              },
            )
          ],
        ),
      ),
    );
  }
}
