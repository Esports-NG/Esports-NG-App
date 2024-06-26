import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/profiles/components/team_games_played_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PlayerApplication extends StatefulWidget {
  const PlayerApplication({super.key, required this.application});
  final TeamApplicationModel application;

  @override
  State<PlayerApplication> createState() => _PlayerApplicationState();
}

class _PlayerApplicationState extends State<PlayerApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          title: "#Username's Application",
          color: AppColor().primaryWhite,
          size: 20,
          fontFamily: 'GilroyMedium',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Get.height * 0.03, horizontal: Get.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: "Role",
                color: AppColor().primaryWhite,
                size: 18,
                fontFamily: "GilroyMedium",
              ),
              Gap(Get.height * 0.005),
              CustomText(
                title: widget.application.role,
                color: AppColor().primaryWhite.withOpacity(0.6),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: "Application Reason",
                color: AppColor().primaryWhite,
                size: 18,
                fontFamily: "GilroyMedium",
              ),
              Gap(Get.height * 0.005),
              CustomText(
                title: widget.application.message,
                color: AppColor().primaryWhite.withOpacity(0.6),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: "Selected Games",
                color: AppColor().primaryWhite,
                size: 18,
                fontFamily: "GilroyMedium",
              ),
              Gap(Get.height * 0.01),
              SizedBox(
                width: double.infinity,
                height: Get.height * 0.19,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        TeamsGamesPlayedItemWithIGN(
                            game: widget
                                .application.playerProfiles![index].gamePlayed!,
                            ign: widget.application.playerProfiles![index]
                                .inGameName!),
                    separatorBuilder: (context, index) =>
                        Gap(Get.height * 0.02),
                    itemCount: widget.application.playerProfiles!.length),
              ),
              Gap(Get.height * 0.02),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: AppColor().secondaryGreenColor,
                          borderRadius: BorderRadius.circular(99)),
                      child: Center(
                          child: CustomText(
                        title: "Accept",
                        color: AppColor().primaryDark,
                        fontFamily: "GilroySemiBold",
                      )),
                    ),
                  )),
                  Gap(Get.height * 0.01),
                  Expanded(
                      child: InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: AppColor().primaryRed,
                          borderRadius: BorderRadius.circular(99)),
                      child: Center(
                          child: CustomText(
                        title: "Reject",
                        color: AppColor().primaryWhite,
                        fontFamily: "GilroySemiBold",
                      )),
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
