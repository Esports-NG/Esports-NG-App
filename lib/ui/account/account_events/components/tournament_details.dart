import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentDetails extends StatelessWidget {
  const TournamentDetails({super.key, required this.item});

  final EventModel item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(onPressed: () => Get.back()),
        centerTitle: true,
        title: CustomText(
          title: "Tournament Details",
          color: AppColor().primaryWhite,
          size: 20,
          fontFamily: "GilroySemiBold",
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: "Tournament Summary",
              color: AppColor().primaryWhite,
              size: 20,
              fontFamily: "GilroySemiBold",
            ),
            Gap(Get.height * 0.01),
            CustomText(
              title: item.summary,
              color: AppColor().primaryWhite.withOpacity(0.7),
            ),
            Gap(Get.height * 0.03),
            CustomText(
              title: "Tournament Requirements",
              color: AppColor().primaryWhite,
              size: 20,
              fontFamily: "GilroySemiBold",
            ),
            Gap(Get.height * 0.01),
            CustomText(
              title: item.requirements,
              color: AppColor().primaryWhite.withOpacity(0.7),
            ),
            Gap(Get.height * 0.03),
            CustomText(
              title: "Tournament Regulations",
              color: AppColor().primaryWhite,
              size: 20,
              fontFamily: "GilroySemiBold",
            ),
            Gap(Get.height * 0.01),
            CustomText(
              title: item.rulesRegs,
              color: AppColor().primaryWhite.withOpacity(0.7),
            ),
            Gap(Get.height * 0.03),
            CustomText(
              title: "Tournament Structure",
              color: AppColor().primaryWhite,
              size: 20,
              fontFamily: "GilroySemiBold",
            ),
            Gap(Get.height * 0.01),
            CustomText(
              title: item.structure,
              color: AppColor().primaryWhite.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
