import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'notification_type/all.dart';
import 'notification_type/events.dart';
import 'notification_type/personal.dart';
import 'notification_type/posts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
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

  var pages = <Widget>[
    const AllNotification(),
    const Personal(),
    const Posts(),
    const Events(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          title: 'Notifications',
          weight: FontWeight.w500,
          size: 18,
          color: AppColor().primaryWhite,
        ),
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
          PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), side: BorderSide.none),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            color: AppColor().primaryMenu,
            offset: const Offset(0, -10),
            initialValue: _selectedIndex,
            onSelected: (value) async {
              print('value: $value');

              setState(() {
                if (value == 0) {
                  _selectedIndex = value;
                } else if (value == 1) {
                  _selectedIndex = value;
                } else if (value == 2) {
                  _selectedIndex = value;
                } else {
                  _selectedIndex = value;
                }
              });

              // await Future.delayed(const Duration(milliseconds: 500))
              //     .then((value) => _selectedIndex = null);

              // return _selectedIndex = null;
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                height: Get.height * 0.03,
                padding: EdgeInsets.all(Get.height * 0.025),
                child: optionItem(
                  title: 'All',
                  cColor: _selectedIndex == 0
                      ? AppColor().primaryWhite
                      : Colors.transparent,
                  sColor: _selectedIndex == 0
                      ? AppColor().primaryColor
                      : AppColor().primaryWhite,
                  bColor: _selectedIndex == 0
                      ? AppColor().primaryColor
                      : Colors.transparent,
                ),
              ),
              PopupMenuItem(
                value: 1,
                height: Get.height * 0.03,
                padding: EdgeInsets.only(
                    left: Get.height * 0.025,
                    right: Get.height * 0.025,
                    bottom: Get.height * 0.025),
                child: optionItem(
                  title: 'Personal',
                  cColor: _selectedIndex == 1
                      ? AppColor().primaryWhite
                      : Colors.transparent,
                  sColor: _selectedIndex == 1
                      ? AppColor().primaryColor
                      : AppColor().primaryWhite,
                  bColor: _selectedIndex == 1
                      ? AppColor().primaryColor
                      : Colors.transparent,
                ),
              ),
              PopupMenuItem(
                value: 2,
                height: Get.height * 0.03,
                padding: EdgeInsets.only(
                    left: Get.height * 0.025,
                    right: Get.height * 0.025,
                    bottom: Get.height * 0.025),
                child: optionItem(
                  title: 'Posts',
                  cColor: _selectedIndex == 2
                      ? AppColor().primaryWhite
                      : Colors.transparent,
                  sColor: _selectedIndex == 2
                      ? AppColor().primaryColor
                      : AppColor().primaryWhite,
                  bColor: _selectedIndex == 2
                      ? AppColor().primaryColor
                      : Colors.transparent,
                ),
              ),
              PopupMenuItem(
                value: 3,
                height: Get.height * 0.03,
                padding: EdgeInsets.only(
                    left: Get.height * 0.025,
                    right: Get.height * 0.025,
                    bottom: Get.height * 0.025),
                child: optionItem(
                  title: 'Events',
                  cColor: _selectedIndex == 3
                      ? AppColor().primaryWhite
                      : Colors.transparent,
                  sColor: _selectedIndex == 3
                      ? AppColor().primaryColor
                      : AppColor().primaryWhite,
                  bColor: _selectedIndex == 3
                      ? AppColor().primaryColor
                      : Colors.transparent,
                ),
              ),
            ],
            child: SvgPicture.asset(
              'assets/images/svg/filter.svg',
              height: Get.height * 0.025,
            ),
          ),
          const Gap(20)
        ],
        // bottom: TabBar(
        //     controller: _tabController,
        //     indicatorColor: AppColor().primaryColor,
        //     tabs: [
        //       Tab(
        //         child: CustomText(
        //           title: 'Personal',
        //           color: _tabController.index == 0
        //               ? AppColor().primaryColor
        //               : AppColor().lightItemsColor,
        //           size: 14,
        //           weight: FontWeight.w600,
        //         ),
        //       ),
        //       Tab(
        //         child: CustomText(
        //           title: 'Posts',
        //           color: _tabController.index == 1
        //               ? AppColor().primaryColor
        //               : AppColor().lightItemsColor,
        //           size: 14,
        //           weight: FontWeight.w600,
        //         ),
        //       ),
        //       Tab(
        //         child: CustomText(
        //           title: 'Events',
        //           color: _tabController.index == 2
        //               ? AppColor().primaryColor
        //               : AppColor().lightItemsColor,
        //           size: 14,
        //           weight: FontWeight.w600,
        //         ),
        //       ),
        //     ]),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: pages.elementAt(_selectedIndex ?? 0),
    );
  }

  Container optionItem(
      {String? title, Color? cColor, ccColor, sColor, bColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: sColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            title: title,
            size: Get.height * 0.016,
            fontFamily: 'GilroyMedium',
            textAlign: TextAlign.start,
            color: AppColor().primaryWhite,
          ),
          Gap(Get.height * 0.1),
          const Spacer(),
          SmallCircle(
            size: Get.height * 0.015,
            color: cColor,
            bColor: sColor,
          )
        ],
      ),
    );
  }
}
