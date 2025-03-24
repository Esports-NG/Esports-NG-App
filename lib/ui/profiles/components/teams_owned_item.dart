import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// Teams Owned Item For Scrollable
class TeamsOwnedItem extends StatelessWidget {
  const TeamsOwnedItem({super.key, required this.team});

  final TeamModel team;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor().bgDark,
            AppColor().primaryBackGroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().darkGrey,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                team.profilePicture == null
                    ? CircleAvatar(
                        foregroundImage:
                            AssetImage('assets/images/png/placeholder.png'),
                        radius: Get.width * 0.07,
                      )
                    : Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                          CircleAvatar(
                            foregroundImage: NetworkImage(team.profilePicture!),
                            radius: Get.width * 0.07,
                          ),
                          if(team.isVerified == true) SvgPicture.asset("assets/images/svg/check_badge.svg", height: Get.height * 0.025,)
                        ],
                    ),
                Gap(Get.height * 0.015),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: team.name!.toUpperCase(),
                      size: 14,
                      fontFamily: 'InterBold',
                    ),
                    CustomText(
                      title: 'Founded: Day Month Year',
                      size: 10,
                      fontFamily: 'Inter',
                      color: AppColor().primaryWhite.withOpacity(0.7),
                    ),
                    Gap(Get.height * 0.01),
                    CustomText(
                      title: 'Games Played:',
                      fontFamily: 'InterSemiBold',
                      size: 12,
                    ),
                    Gap(Get.height * 0.005),
                    if (team.gamesPlayed!.isNotEmpty)
                      CustomFillButton(
                        buttonText: team.gamesPlayed![0].abbrev,
                        textSize: 10,
                        buttonColor: AppColor().greyButton,
                        width: 50,
                        height: 20,
                        fontWeight: FontWeight.bold,
                      ),
                  ],
                ),
              ],
            ),
          ),
          Gap(Get.height * 0.005),
        ],
      ),
    );
  }

  Row textItem({String? title, subTitle}) {
    return Row(
      children: [
        CustomText(
          title: title,
          size: 12,
          fontFamily: 'Inter',
          textAlign: TextAlign.start,
          color: AppColor().greyTwo,
        ),
        CustomText(
          title: subTitle,
          size: 12,
          fontFamily: 'InterSemiBold',
          textAlign: TextAlign.start,
          color: AppColor().greyTwo,
        ),
      ],
    );
  }
}
