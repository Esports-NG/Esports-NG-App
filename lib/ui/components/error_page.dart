import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(Get.height * 0.1),
          Icon(
            Icons.error_outline,
            color: AppColor().primaryColor,
            size: Get.height * 0.1,
          ),
          Gap(Get.height * 0.02),
          CustomText(
            title: 'Error occurred, try again!',
            size: 15,
            color: AppColor().primaryWhite,
          ),
        ],
      ),
    );
  }
}
