import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// There are 2 classes in this folder namely "TeamsGamesPlayedItem" For Scrollable
// and "TeamsGamesPlayedItemForList" For List

// Games Played Item For Scrollable
class UserGamesPlayedItem extends StatelessWidget {
  const UserGamesPlayedItem({super.key, required this.player});

  final PlayerModel player;

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
          player.profile == null
              ? Container(
                  height: Get.height * 0.12,
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
                  imageUrl: player.profile,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      image: DecorationImage(
                          image: NetworkImage(player.profile),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 5),
            child: Column(
              children: [
                textItem(title: 'Game: ', subTitle: player.gamePlayed!.name),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'IGN: ',
                  subTitle: player.inGameName ?? "",
                ),
                Gap(Get.height * 0.01),
                textItem(
                  title: 'Game ID: ',
                  subTitle: player.inGameId ?? "",
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
