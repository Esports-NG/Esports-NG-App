import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

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
            IconsaxPlusLinear.clock_1,
            size: 70,
            color: AppColor().primaryWhite,
          ),
          Gap(Get.height * 0.02),
          CustomText(
            title: "Coming Soon",
            fontFamily: "InterMedium",
            color: AppColor().primaryWhite,
            size: 20,
          ),
          const Gap(25)
        ]);
  }
}
