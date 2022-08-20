import 'dart:async';

import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:get/get.dart';

class RegularTradeController extends GetxController {
  RxBool isStart = false.obs;
  // CountdownTimerController controller;
  // int endTime = DateTime.now().millisecondsSinceEpoch + 1000 *420;
  // void onEnd() {
  //   print('back');
  //   // Get.back();
  // }

  // callCountDown() {
  //   controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  // }
  RxInt seconds = 
420.obs;
  Timer timer;

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds.value--;
      if (seconds.value == 0) {
        timer.cancel();
      }
    });
  }
}
