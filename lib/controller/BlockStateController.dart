import 'package:get/get.dart';

class BlockStateController extends GetxController {
  RxString blockCD = ''.obs;

  void change(String temp) {
      blockCD.value = temp;
  }
}
