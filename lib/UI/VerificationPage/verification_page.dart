import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/UI/AuthScreen/login_screen.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:usdt_beta/sizeConfig.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key key}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  RxBool isVerifiedEmail = false.obs;
  // @override
  // void initState()
  // {
  //   isVerifiedEmail.value =FirebaseAuth.instance.currentUser.emailVerified;
  //   super.initState();
  // }
  refresh() {
    isVerifiedEmail.value = FirebaseAuth.instance.currentUser.emailVerified;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => isVerifiedEmail.value
                ? Center(
                    child: Column(
                    children: [
                      Container(
                          height: SizeConfig.screenHeight * 0.16,
                          child: Image.asset('assets/images/approve.png')),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.04,
                      ),
                      Text('Email is verified, login now',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: SizeConfig.screenHeight * 0.015),
                      AuthButton(
                        label: 'Login',
                        onTap: () {
                          Get.to(LoginPage());
                        },
                      )
                    ],
                  )
                    //Lottie.network('https://assets9.lottiefiles.com/private_files/lf30_ddneumch.json'),
                    )
                : Column(
                    children: [
                      Container(
                          height: SizeConfig.screenHeight * 0.16,
                          child: Image.asset('assets/images/clipboard.png')),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.04,
                      ),
                      Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Email not verified\nPlease check your mail box',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                              SizedBox(height: 10,),
                              Text(
                                  'Do not forget to check spam folder, if email not received.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.normal))
                            ],
                          )),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      AuthButton(
                        label: 'Refresh',
                        onTap: () {
                          refresh();
                        },
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
