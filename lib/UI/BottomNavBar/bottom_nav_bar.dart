import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/admin_controller.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/UI/DepositWithDrawScreen/deposit_withDraw_screen.dart';
import 'package:usdt_beta/UI/HelpScreen/help_screen.dart';
import 'package:usdt_beta/UI/ProfileScreen/profile_screen.dart';
import 'package:usdt_beta/UI/ReferalScreen/referal_screen.dart';
import 'package:usdt_beta/UI/home_screem/home_screen.dart';
import 'package:usdt_beta/style/color.dart';

class BottomNavBar extends StatefulWidget {
  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  var currentIndex = 0;
  final adminController = Get.put(AdminController());
  @override
  void initState() {
    Get.put(UserController());
    //adminController.getVariable();
    // print('called');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20),
        height: size.width * .140,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .024),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(
                () {
                  currentIndex = index;
                },
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: index == currentIndex ? 0 : size.width * .026,
                    right: size.width * .0286,
                    top: size.height * .0030,
                    left: size.width * .0286,
                  ),
                  width: size.width * .113,
                  height: index == currentIndex ? size.width * .014 : 0,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                Icon(
                  listOfIcons[index],
                  size: size.width * .076,
                  color: index == currentIndex ? bgColor : Colors.black38,
                ),
                SizedBox(height: size.width * .03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.wallet_travel,
    Icons.groups_sharp,
    Icons.help,
    Icons.person_rounded,
  ];
  List<Widget> pages = [
    HomeScreen(),
    DepositWithDrawScreen(),
    ReferalScreen(),
    HelpScreen(),
    ProfilePage()
  ];
}
