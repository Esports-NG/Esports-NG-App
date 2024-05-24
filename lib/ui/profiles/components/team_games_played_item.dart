import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../data/model/team/team_model.dart';

class TeamsGamesPlayedItem extends StatelessWidget {
  const TeamsGamesPlayedItem(
      {super.key, required this.game,});

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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
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
                            image:
                                AssetImage('assets/images/png/placeholder.png'),
                            fit: BoxFit.cover),
                      ),
                    )
                  : CachedNetworkImage(
                      height: Get.height * 0.12,
                      width: double.infinity,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
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
                      imageUrl: "${ApiLink.imageUrl}${game.cover!}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${ApiLink.imageUrl}${game.cover!}"),
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
                  fontFamily: 'GilroyMedium',
                  weight: FontWeight.w400,
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.left,
                ),
              ),
              Gap(Get.height * 0.005),
            ],
          ),
        ],
      ),
    );
  }
}
