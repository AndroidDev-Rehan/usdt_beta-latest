import 'package:flutter/cupertino.dart';

class DepositRequest{
  final String userId;
  final String userMail;
  final double amount;
  final String documentLink;
  final String userName;
  final String depositId;

  DepositRequest({@required this.userId, @required this.amount, @required this.documentLink, @required this.userMail, @required this.userName, @required this.depositId });

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'userMail': this.userMail,
      'amount': this.amount,
      'documentLink': this.documentLink,
      'userName': this.userName,
      'depositId': this.depositId,
    };
  }

  factory DepositRequest.fromMap(Map<String, dynamic> map) {
    return DepositRequest(
      userId: map['userId'] as String,
      userMail: map['userMail'] as String,
      amount: map['amount'] as double,
      documentLink: map['documentLink'] as String,
      userName: map['userName'] as String,
      depositId: map['depositId'] as String,
    );
  }
}