import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/chat_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/small_circle.dart';
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
  State<Messages> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<Messages>
    with SingleTickerProviderStateMixin {
  final authController = Get.find<AuthRepository>();
  final chatController = Get.put(ChatRepository());
  late TabController _tabController;
  int? _selectedIndex;

  // Cache color instances to avoid creating new ones on each build
  final _primaryColor = AppColor().primaryColor;
  final _primaryWhite = AppColor().primaryWhite;
  final _primaryBackGroundColor = AppColor().primaryBackGroundColor;
  final _lightItemsColor = AppColor().lightItemsColor;
  final _primaryMenu = AppColor().primaryMenu;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTab(
      {required int index,
      required String title,
      required String count,
      String fontFamily = "InterBold"}) {
    final bool isSelected = _tabController.index == index;
    final Color textColor = isSelected ? _primaryColor : _lightItemsColor;

    return Tab(
      child: isSelected
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  title: title,
                  color: textColor,
                  size: 13,
                  fontFamily: fontFamily,
                ),
                Gap(Get.height * 0.01),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: _primaryColor, shape: BoxShape.circle),
                  child: Center(
                    child: CustomText(
                      title: count,
                      color: _primaryWhite,
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
                  title: title,
                  color: textColor,
                  size: 14,
                  fontFamily: fontFamily,
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: _primaryBackGroundColor,
          centerTitle: true,
          title: (chatController.messageOnSelect.isFalse)
              ? CustomText(
                  title: 'Messages',
                  fontFamily: "InterSemiBold",
                  size: 18,
                  color: _primaryWhite,
                )
              : null,
          // leading: IconButton(
          //   padding: EdgeInsets.zero,
          //   constraints: const BoxConstraints(),
          //   onPressed: Get.back,
          //   icon: Icon(
          //     Icons.arrow_back,
          //     color: _primaryWhite,
          //   ),
          // ),
          actions: [
            if (chatController.messageOnSelect.isFalse) ...[
              InkWell(
                onTap: () {
                  // Get.to(() => const Messages());
                },
                child: SvgPicture.asset(
                  'assets/images/svg/search.svg',
                  height: Get.height * 0.025,
                  width: Get.height * 0.025,
                  cacheColorFilter: true,
                ),
              ),
              Gap(Get.height * 0.02),
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide.none),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: _primaryMenu,
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
                      fontFamily: 'InterMedium',
                      textAlign: TextAlign.start,
                      color: _primaryWhite,
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
                      fontFamily: 'InterMedium',
                      textAlign: TextAlign.start,
                      color: _primaryWhite,
                    ),
                  ),
                ],
                child: SvgPicture.asset(
                  'assets/images/svg/sort.svg',
                  height: Get.height * 0.025,
                  width: Get.height * 0.025,
                  cacheColorFilter: true,
                ),
              ),
            ] else ...[
              InkWell(
                onTap: () {
                  // Get.to(() => const Messages());
                },
                child: SvgPicture.asset(
                  'assets/images/svg/pin.svg',
                  height: Get.height * 0.025,
                  width: Get.height * 0.025,
                  cacheColorFilter: true,
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
                  width: Get.height * 0.025,
                  cacheColorFilter: true,
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
                  width: Get.height * 0.025,
                  cacheColorFilter: true,
                ),
              ),
              Gap(Get.height * 0.05),
              InkWell(
                onTap: () {},
                child: SvgPicture.asset(
                  'assets/images/svg/archive.svg',
                  height: Get.height * 0.025,
                  width: Get.height * 0.025,
                  cacheColorFilter: true,
                ),
              ),
              Gap(Get.height * 0.05),
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide.none),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: _primaryMenu,
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
                    padding: EdgeInsets.all(Get.height * 0.02),
                    child: CustomText(
                      title: 'Mark as unread',
                      size: Get.height * 0.016,
                      fontFamily: 'InterMedium',
                      textAlign: TextAlign.start,
                      color: _primaryWhite,
                    ),
                  ),
                  PopupMenuItem(
                    height: Get.height * 0.02,
                    padding: EdgeInsets.only(
                        top: Get.height * 0.01,
                        bottom: Get.height * 0.02,
                        left: Get.height * 0.02,
                        right: Get.height * 0.02),
                    child: CustomText(
                      title: 'Select all',
                      size: Get.height * 0.016,
                      fontFamily: 'InterMedium',
                      textAlign: TextAlign.start,
                      color: _primaryWhite,
                    ),
                  ),
                  PopupMenuItem(
                    height: Get.height * 0.02,
                    padding: EdgeInsets.only(
                      top: Get.height * 0.01,
                      bottom: Get.height * 0.02,
                      left: Get.height * 0.02,
                    ),
                    child: CustomText(
                      title: 'Block user',
                      size: Get.height * 0.016,
                      fontFamily: 'InterMedium',
                      textAlign: TextAlign.start,
                      color: _primaryWhite,
                    ),
                  ),
                  PopupMenuItem(
                    height: Get.height * 0.02,
                    padding: EdgeInsets.only(
                        top: Get.height * 0.01,
                        bottom: Get.height * 0.02,
                        left: Get.height * 0.02,
                        right: Get.height * 0.02),
                    child: CustomText(
                      title: 'Contact info',
                      size: Get.height * 0.016,
                      fontFamily: 'InterMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ),
                ],
                child: SvgPicture.asset(
                  'assets/images/svg/dots-vert.svg',
                  height: Get.height * 0.025,
                  width: Get.height * 0.025,
                  cacheColorFilter: true,
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     // Get.to(() => const Messages());
              //   },
              //   child: SvgPicture.asset(
              //     'assets/images/svg/dots-vert.svg',
              //     height: Get.height * 0.025,
              //   ),
              // ),
            ],
            Gap(Get.height * 0.02)
          ],
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: _primaryColor,
              dividerHeight: 0.5,
              dividerColor: Colors.grey.withOpacity(0.4),
              // padding: EdgeInsets.only(top: Get.height * 0.02),
              labelPadding: EdgeInsets.symmetric(horizontal: 4.0),
              tabs: [
                _buildTab(index: 0, title: 'Chats', count: '1000'),
                _buildTab(
                    index: 1,
                    title: 'Communities',
                    count: '500',
                    fontFamily: "InterSemiBold"),
                _buildTab(index: 2, title: 'Tournaments', count: '200'),
              ]),
        ),
        backgroundColor: _primaryBackGroundColor,
        body: TabBarView(controller: _tabController, children: const [
          Chats(),
          Communities(),
          Tournaments(),
        ]),
      );
    });
  }
}
