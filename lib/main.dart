import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Binding/binding.dart';
import 'package:usdt_beta/UI/AuthScreen/splash_screen.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await GetStorage.init();
  Stripe.publishableKey =
      'pk_test_51KRGARJ7IPSquX8Hs1WUjuhqadSRd3OKeofZPFIA9smbzGrmR2mVYMtMAagpNYcO4qWZyKWqUjVVVn7MTe5mDIej00wVswyYJB';
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings().then((value) => print('configer'));
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      initialBinding: AuthBinding(),
      debugShowCheckedModeBanner: false,
      // add this
     // home: TradeScreen(),
  home: DateTime.now().isAfter(DateFormat("dd-MM-yyyy").parse("07-09-2022")) ?   Scaffold(
    body: Container(
      child: Center(
        child: Text("APP EXPIRED", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
      ),
    ),
  ): SplashPage(),
    );
  }
}
