import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:usdt_beta/style/color.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

//import 'package:string_to_hex/string_to_hex.dart';

//import '../InvestmentScreen/insvestment_screen.dart';
// Developed by Muhammad Ibrahim Basit
class PaymentScreen extends StatelessWidget {
  final String amount;
  PaymentScreen({this.amount});
  // Calling platform method to web view the jazz cash gateway link
  static const platform = const MethodChannel('com.usdt_beta/performPayment');
  static const integritySalt = '31xt0g53s3';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            AuthButton(
              label: 'JazzCash',
              onTap: pay,
            ),
            Divider(),
            AuthButton(
              label: 'EasyPaisa',
              onTap: () {},
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }

  // hashing the required data to send to jazz cash
  String hashingFunc(Map<String, String> data) {
    Map<String, String> temp2 = {};

    data.forEach((k, v) {
      if (v != "") v += "&";
      temp2[k] = v;
    });
    var sortedKeys = temp2.keys.toList(growable: false)
      ..sort((k1, k2) => k1.compareTo(k2));
    Map<String, String> sortedMap = Map.fromIterable(sortedKeys,
        key: (k) => k,
        value: (k) {
          return temp2[k];
        });
    // the hashing function has some issues.
    // hash needs the request body values in alphabetical order and an & between
    // each value. At the start of the hash should be integritySalt.
    // this should run through hmac sha 256 algo and then the result should be converted
    // to hexadecimal. This will be the secureHash that is sent to the API.
    var values = sortedMap.values;
    String and = "&";
    String superdata = integritySalt +
        and +
        data["pp_Amount"] +
        and +
        data["pp_BankID"] +
        and +
        data["pp_BillReference"] +
        and +
        data["pp_CNIC"] +
        and +
        data["pp_Description"] +
        and +
        data["pp_Language"] +
        and +
        data["pp_MerchantID"] +
        and +
        data["pp_Password"] +
        and +
        // data["pp_ReturnURL"] +
        // and +
        data["pp_TxnCurrency"] +
        and +
        data["pp_TxnDateTime"] +
        and +
        data["pp_TxnExpiryDateTime"] +
        and +
        data["pp_TxnRefNo"] +
        and +
        data["pp_TxnType"] +
        and +
        data["pp_Version"] +
        and +
        data["ppmpf_1"];
    String toBePrinted = values.reduce((str, ele) => str += ele);
    toBePrinted = toBePrinted.substring(0, toBePrinted.length - 1);
    toBePrinted = integritySalt + '&' + toBePrinted;
    debugPrint(toBePrinted);
    var key = utf8.encode(integritySalt);
    var bytes = utf8.encode(toBePrinted);
    var latin = Latin1Codec().encode(bytes.toString());
    var decoded = Latin1Codec().decode(latin);
    var hash2 = Hmac(sha256, key);
    // HexEncoder _hexEncoder;
    var digest = hash2.convert(latin);
    // var second = utf8.encode(digest.toString());
    // String last = HEX.encode(second);

    // var key = utf8.encode(integritySalt);
    // var bytes = utf8.encode(superdata);
    // var next = Latin1Codec().encode(bytes.toString());
    // var hmacSha256 = Hmac(sha256, key);
    // var hash = hmacSha256.convert(next);

    // var last = utf8.encode(hash.toString());
    // var hmm = HEX.encode(last);

    // var key = utf8.encode(integritySalt);
    // var bytes = utf8.encode(toBePrinted);
    // var hmacSha256 = Hmac(sha256, key);
    // var hash = hmacSha256.convert(bytes);
    // var last = utf8.encode(hash.toString());
    // Future<String> hashFromJs(JavascriptRuntime jsRunTime, data) async {
    //   String hashJs = await rootBundle.loadString("assets/hash.js");
    //   final jsResult = jsRunTime.evaluate(hashJs + """calcHash($data)""");
    //   final jsStringResult = jsResult.stringResult;
    //   return jsStringResult;
    // }

    // String final_try;
    // hashFromJs(jsRunTime, data).then((value) => final_try = value);

    data["pp_SecureHash"] = digest.toString().toUpperCase();
    debugPrint(data["pp_SecureHash"]);
    //debugPrint(hash.toString());
    String returnString = "";
    data.forEach((k, v) {
      returnString += k + '=' + v + '&';
    });
    returnString = returnString.substring(0, returnString.length);

    return returnString;
  }

  Future<void> pay() async {
    // Transaction Start Time
    final currentDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

    // Transaction Expiry Time
    final expDate = DateFormat('yyyyMMddHHmmss')
        .format(DateTime.now().add(Duration(minutes: 5)));
    final refNo = 'T' + currentDate.toString();

    // The json map that contains our key-value pairs
    var data = {
      // add fields according to need of whatever kind of billing system you want the app to have
      "pp_Version": "1.1",
      "pp_TxnType": "MWALLET",
      "pp_Language": "EN",
      "pp_MerchantID": "MC36820",
      "pp_SubMerchantID": "",
      "pp_Password": "x225a0ts9a",
      "pp_BankID": "",
      "pp_ProductID": "",
      "pp_TxnRefNo": refNo,
      "pp_Amount": amount, // Amount the user pays goes here
      "pp_TxnCurrency": "PKR",
      "pp_CNIC": "345678",
      "pp_TxnDateTime": currentDate,
      "pp_BillReference": "billRef",
      "pp_Description": "Description",
      "pp_TxnExpiryDateTime": expDate,
      "pp_ReturnURL":
          "http://localhost/MerchantSimulator/HttpRequestDemoServer/Index",
      "pp_SecureHash": "",
      "ppmpf_1": "03123456789",
      "ppmpf_2": "",
      "ppmpf_3": "",
      "ppmpf_4": "",
      "ppmpf_5": ""
    };
    String postData = hashingFunc(data);
    String responseString;

    try {
      // Trigger native code through channel method
      // The first arguemnt is the name of method that is invoked
      // The second argument is the data passed to the method as input
      debugPrint("ok");
      final result =
          await platform.invokeMethod('performPayment', {"postData": postData});
      debugPrint("not ok");
      // Await for response from above before moving on
      // The response contains the result of the transaction

      responseString = result.toString();
    } on PlatformException catch (e) {
      // On Channel Method Invocation Failure
      print("PLATFORM_EXCEPTION: ${e.message.toString()}");
    }

    // Parse the response now
    List<String> responseStringArray = responseString.split('&');
    Map<String, String> response = {};
    responseStringArray.forEach((e) {
      if (e.length > 0) {
        e.trim();
        final c = e.split('=');
        response[c[0]] = c[1];
      }
    });
// Use the transaction response as needed now

    debugPrint("Message: " + response["responseMessage"]);
    return response;
  }
}
