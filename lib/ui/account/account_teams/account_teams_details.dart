// ignore_for_file: deprecated_member_use

import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'account_teams_full_profile.dart';

class AccountTeamsDetail extends StatefulWidget {
  final TeamModel item;
  const AccountTeamsDetail({super.key, required this.item});

  @override
  State<AccountTeamsDetail> createState() => _AccountTeamsDetailState();
}

class _AccountTeamsDetailState extends State<AccountTeamsDetail> {
  final teamController = Get.put(TeamRepository());
  @override
  void initState() {
    super.initState();
    teamController.getTeamInbox(true, widget.item.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: Get.height * 0.15,
                width: Get.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/png/team_cover.png'),
                      fit: BoxFit.cover,
                      opacity: 0.2),
                ),
              ),
              Positioned(
                top: Get.height * 0.1,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    widget.item.cover == null
                        ? Container(
                            height: Get.height * 0.1,
                            width: Get.height * 0.1,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              'assets/images/svg/people.svg',
                            ),
                          )
                        : OtherImage(
                            itemSize: Get.height * 0.1,
                            image: '${ApiLink.imageUrl}${widget.item.cover}'),
                    Positioned(
                      child: SvgPicture.asset(
                        'assets/images/svg/check_badge.svg',
                        height: Get.height * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GoBackButton(onPressed: () => Get.back()),
                    Padding(
                      padding: EdgeInsets.only(right: Get.height * 0.02),
                      child: InkWell(
                        child: Icon(Icons.settings,
                            color: AppColor().primaryWhite),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(Get.height * 0.07),
          CustomText(
              title: widget.item.name,
              weight: FontWeight.w500,
              size: Get.height * 0.02,
              fontFamily: 'GilroyBold',
              color: AppColor().primaryWhite),
          Gap(Get.height * 0.01),
          CustomText(
              title: widget.item.members!.isEmpty
                  ? 'No Member'
                  : widget.item.members!.length == 1
                      ? '1 Member'
                      : '${widget.item.members!.length} Members',
              weight: FontWeight.w400,
              size: Get.height * 0.017,
              fontFamily: 'GilroyRegular',
              color: AppColor().greyEight),
          Gap(Get.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                      title: '0',
                      weight: FontWeight.w500,
                      size: Get.height * 0.02,
                      fontFamily: 'GilroyBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: 'Following',
                      weight: FontWeight.w400,
                      size: Get.height * 0.017,
                      fontFamily: 'GilroyRegular',
                      color: AppColor().greyEight),
                ],
              ),
              Gap(Get.height * 0.04),
              Container(
                  height: Get.height * 0.03,
                  width: Get.width * 0.005,
                  color: AppColor().greyEight),
              Gap(Get.height * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                      title: '0',
                      weight: FontWeight.w500,
                      size: Get.height * 0.02,
                      fontFamily: 'GilroyBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: 'Followers',
                      weight: FontWeight.w400,
                      size: Get.height * 0.017,
                      fontFamily: 'GilroyRegular',
                      color: AppColor().greyEight),
                ],
              ),
            ],
          ),
          Gap(Get.height * 0.04),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomFillOption(
                        onTap: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/images/svg/account_icon.svg',
                                  height: Get.height * 0.015,
                                  color: AppColor().primaryWhite),
                              Gap(Get.height * 0.01),
                              CustomText(
                                  title: 'Follow',
                                  weight: FontWeight.w400,
                                  size: Get.height * 0.017,
                                  fontFamily: 'GilroyRegular',
                                  color: AppColor().primaryWhite),
                            ]),
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Expanded(
                      child: CustomFillOption(
                        buttonColor:
                            AppColor().primaryBackGroundColor.withOpacity(0.7),
                        borderColor: AppColor().greyEight,
                        onTap: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sms_outlined,
                                color: AppColor().primaryWhite,
                                size: Get.height * 0.015,
                              ),
                              Gap(Get.height * 0.01),
                              CustomText(
                                  title: 'Message',
                                  weight: FontWeight.w400,
                                  size: Get.height * 0.017,
                                  fontFamily: 'GilroyRegular',
                                  color: AppColor().primaryWhite),
                              Gap(Get.height * 0.01),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColor().primaryColor,
                                size: Get.height * 0.015,
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                Gap(Get.height * 0.02),
                CustomFillOption(
                  buttonColor:
                      AppColor().primaryBackGroundColor.withOpacity(0.7),
                  borderColor: AppColor().greyEight,
                  onTap: () {},
                  child: CustomText(
                      title: 'Apply to team',
                      weight: FontWeight.w400,
                      size: Get.height * 0.017,
                      fontFamily: 'GilroyRegular',
                      color: AppColor().primaryWhite),
                ),
                Gap(Get.height * 0.04),
                CustomText(
                    title:
                        'This team is made up of skilled gamers who are passionate\nabout the Attack on Titan series.',
                    weight: FontWeight.w400,
                    size: Get.height * 0.015,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.center,
                    height: 1.5,
                    color: AppColor().greyEight),
                Gap(Get.height * 0.02),
                InkWell(
                  onTap: () =>
                      Get.to(() => AccountTeamsFullProfile(item: widget.item)),
                  child: CustomText(
                      title: 'See full profile',
                      weight: FontWeight.w400,
                      size: Get.height * 0.017,
                      fontFamily: 'GilroyMedium',
                      underline: TextDecoration.underline,
                      color: AppColor().primaryColor),
                ),
              ],
            ),
          ),
          Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.05,
            thickness: 4,
          ),
          SizedBox(
            width: Get.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      title: 'Team Owner',
                      weight: FontWeight.w400,
                      size: Get.height * 0.019,
                      fontFamily: 'GilroySemiBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.02),
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          widget.item.owner!.profile!.profilePicture == null
                              ? Container(
                                  height: Get.height * 0.04,
                                  width: Get.height * 0.04,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/svg/people.svg',
                                  ),
                                )
                              : OtherImage(
                                  itemSize: Get.height * 0.04,
                                  image: widget
                                      .item.owner!.profile!.profilePicture),
                          Positioned(
                            child: SvgPicture.asset(
                              'assets/images/svg/check_badge.svg',
                              height: Get.height * 0.015,
                            ),
                          ),
                        ],
                      ),
                      Gap(Get.height * 0.015),
                      CustomText(
                          title: widget.item.owner!.fullName!.toCapitalCase(),
                          weight: FontWeight.w400,
                          size: Get.height * 0.017,
                          fontFamily: 'GilroyMedium',
                          color: AppColor().primaryWhite),
                    ],
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title:
                          'I’m a gaming enthusiast and an integral part of the gaming community. With a passion for video games and a deep understanding of gaming trends...',
                      weight: FontWeight.w400,
                      size: Get.height * 0.015,
                      fontFamily: 'GilroyRegular',
                      textAlign: TextAlign.left,
                      height: 1.5,
                      color: AppColor().greyEight),
                  Gap(Get.height * 0.02),
                  Center(
                    child: CustomText(
                        title: 'See full profile',
                        weight: FontWeight.w400,
                        size: Get.height * 0.017,
                        fontFamily: 'GilroyMedium',
                        underline: TextDecoration.underline,
                        color: AppColor().primaryColor),
                  ),
                ],
              ),
            ),
          ),
          Gap(Get.height * 0.02),
          Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.05,
            thickness: 4,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: PageHeaderWidget(
              onTap: () {},
              title: 'Media, Links and Document',
            ),
          ),
          Gap(Get.height * 0.01),
          SizedBox(
            height: Get.height * 0.12,
            child: ListView.separated(
                physics: const ScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Gap(Get.height * 0.01),
                itemCount: mediaItems.length,
                itemBuilder: (context, index) {
                  var item = mediaItems[index];
                  return Container(
                    padding: EdgeInsets.all(Get.height * 0.02),
                    width: Get.width * 0.25,
                    decoration: BoxDecoration(
                      color: AppColor().bgDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor().greySix,
                      ),
                      image: DecorationImage(
                        image: AssetImage(item.image!),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  );
                }),
          ),
          Gap(Get.height * 0.04),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: 'Join our Community:',
                  fontFamily: 'GilroySemiBold',
                  size: 16,
                  color: AppColor().primaryWhite,
                ),
                Gap(Get.height * 0.02),
              ],
            ),
          ),
          Gap(Get.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Row(
              children: [
                SvgPicture.asset('assets/images/svg/discord.svg'),
                Gap(Get.height * 0.01),
                SvgPicture.asset('assets/images/svg/twitter.svg'),
                Gap(Get.height * 0.01),
                SvgPicture.asset('assets/images/svg/telegram.svg'),
                Gap(Get.height * 0.01),
                SvgPicture.asset('assets/images/svg/meduim.svg'),
              ],
            ),
          ),
          Gap(Get.height * 0.02),
        ],
      )),
    );
  }
}
