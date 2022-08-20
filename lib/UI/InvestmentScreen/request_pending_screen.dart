import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/UI/BottomNavBar/bottom_nav_bar.dart';
import 'package:usdt_beta/UI/home_screem/home_screen.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';

import '../../style/color.dart';

class RequestPendingScreen extends StatelessWidget {
  const RequestPendingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Your Deposit Request is submitted and pending for admin approval.", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
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
