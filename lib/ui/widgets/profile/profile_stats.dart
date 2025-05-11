import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';

class ProfileStats extends StatelessWidget {
  final int followersCount;
  final int followingCount;

  const ProfileStats({
    Key? key,
    required this.followersCount,
    required this.followingCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
                title: followingCount.toString(),
                size: 18,
                fontFamily: 'InterBold',
                color: AppColor().primaryWhite),
            Gap(Get.height * 0.01),
            CustomText(
                title: 'Following',
                size: 14,
                fontFamily: 'Inter',
                color: AppColor().greyEight),
          ],
        ),
        Gap(Get.height * 0.04),
        Container(
            height: Get.height * 0.03,
            width: Get.width * 0.005,
            color: AppColor().greyEight),
        Gap(Get.height * 0.04),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
                title: followersCount.toString(),
                size: 18,
                fontFamily: 'InterBold',
                color: AppColor().primaryWhite),
            Gap(Get.height * 0.01),
            CustomText(
                title: 'Followers',
                size: 14,
                fontFamily: 'Inter',
                color: AppColor().greyEight),
          ],
        ),
      ],
    );
  }
}
