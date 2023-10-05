import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/messages/archive.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'message_type/chats/chats.dart';
import 'message_type/communities.dart';
import 'message_type/tournaments.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<Messages>
    with SingleTickerProviderStateMixin {
  final authController = Get.put(AuthRepository());
  late TabController _tabController;
  int? _selectedIndex;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor().primaryBackGroundColor,
          centerTitle: true,
          title: (authController.mOnSelect.isFalse)
              ? CustomText(
                  title: 'Messages',
                  weight: FontWeight.w600,
                  size: 18,
                  color: AppColor().primaryWhite,
                )
              : null,
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              color: AppColor().primaryWhite,
            ),
          ),
          actions: [
            if (authController.mOnSelect.isFalse) ...[
              InkWell(
                onTap: () {
                  // Get.to(() => const Messages());
                },
                child: SvgPicture.asset(
                  'assets/images/svg/search.svg',
                  height: Get.height * 0.025,
                ),
              ),
              Gap(Get.height * 0.02),
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide.none),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: AppColor().primaryMenu,
                offset: const Offset(0, -10),
                initialValue: _selectedIndex,
                onSelected: (value) {
                  if (value == 0) {
                    _selectedIndex = value;
                  } else if (value == 1) {
                    _selectedIndex = value;
                  } else if (value == 2) {
                    _selectedIndex = value;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert Dialog Title'),
                          content: const Text(
                              'This is the content of the alert dialog.'),
                          actions: [
                            // Define actions like "OK" or "Cancel" buttons.
                            TextButton(
                              onPressed: () {
                                // Close the dialog when the "OK" button is pressed.
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    height: Get.height * 0.02,
                    padding: EdgeInsets.only(
                        bottom: Get.height * 0.03,
                        left: Get.height * 0.02,
                        top: Get.height * 0.02),
                    child: CustomText(
                      title: 'Archives',
                      size: Get.height * 0.016,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ),
                  PopupMenuItem(
                    height: Get.height * 0.02,
                    padding: EdgeInsets.only(
                        bottom: Get.height * 0.02,
                        left: Get.height * 0.02,
                        right: Get.height * 0.02),
                    child: CustomText(
                      title: 'Friend requests',
                      size: Get.height * 0.016,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ),
                ],
                child: SvgPicture.asset(
                  'assets/images/svg/sort.svg',
                  height: Get.height * 0.025,
                ),
              )
            ] else ...[
              InkWell(
                onTap: () {
                  // Get.to(() => const Messages());
                },
                child: SvgPicture.asset(
                  'assets/images/svg/pin.svg',
                  height: Get.height * 0.025,
                ),
              ),
              Gap(Get.height * 0.05),
              InkWell(
                onTap: () {
                  // Get.to(() => const Messages());
                },
                child: SvgPicture.asset(
                  'assets/images/svg/mute.svg',
                  height: Get.height * 0.025,
                ),
              ),
              Gap(Get.height * 0.05),
              InkWell(
                onTap: () {
                  // Get.to(() => const Messages());
                },
                child: SvgPicture.asset(
                  'assets/images/svg/trash.svg',
                  height: Get.height * 0.025,
                ),
              ),
              Gap(Get.height * 0.05),
              InkWell(
                onTap: () {
                  Get.to(() => const Archives());
                },
                child: SvgPicture.asset(
                  'assets/images/svg/archive.svg',
                  height: Get.height * 0.025,
                ),
              ),
              Gap(Get.height * 0.05),
              InkWell(
                onTap: () {
                  // Get.to(() => const Messages());
                },
                child: SvgPicture.asset(
                  'assets/images/svg/dots-vert.svg',
                  height: Get.height * 0.025,
                ),
              ),
            ],
            Gap(Get.height * 0.02)
          ],
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColor().primaryColor,
              padding: EdgeInsets.only(top: Get.height * 0.02),
              tabs: [
                Tab(
                  child: _tabController.index == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              title: 'Chats',
                              color: _tabController.index == 0
                                  ? AppColor().primaryColor
                                  : AppColor().lightItemsColor,
                              size: 13,
                              weight: FontWeight.w600,
                            ),
                            Gap(Get.height * 0.01),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: AppColor().primaryColor,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: CustomText(
                                  title: '1000',
                                  color: AppColor().primaryWhite,
                                  size: 8,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SmallCircle(),
                            Gap(Get.height * 0.01),
                            CustomText(
                              title: 'Chats',
                              color: _tabController.index == 0
                                  ? AppColor().primaryColor
                                  : AppColor().lightItemsColor,
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                ),
                Tab(
                  child: _tabController.index == 1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              title: 'Communities',
                              color: _tabController.index == 1
                                  ? AppColor().primaryColor
                                  : AppColor().lightItemsColor,
                              size: 13,
                              weight: FontWeight.w600,
                            ),
                            Gap(Get.height * 0.01),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: AppColor().primaryColor,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: CustomText(
                                  title: '500',
                                  color: AppColor().primaryWhite,
                                  size: 8,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SmallCircle(),
                            Gap(Get.height * 0.01),
                            CustomText(
                              title: 'Communities',
                              color: _tabController.index == 1
                                  ? AppColor().primaryColor
                                  : AppColor().lightItemsColor,
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                ),
                Tab(
                  child: _tabController.index == 2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              title: 'Tournaments',
                              color: _tabController.index == 2
                                  ? AppColor().primaryColor
                                  : AppColor().lightItemsColor,
                              size: 13,
                              weight: FontWeight.w600,
                            ),
                            Gap(Get.height * 0.01),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: AppColor().primaryColor,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: CustomText(
                                  title: '200',
                                  color: AppColor().primaryWhite,
                                  size: 8,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SmallCircle(),
                            Gap(Get.height * 0.01),
                            CustomText(
                              title: 'Tournaments',
                              color: _tabController.index == 2
                                  ? AppColor().primaryColor
                                  : AppColor().lightItemsColor,
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                ),
              ]),
        ),
        backgroundColor: AppColor().primaryBackGroundColor,
        body: Padding(
          padding: EdgeInsets.only(top: Get.height * 0.02),
          child: TabBarView(controller: _tabController, children: const [
            Chats(),
            Communities(),
            Tournaments(),
          ]),
        ),
      );
    });
  }
}
