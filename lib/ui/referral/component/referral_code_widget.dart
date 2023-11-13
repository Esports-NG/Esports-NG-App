import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'referral_item.dart';
import 'referral_option.dart';

class ReferralCodeWidget extends StatelessWidget {
  const ReferralCodeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Gap(Get.height * 0.05),
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
        Gap(Get.height * 0.05),
        ReferralOption(
          title: 'Copy Referral Code',
          icon: Icons.copy,
          color: AppColor().primaryColor,
        ),
        Gap(Get.height * 0.02),
        ReferralOption(
          title: 'Share Code',
          icon: Icons.share,
          color: AppColor().primaryBackGroundColor,
          textColor: AppColor().primaryColor,
          border: Border.all(
            color: AppColor().primaryColor,
            width: 0.5,
          ),
        ),
        Gap(Get.height * 0.05),
        ReferralItem(
          title: 'View Referral Earnings',
          onTap: () {},
        ),
        Gap(Get.height * 0.03),
        ReferralItem(
          title: 'View Referral Leader board',
          onTap: () {},
        ),
      ],
    );
  }
}
