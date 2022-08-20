import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as pathLibrary;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/Model/deposit_request_model.dart';
import 'package:usdt_beta/UI/InvestmentScreen/request_pending_screen.dart';
import 'package:usdt_beta/UI/InvestmentScreen/widgets/upload_document.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';
import 'package:http/http.dart' as http;

String downloadURL;

class InvestmentScreen extends StatefulWidget {
  const InvestmentScreen({
    Key key,
  }) : super(key: key);

  @override
  _InvestmentScreenState createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  String curr_url =
      "https://free.currconv.com/api/v7/convert?q=USD_PKR&apiKey=e601d58e1e0414a3fcb4&compact=ultra";
  Map<String, dynamic> paymentIntentData;
  String amount = "560";
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  TextEditingController investController = new TextEditingController();
  String selectedChoice = "";
  List<String> itemList = [
    "30",
    "50",
    "75",
    "100",
    "200",
    "300",
    "400",
    "500",
  ];
  _buildChoiceList() {
    List<Widget> choices = List();
    itemList.forEach((item) {
      choices.add(Container(
        height: SizeConfig.screenHeight * 0.1,
        padding: const EdgeInsets.all(8.0),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          selectedColor: bgColorDark,
          labelStyle: TextStyle(
              color: Colors.white, fontSize: SizeConfig.screenHeight * 0.024),
          backgroundColor: bgColorLight,
          label: Container(
              height: SizeConfig.screenHeight * 0.06,
              width: SizeConfig.screenWidth * 0.34,
              child: Center(child: Text('\$$item'))),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              print('Selected chocie $selectedChoice');
              investController.text = selectedChoice;
            });
          },
        ),
      ));
    });
    return choices;
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent(
          investController.text, 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData['client_secret'],
              applePay: true,
              googlePay: true,
              //testEnv: true,
              //style: ThemeMode.dark,
              merchantCountryCode: 'US',
              merchantDisplayName: 'USDTBETA'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData['client_secret'],
            confirmPayment: true,
          ))
          .then((newValue) {
        print('payment intent' + paymentIntentData['id'].toString());
        print('payment intent' + paymentIntentData['client_secret'].toString());
        print('payment intent' + paymentIntentData['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(investController.text),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
            'Bearer sk_test_51KRGARJ7IPSquX8HFqgj9fVarcTdfwPtaVpJ5XPlfb1fFi28V3VjlwBhAX7TI9dcnT52Y56yEayY5bWXMMI0x9e500M6BNhMmQ',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  // Future<Currency> getExchangeRate() async {
  //   var res = await http.get(Uri.parse(curr_url));

  //   return Currency.fromJson(jsonDecode(res.body));
  // }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: bgColorLight,
        title: Text('Deposit'),
      ),
      body:
      loading ? Center(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please wait processing your request ...", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
            CircularProgressIndicator(),
          ],
        ),
      ),)
      : SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 30,),
              // NumberTextField(title: "EasyPaisa / JazzCash: ",),
              // NumberTextField(title: "JazzCash: ",),
              NumberTextField(title: "Bank: ",bank: true,text: '98360105660934',),
              NumberTextField(title: "Jazz Cash: ", text: "03193587448",),
              // NumberTextField(title: "Vault Address: ", text: "0x18bcb74ED66Fe70a14879fBb64CB1cF7742A5235",),
              NumberTextField(title: "Easy paisa: ", text: "03193587448",trc: false,),





              // Padding(
              //   padding:
              //   const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              //   child: Text('Select Amount to deposit',
              //       style: TextStyle(color: Colors.white, fontSize: 20)),
              // ),
              // Center(
              //   child: Wrap(
              //     children: _buildChoiceList(),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Text('Or enter another Amount',
              //       style: TextStyle(color: Colors.white, fontSize: 20)),
              // ),
              //SizedBox(height: SizeConfig.screenHeight * 0.18),
              // Text(
              //   'Your money\nwork while you\nrest',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 42,
              //       fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: SizeConfig.screenHeight * 0.06,
              // ),
              // Image.asset('assets/images/return-on-investment.png',
              //
              //   height: SizeConfig.screenHeight * 0.3),
              // CardField(
              //   onCardChanged: (card) {
              //     print(card);
              //   },
              // ),

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Container(
                  height: SizeConfig.screenHeight * 0.16,
                  child: Row(
                    children: [
                      Flexible(
                          child: Form(
                            key: _key,
                            child: TextFormField(
                              controller: investController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some amount';
                                } else if (value.isNumericOnly) {
                                  if (int.parse(value) <= 29) {
                                    return 'Investment amount must be at least 30\$';
                                  }
                                } else
                                  return 'It is not a number';
                                final n = num.tryParse(value);
                                if (n == null) {
                                  return '"$value" is not a valid number';
                                }
                                return null;
                              },
                              cursorColor: Colors.white,
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: 'Enter Amount you want to invest',
                                  labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 14),
                                  border: InputBorder.none,
                                  // focusedBorder: OutlineInputBorder(),
                                  hintText: '879.0',
                                  hintStyle: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  prefix: Text(
                                    '\$ ',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                          )),
                      // RaisedButton(
                      //     onPressed: () {
                      //       if (_key.currentState.validate()) {
                      //         FocusScope.of(context).requestFocus(FocusNode());
                      //         Get.to(DepositWidget());
                      //         Fluttertoast.showToast(
                      //             msg:
                      //                 'You are eligible for investment proceed further');
                      //         investController.clear();
                      //       }
                      //     },
                      //     color: bgColorDark,
                      //     child: Text('Invest',
                      //         style:
                      //             TextStyle(color: Colors.white, fontSize: 24)))
                      // Text('\$$amount',
                      //     style: TextStyle(
                      //         fontSize: 42, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UploadDocument(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AuthButton(
                    label: 'Pay Now',
                    // on click go to payment options with the amount selected:
                    onTap: () async{
                      if (_key.currentState.validate()) {
                        if(pdfFile!=null){
                          setState(() {
                            loading = true;
                          });
                          bool status = await uploadFileAndGetLink();
                          if(status){
                            Get.off(()=>RequestPendingScreen());
                            loading = false;
                            pdfFile = null;
                          }
                          else {
                            setState(() {
                              loading = false;
                            });
                          }



                          // final String am = investController.text;
                          // var calc = double.parse(am);
                          // //Currency rate;
                          // //getExchangeRate().then((value) => rate = value);
                          //
                          // var amount = calc * 185;
                          // Get.to(
                          //     PaymentScreen(amount: amount.toInt().toString()));
                          // // print('Amount ${int.parse(investController.text)}');
                          // // makePayment();
                          // //MyDatabase().updateInvestmentAmount(
                          // //  int.parse(investController.text));
                          //
                          // //FocusScope.of(context).requestFocus(FocusNode());
                          // //Get.to(DepositWidget());
                          // // Fluttertoast.showToast(
                          // //     msg:
                          // //         'You are eligible for investment proceed further');
                          // //investController.clear();
                        }
                        else{
                          Get.snackbar("Error", "Verification Document Missing",snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
                        }
                      }
                    },
                  ),
                ),
              ),
              //             GooglePayButton(
              //   paymentConfigurationAsset: 'gpay.json',
              //   paymentItems: _paymentItems,
              //   style: GooglePayButtonStyle.black,
              //   type: GooglePayButtonType.pay,
              //   margin: const EdgeInsets.only(top: 15.0),
              //   onPaymentResult: onGooglePayResult,
              //   loadingIndicator: const Center(
              //     child: CircularProgressIndicator(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
    // Future<PaymentMethod> createPaymentMethod(){
    //   return
    // };
  }

  Future<bool> uploadFileAndGetLink() async {
    try{

      final String dateRef = DateTime.now().toString();

      UserController userController = Get.find();
      await uploadFile();
      downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(pathLibrary.basename(pdfFile.path)).getDownloadURL();
      await FirebaseFirestore.instance.collection("DepositRequests").doc("${userController
          .usermodel.value.uid} $dateRef").set(DepositRequest(userId: userController.usermodel.value.uid, amount: double.parse(investController.text), documentLink: downloadURL,userMail: userController.usermodel.value.email, userName: userController.usermodel.value.name,
          depositId: "${userController.usermodel.value.uid} $dateRef").toMap());
      await userController.uploadReference(investController.text);
      return true;
    }
    catch(e){
      Get.snackbar("Error", e.toString());
      return false;
    }
//    return downloadURL;
    // Within your widgets:
    // Image.network(downloadURL);
  }

  Future<void> uploadFile() async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(pathLibrary.basename(pdfFile.path)).putFile(pdfFile);
    } catch (e) {
      Get.snackbar("Error", e.toString());
      // e.g, e.code == 'canceled'
    }
  }

  void makeJazzCashPayment() async {
    var digest;
    String dateandtime = DateTime.now().toString();
    String dexpiredate = DateTime.now().add(Duration(days: 1)).toString();
    String tre = "T" + dateandtime;
    String pp_Amount = "100000";
    String pp_BillReference = "billRef";
    String pp_Description = "Description";
    String pp_Language = "EN";
    String pp_MerchantID = "your id";
    String pp_Password = "your password";

    String pp_ReturnURL =
        "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
    String pp_ver = "1.1";
    String pp_TxnCurrency = "PKR";
    String pp_TxnDateTime = dateandtime.toString();
    String pp_TxnExpiryDateTime = dexpiredate.toString();
    String pp_TxnRefNo = tre.toString();
    String pp_TxnType = "MWALLET";
    String ppmpf_1 = "4456733833993";
    String IntegeritySalt = "your key";
    String and = '&';
    String superdata = IntegeritySalt +
        and +
        pp_Amount +
        and +
        pp_BillReference +
        and +
        pp_Description +
        and +
        pp_Language +
        and +
        pp_MerchantID +
        and +
        pp_Password +
        and +
        pp_ReturnURL +
        and +
        pp_TxnCurrency +
        and +
        pp_TxnDateTime +
        and +
        pp_TxnExpiryDateTime +
        and +
        pp_TxnRefNo +
        and +
        pp_TxnType +
        and +
        pp_ver +
        and +
        ppmpf_1;

    var key = utf8.encode(IntegeritySalt);
    var bytes = utf8.encode(superdata);
    var hmacSha256 = Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    String url =
        'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

    var response = await http.post(Uri.parse(url), body: {
      "pp_Version": pp_ver,
      "pp_TxnType": pp_TxnType,
      "pp_Language": pp_Language,
      "pp_MerchantID": pp_MerchantID,
      "pp_Password": pp_Password,
      "pp_TxnRefNo": tre,
      "pp_Amount": pp_Amount,
      "pp_TxnCurrency": pp_TxnCurrency,
      "pp_TxnDateTime": dateandtime,
      "pp_BillReference": pp_BillReference,
      "pp_Description": pp_Description,
      "pp_TxnExpiryDateTime": dexpiredate,
      "pp_ReturnURL": pp_ReturnURL,
      "pp_SecureHash": sha256Result.toString(),
      "ppmpf_1": "4456733833993"
    });

    print("response=>");
    print(response.body);
  }

  String numberValidator(String value) {
    if (value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  void onGooglePayResult(paymentResult) {
    // Send the resulting Google Pay token to your server / PSP
  }
// static Future<StripeTransactionResponse> addNewCard(
//     {String amount, String currency}) async {
//   try {
//     var stripePaymentMethod = await StripePayment.paymentRequestWithCardForm(
//         CardFormPaymentRequest());
//     var stripePaymentIntent =
//         await StripeService.createPaymentIntent(amount, currency);
//     var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
//         clientSecret: stripePaymentIntent['client_secret'],
//         paymentMethodId: stripePaymentMethod.id));

//     if (response.status == 'succeeded') {
//       //if the payment process success
//       return new StripeTransactionResponse(
//           message: 'Transaction successful', success: true);
//     } else {
//       //payment process fail
//       return new StripeTransactionResponse(
//           message: 'Transaction failed', success: false);
//     }
//   } on PlatformException catch (error) {
//     return StripeService.getPlatformExceptionErrorResult(error);
//   } catch (error) {
//     return new StripeTransactionResponse(
//         //convert the error to string and assign to message variable
//         message: 'Transaction failed: ${error.toString()}',
//         success: false);
//   }
// }

}

class PaymentResponse {
  String message; // message from the response
  bool success; //state of the processs

  //class constructor
  PaymentResponse({this.message, this.success});
}

class NumberTextField extends StatelessWidget {
  String title;
  String text;
  bool bank;
  NumberTextField({this.title, this.text,this.bank, this.trc = false});
  bool trc;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                top: 25.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(
                  mainAxisAlignment:
                  MainAxisAlignment.start,
                  mainAxisSize:
                  MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      (bank!=null) ?
                      "$title Meezan Bank" : "$title",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight:
                          FontWeight.bold),
                    ),
                  ],
                ),
              ],
            )),
        (bank!=null) ?
        Padding(
            padding: EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                top: 15.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(
                  mainAxisAlignment:
                  MainAxisAlignment.start,
                  mainAxisSize:
                  MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      "##########",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight:
                          FontWeight.bold),
                    ),
                  ],
                ),
              ],
            )) : SizedBox(height: 0,),
        Padding(
            padding: EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                top: 2.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    readOnly: true,
                    style: TextStyle(
                        color: Colors.white),
                    decoration: InputDecoration(
                        focusedBorder:
                        UnderlineInputBorder(),
                        hintText:
                            text ??
                        "############",
                        hintStyle: TextStyle(
                            color:
                            Colors.white)),
                    enabled: false,
                  ),
                ),
                InkWell(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(
                              text:
                                  text ??
                              "############"))
                          .then((value) =>
                          Get.snackbar(
                              'Success',
                              'Number copied'));
                    },
                    child: Icon(Icons.copy_all,
                        color: Colors.white))
              ],
            )),
        trc ?
        Padding(
            padding: EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                top: 0.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Column(
                  mainAxisAlignment:
                  MainAxisAlignment.start,
                  mainAxisSize:
                  MainAxisSize.min,
                  children: <Widget>[
                    new Text(
                      "TRC 20",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight:
                          FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ))
            : SizedBox(height: 0,)

      ],
    );
  }
}
