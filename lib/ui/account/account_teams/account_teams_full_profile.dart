import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountTeamsFullProfile extends StatefulWidget {
  final TeamModel item;
  const AccountTeamsFullProfile({super.key, required this.item});

  @override
  State<AccountTeamsFullProfile> createState() =>
      _AccountTeamsFullProfileState();
}

class _AccountTeamsFullProfileState extends State<AccountTeamsFullProfile> {
  final authController = Get.put(AuthRepository());
  final teamController = Get.put(TeamRepository());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColor().primaryBackGroundColor,
        body: SingleChildScrollView(
            child: Column(children: [
          Gap(Get.height * 0.06),
          Row(
            children: [
              GoBackButton(onPressed: () => Get.back()),
              InkWell(
                onTap: () =>
                    Get.to(() => UserDetails(item: widget.item.owner!)),
                child: widget.item.owner!.profile!.profilePicture == null
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
                        image: widget.item.owner!.profile!.profilePicture),
              ),
              Gap(Get.height * 0.015),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      title: widget.item.owner!.fullName!.toCapitalCase(),
                      weight: FontWeight.w400,
                      size: Get.height * 0.018,
                      fontFamily: 'GilroyMedium',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.005),
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
                ],
              ),
              Spacer(),
              if (widget.item.owner!.fullName != authController.user!.fullName)
                CustomFillButton(
                  buttonText: 'Follow',
                  textSize: Get.height * 0.015,
                  width: Get.width * 0.25,
                  height: Get.height * 0.04,
                  onTap: () {},
                  isLoading: false,
                ),
              Gap(Get.height * 0.02),
            ],
          ),
          Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.03,
            thickness: 0.5,
          ),
          teamController.teamInboxStatus == TeamInboxStatus.loading
              ? const ProgressLoader()
              : Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: Column(
                        children: [
                          PageHeaderWidget(
                            onTap: () => Get.to(() => Container()),
                            title: 'Recent Posts',
                          ),
                        ],
                      ),
                    ),
                    Gap(Get.height * 0.03),
                    Divider(
                      color: AppColor().primaryWhite.withOpacity(0.1),
                      thickness: 4,
                    ),
                    Gap(Get.height * 0.015),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: 'Personnel List',
                            fontFamily: 'GilroySemiBold',
                            size: 16,
                            color: AppColor().primaryWhite,
                          ),
                          Gap(Get.height * 0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.height * 0.02),
                            child: Column(
                              children: [
                                tournamentDetails(
                                    onTap: () {},
                                    title:
                                        'Players (${teamController.teamInbox!.team!.members!.length})'),
                                Divider(
                                    color: AppColor()
                                        .lightItemsColor
                                        .withOpacity(0.3),
                                    height: Get.height * 0.05,
                                    thickness: 0.5),
                                tournamentDetails(
                                    onTap: () {},
                                    title:
                                        'Staff (${teamController.teamInbox!.team!.teamStaffs!.length})'),
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
                    Gap(Get.height * 0.015),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: 'Team Record',
                            fontFamily: 'GilroySemiBold',
                            size: 16,
                            color: AppColor().primaryWhite,
                          ),
                          Gap(Get.height * 0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.height * 0.02),
                            child: Column(
                              children: [
                                tournamentDetails(
                                    onTap: () {}, title: 'Game Played'),
                                Divider(
                                    color: AppColor()
                                        .lightItemsColor
                                        .withOpacity(0.3),
                                    height: Get.height * 0.05,
                                    thickness: 0.5),
                                tournamentDetails(
                                    onTap: () {}, title: 'Tournament History'),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
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
                )
        ])),
      );
    });
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
