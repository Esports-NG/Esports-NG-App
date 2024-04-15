import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ReferralOption extends StatelessWidget {
  final String? title;
  final Color? color, textColor;
  final BoxBorder? border;
  final IconData? icon;
  const ReferralOption(
      {super.key,
      this.title,
      this.color,
      this.textColor,
      this.border,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.06,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: color,
          border: border ?? Border.all()),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor ?? AppColor().greyTwo,
            ),
            Gap(Get.height * 0.01),
            CustomText(
              title: title,
              color: textColor ?? AppColor().greyTwo,
              weight: FontWeight.w400,
              size: Get.height * 0.016,
              fontFamily: 'GilroySemiBold',
            ),
          ],
        ),
      ),
    );
  }
}
