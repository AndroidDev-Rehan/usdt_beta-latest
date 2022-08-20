// import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';
// import 'package:usdt_beta/UI/DepositWithDrawScreen/choose_option_screen.dart';
// import 'package:usdt_beta/UI/InvestmentScreen/insvestment_screen.dart';
// import 'package:usdt_beta/UI/Manual_Trade/enter_amount_screen.dart';
// import 'package:usdt_beta/Widgets/auth_button.dart';
// import 'package:usdt_beta/sizeConfig.dart';
// import 'package:usdt_beta/style/color.dart';
//
// class BitUpDownScreen extends StatelessWidget {
//   final String category;
//   const BitUpDownScreen(this.category,{Key key,}) : super(key: key);
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AuthButton(
//               label: 'Bit Up',
//               onTap: () {
//                 Get.off(EnterBidAmountScreen("up", category ));
//               },
//               color: Colors.green,
//             ),
//             SizedBox(height: SizeConfig.screenHeight * 0.01),
//             AuthButton(
//               color: Colors.red,
//               label: 'Bit Down',
//               onTap: () {
//                 Get.off(EnterBidAmountScreen("down", category));
// //                Get.to(WithDrawWidget());
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
