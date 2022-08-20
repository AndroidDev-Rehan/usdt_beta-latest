import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/AdminScreen/Widgets/user_detail_widget.dart';
import 'package:usdt_beta/AdminScreen/Widgets/withdraw_request_widget.dart';
import 'package:usdt_beta/AdminScreen/all_deposit_requests_page.dart';
import 'package:usdt_beta/AdminScreen/all_withdraw_request.dart';
import 'package:usdt_beta/AdminScreen/searchScreeb.dart';
import 'package:usdt_beta/Controller/all_user_controller.dart';
import 'package:usdt_beta/Controller/referal_controller.dart';
import 'package:usdt_beta/UI/AuthScreen/login_screen.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

import 'copy_trade_screen_home.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({Key key}) : super(key: key);

  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  final referal_controller = Get.put(ReferalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: bgColor,
          title: Text('All Registered User'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                  onTap: (){
                    Get.to(SearchScreen());
                  },
                  child: Icon(Icons.search)),
            ),
          ],
        ),
        drawer: MyDrawer(),
        body: GetX<AllUserController>(
            init: Get.put<AllUserController>(AllUserController()),
            builder: (AllUserController allUserController) {
              if (allUserController != null &&
                  allUserController.allUser != null) {
                return Container(
                  height: SizeConfig.screenHeight * 0.9,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: allUserController.allUser.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: allUserController
                                            .allUser[index].userImage !=
                                        ""
                                    ? NetworkImage(allUserController
                                        .allUser[index].userImage)
                                    : AssetImage('assets/images/man.png'),
                              ),
                              title:
                                  Text(allUserController.allUser[index].name),
                              subtitle:
                                  Text(allUserController.allUser[index].email),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Balance'),
                                  Text(
                                    allUserController.allUser[index]
                                                .investmentAmount !=
                                            0
                                        ? '\$ ${allUserController.allUser[index].investmentAmount}'
                                        : '\$ 0',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              onTap: () {
                                referal_controller.getRef(
                                    allUserController.allUser[index].uid);
                                Get.to(UserDetailWidget(
                                    allUserData:
                                        allUserController.allUser[index]));
                              },
                            ));
                      }),
                );
              } else {
                return Center(
                  child: Text(
                    'User Loading...',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            }));
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: const EdgeInsets.all(0.0), children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: const Text('Admin'),
          accountEmail: const Text('Admin@123'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('assets/images/man.png'),
          ),
          otherAccountsPictures: const <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white60,
              child: Text('A'),
            ),
            CircleAvatar(
              child: Text('R'),
            ),
          ],
          onDetailsPressed: () {},
          decoration: BoxDecoration(
            color: bgColor,
          ),
        ),
        ListTile(
          title: const Text('Profile'),
          leading: const Icon(Icons.person),
          onLongPress: () {},
        ),
        const Divider(),
        const ListTile(
          title: Text('Noftifications'),
          leading: Icon(Icons.notifications),
        ),
        ListTile(
          title: const Text('Copy Trade'),
          leading: const Icon(CupertinoIcons.graph_circle_fill),
          onTap: () {
            Get.to(CopyTradeAdminHome());
          },
        ),
        ListTile(
          title: const Text('Deposit Requests'),
          leading: const Icon(CupertinoIcons.money_dollar),
          onTap: () {
            Get.to(AllDepositRequests());
          },
        ),
        ListTile(
          title: const Text('Withdraw Requests'),
          leading: const Icon(CupertinoIcons.arrow_counterclockwise),
          onTap: () {
            Get.to(AllWithDrawRequests());
          },
        ),
        // ListTile(
        //   title: const Text('Calls'),
        //   leading: const Icon(Icons.call),
        //   onLongPress: () {},
        // ),
        const Divider(),
        ListTile(
          title: const Text('Settings'),
          leading: const Icon(Icons.settings),
          onLongPress: () {},
        ),
        const Divider(),
        ListTile(
          title: const Text('LogOut'),
          leading: const Icon(Icons.logout),
          onTap: () {
            Get.offAll(LoginPage());
          },
        ),
        ListTile(
            title: const Text('Close'),
            leading: const Icon(Icons.close),
            onTap: () {
              Navigator.of(context).pop();
            }),
      ]),
    );
  }
}
