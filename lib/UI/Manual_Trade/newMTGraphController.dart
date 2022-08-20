import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class GraphController extends GetxController{
  Rx<FlSpot> selectedSpot = FlSpot(0,0).obs;
  Rx<bool> timerStarted = false.obs;

}