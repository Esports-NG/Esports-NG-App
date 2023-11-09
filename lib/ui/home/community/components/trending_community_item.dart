import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TrendingCommunityItem extends StatelessWidget {
  final Posts item;
  final int? index;
  const TrendingCommunityItem({
    super.key,
    required this.item,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.02),
      height: Get.height * 0.4,
      width: Get.width * 0.55,
      decoration: BoxDecoration(
        color: AppColor().bgDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().greySix,
        ),
        image: DecorationImage(
          image: AssetImage(item.image!),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: Get.height * 0.07,
                width: Get.height * 0.07,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // border: Border.all(
                  //   color: AppColor().greySix,
                  // ),
                  image: DecorationImage(
                    image: AssetImage(item.pImage!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                child: SvgPicture.asset(
                  'assets/images/svg/check_badge.svg',
                  height: Get.height * 0.025,
                  width: Get.height * 0.025,
                ),
              ),
            ],
          ),
          Gap(Get.height * 0.01),
          CustomText(
            title: item.name,
            size: 14,
            fontFamily: 'GilroySemiBold',
            weight: FontWeight.w400,
            color: AppColor().primaryWhite,
            textAlign: TextAlign.center,
          ),
          Gap(Get.height * 0.01),
          CustomText(
            title: item.uName,
            size: 12,
            fontFamily: 'GilroyRegular',
            weight: FontWeight.w400,
            color: AppColor().greySix,
          ),
          if (index == 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(Get.height * 0.02),
                CustomText(
                  title:
                      'This team is made up of skilled gamers who are\npassionate about the Attack on Titan series.',
                  size: 12,
                  fontFamily: 'GilroyMedium',
                  weight: FontWeight.w400,
                  color: AppColor().greySix,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          Gap(Get.height * 0.02),
          Container(
            padding: EdgeInsets.all(Get.height * 0.015),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: AppColor().primaryColor,
              ),
            ),
            child: Center(
              child: CustomText(
                title: 'Follow',
                size: 14,
                fontFamily: 'GilroyMedium',
                weight: FontWeight.w400,
                color: AppColor().primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
