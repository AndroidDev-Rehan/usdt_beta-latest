import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/AdminScreen/withdrawController.dart';
import 'package:usdt_beta/AdminScreen/withdraw_details_screen.dart';
import 'package:usdt_beta/Model/user_model.dart';
import 'package:usdt_beta/Model/withdraw_model.dart';
import 'package:usdt_beta/Services/database.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import '../../sizeConfig.dart';

class WithDrawRequestWidget extends StatefulWidget {
  final WithDrawModel withDrawRequest;
  const WithDrawRequestWidget({Key key, this.withDrawRequest}) : super(key: key);

  @override
  State<WithDrawRequestWidget> createState() => _WithDrawRequestWidgetState();
}

class _WithDrawRequestWidgetState extends State<WithDrawRequestWidget> {
  // List<DepositRequest> list;

  bool loading = false;
  bool removed = false;

  @override
  Widget build(BuildContext context) {
    return
      removed ? SizedBox(height: 0,) : loading ? SizedBox(height: 200,child: Center(child: CircularProgressIndicator(),),) : Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/man.png'),
                ),
                title:
                Text(widget.withDrawRequest.userName),
                subtitle:
                Text(widget.withDrawRequest.userEmail),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Amount'),
                    Text(
                      '\$ ${widget.withDrawRequest.amount.toString()}',
                      style:
                      TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // onTap: () {
                // },

              ),
              buttonsRow(),
            ],
          )

      );
  }

  buttonsRow(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: SizeConfig.screenWidth * 0.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AuthButton(label: "Accept", color: Colors.green, width: SizeConfig.screenWidth * 0.44, onTap: () async{
                setState(() {
                  loading = true;
                  removed = false;
                });
                bool status = await removeAndAccept();
                if(status){
                  setState(() {
                    loading = false;
                    removed = true;
                  });
                  Get.snackbar("Success", "Withdraw Request Accepted",snackPosition: SnackPosition.BOTTOM);
                }
                else{
                  setState(() {
                    loading = false;
                    removed = false;
                  });
                }
              },),
              AuthButton(label: "Reject", color: Colors.red, width: SizeConfig.screenWidth * 0.44, onTap: () async{
                setState(() {
                  loading = true;
                  removed = false;
                });
                bool status = await removeAndReject();
                if(status){
                  setState(() {
                    loading = false;
                    removed = true;
                  });
                  Get.snackbar("Success", "Withdraw Request Rejected",snackPosition: SnackPosition.BOTTOM);
                }
                else{
                  setState(() {
                    loading = false;
                    removed = false;
                  });
                }
              },)
            ],
          ),
        ),
        SizedBox(height: 10,),
        AuthButton(label: "View Details", onTap: (){
          Get.to(()=>WithdrawalBankDetailsScreen(withDrawModel: widget.withDrawRequest,));
        },)
      ],
    );
  }

  Future<bool> removeAndAccept() async{
    try {

      final UserModel user = await MyDatabase().getUser(widget.withDrawRequest.userId);
      final double newAmount  = user.investmentAmount  - widget.withDrawRequest.amount;

      await FirebaseFirestore.instance.collection("user").doc(
          widget.withDrawRequest.userId).update({
        "investmentAmount" : newAmount
      });
      await FirebaseFirestore.instance.collection("WithdrawRequests").doc(
          widget.withDrawRequest.withdrawRequestId).delete();
      WithdrawController.list.removeWhere((withdrawModel) => widget.withDrawRequest.withdrawRequestId == withdrawModel.withdrawRequestId);
      return true;
    }
    catch(e){
      Get.snackbar("Error", e.toString());
      return false;
    }

  }

  Future<bool> removeAndReject() async{
    try {
      // await FirebaseFirestore.instance.collection("DepositRequests").doc(
      //     widget.depositRequest.depositId).delete();

      final doc = await FirebaseFirestore.instance.collection("WithdrawRequests").doc(
          widget.withDrawRequest.withdrawRequestId).get();
      if(doc.exists)
      {
        log("DOC EXIST MA****");
      }
      else{
        log("DOC Does not exist MA****");
      }

      await FirebaseFirestore.instance.collection("WithdrawRequests").doc(
          widget.withDrawRequest.withdrawRequestId).delete();
      WithdrawController.list.removeWhere((withdrawModel) => widget.withDrawRequest.withdrawRequestId == withdrawModel.withdrawRequestId);
      return true;
    }
    catch(e){
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
