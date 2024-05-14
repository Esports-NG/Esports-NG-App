import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final TextEditingController gameModeController;
  final dynamic handleTap;

  @override
  State<GameModeDropDown> createState() => _GameModeDropDownState();
}

class _GameModeDropDownState extends State<GameModeDropDown> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.enableFill == true
              ? AppColor().primaryWhite
              : AppColor().bgDark,
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColor().lightItemsColor, width: 1),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
        child: DropdownButtonHideUnderline(
          child: widget.gameValue.value != null
              ? DropdownButton<String>(
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: widget.enableFill == true
                          ? AppColor().primaryBackGroundColor
                          : AppColor().lightItemsColor),
                  value: widget.gameModeValue.value,
                  items: widget.gameValue.value!.gameModes!.map((element) {
                    return DropdownMenuItem<String>(
                      value: element.name,
                      child: CustomText(
                        title: element.name,
                        color: widget.enableFill == true
                            ? AppColor().primaryBackGroundColor
                            : AppColor().lightItemsColor,
                        fontFamily: 'GilroyMedium',
                        weight: FontWeight.w400,
                        size: 13,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    widget.gameModeValue.value = value;
                    debugPrint(value);
                    widget.gameModeController.text = value!;
                    widget.handleTap;
                  },
                  hint: CustomText(
                    title: "Game Mode",
                    color: widget.enableFill == true
                        ? AppColor().primaryBackGroundColor
                        : AppColor().lightItemsColor,
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.w400,
                    size: 13,
                  ),
                )
              : CustomText(
                  title: "Select a Game",
                  color: AppColor().primaryWhite,
                ),
        ),
      ),
    );
  }
}
