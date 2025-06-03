import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/util/colors.dart';

class TournamentSettingsForm extends StatelessWidget {
  final TournamentRepository tournamentController;

  const TournamentSettingsForm({
    super.key,
    required this.tournamentController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tournament Type
            _buildDropdownField(
              title: 'Tournament Type',
              value: tournamentController.tournamentTypeValue.value,
              isEnabled: tournamentController.isTournamentType.value,
              items: ['Single Player', 'Teams'],
              hint: "Tournament Type",
              onChanged: (value) {
                tournamentController.tournamentTypeValue.value =
                    value == "Single Player" ? "solo" : "team";
                tournamentController.tournamentTypeController.text =
                    value == "Single Player" ? "solo" : "team";
                tournamentController.handleTap('tournamentType');
              },
            ),
            Gap(Get.height * 0.02),

            // Knockout Type
            _buildDropdownField(
              title: 'Knockout Type',
              value: tournamentController.knockoutValue.value,
              isEnabled: tournamentController.isKnockout.value,
              items: [
                'Group Stage',
                'Knockout Stage',
                'Group and Knockout Stage',
                'Battle Royale',
              ],
              hint: "Knockout Type",
              onChanged: (value) {
                tournamentController.knockoutValue.value = value;
                tournamentController.knockoutTypeController.text = value!;
                tournamentController.handleTap('knockout');
              },
            ),
            Gap(Get.height * 0.02),

            // Rank Type
            _buildDropdownField(
              title: 'Rank Type',
              value: tournamentController.rankTypeValue.value,
              isEnabled: tournamentController.isRankType.value,
              items: ['Ranked', 'Unranked'],
              hint: "Rank Type",
              onChanged: (value) {
                tournamentController.rankTypeValue.value = value;
                tournamentController.rankTypeController.text = value!;
                tournamentController.handleTap('rankType');
              },
            ),
          ],
        ));
  }

  Widget _buildDropdownField({
    required String title,
    required String? value,
    required bool isEnabled,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: title,
          color: AppColor().primaryWhite,
          textAlign: TextAlign.center,
          fontFamily: 'Inter',
          size: 14,
        ),
        Gap(Get.height * 0.01),
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor:
                isEnabled ? AppColor().primaryWhite : AppColor().primaryDark,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColor().lightItemsColor, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: AppColor().primaryDark,
              borderRadius: BorderRadius.circular(10),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: isEnabled
                    ? AppColor().primaryBackGroundColor
                    : AppColor().lightItemsColor,
              ),
              value: value,
              items: items.map((String item) {
                String dropdownValue = item;
                if (title == 'Tournament Type') {
                  dropdownValue = item == "Single Player" ? "solo" : "team";
                }
                return DropdownMenuItem<String>(
                  value: dropdownValue,
                  child: CustomText(
                    title: item,
                    color: isEnabled
                        ? AppColor().primaryBackGroundColor
                        : AppColor().lightItemsColor,
                    fontFamily: 'InterMedium',
                    size: 15,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              hint: CustomText(
                title: hint,
                color: AppColor().lightItemsColor,
                fontFamily: 'InterMedium',
                size: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
