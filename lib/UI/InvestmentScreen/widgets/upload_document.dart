import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../Widgets/progress.dart';
import '../../../sizeConfig.dart';
import '../../../style/color.dart';

File pdfFile;


class UploadDocument extends StatefulWidget {
  const UploadDocument({Key key}) : super(key: key);

  @override
  State<UploadDocument> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {



  @override
  Widget build(BuildContext context) {
    if(pdfFile!=null)
      return uploadedButton();
    else
      return uploadButton();

  }

  uploadButton(){
    return GestureDetector(
      onTap: ()async{
        FilePickerResult result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf']
        );
        if (result != null) {
          setState(() {
            pdfFile = File(result.files.single.path);
          });
        } else {
          // User canceled the picker
        }


      },
      child: Container(
        height: 55.0,
        width: SizeConfig.screenWidth * 0.90,
        decoration: BoxDecoration(
          //gradient: btnGrad,
            color: bgColorLight,
            borderRadius: BorderRadius.circular(8.0)),
        child: Center(
          child: Text(
              "Upload PDF",
              style: TextStyle(
                  color: authBtnTxtClr,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
        )
        ,
      ),
    );  }

  uploadedButton(){
    return Container(
      height: 55.0,
      width: SizeConfig.screenWidth * 0.90,
      decoration: BoxDecoration(
          color: Colors.green,
          //gradient: btnGrad,
//          color: bgColorLight,
          borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                  "Document Uploaded",
                  style: TextStyle(
                      color: authBtnTxtClr,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  pdfFile = null;
                });
                },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.clear, size: 25,),
              ),
            )

          ],
        ),
      )
      ,
    );
  }
}
