import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ReferralWidget extends StatelessWidget {
  const ReferralWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            'assets/images/png/referral.png',
            height: Get.height * 0.4,
          ),
        ),
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
        Gap(Get.height * 0.01),
        Row(
          children: [
            options(
              title: 'Copy Referral Link',
              icon: CupertinoIcons.link,
              color: AppColor().primaryColor,
            ),
            Gap(Get.height * 0.02),
            options(
              title: 'Share',
              icon: Icons.share,
              color: AppColor().primaryBackGroundColor,
              border: Border.all(
                color: AppColor().lightItemsColor.withOpacity(0.3),
                width: 0.5,
              ),
            ),
          ],
        ),
        Gap(Get.height * 0.05),
        CustomText(
          title: 'My Referral Earnings',
          color: AppColor().greyTwo,
          weight: FontWeight.w400,
          size: Get.height * 0.018,
          fontFamily: 'GilroySemiBold',
        ),
        Gap(Get.height * 0.01),
        Container(
          padding: EdgeInsets.all(Get.height * 0.02),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor().referral,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            metrics(title: 'Subscribed', no: '3'),
            Container(
              width: 1,
              height: Get.height * 0.08,
              color: AppColor().greyTwo,
              // width: 1,
            ),
            metrics(title: 'Referrals', no: '11')
          ]),
        )
      ],
    );
  }

  Column metrics({String? title, no}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          title: title,
          color: AppColor().greyTwo,
          weight: FontWeight.w400,
          size: Get.height * 0.018,
          fontFamily: 'GilroyMedium',
        ),
        Gap(Get.height * 0.02),
        CustomText(
          title: no,
          color: AppColor().greyTwo,
          weight: FontWeight.w400,
          size: Get.height * 0.036,
          fontFamily: 'GilroyMedium',
        ),
      ],
    );
  }

  Expanded options({
    String? title,
    Color? color,
    BoxBorder? border,
    IconData? icon,
  }) {
    return Expanded(
      child: Container(
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
                color: AppColor().greyTwo,
              ),
              Gap(Get.height * 0.01),
              CustomText(
                title: title,
                color: AppColor().greyTwo,
                weight: FontWeight.w400,
                size: Get.height * 0.016,
                fontFamily: 'GilroySemiBold',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
