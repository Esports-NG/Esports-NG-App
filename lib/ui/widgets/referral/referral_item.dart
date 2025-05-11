import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ReferralItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  const ReferralItem({super.key, this.onTap, this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CustomText(
            title: title,
            color: AppColor().primaryColor,
            size: 14,
            underline: TextDecoration.underline,
            fontFamily: 'InterMedium',
          ),
          Gap(Get.height * 0.01),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColor().primaryColor,
            size: 17,
          )
        ],
      ),
    );
  }
}
