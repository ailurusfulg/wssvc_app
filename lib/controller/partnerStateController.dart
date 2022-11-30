import 'package:get/get.dart';

class PartnerStateController extends GetxController {
  RxString partnerState = ''.obs;
  RxString partnerCode = ''.obs;
  RxString partnerName = ''.obs;

  void change(String temp) {
    if (temp.length > 1) {
      partnerState.value = temp;
      partnerCode.value = temp.split('/')[0];
      partnerName.value = temp.split('/')[1];
    } else {
      partnerState.value = temp;
       partnerCode.value = temp;
      partnerName.value = temp;
    }
  }

  void clean() {
      partnerState.value = '';
      partnerCode.value = '';
      partnerName.value = '';
    }
}
