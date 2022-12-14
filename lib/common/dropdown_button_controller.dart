import 'package:get/get.dart';

enum DropdownMenu { DEFAULT, VALUE1, VALUE2 }

extension DropdownMenusExtension on DropdownMenu {
  String get name {
    switch (this) {
      case DropdownMenu.DEFAULT:
        return "기본메뉴";
      case DropdownMenu.VALUE1:
        return "메뉴1";
      case DropdownMenu.VALUE2:
        return "메뉴2";
    }
  }
}

class DropdownButtonController extends GetxController {
  static DropdownButtonController get to => Get.find();
  Rx<DropdownMenu> currentItem = DropdownMenu.DEFAULT.obs;

  void changeDropDownMenu(int? itemIndex) {
    var selectedItem =
        DropdownMenu.values.where((menu) => menu.index == itemIndex).first;
    currentItem(selectedItem);
  }
}
