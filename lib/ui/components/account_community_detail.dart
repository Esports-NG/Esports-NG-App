// ignore_for_file: deprecated_member_use

import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/team_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountCommunityDetail extends StatelessWidget {
  final CommunityModel item;
  const AccountCommunityDetail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: Get.height * 0.15,
                width: Get.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/png/community_cover.png'),
                      fit: BoxFit.cover,
                      opacity: 0.2),
                ),
              ),
              Positioned(
                top: Get.height * 0.1,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    item.cover == null
                        ? Container(
                            height: Get.height * 0.1,
                            width: Get.height * 0.1,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/svg/people.svg',
                            ),
                          )
                        : OtherImage(
                            itemSize: Get.height * 0.1,
                            image: '${ApiLink.imageUrl}${item.cover}'),
                    Positioned(
                      child: SvgPicture.asset(
                        'assets/images/svg/check_badge.svg',
                        height: Get.height * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GoBackButton(onPressed: () => Get.back()),
                    Padding(
                      padding: EdgeInsets.only(right: Get.height * 0.02),
                      child: InkWell(
                        child: Icon(Icons.settings,
                            color: AppColor().primaryWhite),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(Get.height * 0.07),
          CustomText(
              title: item.name,
              weight: FontWeight.w500,
              size: Get.height * 0.02,
              fontFamily: 'GilroyBold',
              color: AppColor().primaryWhite),
          Gap(Get.height * 0.01),
          CustomText(
              title: 'No Member',
              weight: FontWeight.w400,
              size: Get.height * 0.017,
              fontFamily: 'GilroyRegular',
              color: AppColor().greyEight),
          Gap(Get.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                      title: '0',
                      weight: FontWeight.w500,
                      size: Get.height * 0.02,
                      fontFamily: 'GilroyBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: 'Following',
                      weight: FontWeight.w400,
                      size: Get.height * 0.017,
                      fontFamily: 'GilroyRegular',
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
                      title: '0',
                      weight: FontWeight.w500,
                      size: Get.height * 0.02,
                      fontFamily: 'GilroyBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: 'Followers',
                      weight: FontWeight.w400,
                      size: Get.height * 0.017,
                      fontFamily: 'GilroyRegular',
                      color: AppColor().greyEight),
                ],
              ),
            ],
          ),
          Gap(Get.height * 0.04),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomFillOption(
                        onTap: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/images/svg/account_icon.svg',
                                  height: Get.height * 0.015,
                                  color: AppColor().primaryWhite),
                              Gap(Get.height * 0.01),
                              CustomText(
                                  title: 'Follow',
                                  weight: FontWeight.w400,
                                  size: Get.height * 0.017,
                                  fontFamily: 'GilroyRegular',
                                  color: AppColor().primaryWhite),
                            ]),
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Expanded(
                      child: CustomFillOption(
                        buttonColor:
                            AppColor().primaryBackGroundColor.withOpacity(0.7),
                        borderColor: AppColor().greyEight,
                        onTap: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sms_outlined,
                                color: AppColor().primaryWhite,
                                size: Get.height * 0.015,
                              ),
                              Gap(Get.height * 0.01),
                              CustomText(
                                  title: 'Message',
                                  weight: FontWeight.w400,
                                  size: Get.height * 0.017,
                                  fontFamily: 'GilroyRegular',
                                  color: AppColor().primaryWhite),
                              Gap(Get.height * 0.01),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColor().primaryColor,
                                size: Get.height * 0.015,
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                Gap(Get.height * 0.02),
                CustomFillOption(
                  buttonColor:
                      AppColor().primaryBackGroundColor.withOpacity(0.7),
                  borderColor: AppColor().greyEight,
                  onTap: () {},
                  child: CustomText(
                      title: 'Apply to team',
                      weight: FontWeight.w400,
                      size: Get.height * 0.017,
                      fontFamily: 'GilroyRegular',
                      color: AppColor().primaryWhite),
                ),
                Gap(Get.height * 0.04),
                CustomText(
                    title:
                        'This team is made up of skilled gamers who are passionate about the Attack on Titan series.',
                    weight: FontWeight.w400,
                    size: Get.height * 0.015,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.center,
                    height: 1.5,
                    color: AppColor().greyEight),
                Gap(Get.height * 0.02),
                CustomText(
                    title: 'See full profile',
                    weight: FontWeight.w400,
                    size: Get.height * 0.017,
                    fontFamily: 'GilroyMedium',
                    underline: TextDecoration.underline,
                    color: AppColor().primaryColor),
              ],
            ),
          ),
          Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.05,
            thickness: 4,
          ),
        ],
      )),
    );
  }
}
