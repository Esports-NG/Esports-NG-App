import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/ui/screens/account/events/account_events_item.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TournamentSummary extends StatelessWidget {
  final EventModel eventDetails;

  const TournamentSummary({
    Key? key,
    required this.eventDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
      child: Column(
        children: [
          CustomText(
              title: eventDetails.name,
              size: Get.height * 0.02,
              fontFamily: 'InterBold',
              color: AppColor().primaryWhite),
          Gap(Get.height * 0.02),
          AccountEventsItem(
            item: eventDetails,
            onDetailsPage: true,
          ),
          Gap(Get.height * 0.05),

          // Tournament Link
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                  title: 'Tournament/Bracket Link: ',
                  size: 14,
                  fontFamily: 'InterMedium',
                  underline: TextDecoration.underline,
                  color: AppColor().primaryWhite),
              Gap(Get.height * 0.01),
              InkWell(
                onTap: () => launchUrl(Uri.parse(eventDetails.linkForBracket!)),
                child: CustomText(
                  title: eventDetails.linkForBracket,
                  size: 14,
                  fontFamily: 'InterMedium',
                  underline: TextDecoration.underline,
                  color: AppColor().primaryColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Gap(Get.height * 0.02),

          // Event Summary
          CustomText(
              title: eventDetails.summary,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              size: Get.height * 0.015,
              fontFamily: 'Inter',
              textAlign: TextAlign.center,
              height: 1.5,
              color: AppColor().greyFour),
        ],
      ),
    );
  }
}
