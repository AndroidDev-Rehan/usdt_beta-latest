import 'package:flutter/material.dart';
import 'package:usdt_beta/AdminScreen/Widgets/withdraw_request_widget.dart';
import 'package:usdt_beta/AdminScreen/withdrawController.dart';

import '../style/color.dart';
import 'admin_main_screen.dart';

class AllWithDrawRequests extends StatelessWidget {
  const AllWithDrawRequests({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Pending Withdraw Requests'),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
//      backgroundColor: bgColor,
      body: FutureBuilder(
          future: WithdrawController.fillList(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else {
              return ListView.builder(
                itemCount: WithdrawController.list.length,
                itemBuilder: (context, index) {
                  return WithDrawRequestWidget(withDrawRequest: WithdrawController.list[index],);
                },
              );
            }
          }
      ),
    );
  }
}
