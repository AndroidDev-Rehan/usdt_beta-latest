import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LiveTradeController extends GetxController {
  IO.Socket socket = IO.io('http://doctor.aetsmsoft.com', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
    'extraHeaders': {'foo': 'bar'},
  });
  RxList<double> data = RxList.empty(growable: false);

  Timer timer;
  RxMap<String, Rx<Timer>> tradeTimer = RxMap();

  startTimer(String trade) {
    print("start timer");

    if (timer != null && timer.isActive) {
      return;
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (
420 == timer.tick) {
        timer.cancel();
        //charge client
      }
    });
    tradeTimer.addIf(true, trade, timer.obs);
  }

  getTimer(String trade) {
    return tradeTimer[trade];
  }

  @override
  void onInit() {
    socket.onConnect((data) {
      print("connected");
    });
    socket.onConnectTimeout((data) {
      print("connection timeout");
      print(data);
    });
    socket.onConnecting((data) {
      print("connecting");
    });
    socket.onError((data) {
      print("error");
    });
    socket.on('addToChart', (d) {
      print(d);
      if (data.length > 10) {
        data.removeAt(0);
      }

      data.add((d as int).toDouble());
    });
    socket.connect();
  }

  get highest {
    return data.reduce(max) * 2;
  }

  get minimum {
    return data.reduce(min) / 2;
  }
}
