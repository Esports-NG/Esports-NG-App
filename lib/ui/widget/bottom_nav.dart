import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/ui/account/account_events/create_event.dart';
import 'package:e_sport/ui/home/post/create_community_page.dart';
import 'package:e_sport/ui/home/post/create_post.dart';
import 'package:e_sport/ui/home/post/create_post_item.dart';
import 'package:e_sport/ui/home/post/create_team.dart';
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
  int? _selectedMenu;
  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavRepository());
    return Obx(
      () => Container(
        height: 72,
        padding:
            EdgeInsets.only(left: Get.height * 0.02, right: Get.height * 0.02),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: AppColor().greyEight, width: 0.25))),
        child: Stack(children: [
          Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0, -36),
                child: GestureDetector(
                  onTap: () {
                    _showItemListDialog(context);
                  },
                  child: Container(
                      // padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: AppColor().primaryColor,
                          borderRadius: BorderRadius.circular(999)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.add,
                          color: AppColor().primaryWhite,
                          size: 30,
                        ),
                      )),
                ),
              )),
          Stack(
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
                      borderRadius: BorderRadius.circular(999),
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
                              fontFamily: "GilroySemiBold",
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
                              fontFamily: "GilroySemiBold",
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
                              fontFamily: "GilroySemiBold",
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
                              fontFamily: "GilroySemiBold",
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ]),
      ),
    );
  }

  void _showItemListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: AppColor().primaryWhite,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomText(
                    title: 'Select what you would like\nto create',
                    size: Get.height * 0.018,
                    fontFamily: 'GilroySemiBold',
                    textAlign: TextAlign.center,
                    color: AppColor().primaryWhite,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColor().primaryLightColor,
            content: Container(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                width: Get.width * 0.5,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: createMenu.length,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.03),
                  itemBuilder: (context, index) {
                    var item = createMenu[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMenu = index;
                        });
                        Get.back();
                        if (_selectedMenu == 0) {
                          Get.to(() => const CreatePost());
                        } else if (_selectedMenu == 1) {
                          Get.to(() => const CreateEvent());
                        } else if (_selectedMenu == 2) {
                          Get.to(() => const CreateTeamPage());
                        } else {
                          Get.to(() => const CreateCommunityPage());
                        }
                      },
                      child: CreateMenu(
                        item: item,
                        selectedItem: _selectedMenu,
                        index: index,
                      ),
                    );
                  },
                )),
          );
        });
      },
    );
  }
}
