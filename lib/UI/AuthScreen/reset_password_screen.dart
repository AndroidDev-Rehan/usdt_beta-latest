import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/UI/VerificationPage/verification_page.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:usdt_beta/Widgets/input_fields.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: SizeConfig.screenHeight * 0.44,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/reset.png'),
              Text('Please enter a valid Email to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold)),
              InputField(
                  hint: 'Email',
                  labelText: 'Email',
                  controller: userController.resetPasswordController),
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              Container(
                width: SizeConfig.screenWidth * 0.78,
                child: AuthButton(
                  label: 'Reset Password',
                  onTap: () {
                    userController.resetPassword(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
