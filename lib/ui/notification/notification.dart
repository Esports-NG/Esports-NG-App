import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBgColor,
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
          InkWell(
            onTap: () {
              // Get.to(() => const NotificationPage());
            },
            child: SvgPicture.asset(
              'assets/images/svg/filter.svg',
              height: Get.height * 0.025,
            ),
          ),
          const Gap(20)
        ],
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColor().primaryColor,
            tabs: [
              Tab(
                child: CustomText(
                  title: 'Personal',
                  color: _tabController.index == 0
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
              Tab(
                child: CustomText(
                  title: 'Posts',
                  color: _tabController.index == 1
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
              Tab(
                child: CustomText(
                  title: 'Events',
                  color: _tabController.index == 2
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
            ]),
      ),
      backgroundColor: AppColor().primaryBgColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: TabBarView(controller: _tabController, children: const [
          Personal(),
          Posts(),
          Events(),
        ]),
      ),
    );
  }
}
