// ignore_for_file: deprecated_member_use

import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColor().primaryBackGroundColor,
      currentIndex: selectedIndex,
      onTap: onTap,
      selectedLabelStyle: TextStyle(
        color: AppColor().primaryColor,
        fontFamily: 'GilroyMedium',
        fontWeight: FontWeight.normal,
        fontSize: Get.height * 0.015,
      ),
      unselectedLabelStyle: TextStyle(
        color: AppColor().lightItemsColor,
        fontFamily: 'GilroyMedium',
        fontWeight: FontWeight.normal,
        fontSize: Get.height * 0.015,
      ),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColor().primaryColor,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
            icon: Column(
              children: [
                selectedIndex == 0
                    ? Container(
                        height: 3,
                        width: Get.height * 0.07,
                        color: AppColor().primaryColor,
                      )
                    : Container(),
                Gap(Get.height * 0.015),
                SvgPicture.asset(
                  'assets/images/svg/home_icon.svg',
                  height: Get.height * 0.025,
                  color: selectedIndex == 0
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                ),
                Gap(Get.height * 0.01),
                CustomText(
                  title: 'Home',
                  fontFamily: 'GilroyMedium',
                  weight: FontWeight.normal,
                  size: Get.height * 0.015,
                  color: selectedIndex == 0
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                ),
              ],
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(right: Get.height * 0.03),
              child: Column(
                children: [
                  selectedIndex == 1
                      ? Container(
                          height: 3,
                          width: Get.height * 0.07,
                          color: AppColor().primaryColor,
                        )
                      : Container(),
                  Gap(Get.height * 0.015),
                  SvgPicture.asset(
                    'assets/images/svg/event_icon.svg',
                    height: Get.height * 0.025,
                    color: selectedIndex == 1
                        ? AppColor().primaryColor
                        : AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'Events',
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.normal,
                    size: Get.height * 0.015,
                    color: selectedIndex == 1
                        ? AppColor().primaryColor
                        : AppColor().lightItemsColor,
                  ),
                ],
              ),
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(left: Get.height * 0.03),
              child: Column(
                children: [
                  selectedIndex == 2
                      ? Container(
                          height: 3,
                          width: Get.height * 0.07,
                          color: AppColor().primaryColor,
                        )
                      : Container(),
                  Gap(Get.height * 0.015),
                  SvgPicture.asset(
                    'assets/images/svg/community_icon.svg',
                    height: Get.height * 0.025,
                    color: selectedIndex == 2
                        ? AppColor().primaryColor
                        : AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'Community',
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.normal,
                    size: Get.height * 0.015,
                    color: selectedIndex == 2
                        ? AppColor().primaryColor
                        : AppColor().lightItemsColor,
                  ),
                ],
              ),
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Column(
              children: [
                selectedIndex == 3
                    ? Container(
                        height: 3,
                        width: Get.height * 0.07,
                        color: AppColor().primaryColor,
                      )
                    : Container(),
                Gap(Get.height * 0.015),
                SvgPicture.asset(
                  'assets/images/svg/account_icon.svg',
                  height: Get.height * 0.025,
                  color: selectedIndex == 3
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                ),
                Gap(Get.height * 0.01),
                CustomText(
                  title: 'Account',
                  fontFamily: 'GilroyMedium',
                  weight: FontWeight.normal,
                  size: Get.height * 0.015,
                  color: selectedIndex == 3
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                ),
              ],
            ),
            label: ''),
      ],
    );
  }
}
