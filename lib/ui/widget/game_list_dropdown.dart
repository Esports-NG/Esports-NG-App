import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameDropdown extends StatefulWidget {
  const GameDropdown(
      {super.key,
      this.enableFill,
      this.toggleArrow,
      required this.gameValue,
      this.handleTap,
      required this.gamePlayedController});
  final bool? enableFill;
  final bool? toggleArrow;
  final Rx<GamePlayed?> gameValue;
  final TextEditingController gamePlayedController;
  final dynamic handleTap;

  @override
  State<GameDropdown> createState() => _GameDropdownState();
}

class _GameDropdownState extends State<GameDropdown> {
  final TextEditingController gameSearchController = TextEditingController();
  final gameController = Get.put(GamesRepository());

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
          child: DropdownButton<GamePlayed>(
            isExpanded: true,
            elevation: 0,
            icon: Icon(Icons.keyboard_arrow_down,
                color: widget.toggleArrow == true
                    ? AppColor().primaryBackGroundColor
                    : AppColor().lightItemsColor),
            value: widget.gameValue.value,
            dropdownColor: AppColor().darkGrey,
            borderRadius: BorderRadius.circular(10),
            items: [
              DropdownMenuItem<GamePlayed>(
                enabled: false,
                child: SizedBox(
                  // height: Get.height * 0.05,
                  // width: Get.width,
                  child: CustomTextField(
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColor().greySix,
                    ),
                    hint: "Search Games",
                    textEditingController: gameSearchController,
                  ),
                ),
              ),
              ...gameController.allGames
                  .map((element) => DropdownMenuItem<GamePlayed>(
                      value: element,
                      child: CustomText(
                        title: element.name,
                        color: AppColor().primaryWhite,
                        size: 12,
                      )))
                  .toList()
            ],
            onChanged: (value) {
              widget.gameValue.value = value!;
              widget.gamePlayedController.text = value.id.toString();
              widget.handleTap;
            },
            hint: CustomText(
              title: "Game",
              color: widget.enableFill == true
                  ? AppColor().primaryBackGroundColor
                  : AppColor().lightItemsColor,
              fontFamily: 'GilroyMedium',
              weight: FontWeight.w400,
              size: 13,
            ),
          ),
        ),
      ),
    );
  }
}
