import 'package:flutter/material.dart';
import 'package:usdt_beta/Widgets/auth_button.dart';
import 'package:usdt_beta/Widgets/input_fields.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class WithDrawWidget extends StatelessWidget {
  WithDrawWidget({Key key}) : super(key: key);
  TextEditingController wNameController = new TextEditingController();
  TextEditingController wIDController = new TextEditingController();
  TextEditingController wACCNoController = new TextEditingController();
  TextEditingController wISBNController = new TextEditingController();
  TextEditingController wAccountController = new TextEditingController();
  TextEditingController wBankName = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColorLight,
        title: Text('WithDraw'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/atm.png',
              height: 200,
            ),
            InputField(
                labelText: 'Name', hint: 'Name', controller: wNameController),
            InputField(
                labelText: 'UniqueId',
                hint: 'UniqueId',
                controller: wIDController),
            InputField(
                labelText: 'Account No',
                hint: 'Account No',
                controller: wACCNoController),
            InputField(
                labelText: 'ISBN', hint: 'ISBN', controller: wISBNController),
            InputField(
                labelText: 'Acount',
                hint: 'Account',
                controller: wAccountController),
            InputField(
                labelText: 'Bank Name',
                hint: 'Bank Name',
                controller: wAccountController),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AuthButton(
                label: 'Submit',
                onTap: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
