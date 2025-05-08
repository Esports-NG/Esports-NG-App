import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class TeamPositionSelector extends StatefulWidget {
  const TeamPositionSelector(
      {super.key, required this.controller, required this.teams});

  final Rx<TeamModel?> controller;
  final List<TeamModel> teams;

  @override
  State<TeamPositionSelector> createState() => _TeamPositionSelectorState();
}

class _TeamPositionSelectorState extends State<TeamPositionSelector> {
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
          child: DropdownButton<TeamModel>(
            dropdownColor: AppColor().primaryDark,
            borderRadius: BorderRadius.circular(10),
            value: widget.controller.value,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColor().lightItemsColor,
            ),
            items: widget.teams.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Row(
                  children: [
                    Image.network(
                      "${ApiLink.imageUrl}${value.profilePicture}",
                      height: 35,
                      fit: BoxFit.contain,
                    ),
                    const Gap(10),
                    CustomText(
                      title: value.name,
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
