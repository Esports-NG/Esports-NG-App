import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
            Gap(Get.height * 0.03),
            TournamentDetailsItem(text: item.name!, title: "Tournament Name"),
            Gap(Get.height * 0.03),
            TournamentDetailsItem(
                text: item.summary!, title: "Tournament Summary"),
            Gap(Get.height * 0.03),
            TournamentDetailsItem(
                text: item.requirements!, title: "Tournament Requirements"),
            Gap(Get.height * 0.03),
            TournamentDetailsItem(
                text:
                    "${DateFormat.MMM().format(item.startDate!)} ${item.startDate!.day}, ${item.startDate!.year} - ${DateFormat.MMM().format(item.endDate!)} ${item.endDate!.day}, ${item.endDate!.year}",
                title: "Tournament Duration"),
            Gap(Get.height * 0.03),
            TournamentDetailsItem(
                text:
                    "${DateFormat.MMM().format(item.regStart!)} ${item.regStart!.day}, ${item.regStart!.year} - ${DateFormat.MMM().format(item.regEnd!)} ${item.regEnd!.day}, ${item.regEnd!.year}",
                title: "Tournament Registration Period"),
            Gap(Get.height * 0.03),
            TournamentDetailsItem(
                text: item.rulesRegs!, title: "Tournament Regulations"),
            Gap(Get.height * 0.03),
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
          fontFamily: "GilroySemiBold",
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
