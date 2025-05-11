import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class NoItemPage extends StatelessWidget {
  final String title;
  final double? size;
  const NoItemPage({
    super.key,
    required this.title,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gap(size ?? Get.height * 0.1),
          Icon(
            Icons.warning_amber,
            color: AppColor().primaryColor,
            size: size ?? Get.height * 0.1,
          ),
          Gap(Get.height * 0.02),
          CustomText(
            title: 'No $title!',
            size: 15,
            color: AppColor().primaryWhite,
          ),
        ],
      ),
    );
  }
}
