import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/admin_controller.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class CurrencyCard extends StatelessWidget {
  CurrencyCard(
      {Key key, this.image, this.title, this.value, this.onTap, this.color})
      : super(key: key);
  final String image;
  final String title;
  final double value;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shadowColor: Colors.grey.shade500,
      color: bgColorLight.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        // height: SizeConfig.screenHeight * 0.28,
        width: SizeConfig.screenWidth * 0.46,
        //color: Colors.red,
        decoration: BoxDecoration(
            color: bgColorLight.withOpacity(0.8),
            borderRadius: BorderRadius.circular(6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.01,
            ),
            Container(
              height: SizeConfig.screenHeight * 0.13,
              width: SizeConfig.screenWidth * 0.40,
              // padding: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${value?.toStringAsFixed(6)}',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  Text(
                    'ID change',
                    style: TextStyle(color: Colors.green, fontSize: 13),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            // Spacer(),
            Container(
              height: SizeConfig.screenHeight * 0.04,
              width: SizeConfig.screenWidth * 0.40,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: color,
                onPressed: () {
                  log("ON TAP PRESSED");
                  onTap();
                },
                child: Text(
                  'Invest',
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
