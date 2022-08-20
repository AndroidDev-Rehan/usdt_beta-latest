import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Model/withdraw_model.dart';
import 'package:usdt_beta/style/color.dart';

class WithdrawalBankDetailsScreen extends StatelessWidget {
  WithdrawalBankDetailsScreen({Key key, this.withDrawModel}) : super(key: key);

  WithDrawModel withDrawModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
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
                          (withDrawModel.bankName!=null) ?
                          "Bank  ${withDrawModel.bankName}" : "${withDrawModel.paymentMethod.capitalizeFirst}",
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
                          withDrawModel.accountName,
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
            Padding(
                padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    top: 2.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: new TextFormField(
                        readOnly: true,
                        style: TextStyle(
                            color: Colors.white),
                        decoration: InputDecoration(
//                          label: Text("Account No"),
                            focusedBorder:
                            UnderlineInputBorder(),
                            hintText:
                            withDrawModel.accountNo,
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
                                  withDrawModel.accountNo))
                              .then((value) =>
                              Get.snackbar(
                                  'Success',
                                  'Value copied'));
                        },
                        child: Icon(Icons.copy_all,
                            color: Colors.white))
                  ],
                )),

          ],
        ),
      ),
    );
  }
}
