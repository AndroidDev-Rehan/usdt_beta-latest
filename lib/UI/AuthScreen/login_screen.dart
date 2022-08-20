import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/AdminScreen/admin_welcom.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/UI/AuthScreen/reset_password_screen.dart';
import 'package:usdt_beta/UI/AuthScreen/singUp_screen.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:usdt_beta/Widgets/input_fields.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

mySnackbar({String title, String message}) {
  return Get.snackbar(title, message,
      backgroundColor: Colors.grey, snackPosition: SnackPosition.TOP);
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  final userController = Get.put(UserController());

  GlobalKey _formKey = GlobalKey<FormState>();

  _buildInputForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputField(
            controller: userController.loginEmailController,
            hint: "Email",
            labelText: 'Email',
          ),
          SizedBox(
            height: 10.0,
          ),
          InputField(
            labelText: 'Password',
            controller: userController.loginPasswordController,
            hint: "Password",
            isPassField: true,
          )
        ],
      ),
    );
  }

  _validateLoginCredentials() {
    if (userController.adminController.text == 'admin#1234') {
      if (userController.loginEmailController.text.isNotEmpty &&
          userController.loginPasswordController.text.isNotEmpty) {
        Get.offAll(AdminWelcome());
        userController.adminController.clear();
      } else {
        mySnackbar(title: "Required!", message: "All Fields are required.");
      }
    } else {
      if (userController.loginEmailController.text.isNotEmpty &&
          userController.loginPasswordController.text.isNotEmpty) {
        userController.login();
      } else {
        mySnackbar(title: "Required!", message: "All Fields are required.");
      }
    }
    // Get.off(OnBoardingPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
        padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.2),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.2,
                child: TextField(
                  controller: userController.adminController,
                  style: TextStyle(color: Colors.grey[800], fontSize: 17),
                  cursorColor: bgColor,
                  decoration: InputDecoration(
                      //  fillColor: Colors.white,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Text("Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.screenHeight * 0.055,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              _buildInputForm(),
              SizedBox(height: 20.0),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                  child: Center(
                    child: Text("Forgot Password?",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                  onTap: () {
                    Get.to(ResetPasswordScreen());
                  },
                ),
                SizedBox(
                  width: SizeConfig.screenHeight * 0.05,
                ),
              ]),
              SizedBox(height: 20.0),
              Container(
                width: SizeConfig.screenWidth * 0.78,
                child: AuthButton(
                  label: "Login",
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _validateLoginCredentials();
                  },
                  isLoading: false,
                ),
              ),
              SizedBox(height: 10.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Don't have an account? ",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600)),
                GestureDetector(
                  onTap: () {
                    Get.off(SignUpPage());
                  },
                  child: Text("REGISTER",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ]),
              SizedBox(height: 30.0),
              // AuthButton(
              //   label: "Continue with Facebook",
              //   onTap: () async {},
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
