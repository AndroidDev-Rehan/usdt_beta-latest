import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:usdt_beta/UI/DepositWithDrawScreen/withdraw_request_pending.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

import '../../Controller/userController.dart';
import '../../Model/withdraw_model.dart';
import '../../Widgets/input_fields.dart';

class NonBankWithdrawScreen extends StatefulWidget {
  final String paymentMethod;
  const NonBankWithdrawScreen(this.paymentMethod,{Key key,}) : super(key: key);

  @override
  State<NonBankWithdrawScreen> createState() => _NonBankWithdrawScreenState();
}

class _NonBankWithdrawScreenState extends State<NonBankWithdrawScreen> {
  TextEditingController wAccNameController = new TextEditingController();

  TextEditingController wACCNoController = new TextEditingController();

  TextEditingController wAmountController = new TextEditingController();

  // TextEditingController wBankName = new TextEditingController();

  bool loading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColorLight,
        title: Text('WithDraw'),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/atm.png',
                      height: 200,
                    ),
                    InputField(
                        labelText: 'Account Name',
                        hint: 'Name',
                        controller: wAccNameController),
                    InputField(
                        labelText: 'Account No',
                        hint: 'Account No',
                        controller: wACCNoController),
                    InputField(
                      labelText: 'Amount',
                      hint: 'Amount',
                      controller: wAmountController,
                      textInputType: TextInputType.number,
                    ),
                    // InputField(
                    //     labelText: 'Bank Name',
                    //     hint: 'Bank Name',
                    //     controller: wBankName),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AuthButton(
                        label: 'Submit',
                        onTap: () async {
                          UserController userController = Get.find();
                          if (formKey.currentState.validate()) {
                            if (userController.user.investmentAmount
                                .isGreaterThan(
                                double.parse(wAmountController.text))) {
                              setState(() {
                                loading = true;
                              });
                              bool success = await sendwithDrawRequest();
                              if (success) {
                                Get.off(() => WithDrawRequestPendingScreen());
                                loading = false;
                              } else {
                                setState(() {
                                  loading = false;
                                });
                              }
                            } else {
                              // showDialog(
                              //     context: context,
                              //     builder: (context){
                              //       return Dialog(
                              //         child: Column(
                              //           mainAxisSize: MainAxisSize.min,
                              //           children: [
                              //             Text("Not Enough Balance!")
                              //           ],
                              //         ),);
                              // });
                              Get.snackbar("Request Failed",
                                  "Not enough balance in account");
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future<bool> sendwithDrawRequest() async {
    UserController userController = Get.find();
    final String timeStamp = DateTime.now().toString();
    log("user id is ${userController.user.uid}");
    try {
      await FirebaseFirestore.instance
          .collection("WithdrawRequests")
          .doc("${userController.user.uid} $timeStamp")
          .set(WithDrawModel(
            userName: userController.user.name,
            userId: userController.user.uid,
            userEmail: userController.user.email,
            amount: double.parse(wAmountController.text),
            paymentMethod: widget.paymentMethod,
            withdrawRequestId: "${userController.user.uid} $timeStamp",
        accountName: wAccNameController.text,
        accountNo: wACCNoController.text,
        bankName: null
          ).toMap());
      return true;
    } catch (e) {
      Get.snackbar("Request Failed", e.toString());
      return false;
    }
  }


}
