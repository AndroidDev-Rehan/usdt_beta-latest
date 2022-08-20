import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/all_user_controller.dart';
import 'package:usdt_beta/Controller/referal_controller.dart';

import 'Widgets/user_detail_widget.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AllUserController controller = Get.find();

  final ReferalController referal_controller = Get.find();

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
                child: TextFormField(
                  autofocus: true,
                  controller: searchController,
                  onChanged: (value){
                    controller.updateSearchList(value);
                    setState((){});
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                  child: searchController.text.isEmpty
                      ? Center(
                          child: Text("Enter text to search user"),
                        )
                      : controller.searchedUsersList.isEmpty
                          ? Center(
                              child: Text("No User found."),
                            )
                          : ListView.builder(
                              itemCount: controller.searchedUsersList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: controller
                                                    .searchedUsersList[index]
                                                    .userImage !=
                                                ""
                                            ? NetworkImage(controller
                                                .searchedUsersList[index].userImage)
                                            : AssetImage('assets/images/man.png'),
                                      ),
                                      title: Text(
                                          controller.searchedUsersList[index].name),
                                      subtitle: Text(controller
                                          .searchedUsersList[index].email),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Balance'),
                                          Text(
                                            controller.searchedUsersList[index]
                                                        .investmentAmount !=
                                                    0
                                                ? '\$ ${controller.searchedUsersList[index].investmentAmount}'
                                                : '\$ 0',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        referal_controller.getRef(controller
                                            .searchedUsersList[index].uid);
                                        Get.off(UserDetailWidget(
                                            allUserData: controller
                                                .searchedUsersList[index]));
                                      },
                                    ));
                              })

              )
            ],
          ),
        ),
      ),
    );
  }
}
