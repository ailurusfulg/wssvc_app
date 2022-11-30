// # 드롭다운 버튼
// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dropdown_button_controller.dart';

class DropdownButtonWidget extends GetView<DropdownButtonController> {
  final bool isExpanded;
  DropdownButtonWidget({Key? key, this.isExpanded = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButton(
        value: controller.currentItem.value.index,
        onChanged: (int? value) {
          controller.changeDropDownMenu(value);
        },
        underline: Container(),
        isExpanded: isExpanded,
        items: DropdownMenu.values
            .map(
              (menu) => DropdownMenuItem(
                value: menu.index,
                child: Text(menu.name),
              ),
            )
            .toList(),
      ),
    );
  }
}
