import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Controller/userController.dart';
import 'package:usdt_beta/Model/user_model.dart';
import 'package:usdt_beta/Services/database.dart';
import 'package:usdt_beta/UI/AuthScreen/login_screen.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  // final uController = Get.put(UserController());
  @override
  void initState() {
    uController.getUser();
    uController.upNameController.text = uController.user.name;
    print('called');
    super.initState();
  }

  // getUser() async {
  //   uController.user =
  //       await MyDatabase().getUser(uController.firbaseUser.value.uid);
  //   uController.upNameController.text = uController.user.name;
  //   //print('Uid is: ${userController.user.uid}');
  // }

  bool _status = true;
  //bool _isLoading = false;
  final FocusNode myFocusNode = FocusNode();
  UserController uController = Get.put(UserController());
  UserModel userModel;

  final ImagePicker picker = ImagePicker();
  Future getImage() async {
    final pickedImage =
    await picker.getImage(source: ImageSource.gallery, imageQuality: 10);

    setState(() {
      if (pickedImage != null) {
        uController.img = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
    File(pickedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: bgColor,
        body: GetX<UserController>(
            init: Get.put<UserController>(UserController()),
            builder: (UserController userController) {
              if (userController != null && userController.user != null) {
                return userController.isLoading.value == true
                    ? Container(
                  color: bgColor,
                  child: new ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new Container(
                            height: 250.0,
                            color: bgColor,
                            child: new Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.0, top: 20.0),
                                    child: new Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        // new Icon(
                                        //   Icons.arrow_back_ios,
                                        //   color: Colors.white,
                                        //   size: 22.0,
                                        // ),
                                        Padding(
                                          padding:
                                          EdgeInsets.only(left: 8.0),
                                          child: new Text('PROFILE',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 20.0,
                                                  fontFamily:
                                                  'sans-serif-light',
                                                  color: Colors.white)),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: GestureDetector(
                                            onTap: () async {
                                              try {
                                                FirebaseAuth.instance
                                                    .signOut()
                                                    .then((value) =>
                                                    Get.offAll(
                                                        LoginPage()));
                                              } catch (e) {
                                                print(e);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Text('Logout',
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 20.0,
                                                        fontFamily:
                                                        'sans-serif-light',
                                                        color: Colors
                                                            .white)),
                                                Icon(Icons.exit_to_app,
                                                    color: Colors.white),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: new Stack(
                                      fit: StackFit.loose,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            new Column(
                                              children: <Widget>[
                                                CircleAvatar(
                                                    radius: 70,
                                                    backgroundImage: uController
                                                        .img !=
                                                        null
                                                        ? FileImage(
                                                        uController
                                                            .img)
                                                        : (userController
                                                        .user
                                                        .userImage !=
                                                        null &&
                                                        uController
                                                            .user
                                                            .userImage
                                                            .isNotEmpty)
                                                        ? NetworkImage(
                                                        userController
                                                            .user
                                                            .userImage)
                                                        : AssetImage(
                                                        'assets/images/man.png')),
                                                SizedBox(
                                                  height: SizeConfig
                                                      .screenHeight *
                                                      0.01,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Current balance: \$${userController.user.investmentAmount?.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize: 22),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        !_status
                                            ? Padding(
                                            padding: EdgeInsets.only(
                                                top: 90.0,
                                                right: 100.0),
                                            child: new Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: getImage,
                                                  child:
                                                  new CircleAvatar(
                                                    backgroundColor:
                                                    Colors.red,
                                                    radius: 25.0,
                                                    child: new Icon(
                                                      Icons
                                                          .camera_alt,
                                                      color: Colors
                                                          .white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ))
                                            : Container(),
                                      ]),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: bgColor,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: new Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0,
                                          right: 25.0,
                                          top: 25.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Personal Information',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: <Widget>[
                                              _status
                                                  ? _getEditIcon()
                                                  : new Container(),
                                            ],
                                          )
                                        ],
                                      )),
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
                                                'Name',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.white),
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
                                            child: new TextField(
                                              controller: userController
                                                  .upNameController,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                  UnderlineInputBorder(),
                                                  hintText:
                                                  "${userController.user.name}",
                                                  hintStyle: TextStyle(
                                                      color:
                                                      Colors.white)),
                                              enabled: !_status,
                                              autofocus: !_status,
                                            ),
                                          ),
                                        ],
                                      )),
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
                                                'Email ID',
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
                                            child: new TextField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  hintText:
                                                  "${userController.user.email}",
                                                  hintStyle: TextStyle(
                                                      color:
                                                      Colors.white)),
                                              enabled: !_status,
                                            ),
                                          ),
                                        ],
                                      )),

                                  ///ReferenceID
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
                                                'Reference Id',
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
                                            child: new TextField(
                                              readOnly: true,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                  UnderlineInputBorder(),
                                                  hintText:
                                                  "${userController.user.uid}",
                                                  hintStyle: TextStyle(
                                                      color:
                                                      Colors.white)),
                                              enabled: !_status,
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                Clipboard.setData(
                                                    ClipboardData(
                                                        text:
                                                        "${userController.user.uid}"))
                                                    .then((value) =>
                                                    Get.snackbar(
                                                        'Success',
                                                        'value coped'));
                                              },
                                              child: Icon(Icons.copy_all,
                                                  color: Colors.white))
                                        ],
                                      )),
                                  // Padding(
                                  //     padding: EdgeInsets.only(
                                  //         left: 25.0, right: 25.0, top: 25.0),
                                  //     child: new Row(
                                  //       mainAxisSize: MainAxisSize.max,
                                  //       mainAxisAlignment: MainAxisAlignment.start,
                                  //       children: <Widget>[
                                  //         Expanded(
                                  //           child: Container(
                                  //             child: new Text(
                                  //               'Pin Code',
                                  //               style: TextStyle(
                                  //                   fontSize: 16.0,
                                  //                   fontWeight: FontWeight.bold),
                                  //             ),
                                  //           ),
                                  //           flex: 2,
                                  //         ),
                                  //         Expanded(
                                  //           child: Container(
                                  //             child: new Text(
                                  //               'State',
                                  //               style: TextStyle(
                                  //                   fontSize: 16.0,
                                  //                   fontWeight: FontWeight.bold),
                                  //             ),
                                  //           ),
                                  //           flex: 2,
                                  //         ),
                                  //       ],
                                  //     )),
                                  // Padding(
                                  //     padding: EdgeInsets.only(
                                  //         left: 25.0, right: 25.0, top: 2.0),
                                  //     child: new Row(
                                  //       mainAxisSize: MainAxisSize.max,
                                  //       mainAxisAlignment: MainAxisAlignment.start,
                                  //       children: <Widget>[
                                  //         Flexible(
                                  //           child: Padding(
                                  //             padding: EdgeInsets.only(right: 10.0),
                                  //             child: new TextField(
                                  //               decoration: const InputDecoration(
                                  //                   hintText: "Enter Pin Code"),
                                  //               enabled: !_status,
                                  //             ),
                                  //           ),
                                  //           flex: 2,
                                  //         ),
                                  //         Flexible(
                                  //           child: new TextField(
                                  //             decoration: const InputDecoration(
                                  //                 hintText: "Enter State"),
                                  //             enabled: !_status,
                                  //           ),
                                  //           flex: 2,
                                  //         ),
                                  //       ],
                                  //     )),
                                  !_status
                                      ? _getActionButtons()
                                      : new Container(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
                    : Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        uController.isLoading.value = false;
                        MyDatabase().updateUser();
                        uController.isLoading.value = true;

                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}