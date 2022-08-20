import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/auth_button.dart';
import '../../style/color.dart';
import '../BottomNavBar/bottom_nav_bar.dart';

class ManualTradeResultScreen extends StatelessWidget {
  final String amount;
  final bool success;
  const ManualTradeResultScreen({Key key,@required this.amount,@required this.success}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text( success ? "Congratulations you won \$$amount!" : "Hard Luck, you lost \$$amount!", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: AuthButton(onTap:(){
          Get.off(()=>BottomNavBar());
        },label: "Okay"),
      ),
    );
  }
}
