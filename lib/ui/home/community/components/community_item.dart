import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommunityItem extends StatelessWidget {
  final CommunityModel item;
  const CommunityItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.4,
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
                      imageUrl: item.cover!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(item.cover!),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
              const Spacer(),
              CustomText(
                title: item.name,
                size: 14,
                fontFamily: 'GilroySemiBold',
                weight: FontWeight.w400,
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
              ),
              Gap(Get.height * 0.01),
              CustomText(
                title: 'No Member',
                size: 12,
                fontFamily: 'GilroyRegular',
                weight: FontWeight.w400,
                color: AppColor().greySix,
              ),
              Container(
                padding: EdgeInsets.all(Get.height * 0.015),
                margin: EdgeInsets.all(Get.height * 0.02),
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
          Positioned(
            top: Get.height * 0.065,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                (item.logo == null)
                    ? Container(
                        height: Get.height * 0.08,
                        width: Get.height * 0.08,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
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
                        imageUrl: item.logo!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColor().primaryWhite, width: 2),
                            image: DecorationImage(
                                image: NetworkImage(item.logo!),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                Positioned(
                  child: SvgPicture.asset(
                    'assets/images/svg/check_badge.svg',
                    height: Get.height * 0.025,
                    width: Get.height * 0.025,
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

class AllCommunityItem extends StatelessWidget {
  final CommunityModel item;
  const AllCommunityItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.35,
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
                      imageUrl: item.cover!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(item.cover!),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
              const Spacer(),
              CustomText(
                title: item.name,
                size: 14,
                fontFamily: 'GilroySemiBold',
                weight: FontWeight.w400,
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
              ),
              Gap(Get.height * 0.015),
              CustomText(
                  title: 'No Member',
                  size: 12,
                  fontFamily: 'GilroyRegular',
                  weight: FontWeight.w400,
                  color: AppColor().greySix),
              Gap(Get.height * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: CustomText(
                    title:
                        'This team is made up of skilled gamers who are passionate about the Attack on Titan series.',
                    size: 12,
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.w400,
                    color: AppColor().greySix,
                    height: 1.5,
                    textAlign: TextAlign.center),
              ),
              Container(
                padding: EdgeInsets.all(Get.height * 0.015),
                margin: EdgeInsets.all(Get.height * 0.02),
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
          Positioned(
            top: Get.height * 0.065,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                (item.logo == null)
                    ? Container(
                        height: Get.height * 0.08,
                        width: Get.height * 0.08,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
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
                        imageUrl: '${ApiLink.imageUrl}${item.logo}',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColor().primaryWhite, width: 2),
                            image: DecorationImage(
                                image: NetworkImage(
                                    '${ApiLink.imageUrl}${item.logo}'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                Positioned(
                  child: SvgPicture.asset(
                    'assets/images/svg/check_badge.svg',
                    height: Get.height * 0.025,
                    width: Get.height * 0.025,
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
