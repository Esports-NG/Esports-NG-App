import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ComingSoonPopup extends StatelessWidget {
  const ComingSoonPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close_rounded,
                  size: 25,
                  color: AppColor().primaryWhite,
                ),
              )
            ],
          ),
          Icon(
            Icons.timer_outlined,
            size: 70,
            color: AppColor().primaryWhite,
          ),
          Gap(Get.height * 0.02),
          CustomText(
            title: "Coming Soon",
            fontFamily: "GilroySemiBold",
            color: AppColor().primaryWhite,
            size: 20,
          ),
          const Gap(25)
        ]);
  }
}
