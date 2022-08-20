import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Model/referal_model.dart';
import '../../../Model/referance_model.dart';

class RefWidget extends StatelessWidget {
  const RefWidget({
    Key key,
    this.refModel,
    this.oldRefModel
  }) : super(key: key);
  final ReferanceModel refModel;
  final ReferalModel oldRefModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading:
        // Obx(() =>
        CircleAvatar(
          radius: 45,
          backgroundImage:
          // refModel.userImage.value != ""
          //     ? NetworkImage(refModel.userImage.value) :
          AssetImage('assets/images/man.png'),
        ),
        // ),
        title:
        // Obx(() =>
        Text(refModel.userName,
            style: TextStyle(color: Colors.white, fontSize: 18)),
        // ),
        trailing:
        // Obx(() =>
        Text(
            'Investment : \$${refModel.value}',
            style: TextStyle(color: Colors.white, fontSize: 18))
      // ),
    );
  }
}