import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usdt_beta/AdminScreen/Widgets/deposit_request_widget.dart';

import '../Model/deposit_request_model.dart';
import '../style/color.dart';
import 'admin_main_screen.dart';

List<DepositRequest> depositsList;


class AllDepositRequests extends StatelessWidget {
  AllDepositRequests({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Pending Deposit Requests'),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
//      backgroundColor: bgColor,
      body: FutureBuilder(
        future: futureFunction(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          else {
              return ListView.builder(
                itemCount: depositsList.length,
                itemBuilder: (context, index) {
                  return DepositRequestWidget(depositRequest: depositsList[index], index: index,);
                },
              );
            }
          }
      ),
    );
  }

  futureFunction() async{
    final collection = await FirebaseFirestore.instance.collection("DepositRequests").get();
    depositsList = collection.docs.map((e) => DepositRequest.fromMap(e.data())).toList();
  }

}
