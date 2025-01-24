import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class BrParticipantSelector extends StatefulWidget {
  const BrParticipantSelector(
      {super.key, required this.controller, required this.playerList});
  final MultiSelectController<PlayerModel> controller;
  final List<PlayerModel> playerList;

  @override
  State<BrParticipantSelector> createState() => _BrParticipantSelectorState();
}

class _BrParticipantSelectorState extends State<BrParticipantSelector> {
  @override
  Widget build(BuildContext context) {
    return MultiDropdown<PlayerModel>(
      enabled: true,
      controller: widget.controller,
      itemBuilder: (item, index, onTap) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            children: [
              OtherImage(
                image: item.value.profile,
                height: 40,
                width: 40,
              ),
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
      items: widget.playerList
          .map((e) => DropdownItem(label: e.inGameName!, value: e))
          .toList(),
      dropdownDecoration:
          DropdownDecoration(backgroundColor: AppColor().primaryDark),
      fieldDecoration: FieldDecoration(
          hintText: 'Tap here to select participants',
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

class BrParticipantSelectorTeam extends StatefulWidget {
  const BrParticipantSelectorTeam(
      {super.key, required this.controller, required this.teamList});
  final MultiSelectController<TeamModel> controller;
  final List<TeamModel> teamList;

  @override
  State<BrParticipantSelectorTeam> createState() =>
      _BrParticipantSelectorTeamState();
}

class _BrParticipantSelectorTeamState extends State<BrParticipantSelectorTeam> {
  @override
  Widget build(BuildContext context) {
    return MultiDropdown<TeamModel>(
      enabled: true,
      controller: widget.controller,
      itemBuilder: (item, index, onTap) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            children: [
              OtherImage(
                image: item.value.profilePicture,
                height: 40,
                width: 40,
              ),
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
      items: widget.teamList
          .map((e) => DropdownItem(label: e.name!, value: e))
          .toList(),
      dropdownDecoration:
          DropdownDecoration(backgroundColor: AppColor().primaryDark),
      fieldDecoration: FieldDecoration(
          hintText: 'Tap here to select participants',
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
