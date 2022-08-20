// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:usdt_beta/Controller/ManualTradeController.dart';
// import 'package:usdt_beta/Controller/userController.dart';
// import 'package:usdt_beta/UI/Manual_Trade/manual_trade_screen.dart';
// import 'package:usdt_beta/Widgets/auth_button.dart';
// import 'package:usdt_beta/style/color.dart';
//
// import '../../sizeConfig.dart';
//
// class EnterBidAmountScreen extends StatefulWidget {
//   final String type;
//   final String category;
//
//   const EnterBidAmountScreen(this.type, this.category,{Key key,}) : super(key: key);
//   @override
//   State<EnterBidAmountScreen> createState() => _EnterBidAmountScreenState();
// }
//
// class _EnterBidAmountScreenState extends State<EnterBidAmountScreen> {
//   final GlobalKey<FormState> _key = new GlobalKey<FormState>();
//
//   bool loading = false;
//
//   TextEditingController investController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Center(
//         child: loading ? CircularProgressIndicator() :
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//               child: Container(
//                 height: SizeConfig.screenHeight * 0.16,
//                 child: Row(
//                   children: [
//                     Flexible(
//                         child: Form(
//                           key: _key,
//                           child: TextFormField(
//                             controller: investController,
//                             validator: (value) {
//                               if (value.isEmpty) {
//                                 return 'Please enter some amount';
//                               } else if (value.isNumericOnly) {
//                                 if (int.parse(value) <= 29) {
//                                   return 'Investment amount must be at least 30\$';
//                                 }
//                               } else
//                                 return 'It is not a number';
//                               final n = num.tryParse(value);
//                               if (n == null) {
//                                 return '"$value" is not a valid number';
//                               }
//                               return null;
//                             },
//                             cursorColor: Colors.white,
//                             style: TextStyle(
//                               fontSize: 42,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             keyboardType: TextInputType.phone,
//                             decoration: InputDecoration(
//                                 labelText: 'Enter Amount you want to invest',
//                                 labelStyle:
//                                 TextStyle(color: Colors.grey, fontSize: 20),
//                                 contentPadding:
//                                 EdgeInsets.symmetric(horizontal: 14),
//                                 border: InputBorder.none,
//                                 // focusedBorder: OutlineInputBorder(),
//                                 hintText: '879.0',
//                                 hintStyle: TextStyle(
//                                     fontSize: 42,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.grey),
//                                 prefix: Text(
//                                   '\$ ',
//                                   style: TextStyle(
//                                     fontSize: 42,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 )),
//                           ),
//                         )),
//                     // RaisedButton(
//                     //     onPressed: () {
//                     //       if (_key.currentState.validate()) {
//                     //         FocusScope.of(context).requestFocus(FocusNode());
//                     //         Get.to(DepositWidget());
//                     //         Fluttertoast.showToast(
//                     //             msg:
//                     //                 'You are eligible for investment proceed further');
//                     //         investController.clear();
//                     //       }
//                     //     },
//                     //     color: bgColorDark,
//                     //     child: Text('Invest',
//                     //         style:
//                     //             TextStyle(color: Colors.white, fontSize: 24)))
//                     // Text('\$$amount',
//                     //     style: TextStyle(
//                     //         fontSize: 42, fontWeight: FontWeight.bold))
//                   ],
//                 ),
//               ),
//             ),
//             AuthButton(label: "Start Trade", onTap: () async{
//               if(_key.currentState.validate()) {
//                 UserController userController = Get.find();
//                 if(userController.user.investmentAmount>=double.parse(investController.text))
//                 {
//                   setState(() {
//                     loading = true;
//                   });
//                   await ManualTradeController.addTrade(
//                             widget.type,
//                             widget.category,
//                             int.parse(investController.text),
//                           );
//                           Get.off(ManualTradeScreen(widget.category,
//                               int.parse(investController.text), widget.type));
//                           setState(() {
//                             loading = false;
//                           });
//                 }
//                 else {
//                   Get.snackbar("Error", "Not enough balance in account");
//                 }
//
//                       }
//               },)
//           ],
//         ),
//       ),
//     );
//   }
// }
