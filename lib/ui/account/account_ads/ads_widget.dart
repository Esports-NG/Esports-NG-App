import 'package:e_sport/ui/account/account_ads/components/promoted_events.dart';
import 'package:e_sport/ui/account/account_ads/components/promoted_posts.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdsWidget extends StatefulWidget {
  const AdsWidget({super.key});

  @override
  State<AdsWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(onPressed: () => Get.back()),
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          textAlign: TextAlign.center,
          title: 'Ads',
          weight: FontWeight.w600,
          size: 18,
          color: AppColor().primaryWhite,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: AppColor().primaryWhite,
            ),
          ),
        ],
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColor().primaryColor,
            dividerColor: AppColor().greyEight,
            padding: EdgeInsets.only(top: Get.height * 0.02),
            tabs: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: CustomText(
                  title: 'Promoted Posts',
                  color: _tabController.index == 0
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                  size: 16,
                  fontFamily:
                      _tabController.index == 0 ? 'GilroyBold' : 'GilroyMedium',
                  weight: FontWeight.w400,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: CustomText(
                  title: 'Promoted Events',
                  color: _tabController.index == 1
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                  size: 16,
                  fontFamily:
                      _tabController.index == 1 ? 'GilroyBold' : 'GilroyMedium',
                  weight: FontWeight.w400,
                ),
              ),
            ]),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: TabBarView(
        controller: _tabController,
        children: const [PromotedPosts(), PromotedEvents()],
      ),
    );
  }
}
