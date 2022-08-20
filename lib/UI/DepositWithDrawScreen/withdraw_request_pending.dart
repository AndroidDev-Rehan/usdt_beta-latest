import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Widgets/auth_button.dart';
import '../../style/color.dart';
import '../BottomNavBar/bottom_nav_bar.dart';

class WithDrawRequestPendingScreen extends StatelessWidget {
  const WithDrawRequestPendingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Your payment withdraw Request is submitted and pending for admin approval.", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
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
