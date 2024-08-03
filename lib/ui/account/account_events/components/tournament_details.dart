import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentDetails extends StatelessWidget {
  const TournamentDetails(
      {super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(onPressed: () => Get.back()),
        centerTitle: true,
        title: CustomText(
          title: title,
          color: AppColor().primaryWhite,
          size: 18,
          fontFamily: "GilroyMedium",
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(title: value, color: AppColor().primaryWhite),
          ],
        ),
      ),
    );
  }
}

class TournamentDetailsItem extends StatelessWidget {
  const TournamentDetailsItem(
      {super.key, required this.text, required this.title});

  final String text;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: title,
          color: AppColor().primaryWhite,
          size: 20,
          weight: FontWeight.w600,
        ),
        Gap(Get.height * 0.01),
        CustomText(
          title: text,
          color: AppColor().primaryWhite.withOpacity(0.7),
        ),
      ],
    );
  }
}
