import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'component/referral_code_widget.dart';
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
            padding: EdgeInsets.only(top: Get.height * 0.0),
            tabs: [
              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.01),
                child: CustomText(
                  title: 'Referral Link',
                  color: _tabController.index == 0
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                  size: 14,
                  fontFamily:
                      _tabController.index == 0 ? 'GilroyBold' : 'GilroyMedium',
                  weight: FontWeight.w400,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.01),
                child: CustomText(
                  title: 'Referral Code',
                  color: _tabController.index == 1
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                  size: 14,
                  fontFamily:
                      _tabController.index == 1 ? 'GilroyBold' : 'GilroyMedium',
                  weight: FontWeight.w400,
                ),
              ),
            ]),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: TabBarView(controller: _tabController, children: const [
          ReferralLinkWidget(),
          ReferralCodeWidget(),
        ]),
      ),
    );
  }
}
