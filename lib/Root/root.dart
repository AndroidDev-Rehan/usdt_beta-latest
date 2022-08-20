import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/authController.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/Services/database.dart';
import 'package:usdt_beta/UI/AuthScreen/login_screen.dart';
import 'package:usdt_beta/UI/BottomNavBar/bottom_nav_bar.dart';

class Root extends StatelessWidget {
  Root({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      initState: (_) {
        Get.put<UserController>(UserController());
      },
      builder: (_) {
        if (Get.find<UserController>().users != null) {
          return BottomNavBar();
        } else
          return LoginPage();
      },
    );
  }
}
