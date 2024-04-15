import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Get.height * 0.02, vertical: Get.height * 0.04),
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(width: 2, color: AppColor().greyEight))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: CustomText(
            title: "Overview",
            color: AppColor().primaryWhite,
            size: 20,
            fontFamily: "GilroySemiBold",
          ),
        ),
        Gap(Get.height * 0.02),
        Row(
          children: [
            CustomText(
              title: "Reach",
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.02),
            const Expanded(
                child: Divider(
              thickness: 0.5,
            )),
            Gap(Get.height * 0.02),
            CustomText(
              title: "3,589",
              color: AppColor().primaryWhite,
            )
          ],
        ),
        Gap(Get.height * 0.02),
        Row(
          children: [
            CustomText(
              title: "Profile Visits",
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.02),
            const Expanded(
                child: Divider(
              thickness: 0.5,
            )),
            Gap(Get.height * 0.02),
            CustomText(
              title: "60",
              color: AppColor().primaryWhite,
            )
          ],
        ),
        Gap(Get.height * 0.02),
        Row(
          children: [
            CustomText(
              title: "Content Interaction",
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.02),
            const Expanded(
                child: Divider(
              thickness: 0.5,
            )),
            Gap(Get.height * 0.02),
            CustomText(
              title: "109",
              color: AppColor().primaryWhite,
            )
          ],
        ),
        Gap(Get.height * 0.02),
        Row(
          children: [
            CustomText(
              title: "Follows",
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.02),
            const Expanded(
                child: Divider(
              thickness: 0.5,
            )),
            Gap(Get.height * 0.02),
            CustomText(
              title: "2",
              color: AppColor().primaryWhite,
            )
          ],
        ),
        Gap(Get.height * 0.02),
        Row(
          children: [
            CustomText(
              title: "Amount Spend",
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.02),
            const Expanded(
                child: Divider(
              thickness: 0.5,
            )),
            Gap(Get.height * 0.02),
            CustomText(
              title: "5,000",
              color: AppColor().primaryWhite,
            )
          ],
        ),
        Gap(Get.height * 0.02),
        Row(
          children: [
            CustomText(
              title: "Daily Budget",
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.02),
            const Expanded(
                child: Divider(
              thickness: 0.5,
            )),
            Gap(Get.height * 0.02),
            CustomText(
              title: "1,000",
              color: AppColor().primaryWhite,
            )
          ],
        ),
        Gap(Get.height * 0.02),
        Row(
          children: [
            CustomText(
              title: "Duration",
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.02),
            const Expanded(
                child: Divider(
              thickness: 0.5,
            )),
            Gap(Get.height * 0.02),
            CustomText(
              title: "5 days",
              color: AppColor().primaryWhite,
            )
          ],
        ),
      ]),
    );
  }
}
