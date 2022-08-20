import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CountDown {
  final Timestamp startAt;
  final Timestamp endAt;
  final int seconds;
  final num profit;
  final String commodityType;

  CountDown({
    @required this.startAt,
    @required this.endAt,
    @required this.seconds,
    @required this.profit,
    @required this.commodityType,
  });
}
