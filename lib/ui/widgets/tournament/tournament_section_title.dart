import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';

class TournamentSectionTitle extends StatelessWidget {
  final String title;

  const TournamentSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      decoration: BoxDecoration(
        color: AppColor().primaryLightColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        title: title,
        color: AppColor().primaryWhite,
        fontFamily: 'InterSemiBold',
        size: 16,
        textAlign: TextAlign.center,
      ),
    );
  }
}
