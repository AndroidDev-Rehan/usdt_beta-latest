// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class AuthController extends GetxController {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   Rx<User> firbaseUser = Rx<User>();
//   String get user => firbaseUser.value?.email;
//   @override
//   void onInit() {
//     firbaseUser.bindStream(auth.authStateChanges());
//     super.onInit();
//   }
// }
