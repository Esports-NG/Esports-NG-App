import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class PlayerPositionSelector extends StatefulWidget {
  const PlayerPositionSelector(
      {super.key, required this.controller, required this.players});

  final Rx<PlayerModel?> controller;
  final List<PlayerModel> players;

  @override
  State<PlayerPositionSelector> createState() => _PlayerPositionSelectorState();
}

class _PlayerPositionSelectorState extends State<PlayerPositionSelector> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor().primaryDark,
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
          child: DropdownButton<PlayerModel>(
            dropdownColor: AppColor().primaryDark,
            borderRadius: BorderRadius.circular(10),
            value: widget.controller.value,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColor().lightItemsColor,
            ),
            items: widget.players.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Row(
                  children: [
                    OtherImage(image: value.profile, height: 35, width: 35),
                    const Gap(10),
                    CustomText(
                      title: value.inGameName,
                      color: AppColor().lightItemsColor,
                      fontFamily: 'InterMedium',
                      size: 18,
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              widget.controller.value = value;
            },
            hint: CustomText(
              title: "Select Participant",
              color: AppColor().lightItemsColor,
              fontFamily: 'InterMedium',
              size: 15,
            ),
          ),
        ),
      ),
    );
  }
}
