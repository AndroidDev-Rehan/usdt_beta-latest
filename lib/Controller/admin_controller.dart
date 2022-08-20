import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:usdt_beta/Model/variable_model.dart';
import 'package:usdt_beta/Services/database.dart';

class AdminController extends GetxController {

  Rx<VariablesModel> adminVariable = VariablesModel().obs;
  VariablesModel get variablesModel => adminVariable.value;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Rx<VariablesModel> vModel = VariablesModel().obs;
  // VariablesModel get vari => vModel.value;
  // set vari(VariablesModel value) => this.vModel.value = value;
  // // @override
  // // void onInit() {
  // //   getVari();
  // //   super.onInit();
  // // }
  //
  // void getVari() async {
  //   vari = await MyDatabase().getVariValues('s0bkpSrG6x9gwvdzNM2n');
  // }

  ///TODO GETTING INFO ABOUT WHICH COPY TRADES ARE ENABLED

  @override
  void onInit() {
    adminVariable.bindStream(getAdminVariables());
    super.onInit();
  }

  Stream<VariablesModel> getAdminVariables(){
    return firebaseFirestore
        .collection('Admin')
        .doc('s0bkpSrG6x9gwvdzNM2n')
        .snapshots()
        .map((event) => VariablesModel.fromDocumentSnapshot(event));
  }

}
