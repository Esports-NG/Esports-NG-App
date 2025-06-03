import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentDropdownField extends StatelessWidget {
  final String title;
  final String hint;
  final String? value;
  final List<String> items;
  final bool enableFill;
  final Function(String?) onChanged;
  final Map<String, String>? valueMap;

  const TournamentDropdownField({
    super.key,
    required this.title,
    required this.hint,
    required this.value,
    required this.items,
    required this.enableFill,
    required this.onChanged,
    this.valueMap,
  });

  @override
  Widget build(BuildContext context) {
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
                enableFill ? AppColor().primaryWhite : AppColor().primaryDark,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor().lightItemsColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: AppColor().primaryDark,
              borderRadius: BorderRadius.circular(10),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: enableFill
                    ? AppColor().primaryBackGroundColor
                    : AppColor().lightItemsColor,
              ),
              value: value,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: valueMap != null ? valueMap![item] : item,
                  child: CustomText(
                    title: item,
                    color: enableFill
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
                color: enableFill
                    ? AppColor().primaryBackGroundColor
                    : AppColor().lightItemsColor,
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
