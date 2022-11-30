// ignore_for_file: camel_case_types

import 'package:get/get.dart';

class SearchStateController_B extends GetxController {
  RxString searchState = ''.obs;
  RxString searchContrNO = ''.obs;
  RxString searchBlockCD = ''.obs;
  RxString searchBlock = ''.obs;
  RxString searchBay = ''.obs;
  RxString searchRow = ''.obs;
  RxString searchTier = ''.obs;

  void change(String temp) {
    if (temp.length > 1) {
      searchState.value = temp;
      searchContrNO.value = temp.split('/')[0];
      searchBlockCD.value = temp.split('/')[1];
      searchBlock.value = temp.split('/')[2];
      searchBay.value = temp.split('/')[3];
      searchRow.value = temp.split('/')[4];
      searchTier.value = temp.split('/')[5];
    } else {
      searchState.value = temp;
      searchContrNO.value = temp;
      searchBlockCD.value = temp;
      searchBlock.value = temp;
      searchBay.value = temp;
      searchRow.value = temp;
      searchTier.value = temp;
    }
  }

  void clean() {
    searchState.value = '';
    searchContrNO.value = '';
    searchBlockCD.value = '';
    searchBlock.value = '';
    searchBay.value = '';
    searchRow.value = '';
    searchTier.value = '';
  }
}
