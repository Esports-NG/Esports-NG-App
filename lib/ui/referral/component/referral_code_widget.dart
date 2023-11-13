import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
        options(
          title: 'Copy Referral Code',
          icon: Icons.copy,
          color: AppColor().primaryColor,
        ),
        Gap(Get.height * 0.02),
        options(
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
        referralItem(
          title: 'View Referral Earnings',
          onTap: () {},
        ),
        Gap(Get.height * 0.03),
        referralItem(
          title: 'View Referral Leader board',
          onTap: () {},
        ),
      ],
    );
  }

  referralItem({VoidCallback? onTap, String? title}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CustomText(
            title: title,
            color: AppColor().primaryColor,
            weight: FontWeight.w400,
            size: Get.height * 0.018,
            underline: TextDecoration.underline,
            fontFamily: 'GilroyMedium',
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

  options({
    String? title,
    Color? color,
    textColor,
    BoxBorder? border,
    IconData? icon,
  }) {
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
