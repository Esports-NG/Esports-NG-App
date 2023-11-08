import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LatestNewsItem extends StatelessWidget {
  final Posts item;
  const LatestNewsItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.8,
      height: Get.height * 0.4,
      padding: EdgeInsets.all(Get.height * 0.02),
      decoration: BoxDecoration(
        color: AppColor().bgDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().greySix,
        ),
        gradient: LinearGradient(
          colors: [
            AppColor().bgDark,
            AppColor().primaryBackGroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: AssetImage(item.image!),
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(Get.height * 0.01),
          CustomText(
            title: item.name,
            size: Get.height * 0.018,
            fontFamily: 'GilroySemiBold',
            weight: FontWeight.w400,
            color: AppColor().primaryWhite,
          ),
          Gap(Get.height * 0.01),
          CustomText(
            title: item.uName,
            size: Get.height * 0.016,
            fontFamily: 'GilroyRegular',
            weight: FontWeight.w400,
            color: AppColor().greySix,
          ),
          Divider(
              color: AppColor().primaryWhite.withOpacity(0.1), thickness: 1),
          CustomText(
            title: item.details,
            size: Get.height * 0.016,
            fontFamily: 'GilroyRegular',
            weight: FontWeight.w400,
            color: AppColor().primaryWhite,
          ),
          Gap(Get.height * 0.01),
          Row(
            children: [
              CustomText(
                title: 'By',
                size: Get.height * 0.016,
                fontFamily: 'GilroyRegular',
                weight: FontWeight.w400,
                color: AppColor().greySix,
              ),
              Gap(Get.height * 0.01),
              CustomText(
                title: item.postedBy,
                size: Get.height * 0.016,
                fontFamily: 'GilroySemiBold',
                weight: FontWeight.w400,
                color: AppColor().primaryGreen,
              ),
              Gap(Get.height * 0.01),
              const SmallCircle(),
              Gap(Get.height * 0.01),
              CustomText(
                title: item.time,
                size: Get.height * 0.016,
                fontFamily: 'GilroyMedium',
                weight: FontWeight.w400,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
          // Gap(Get.height * 0.02),
          // Container(
          //   padding: EdgeInsets.all(Get.height * 0.015),
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(40),
          //     border: Border.all(
          //       color: AppColor().primaryColor,
          //     ),
          //   ),
          //   child: Center(
          //     child: CustomText(
          //       title: 'Follow',
          //       size: 14,
          //       fontFamily: 'GilroyMedium',
          //       weight: FontWeight.w400,
          //       color: AppColor().primaryColor,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
