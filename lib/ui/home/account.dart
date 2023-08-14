import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().pureBlackColor,
      body: Center(
        child: CustomText(
          title: 'Account',
          color: AppColor().primaryWhite,
          textAlign: TextAlign.center,
          fontFamily: 'GilroyRegular',
          size: Get.height * 0.015,
        ),
      ),
    );
  }
}
