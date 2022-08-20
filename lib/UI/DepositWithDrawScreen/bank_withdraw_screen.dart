import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/Model/withdraw_model.dart';
import 'package:usdt_beta/UI/DepositWithDrawScreen/withdraw_request_pending.dart';
import '../../Widgets/auth_button.dart';
import '../../Widgets/input_fields.dart';
import '../../sizeConfig.dart';
import '../../style/color.dart';

class BankWithdrawScreen extends StatefulWidget {
  @override
  State<BankWithdrawScreen> createState() => _BankWithdrawScreenState();
}

class _BankWithdrawScreenState extends State<BankWithdrawScreen> {
  TextEditingController wAccNameController = new TextEditingController();

  TextEditingController wACCNoController = new TextEditingController();

  TextEditingController wAmountController = new TextEditingController();

  TextEditingController wBankName = new TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;

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
                    InputField(
                        labelText: 'Bank Name',
                        hint: 'Bank Name',
                        controller: wBankName),
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
            paymentMethod: "bank",
            withdrawRequestId: "${userController.user.uid} $timeStamp",
        bankName: wBankName.text,
        accountNo: wACCNoController.text,
        accountName: wAccNameController.text
          ).toMap());
      return true;
    } catch (e) {
      Get.snackbar("Request Failed", e.toString());
      return false;
    }
  }
}
