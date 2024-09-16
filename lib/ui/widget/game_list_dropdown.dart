import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class GameDropdown extends StatefulWidget {
  const GameDropdown({
    super.key,
    this.enableFill,
    this.toggleArrow,
    required this.gameValue,
    this.handleTap,
    this.gameList,
  });
  final bool? enableFill;
  final bool? toggleArrow;
  final Rx<GamePlayed?> gameValue;
  final dynamic handleTap;
  final List<GamePlayed>? gameList;

  @override
  State<GameDropdown> createState() => _GameDropdownState();
}

class _GameDropdownState extends State<GameDropdown> {
  final gameController = Get.put(GamesRepository());
  final eventController = Get.put(EventRepository());
  final LayerLink _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<GamePlayed>(
      itemBuilder: (item, index, onTap) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "${ApiLink.imageUrl}${item.value.profilePicture!}",
                        )),
                  )),
              const Gap(16),
              CustomText(
                title: item.label,
                fontFamily: "InterMedium",
                color: item.selected
                    ? AppColor().primaryColor
                    : AppColor().lightItemsColor,
              ),
              const Spacer(),
              Visibility(
                  visible: item.selected,
                  child: Icon(
                    CupertinoIcons.checkmark_alt,
                    color: AppColor().primaryColor,
                  ))
            ],
          ),
        ),
      ),
      searchEnabled: true,
      selectedItemBuilder: (item) => CustomText(
        title: item.label,
        color: AppColor().primaryWhite,
      ),
      singleSelect: true,
      searchDecoration: SearchFieldDecoration(
          searchIcon: Icon(
            CupertinoIcons.search,
            color: AppColor().lightItemsColor,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().bgDark))),
      onSelectionChange: (selectedItems) {
        widget.gameValue.value = selectedItems[0];
      },
      items: (widget.gameList ?? gameController.allGames)
          .map((e) => DropdownItem(label: e.name!, value: e))
          .toList(),
      dropdownDecoration:
          DropdownDecoration(backgroundColor: AppColor().primaryDark),
      fieldDecoration: FieldDecoration(
          hintText: 'Select Game',
          animateSuffixIcon: true,
          suffixIcon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColor().lightItemsColor,
          ),
          hintStyle: TextStyle(
              fontFamily: "InterMedium", color: AppColor().lightItemsColor),
          backgroundColor: AppColor().primaryDark),
      chipDecoration: ChipDecoration(
          backgroundColor: AppColor().secondaryGreenColor,
          labelStyle: const TextStyle(
            fontFamily: "InterMedium",
          )),
      dropdownItemDecoration: DropdownItemDecoration(
          selectedBackgroundColor: Colors.transparent,
          textColor: AppColor().lightItemsColor,
          selectedTextColor: AppColor().primaryColor),
    );
  }
}
