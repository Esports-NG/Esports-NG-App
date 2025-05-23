import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class GameSelectionChip extends StatefulWidget {
  const GameSelectionChip(
      {super.key,
      required this.gameList,
      required this.controller,
      this.postCreation,
      this.teamApplication});
  final bool? postCreation;
  final bool? teamApplication;
  final MultiSelectController<GamePlayed> controller;
  final List<GamePlayed> gameList;

  @override
  State<GameSelectionChip> createState() => _GameSelectionChipState();
}

class _GameSelectionChipState extends State<GameSelectionChip> {
  final teamController = Get.put(TeamRepository());
  final gameController = Get.put(GamesRepository());
  final postController = Get.put(PostRepository());

  @override
  Widget build(BuildContext context) {
    return MultiDropdown<GamePlayed>(
      enabled: true,
      controller: widget.controller,
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
                          item.value.profilePicture!,
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
      searchDecoration: SearchFieldDecoration(
          searchIcon: Icon(
            CupertinoIcons.search,
            color: AppColor().lightItemsColor,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColor().bgDark))),
      items: widget.gameList
          .map((e) => DropdownItem(label: e.name!, value: e))
          .toList(),
      dropdownDecoration:
          DropdownDecoration(backgroundColor: AppColor().primaryDark),
      fieldDecoration: FieldDecoration(
          hintText: 'Tap here to add games',
          animateSuffixIcon: true,
          suffixIcon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColor().lightItemsColor,
          ),
          hintStyle: TextStyle(
              fontFamily: "InterMedium", color: AppColor().lightItemsColor),
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
    );
  }
}
