import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameModeItem extends StatelessWidget {
  const GameModeItem({super.key, required this.mode});

  final String mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.55,
      decoration: BoxDecoration(
          color: AppColor().bgDark,
          border: Border.all(color: AppColor().greyEight),
          borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: Get.height * 0.14,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            image: DecorationImage(
                image: AssetImage('assets/images/png/placeholder.png'),
                fit: BoxFit.cover),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomText(
              title: mode,
              color: AppColor().primaryWhite,
              weight: FontWeight.w600,
            ),
          ]),
        )
      ]),
    );
  }
}
