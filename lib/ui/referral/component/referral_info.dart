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
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(blurRadius: 120, color: AppColor().greySix)
                  ])),
            ),
            Center(
              child: Image.asset(
                'assets/images/png/gift.png',
                // height: Get.height * 0.17,
              ),
            ),
          ],
        ),
        Gap(Get.height * 0.04),
        Center(
          child: CustomText(
            textAlign: TextAlign.center,
            title: 'Invite Friends and Earn!',
            color: AppColor().greyTwo,
            size: Get.height * 0.025,
            fontFamily: 'GilroySemiBold',
          ),
        ),
        Gap(Get.height * 0.01),
        CustomText(
          textAlign: TextAlign.center,
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
