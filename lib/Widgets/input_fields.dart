import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/sizeConfig.dart';
import 'package:usdt_beta/style/color.dart';

class InputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassField;
  final bool isShortFiedl;
  final String labelText;
  final TextInputType textInputType;

  InputField(
      {@required this.hint,
      @required this.controller,
      this.isPassField,
      this.isShortFiedl,
      this.labelText, this.textInputType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        margin: isShortFiedl != null
            ? EdgeInsets.only()
            : EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.05),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.07),
//      height: 68,
        decoration: BoxDecoration(
            //border: Border.all(color: Colors.grey, width: 1.0),
            // color: Colors.white24.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Field required";
                }
                return null;
              },
              keyboardType: textInputType ?? TextInputType.text,
              cursorColor: Colors.white,
              controller: controller,
              obscureText: isPassField != null ? true : false,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 19.0),
          decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0),
                hintText: hint,
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Get.isDarkMode ? Colors.grey[700] : Colors.white,
                    width: 0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Get.isDarkMode ? Colors.grey[700] : Colors.white,
                    width: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
