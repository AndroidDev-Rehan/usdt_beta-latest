import 'package:flutter/material.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: bgColorLight,
        title: Text('Help', style: TextStyle(fontSize: 25)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie.network(
              //     'https://assets7.lottiefiles.com/private_files/lf30_udcuw1v9.json'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Image.asset(
                  'assets/images/help.png',
                  color: Colors.white,
                  height: 150,
                ),
              ),
              //  Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 0,
                  color: bgColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Support',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                          keyboardType: TextInputType.multiline,
                          //     minLines: 1, //Normal textInputField will be displayed
                          maxLines: 5,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Email',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          cursorColor: Colors.white,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          //     minLines: 1, //Normal textInputField will be displayed
                          // maxLines: 5,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.03,
              ),
              AuthButton(
                label: 'Submit',
                onTap: () {},
              ),

              // RaisedButton(
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(18)),
              //   onPressed: () {},
              //   child: Text('Submit'),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
