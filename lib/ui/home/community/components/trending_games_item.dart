import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TrendingGamesItem extends StatelessWidget {
  const TrendingGamesItem(
      {super.key, required this.game, this.isOnTrendingPage});

  final GamePlayed game;
  final bool? isOnTrendingPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.55,
      decoration: BoxDecoration(
        color: AppColor().bgDark,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      height: isOnTrendingPage != null
                          ? Get.height * 0.1
                          : Get.height * 0.12,
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
              CustomText(
                title: game.name!.toCapitalCase(),
                size: 15,
                fontFamily: 'GilroyMedium',
                weight: FontWeight.w400,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.005),
              CustomText(
                title: '${game.players} Player(s)',
                size: 12,
                fontFamily: 'GilroyRegular',
                weight: FontWeight.w400,
                color: AppColor().greySix,
              ),
              Gap(Get.height * 0.01),
              Container(
                padding: EdgeInsets.all(Get.height * 0.01),
                margin: EdgeInsets.only(
                    left: Get.height * 0.02,
                    right: Get.height * 0.02,
                    bottom: Get.height * 0.02),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: AppColor().primaryColor,
                  ),
                ),
                child: Center(
                  child: CustomText(
                    title: 'Follow',
                    size: 14,
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.w400,
                    color: AppColor().primaryColor,
                  ),
                ),
              )
            ],
          ),
          Positioned(
              top: Get.height * 0.065,
              child: game.profilePicture == null
                  ? Container(
                      height: Get.height * 0.07,
                      width: Get.height * 0.07,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/svg/people.svg',
                      ),
                    )
                  : CachedNetworkImage(
                      height: isOnTrendingPage != null
                          ? Get.height * 0.06
                          : Get.height * 0.08,
                      width: isOnTrendingPage != null
                          ? Get.height * 0.06
                          : Get.height * 0.08,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: SizedBox(
                          height: Get.height * 0.02,
                          width: Get.height * 0.02,
                          child: CircularProgressIndicator(
                              color: AppColor().primaryColor,
                              value: progress.progress),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: AppColor().primaryColor),
                      imageUrl: "${ApiLink.imageUrl}${game.profilePicture!}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColor().primaryWhite, width: 0.5),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${ApiLink.imageUrl}${game.profilePicture!}"),
                              fit: BoxFit.cover),
                        ),
                      ),
                    )),
        ],
      ),
    );
  }
}
