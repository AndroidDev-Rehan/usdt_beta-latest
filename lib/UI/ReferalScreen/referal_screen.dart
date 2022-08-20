import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/UI/ReferalScreen/Widget/ref_widget.dart';
import 'package:usdt_beta/style/color.dart';

class ReferalScreen extends StatefulWidget {
  ReferalScreen({Key key}) : super(key: key);

  @override
  _ReferalScreenState createState() => _ReferalScreenState();
}

class _ReferalScreenState extends State<ReferalScreen> {
  @override
  void initState() {
    super.initState();
  }

  futureFunction() async {
    UserController userController = Get.find();
    log("print working in future function");
    print("print working in future function");
    await userController.getReferalInfo();
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        // appBar: AppBar(
        //   backgroundColor: bgColorLight,
        //   centerTitle: true,
        //   title: Text('Referals', style: TextStyle(color: Colors.white)),
        // ),
        body: FutureBuilder(
            future: futureFunction(),
            builder: (context, s) {
              if (s.connectionState == ConnectionState.done)
                return Column(
                  children: [
                    Divider(),
                    Text(
                      'Referals',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                    Divider(),
                    Expanded(
                      child: Container(
//                    height: SizeConfig.screenHeight * 0.9,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:
                                userController.referanceModelList.list.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RefWidget(
                                  refModel: userController
                                      .referanceModelList.list[index],
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                );
              else
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.brown,
                  ),
                );
            }),
      ),
    );
  }
}
