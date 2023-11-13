import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ReferralInfo extends StatelessWidget {
  const ReferralInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(Get.height * 0.04),
        Center(
          child: Container(
            height: Get.height * 0.25,
            width: Get.height * 0.25,
            padding: EdgeInsets.all(Get.height * 0.03),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor().referralC,
            ),
            child: Image.asset(
              'assets/images/png/referral.png',
              height: Get.height * 0.17,
            ),
          ),
        ),
        Gap(Get.height * 0.04),
        CustomText(
          title: 'Invite Friends and Earn!',
          color: AppColor().greyTwo,
          weight: FontWeight.w400,
          size: Get.height * 0.018,
          fontFamily: 'GilroySemiBold',
        ),
        Gap(Get.height * 0.01),
        CustomText(
          title:
              'Refer users to Esports NG and Earn N500 every time a user you referred subscribes. You also stand a chance to win other amazing prizes.',
          color: AppColor().greySix,
          weight: FontWeight.w400,
          height: 1.5,
          size: Get.height * 0.016,
          fontFamily: 'GilroyRegular',
        ),
        Gap(Get.height * 0.04),
      ],
    );
  }
}
