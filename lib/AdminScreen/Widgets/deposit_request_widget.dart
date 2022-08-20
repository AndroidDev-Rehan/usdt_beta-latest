import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:usdt_beta/AdminScreen/all_deposit_requests_page.dart';
import 'package:usdt_beta/AdminScreen/pdf_view.dart';
import 'package:usdt_beta/AdminScreen/webview_screen.dart';
import 'package:usdt_beta/Model/user_model.dart';
import 'package:usdt_beta/Services/database.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';

import '../../Model/deposit_request_model.dart';
import '../../sizeConfig.dart';

class DepositRequestWidget extends StatefulWidget {
  final DepositRequest depositRequest;
  final int index;
  DepositRequestWidget({this.depositRequest, this.index});

  @override
  State<DepositRequestWidget> createState() => _DepositRequestWidgetState();
}

class _DepositRequestWidgetState extends State<DepositRequestWidget> {
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
              Text(widget.depositRequest.userName),
              subtitle:
              Text(widget.depositRequest.userMail),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Deposit Request'),
                  Text(
                    '\$ ${widget.depositRequest.amount.toString()}',
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
                  Get.snackbar("Success", "Deposit Request Accepted",snackPosition: SnackPosition.BOTTOM);
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
                  Get.snackbar("Success", "Deposit Request Rejected",snackPosition: SnackPosition.BOTTOM);
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
        AuthButton(label: "View Document", onTap: (){
         Get.to(()=>PdfViewScreen(link: widget.depositRequest.documentLink,));
        },)
      ],
    );
  }

  Future<bool> removeAndAccept() async{
    try {

      final UserModel user = await MyDatabase().getUser(widget.depositRequest.userId);
      final double newAmount  = user.investmentAmount  + widget.depositRequest.amount;

      await FirebaseFirestore.instance.collection("user").doc(
          widget.depositRequest.userId).update({
        "investmentAmount" : newAmount
      });
      await FirebaseFirestore.instance.collection("DepositRequests").doc(
          widget.depositRequest.depositId).delete();
      depositsList.removeWhere((deposit) => widget.depositRequest.depositId == deposit.depositId);
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

      final doc = await FirebaseFirestore.instance.collection("DepositRequests").doc(
          widget.depositRequest.depositId).get();
      if(doc.exists)
        {
          log("DOC EXIST MA****");
        }
      else{
        log("DOC Does not exist MA****");
      }

      await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
        myTransaction.delete(FirebaseFirestore.instance.collection("DepositRequests").doc(widget.depositRequest.depositId));
      });
      log("deposit id is ${widget.depositRequest.depositId}");
      depositsList.removeWhere((deposit) => widget.depositRequest.depositId == deposit.depositId);
      return true;
    }
    catch(e){
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }
}
