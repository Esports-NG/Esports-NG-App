import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TrendingTeamsItem extends StatelessWidget {
  final TeamModel item;
  final bool? onFilterPage;
  const TrendingTeamsItem({super.key, required this.item, this.onFilterPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.4,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (item.cover == null)
                  ? Container(
                      height: Get.height * 0.12,
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
                      imageUrl: '${ApiLink.imageUrl}${item.cover}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(
                                  '${ApiLink.imageUrl}${item.cover}'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
                child: Column(
                  children: [
                    CustomText(
                      title: item.name!.toCapitalCase(),
                      size: 16,
                      fontFamily: 'GilroySemiBold',
                      weight: FontWeight.w400,
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Gap(Get.height * 0.005),
                    Visibility(
                      visible: onFilterPage == null,
                      child: CustomText(
                        title: item.members!.isEmpty
                            ? 'No Member'
                            : item.members!.length == 1
                                ? '1 Member'
                                : '${item.members!.length.toString()} Members',
                        size: 12,
                        fontFamily: 'GilroyRegular',
                        weight: FontWeight.w400,
                        color: AppColor().greyFour,
                      ),
                    ),
                    Gap(Get.height * 0.01),
                    Container(
                      padding: EdgeInsets.all(Get.height * 0.015),
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
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: Get.height * 0.065,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                (item.profilePicture == null)
                    ? Container(
                        height: Get.height * 0.08,
                        width: Get.height * 0.08,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColor().primaryWhite)),
                        child: SvgPicture.asset(
                          'assets/images/svg/people.svg',
                        ),
                      )
                    : CachedNetworkImage(
                        height: Get.height * 0.08,
                        width: Get.height * 0.08,
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
                        imageUrl: item.profilePicture!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColor().primaryWhite),
                            image: DecorationImage(
                                image: NetworkImage(item.profilePicture!),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
