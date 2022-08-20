import 'package:flutter/material.dart';

class TradeModel{
  final String uid;
  final String commodityType;
  final double tradeAmount;

  TradeModel({@required this.uid,@required this.commodityType, this.tradeAmount});
}