import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'custom_text.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.wifi_off,
              color: AppColor().primaryWhite,
              size: Get.width * 0.5,
            ),
          ),
          Gap(Get.height * 0.05),
          Center(
            child: CustomText(
              title: "No internet connection",
              size: Get.height * 0.02,
              weight: FontWeight.w600,
              color: AppColor().primaryWhite,
            ),
          ),
        ],
      ),
    );
  }
}
