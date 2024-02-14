// ignore_for_file: deprecated_member_use

import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
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

import 'no_item_page.dart';

class AccountTournamentDetail extends StatefulWidget {
  final EventModel item;
  const AccountTournamentDetail({super.key, required this.item});

  @override
  State<AccountTournamentDetail> createState() =>
      _AccountTournamentDetailState();
}

class _AccountTournamentDetailState extends State<AccountTournamentDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: Get.height * 0.15,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/png/tournament_cover.png'),
                        opacity: 0.2),
                  ),
                ),
                Positioned(
                  top: Get.height * 0.1,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      OtherImage(
                          itemSize: Get.height * 0.1,
                          image: '${ApiLink.imageUrl}${widget.item.profile}'),
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
                          child: Icon(
                            Icons.settings,
                            color: AppColor().primaryWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(Get.height * 0.07),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Column(
                children: [
                  CustomText(
                      title: widget.item.name,
                      weight: FontWeight.w500,
                      size: Get.height * 0.02,
                      fontFamily: 'GilroyBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.02),
                  AccountEventsItem(item: widget.item),
                  Gap(Get.height * 0.05),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: Get.height * 0.06,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColor().primaryColor,
                      ),
                      child:
                          // (authController.signInStatus == SignInStatus.loading)
                          //     ? const LoadingWidget()
                          //     :
                          Center(
                              child: CustomText(
                        title: 'Register Now',
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.018,
                        fontFamily: 'GilroyMedium',
                      )),
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomFillOption(
                              buttonColor: AppColor()
                                  .primaryBackGroundColor
                                  .withOpacity(0.7),
                              borderColor: AppColor().greyEight,
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
                                        title: 'Follow Community',
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
                              buttonColor: AppColor()
                                  .primaryBackGroundColor
                                  .withOpacity(0.7),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                              title: 'Tournament Link - ',
                              weight: FontWeight.w400,
                              size: Get.height * 0.017,
                              fontFamily: 'GilroyMedium',
                              underline: TextDecoration.underline,
                              color: AppColor().primaryWhite),
                          Gap(Get.height * 0.01),
                          CustomText(
                              title: 'https://bit.ly232sjfis',
                              weight: FontWeight.w400,
                              size: Get.height * 0.017,
                              fontFamily: 'GilroyMedium',
                              underline: TextDecoration.underline,
                              color: AppColor().primaryColor),
                        ],
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                          title:
                              'This is the most prestigious gaming tournament in the whole of West Africa. Covering a wide range of players with profound specialities from different games',
                          weight: FontWeight.w400,
                          size: Get.height * 0.015,
                          fontFamily: 'GilroyRegular',
                          textAlign: TextAlign.center,
                          height: 1.5,
                          color: AppColor().greyEight),
                      Gap(Get.height * 0.02),
                      CustomText(
                          title: 'See tournament details',
                          weight: FontWeight.w400,
                          size: Get.height * 0.017,
                          fontFamily: 'GilroyMedium',
                          underline: TextDecoration.underline,
                          color: AppColor().primaryColor),
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
                      title: 'Organising Community',
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
                          widget.item.community!.logo == null
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
                                  image: widget.item.community!.logo),
                          Positioned(
                            child: SvgPicture.asset(
                              'assets/images/svg/check_badge.svg',
                              height: Get.height * 0.015,
                            ),
                          ),
                        ],
                      ),
                      Gap(Get.height * 0.015),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              title:
                                  widget.item.community!.name!.toCapitalCase(),
                              weight: FontWeight.w400,
                              size: Get.height * 0.017,
                              fontFamily: 'GilroyMedium',
                              color: AppColor().primaryWhite),
                          Gap(Get.height * 0.005),
                          CustomText(
                              title: 'No members',
                              weight: FontWeight.w400,
                              size: Get.height * 0.015,
                              fontFamily: 'GilroyRegular',
                              textAlign: TextAlign.left,
                              height: 1.5,
                              color: AppColor().greyEight),
                        ],
                      ),
                    ],
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: widget.item.community!.bio != ''
                          ? widget.item.community!.bio!.toSentenceCase()
                          : 'Bio: Nil',
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
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 0.5,
                  ),
                  CustomText(
                      title: 'Partners',
                      weight: FontWeight.w400,
                      size: Get.height * 0.019,
                      fontFamily: 'GilroySemiBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.02),
                  Row(
                    children: [
                      widget.item.community!.logo == null
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
                              image: widget.item.community!.logo),
                      Gap(Get.height * 0.015),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              title:
                                  widget.item.community!.name!.toCapitalCase(),
                              weight: FontWeight.w400,
                              size: Get.height * 0.017,
                              fontFamily: 'GilroyMedium',
                              color: AppColor().primaryWhite),
                          Gap(Get.height * 0.005),
                          CustomText(
                              title: 'No members',
                              weight: FontWeight.w400,
                              size: Get.height * 0.015,
                              fontFamily: 'GilroyRegular',
                              textAlign: TextAlign.left,
                              height: 1.5,
                              color: AppColor().greyEight),
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
              child: PageHeaderWidget(
                onTap: () {},
                title: 'Fixtures and Results',
              ),
            ),
            NoItemPage(title: 'Fixtures', size: Get.height * 0.04),
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
                    title: 'Tournament Details',
                    fontFamily: 'GilroySemiBold',
                    size: 16,
                    color: AppColor().primaryWhite,
                  ),
                  Gap(Get.height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Column(
                      children: [
                        tournamentDetails(
                            onTap: () {}, title: 'Tournament Structure'),
                        Divider(
                            color: AppColor().lightItemsColor.withOpacity(0.3),
                            height: Get.height * 0.05,
                            thickness: 0.5),
                        tournamentDetails(
                            onTap: () {}, title: 'Rules and regulations'),
                        Divider(
                            color: AppColor().lightItemsColor.withOpacity(0.3),
                            height: Get.height * 0.05,
                            thickness: 0.5),
                        tournamentDetails(
                            onTap: () {}, title: 'Tournament Requirements'),
                        Divider(
                            color: AppColor().lightItemsColor.withOpacity(0.3),
                            height: Get.height * 0.05,
                            thickness: 0.5),
                        tournamentDetails(
                            onTap: () {}, title: 'Participant List'),
                        Gap(Get.height * 0.01),
                      ],
                    ),
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
              child: PageHeaderWidget(
                onTap: () {},
                title: 'Tournament Staff',
              ),
            ),
            NoItemPage(title: 'Staff', size: Get.height * 0.04),
            Divider(
              color: AppColor().lightItemsColor.withOpacity(0.3),
              height: Get.height * 0.05,
              thickness: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: PageHeaderWidget(
                onTap: () {},
                title: 'Announcement',
              ),
            ),
            NoItemPage(title: 'Announcement', size: Get.height * 0.04),
            Divider(
              color: AppColor().lightItemsColor.withOpacity(0.3),
              height: Get.height * 0.05,
              thickness: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: PageHeaderWidget(
                onTap: () {},
                title: 'Tournament Leaderboard',
              ),
            ),
            NoItemPage(title: 'Active tournament', size: Get.height * 0.04),
            Divider(
              color: AppColor().lightItemsColor.withOpacity(0.3),
              height: Get.height * 0.05,
              thickness: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: PageHeaderWidget(
                onTap: () {},
                title: 'Other Tournaments',
              ),
            ),
            NoItemPage(title: 'Tournament', size: Get.height * 0.04),
            Divider(
              color: AppColor().lightItemsColor.withOpacity(0.3),
              height: Get.height * 0.05,
              thickness: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: PageHeaderWidget(
                onTap: () {},
                title: 'Badges',
              ),
            ),
            NoItemPage(title: 'Badges', size: Get.height * 0.04),
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
            Gap(Get.height * 0.02),
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
        ),
      ),
    );
  }

  tournamentDetails({String? title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
              title: title,
              weight: FontWeight.w400,
              size: Get.height * 0.017,
              fontFamily: 'GilroyMedium',
              underline: TextDecoration.underline,
              color: AppColor().greySix),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColor().primaryColor,
            size: Get.height * 0.018,
          ),
        ],
      ),
    );
  }
}
