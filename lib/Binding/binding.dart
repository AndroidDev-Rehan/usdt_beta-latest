import 'package:get/get.dart';
import 'package:usdt_beta/Controller/userController.dart';

import '../Controller/LiveTradeController.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserController>(UserController());
    Get.put<LiveTradeController>(LiveTradeController());
  }
}
