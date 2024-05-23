import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PageHeaderWidget extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  const PageHeaderWidget({
    super.key,
    this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title: title,
          fontFamily: 'GilroySemiBold',
          size: 16,
          color: AppColor().primaryWhite,
        ),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              CustomText(
                title: 'See all',
                fontFamily: 'GilroyMedium',
                size: 16,
                color: AppColor().primaryLiteColor,
              ),
              Gap(Get.height * 0.01),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColor().primaryLiteColor,
                size: 18,
              ),
            ],
          ),
        )
      ],
    );
  }
}
