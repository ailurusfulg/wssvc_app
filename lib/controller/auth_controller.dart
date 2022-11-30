// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../api/api.dart';
import '../model/models.dart';

class AuthController extends GetxController {
  // static AuthController to = Get.find();
  // TextEditingController nameController = TextEditingController();
  late TextEditingController idController;
  late TextEditingController pwController;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rxn<UserModel> loginUser = Rxn<UserModel>();
  Rxn<UserModel> storeUser = Rxn<UserModel>();
  final RxBool admin = false.obs;
  static final storage = FlutterSecureStorage();

  @override
  void onInit() {
    idController = TextEditingController();
    pwController = TextEditingController();
    super.onInit();
  }

  // @override
  // void onReady() async {
  //   //run every time auth state changes
  //   ever(loginUser, handleAuthChanged);

  //   loginUser.bindStream(user);

  //   super.onReady();
  // }

  void apiLogin() async {
    Get.dialog(Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    APICheckLogin apiService = APICheckLogin();
    List<String> sParams = [idController.text, pwController.text];
    apiService.getSelect("CHECKLOGIN_S2", sParams).then((value2) {
      if (value2.result.elementAt(0).sResult == "OK") {
        storage.write(
          key: "login",
          value:
              "id " + idController.text + " " + "password " + pwController.text,
        );
        Get.back();
        Get.offNamed('selectWC');
      }
      // else if (value2.result.elementAt(0).sResult == "PWD") {
      //   // show("비밀번호가 일치하지 않습니다."); // 비밀번호 불일치
      //   return;
      // } else if (value2.result.elementAt(0).sResult == "USER") {

      // }
    });
  }

  @override
  void onClose() {
    idController.dispose();
    pwController.dispose();
    super.onClose();
  }
}
