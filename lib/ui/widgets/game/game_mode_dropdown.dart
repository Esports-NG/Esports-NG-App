import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class GameModeDropDown extends StatefulWidget {
  const GameModeDropDown(
      {super.key,
      this.enableFill,
      this.toggleArrow,
      this.handleTap,
      required this.gameModeValue,
      required this.gameModeController,
      required this.gameValue});
  final bool? enableFill;
  final bool? toggleArrow;
  final Rx<String?> gameModeValue;
  final Rx<GamePlayed?> gameValue;
  final MultiSelectController<int> gameModeController;
  final dynamic handleTap;

  @override
  State<GameModeDropDown> createState() => _GameModeDropDownState();
}

class _GameModeDropDownState extends State<GameModeDropDown> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MultiDropdown<int>(
        // singleSelect: true,

        controller: widget.gameModeController,
        onSelectionChange: (selectedItems) => print(selectedItems),
        items: widget.gameValue.value == null
            ? []
            : widget.gameValue.value!.gameModes!
                .map((e) => DropdownItem(label: e.name!, value: e.id!))
                .toList(),
        enabled: true,
        dropdownDecoration:
            DropdownDecoration(backgroundColor: AppColor().primaryDark),
        fieldDecoration: FieldDecoration(
            hintText: 'Select Game Mode',
            animateSuffixIcon: true,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColor().lightItemsColor,
            ),
            hintStyle: TextStyle(
                fontFamily: "InterMedium", color: AppColor().lightItemsColor),
            showClearIcon: false,
            backgroundColor: AppColor().primaryDark),
        chipDecoration: ChipDecoration(
            wrap: false,
            backgroundColor: AppColor().secondaryGreenColor,
            labelStyle: TextStyle(
                fontFamily: "InterMedium",
                color: AppColor().primaryBackGroundColor)),
        dropdownItemDecoration: DropdownItemDecoration(
            selectedBackgroundColor: Colors.transparent,
            textColor: AppColor().lightItemsColor,
            selectedTextColor: AppColor().primaryColor),
      ),
    );
  }
}
