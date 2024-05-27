import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GamesPlayedDetails extends StatefulWidget {
  final PlayerModel item;
  const GamesPlayedDetails({super.key, required this.item});

  @override
  State<GamesPlayedDetails> createState() => _GamesPlayedDetailsState();
}

class _GamesPlayedDetailsState extends State<GamesPlayedDetails> {
  int? categoryType = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: GoBackButton(onPressed: () => Get.back()),
        title: InkWell(
          onTap: () =>
                    Get.to(() => UserDetails(id: widget.item.player!.id!.toInt())),
          child: CustomText(
            title: 'User: ${widget.item.player!.userName}',
            fontFamily: 'GilroySemiBold',
            size: 18,
            color: AppColor().primaryWhite,
          ),
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Row(
              children: [
                (widget.item.gamePlayed!.profilePicture == null)
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
                    : InkWell(
                      onTap: () => Get.to(() => GameProfile(game: widget.item.gamePlayed!)),
                      child: CachedNetworkImage(
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
                          imageUrl:
                              '${ApiLink.imageUrl}${widget.item.gamePlayed!.profilePicture}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColor().primaryWhite),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${ApiLink.imageUrl}${widget.item.gamePlayed!.profilePicture}'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                    ),
                Gap(Get.height * 0.015),
                CustomText(
                  title: 'Title: ',
                  size: 14,
                  fontFamily: 'GilroyRegular',
                  textAlign: TextAlign.start,
                  color: AppColor().greyOne,
                ),
                InkWell(
                  onTap: () => Get.to(() => GameProfile(game: widget.item.gamePlayed!)),
                  child: CustomText(
                    title: widget.item.gamePlayed!.name!.toCapitalCase(),
                    size: 14,
                    fontFamily: 'GilroySemiBold',
                    textAlign: TextAlign.start,
                    color: AppColor().greyOne,
                  ),
                ),
              ],
            ),
          ),
          Gap(Get.height * 0.015),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Row(
              children: [
                (widget.item.profile == null)
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
                        imageUrl: widget.item.profile,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColor().primaryWhite),
                            image: DecorationImage(
                                image: NetworkImage(widget.item.profile),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                Gap(Get.height * 0.015),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          title: 'IGN: ',
                          size: 14,
                          fontFamily: 'GilroyRegular',
                          textAlign: TextAlign.start,
                          color: AppColor().greyOne,
                        ),
                        CustomText(
                          title: widget.item.inGameName!,
                          size: 14,
                          fontFamily: 'GilroySemiBold',
                          textAlign: TextAlign.start,
                          color: AppColor().greyOne,
                        ),
                      ],
                    ),
                    Gap(Get.height * 0.005),
                    Row(
                      children: [
                        CustomText(
                          title: 'Game ID: ',
                          size: 14,
                          fontFamily: 'GilroyRegular',
                          textAlign: TextAlign.start,
                          color: AppColor().greyOne,
                        ),
                        CustomText(
                          title: widget.item.inGameId!,
                          size: 14,
                          fontFamily: 'GilroySemiBold',
                          textAlign: TextAlign.start,
                          color: AppColor().greyOne,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.05,
            thickness: 4,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    title: 'Statistics:',
                    weight: FontWeight.w400,
                    size: Get.height * 0.019,
                    fontFamily: 'GilroySemiBold',
                    color: AppColor().primaryWhite),
                Gap(Get.height * 0.04),
                categoryWidget(),
                Gap(Get.height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: Column(
                    children: [
                      stats(name: 'Matches Played', value: '0'),
                      Divider(
                          color: AppColor().lightItemsColor.withOpacity(0.3),
                          height: Get.height * 0.04),
                      stats(name: 'Wins', value: '0'),
                      Divider(
                          color: AppColor().lightItemsColor.withOpacity(0.3),
                          height: Get.height * 0.04),
                      stats(name: 'Draws', value: '0'),
                      Divider(
                          color: AppColor().lightItemsColor.withOpacity(0.3),
                          height: Get.height * 0.04),
                      stats(name: 'Losses', value: '0'),
                      Divider(
                          color: AppColor().lightItemsColor.withOpacity(0.3),
                          height: Get.height * 0.04),
                      stats(name: 'Kills', value: '0'),
                      Divider(
                          color: AppColor().lightItemsColor.withOpacity(0.3),
                          height: Get.height * 0.04),
                      stats(name: 'Deaths', value: '0'),
                      Divider(
                          color: AppColor().lightItemsColor.withOpacity(0.3),
                          height: Get.height * 0.04),
                      stats(name: 'Avg kills per game', value: '0'),
                      Divider(
                          color: AppColor().lightItemsColor.withOpacity(0.3),
                          height: Get.height * 0.04),
                      stats(name: 'K/D', value: '0'),
                      Divider(
                          color: AppColor().lightItemsColor.withOpacity(0.3),
                          height: Get.height * 0.04),
                      stats(name: 'Avg HP time per game', value: '0'),
                      Divider(
                          color: AppColor().lightItemsColor.withOpacity(0.3),
                          height: Get.height * 0.04),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  stats({String? name, value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title: name,
          size: 14,
          fontFamily: 'GilroyRegular',
          textAlign: TextAlign.start,
          color: AppColor().greyOne,
        ),
        CustomText(
          title: value,
          size: 14,
          fontFamily: 'GilroySemiBold',
          textAlign: TextAlign.start,
          color: AppColor().greyOne,
        ),
      ],
    );
  }

  categoryWidget() {
    return SizedBox(
      height: Get.height * 0.045,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        shrinkWrap: false,
        itemCount: gameStatItem.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.05),
        itemBuilder: (context, index) {
          var item = gameStatItem[index];
          return InkWell(
            onTap: () {
              setState(() {
                categoryType = index;
              });
            },
            child: Center(
              child: Column(
                children: [
                  CustomText(
                    title: item.title,
                    size: 13,
                    fontFamily:
                        categoryType == index ? 'GilroyBold' : 'GilroyMedium',
                    weight: FontWeight.w400,
                    textAlign: TextAlign.start,
                    color: categoryType == index
                        ? AppColor().primaryColor
                        : AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  Container(
                    width: Get.height * 0.12,
                    height: 1.5,
                    color: categoryType == index
                        ? AppColor().primaryColor
                        : AppColor().primaryBackGroundColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
