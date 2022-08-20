import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class RegularCard extends StatelessWidget {
  RegularCard({
    Key key,
    this.randomNumber,
    this.title,
    this.onTap,
    this.color,
  }) : super(key: key);
  final double randomNumber;
  final String title;
  final Function onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
      child: Card(
        elevation: 6,
        shadowColor: Colors.grey.shade500,
        color: bgColorLight.withOpacity(0.8),
        child: Container(
            height: SizeConfig.screenHeight * 0.07,
            width: SizeConfig.screenWidth * 0.95,
            child: Row(
              children: [
                SizedBox(width: SizeConfig.screenWidth * 0.02),
                Container(
                  height: SizeConfig.screenHeight * 0.04,
                  width: SizeConfig.screenWidth * 0.30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: color.withOpacity(0.6)),
                  child: Center(
                      child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white, fontSize: SizeConfig.defaultSize),
                  )),
                ),
                Spacer(),
                Text(randomNumber > 0.5 ? '+' : '-',
                    style: TextStyle(
                        color: randomNumber > 0.5 ? Colors.green : Colors.red,
                        fontSize: 17)),
                Text('${randomNumber.toStringAsFixed(9)}',
                    style: TextStyle(
                        color: randomNumber > 0.5 ? Colors.green : Colors.red,
                        fontSize: SizeConfig.defaultSize)),
                Spacer(),
                RaisedButton(
                  padding: EdgeInsets.zero,
                  onPressed: onTap,
                  color: bgColor,
                  child: Text('Trade Now',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                )
              ],
            )),
      ),
    );
  }
}
