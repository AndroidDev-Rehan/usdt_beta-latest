import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/admin_controller.dart';
import 'package:usdt_beta/Root/root.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // Get.put(AdminController());
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Root();
      }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
        ),
        padding: EdgeInsets.symmetric(
            vertical: 0.03 * SizeConfig.screenHeight,
            horizontal: 0.06 * SizeConfig.screenWidth),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "USDTBETA",
              style: TextStyle(
                  fontSize: 0.05 * SizeConfig.screenHeight,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Developed by ..",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 0.014 * SizeConfig.screenHeight,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
                color: Colors.grey[100],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
