import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../data/model/team/team_model.dart';

// There are 2 classes in this folder namely "TeamsGamesPlayedItem" For Scrollable
// and "TeamsGamesPlayedItemForList" For List

// Games Played Item For Scrollable
class TeamsGamesPlayedItem extends StatelessWidget {
  const TeamsGamesPlayedItem(
      {super.key, required this.game, required this.team});

  final GamePlayed game;
  final TeamModel team;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.55,
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
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          game.cover == null
              ? Container(
                  height: Get.height * 0.1,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/png/placeholder.png'),
                        fit: BoxFit.cover),
                  ),
                )
              : CachedNetworkImage(
                  height: Get.height * 0.12,
                  width: double.infinity,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: SizedBox(
                      height: Get.height * 0.05,
                      width: Get.height * 0.05,
                      child: CircularProgressIndicator(
                          color: AppColor().primaryColor,
                          value: progress.progress),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, color: AppColor().primaryColor),
                  imageUrl: game.cover!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      image: DecorationImage(
                          image:
                              NetworkImage(game.cover!),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: CustomText(
              title: game.name!.toCapitalCase(),
              size: 15,
              fontFamily: 'InterMedium',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.left,
            ),
          ),
          Gap(Get.height * 0.005),
        ],
      ),
    );
  }
}

class TeamsGamesPlayedItemWithIGN extends StatelessWidget {
  const TeamsGamesPlayedItemWithIGN(
      {super.key, required this.game, required this.ign});
  final String ign;
  final GamePlayed game;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.55,
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
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          game.cover == null
              ? Container(
                  height: Get.height * 0.1,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/png/placeholder.png'),
                        fit: BoxFit.cover),
                  ),
                )
              : CachedNetworkImage(
                  height: Get.height * 0.12,
                  width: double.infinity,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: SizedBox(
                      height: Get.height * 0.05,
                      width: Get.height * 0.05,
                      child: CircularProgressIndicator(
                          color: AppColor().primaryColor,
                          value: progress.progress),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, color: AppColor().primaryColor),
                  imageUrl: game.cover!,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      image: DecorationImage(
                          image:
                              NetworkImage(game.cover!),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: 'IGN: $ign',
                  size: 15,
                  fontFamily: 'InterMedium',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.left,
                ),
                Gap(Get.height * 0.005),
                CustomText(
                  title: game.name!.toCapitalCase(),
                  size: 15,
                  fontFamily: 'InterMedium',
                  color: AppColor().greyTwo.withOpacity(0.7),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
          Gap(Get.height * 0.005),
        ],
      ),
    );
  }
}

//Games Played Item For List

class TeamsGamesPlayedItemForList extends StatelessWidget {
  const TeamsGamesPlayedItemForList(
      {super.key, required this.game, required this.team});

  final GamePlayed game;
  final TeamModel team;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            height: Get.height * 0.15,
            width: double.infinity,
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: SizedBox(
                height: Get.height * 0.05,
                width: Get.height * 0.05,
                child: CircularProgressIndicator(
                    color: AppColor().primaryColor, value: progress.progress),
              ),
            ),
            errorWidget: (context, url, error) =>
                Icon(Icons.error, color: AppColor().primaryColor),
            imageUrl: game.cover!,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                image: DecorationImage(
                    image: NetworkImage(game.cover!),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: CustomText(
                      title: game.name!.toCapitalCase(),
                      size: 15,
                      fontFamily: 'InterMedium',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  //   Positioned(
                  //     bottom: 0,
                  //     right: 0,
                  //     child: IconButton(
                  //       padding: EdgeInsets.zero,
                  //       constraints: const BoxConstraints(),
                  //       onPressed: () {
                  //         Get.defaultDialog(
                  //           title: "Remove Game From Team",
                  //           backgroundColor: AppColor().primaryLightColor,
                  //           titlePadding: const EdgeInsets.only(top: 30),
                  //           contentPadding: const EdgeInsets.only(
                  //               top: 5, bottom: 30, left: 25, right: 25),
                  //           middleText:
                  //               "Are you sure? \n Data of your team, players and statistics for this game will still be stored",
                  //           titleStyle: TextStyle(
                  //             color: AppColor().primaryWhite,
                  //             fontSize: 15,
                  //              fontFamily: "InterSemiBold",
                  //             fontFamily: 'Inter',
                  //           ),
                  //           radius: 10,
                  //           confirm: Column(
                  //             children: [
                  //               CustomFillButton(
                  //                 onTap: () {
                  //                   //teamController.deleteTeam(widget.item.id!);
                  //                   Get.back();
                  //                 },
                  //                 height: 45,
                  //                 width: Get.width * 0.5,
                  //                 buttonText: 'Yes',
                  //                 textColor: AppColor().primaryWhite,
                  //                 buttonColor: AppColor().primaryColor,
                  //                 boarderColor: AppColor().primaryColor,
                  //                 borderRadius: BorderRadius.circular(25),
                  //               ),
                  //               const Gap(10),
                  //               CustomFillButton(
                  //                 onTap: () {
                  //                   Get.back();
                  //                 },
                  //                 height: 45,
                  //                 width: Get.width * 0.5,
                  //                 buttonText: 'No',
                  //                 textColor: AppColor().primaryWhite,
                  //                 buttonColor: AppColor().primaryColor,
                  //                 boarderColor: AppColor().primaryColor,
                  //                 borderRadius: BorderRadius.circular(25),
                  //               ),
                  //             ],
                  //           ),
                  //           middleTextStyle: TextStyle(
                  //             color: AppColor().primaryWhite,
                  //             fontFamily: 'Inter',
                  //             fontSize: 14,
                  //
                  //           ),
                  //         );
                  //       },
                  //       icon: Icon(
                  //         Icons.delete_outline,
                  //         color: AppColor().primaryWhite,
                  //       ),
                  //     ),
                  //   )
                ],
              ),
            ],
          ),
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
