import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:usdt_beta/UI/DepositWithDrawScreen/DWWidgets/withdraw_widget.dart';
import 'package:usdt_beta/UI/DepositWithDrawScreen/bank_withdraw_screen.dart';
import 'package:usdt_beta/UI/DepositWithDrawScreen/jazzcash_withdraw.dart';
import 'package:usdt_beta/UI/InvestmentScreen/insvestment_screen.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class ChooseOptionScreen extends StatefulWidget {
  const ChooseOptionScreen({Key key}) : super(key: key);

  @override
  State<ChooseOptionScreen> createState() => _ChooseOptionScreenState();
}

class _ChooseOptionScreenState extends State<ChooseOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Choose Withdraw Option", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20,),
            AuthButton(
              label: 'Bank',
              onTap: () {
                Get.to(BankWithdrawScreen());
              },
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            AuthButton(
              label: 'JazzCash',
              onTap: () {
                Get.to(NonBankWithdrawScreen("JazzCash".toLowerCase()));
//                Get.to(WithDrawWidget());
              },
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            AuthButton(
              label: 'Skype',
              onTap: () {
                Get.to(NonBankWithdrawScreen("Skype".toLowerCase()));
//                Get.to(WithDrawWidget());
              },
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            AuthButton(
              label: 'Skrill',
              onTap: () {
                Get.to(NonBankWithdrawScreen("Skrill".toLowerCase()));
//                Get.to(WithDrawWidget());
              },
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.01),
            AuthButton(
              label: 'Vault Address',
              onTap: () {
                Get.to(NonBankWithdrawScreen("Vault Address".toLowerCase()));
//                Get.to(WithDrawWidget());
              },
            )

          ],
        ),
      ),
    );
  }
}
