import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavRepository());
    return Obx(
      () => Container(
        height: 72,
        padding:
            EdgeInsets.only(left: Get.height * 0.02, right: Get.height * 0.02),
        decoration: BoxDecoration(
            color: AppColor().primaryBackGroundColor,
            border: Border(
                top: BorderSide(color: AppColor().darkGrey, width: 0.25))),
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: navController.currentIndex.value == 0
                  ? 0
                  : navController.currentIndex.value == 1
                      ? 70
                      : navController.currentIndex.value == 2
                          ? Get.width - 140 - Get.height * 0.04
                          : Get.width - 70 - Get.height * 0.04,
              // right: navController.currentIndex.value == 2
              //     ? 70
              //     : navController.currentIndex.value == 3
              //         ? 0
              //         : null,
              child: AnimatedContainer(
                height: 5,
                width: 70,
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    color: AppColor().primaryColor),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      navController.setIndex(0);
                    },
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      decoration: const BoxDecoration(
                          // border: navController.currentIndex.value == 0
                          //     ? Border(
                          //         top: BorderSide(
                          //             color: AppColor().primaryColor, width: 2))
                          ),
                      child: Column(
                        children: [
                          HeroIcon(
                            HeroIcons.home,
                            size: 28,
                            color: navController.currentIndex.value == 0
                                ? AppColor().primaryColor
                                : AppColor().lightItemsColor,
                          ),
                          const Gap(5),
                          CustomText(
                            title: "Home",
                            size: 12,
                            color: navController.currentIndex.value == 0
                                ? AppColor().primaryColor
                                : AppColor().lightItemsColor,
                            fontFamily: "InterSemiBold",
                          )
                        ],
                      ),
                    ),
                  ),
                  // const Spacer(flex: 1),
                  GestureDetector(
                    onTap: () {
                      navController.setIndex(1);
                    },
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      decoration: const BoxDecoration(
                          // border: navController.currentIndex.value == 1
                          //     ? Border(
                          //         top: BorderSide(
                          //             color: AppColor().primaryColor, width: 2))
                          ),
                      child: Column(
                        children: [
                          HeroIcon(
                            HeroIcons.calendar,
                            size: 28,
                            color: navController.currentIndex.value == 1
                                ? AppColor().primaryColor
                                : AppColor().lightItemsColor,
                          ),
                          const Gap(5),
                          CustomText(
                            title: "Events",
                            size: 12,
                            color: navController.currentIndex.value == 1
                                ? AppColor().primaryColor
                                : AppColor().lightItemsColor,
                            fontFamily: "InterSemiBold",
                          )
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                  GestureDetector(
                    onTap: () {
                      navController.setIndex(2);
                    },
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      decoration: const BoxDecoration(
                          // border: navController.currentIndex.value == 2
                          //     ? Border(
                          //         top: BorderSide(
                          //             color: AppColor().primaryColor, width: 2))
                          ),
                      child: Column(
                        children: [
                          HeroIcon(
                            HeroIcons.userGroup,
                            size: 28,
                            color: navController.currentIndex.value == 2
                                ? AppColor().primaryColor
                                : AppColor().lightItemsColor,
                          ),
                          const Gap(5),
                          CustomText(
                            title: "Community",
                            size: 12,
                            color: navController.currentIndex.value == 2
                                ? AppColor().primaryColor
                                : AppColor().lightItemsColor,
                            fontFamily: "InterSemiBold",
                          )
                        ],
                      ),
                    ),
                  ),
                  // const Spacer(
                  //   flex: 1,
                  // ),
                  GestureDetector(
                    onTap: () {
                      navController.setIndex(3);
                    },
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      decoration: const BoxDecoration(
                          // border: navController.currentIndex.value == 3
                          //     ? Border(
                          //         top: BorderSide(
                          //             color: AppColor().primaryColor, width: 2))
                          ),
                      child: Column(
                        children: [
                          HeroIcon(
                            HeroIcons.user,
                            size: 28,
                            color: navController.currentIndex.value == 3
                                ? AppColor().primaryColor
                                : AppColor().lightItemsColor,
                          ),
                          const Gap(5),
                          CustomText(
                            title: "Account",
                            size: 12,
                            color: navController.currentIndex.value == 3
                                ? AppColor().primaryColor
                                : AppColor().lightItemsColor,
                            fontFamily: "InterSemiBold",
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
