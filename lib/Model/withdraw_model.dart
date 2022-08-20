import 'package:flutter/material.dart';

class WithDrawModel{
  double amount;
  String paymentMethod;
  String withdrawRequestId;
  String userId;
  String userName;
  String userEmail;
  String bankName;
  String accountNo;
  String accountName;

  WithDrawModel({
     this.amount,
     this.paymentMethod,
     this.withdrawRequestId,
     this.userId,
     this.userName,
     this.userEmail,
    this.bankName,
    this.accountNo,
    this.accountName
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': this.amount,
      'paymentMethod': this.paymentMethod,
      'withdrawRequestId': this.withdrawRequestId,
      'userId': this.userId,
      'userName': this.userName,
      'userEmail': this.userEmail,
      'bankName': this.bankName,
      'accountNo': this.accountNo,
      'accountName': this.accountName,
    };
  }

  factory WithDrawModel.fromMap(Map<String, dynamic> map) {
    return WithDrawModel(
      amount: map['amount'] as double,
      paymentMethod: map['paymentMethod'] as String,
      withdrawRequestId: map['withdrawRequestId'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      userEmail: map['userEmail'] as String,
      bankName: map['bankName'] as String,
      accountNo: map['accountNo'] as String,
      accountName: map['accountName'] as String,
    );
  }
}