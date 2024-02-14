import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TrendingGamesItem extends StatelessWidget {
  final PlayerModel item;
  const TrendingGamesItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.55,
      decoration: BoxDecoration(
        color: AppColor().bgDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().greySix,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (item.profile == null)
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
                      height: Get.height * 0.1,
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
                      imageUrl: item.profile!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(item.profile!),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
              const Spacer(),
              CustomText(
                title: item.inGameName!.toCapitalCase(),
                size: 14,
                fontFamily: 'GilroySemiBold',
                weight: FontWeight.w400,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.01),
              CustomText(
                title: '@${item.inGameId}',
                size: 12,
                fontFamily: 'GilroyRegular',
                weight: FontWeight.w400,
                color: AppColor().greySix,
              ),
              Gap(Get.height * 0.005),
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
            child: (item.player!.profile!.profilePicture == null)
                ? Container(
                    height: Get.height * 0.06,
                    width: Get.height * 0.06,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/svg/people.svg',
                    ),
                  )
                : CachedNetworkImage(
                    height: Get.height * 0.06,
                    width: Get.height * 0.06,
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: SizedBox(
                        height: Get.height * 0.015,
                        width: Get.height * 0.015,
                        child: CircularProgressIndicator(
                            color: AppColor().primaryColor,
                            value: progress.progress),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, color: AppColor().primaryColor),
                    imageUrl: item.player!.profile!.profilePicture!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor().primaryWhite),
                        image: DecorationImage(
                            image: NetworkImage(
                                item.player!.profile!.profilePicture!),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
