import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().pureBlackColor,
      body: Center(
        child: CustomText(
          title: 'Community',
          color: AppColor().primaryWhite,
          textAlign: TextAlign.center,
          fontFamily: 'GilroyRegular',
          size: Get.height * 0.015,
        ),
      ),
    );
  }
}
