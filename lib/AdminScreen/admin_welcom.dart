import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/AdminScreen/admin_main_screen.dart';
import 'package:usdt_beta/Controller/admin_controller.dart';
import 'package:usdt_beta/Controller/all_user_controller.dart';
import 'package:usdt_beta/Controller/referal_controller.dart';
import 'package:usdt_beta/sizeConfig.dart';

class AdminWelcome extends StatefulWidget {
  const AdminWelcome({Key key}) : super(key: key);

  @override
  _AdminWelcomeState createState() => _AdminWelcomeState();
}

class _AdminWelcomeState extends State<AdminWelcome> {
  @override
  void initState() {
    //Get.put(AdminController());
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return AdminMain();
      }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/admin.png'),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
          ),
          Text(
            'Welcome Admin',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.02,
          ),
          CircularProgressIndicator()
        ],
      )),
    );
  }
}
