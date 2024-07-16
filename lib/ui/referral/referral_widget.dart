import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'component/referral_leaderboard_widget.dart';
import 'component/referral_link_widget.dart';

class Referral extends StatefulWidget {
  const Referral({super.key});

  @override
  State<Referral> createState() => _ReferralState();
}

class _ReferralState extends State<Referral>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          textAlign: TextAlign.center,
          title: 'Referrals',
          weight: FontWeight.w600,
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: GoBackButton(onPressed: () => Get.back()),
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
                  title: 'Referral Link',
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
                  title: 'Referral Leaderboard',
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
      body: TabBarView(controller: _tabController, children: [
        Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: const ReferralLinkWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: const ReferralLeaderboardWidget(),
        ),
      ]),
    );
  }
}
