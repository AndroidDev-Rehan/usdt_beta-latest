import 'package:flutter/material.dart';
import 'package:usdt_beta/style/color.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Text(
          "Coming Soon ... ",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}
