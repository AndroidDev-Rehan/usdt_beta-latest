import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ManualTradeModel{
  Timestamp timestamp;
  String type;
  String uid;
  int amount;

  ManualTradeModel({
    @required
    this.timestamp,
    @required
    this.type,
    @required
  this.uid,
    @required this.amount
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': this.timestamp,
      'type': this.type,
      'uid': this.uid,
      "amount" : this.amount,
    };
  }

  factory ManualTradeModel.fromMap(Map<String, dynamic> map) {
    return ManualTradeModel(
      timestamp: map['timestamp'] as Timestamp,
      type: map['type'] as String,
      uid: map["uid"] as String,
      amount: map["amount"] as int
    );
  }
}
