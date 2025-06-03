import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentDatePickerField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final bool hasText;
  final FocusNode focusNode;
  final VoidCallback onTap;

  const TournamentDatePickerField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    required this.hasText,
    required this.focusNode,
    required this.onTap,
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
        InkWell(
          onTap: onTap,
          child: CustomTextField(
            hint: hint,
            enabled: false,
            textEditingController: controller,
            hasText: hasText,
            focusNode: focusNode,
            onSubmited: (_) => focusNode.unfocus(),
            onChanged: (value) {
              // Handle change if needed
            },
            suffixIcon: Icon(
              CupertinoIcons.calendar,
              color: hasText
                  ? AppColor().primaryBackGroundColor
                  : AppColor().lightItemsColor,
            ),
          ),
        ),
      ],
    );
  }
}
