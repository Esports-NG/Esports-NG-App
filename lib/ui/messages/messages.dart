import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'message_type/chats.dart';
import 'message_type/communities.dart';
import 'message_type/tournaments.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<Messages>
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
          title: 'Messages',
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
              // Get.to(() => const Messages());
            },
            child: SvgPicture.asset(
              'assets/images/svg/search.svg',
              height: Get.height * 0.025,
            ),
          ),
          Gap(Get.height * 0.02),
          InkWell(
            onTap: () {
              // Get.to(() => const Messages());
            },
            child: SvgPicture.asset(
              'assets/images/svg/sort.svg',
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
                  title: 'Chats',
                  color: _tabController.index == 0
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
              Tab(
                child: CustomText(
                  title: 'Communities',
                  color: _tabController.index == 1
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
              Tab(
                child: CustomText(
                  title: 'Tournaments',
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
          Chats(),
          Communities(),
          Tournaments(),
        ]),
      ),
    );
  }
}
