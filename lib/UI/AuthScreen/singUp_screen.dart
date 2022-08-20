import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/UI/AuthScreen/login_screen.dart';
import 'package:usdt_beta/UI/VerificationPage/verification_page.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:usdt_beta/Widgets/input_fields.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final userController = Get.put(UserController());

  bool isLoading = false;
  GlobalKey _formKey = GlobalKey<FormState>();
  _buildInputForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputField(
            controller: userController.nameController,
            hint: "Name",
            labelText: 'Name',
          ),
          SizedBox(
            height: 10.0,
          ),
          InputField(
            controller: userController.emailController,
            hint: "Email",
            labelText: 'Email',
          ),
          SizedBox(
            height: 10.0,
          ),
          InputField(
            controller: userController.idController,
            hint: "Referal Id",
            labelText: 'Referal Id',
          ),
          SizedBox(
            height: 10.0,
          ),
          // InputField(
          //   controller: emailController,
          //   hint: "Account",
          // ),
          // SizedBox(
          //   height: 10.0,
          // ),
          InputField(
            controller: userController.passwordController,
            hint: "Password",
            labelText: 'Password',
            isPassField: true,
          ),
          SizedBox(
            height: 10.0,
          ),
          InputField(
            controller: userController.confirmPasswordController,
            hint: "Confirm Password",
            labelText: 'Confirm Password',
            isPassField: true,
          )
        ],
      ),
    );
  }

  _validateSignupCredentials() {
    if (userController.emailController.text.isNotEmpty &&
        userController.passwordController.text.isNotEmpty &&
        userController.confirmPasswordController.text.isNotEmpty) {
      if (userController.passwordController.text !=
          userController.confirmPasswordController.text) {
        mySnackbar(
            title: "Password Not Match", message: "Password are not matching!");
      } else {
        mySnackbar(title: "Successfully Signup", message: "Now you can login.");
        setState(() {
          isLoading = true;
        });
        userController.signUp();

        Timer(const Duration(milliseconds: 1000), () {
          isLoading = false;
          Get.off(VerificationPage());
        });
      }
    } else {
      mySnackbar(title: "Required!", message: "All Fields are required.");
    }
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
              Text("Sign-Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.screenHeight * 0.055,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              _buildInputForm(),
              SizedBox(height: 20.0),

              Container(
                width: SizeConfig.screenWidth * 0.78,
                child: AuthButton(
                  label: "Sign-Up",
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _validateSignupCredentials();
                    //Get.off(LoginPage());
                  },
                  isLoading: isLoading,
                ),
              ),
              SizedBox(height: 16.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Already a member? ",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600)),
                GestureDetector(
                  onTap: () {
                    Get.off(LoginPage());
                  },
                  child: Text("LOGIN",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ]),
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
