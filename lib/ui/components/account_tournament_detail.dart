// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/account/account_events/components/tournament_details.dart';
import 'package:e_sport/ui/components/account_community_detail.dart';
import 'package:e_sport/ui/components/choose_team_dialog.dart';
import 'package:e_sport/ui/components/participant_list.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/coming_soon.dart';
import 'package:e_sport/ui/widget/coming_soon_popup.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountTournamentDetail extends StatefulWidget {
  final EventModel item;
  const AccountTournamentDetail({super.key, required this.item});

  @override
  State<AccountTournamentDetail> createState() =>
      _AccountTournamentDetailState();
}

class _AccountTournamentDetailState extends State<AccountTournamentDetail> {
  final authController = Get.put(AuthRepository());
  final communityController = Get.put(CommunityRepository());
  final tournamentController = Get.put(TournamentRepository());

  List<Map<String, dynamic>>? _communityFollowers;
  bool _isFollowing = false;
  bool _isLoading = true;
  bool _isRegistered = false;
  bool _isRegisterLoading = false;

  Future getCommunityFollowers() async {
    var followers = await communityController
        .getCommunityFollowers(widget.item.community!.id!);
    setState(() {
      _communityFollowers = followers;
      if (followers.any(
          (element) => element["user_id"]["id"] == authController.user!.id)) {
        _isFollowing = true;
      } else {
        _isFollowing = false;
      }
      _isLoading = false;
    });
  }

  @override
  initState() {
    print(widget.item.toJson());
    getCommunityFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Helpers().showImagePopup(
                  context, "${ApiLink.imageUrl}${widget.item.banner}"),
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  widget.item.banner == null
                      ? Container(
                          height: Get.height * 0.15,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/png/tournament_cover.png'),
                                opacity: 0.2),
                          ),
                        )
                      : CachedNetworkImage(
                          height: Get.height * 0.15,
                          width: double.infinity,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: SizedBox(
                              height: Get.height * 0.05,
                              width: Get.height * 0.05,
                              child: CircularProgressIndicator(
                                  color: AppColor().primaryWhite,
                                  value: progress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, color: AppColor().primaryColor),
                          imageUrl: '${ApiLink.imageUrl}${widget.item.banner}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${ApiLink.imageUrl}${widget.item.banner}'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                  Positioned(
                    top: Get.height * 0.1,
                    child: GestureDetector(
                      onTap: () => Helpers()
                          .showImagePopup(context, "${widget.item.profile}"),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          OtherImage(
                              itemSize: Get.height * 0.1,
                              image: '${widget.item.profile}'),
                        ],
                      ),
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
                  AccountEventsItem(
                    item: widget.item,
                    onDetailsPage: true,
                  ),
                  Gap(Get.height * 0.05),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      if (widget.item.tournamentType == "team") {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              ChooseTeamDialog(id: widget.item.id!),
                        );
                      } else {
                        setState(() {
                          _isRegisterLoading = true;
                        });
                        await tournamentController
                            .registerForTournament(widget.item.id!);
                        setState(() {
                          _isRegisterLoading = false;
                        });
                      }
                    },
                    child: Container(
                      height: Get.height * 0.06,
                      width: Get.width,
                      decoration: BoxDecoration(
                        border: !_isRegisterLoading
                            ? null
                            : Border.all(
                                width: 1,
                                color:
                                    AppColor().primaryColor.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(30),
                        color: _isRegisterLoading
                            ? Colors.transparent
                            : AppColor().primaryColor,
                      ),
                      child: _isRegisterLoading
                          ? Center(
                              child: SizedBox(
                                width: Get.height * 0.03,
                                height: Get.height * 0.03,
                                child: CircularProgressIndicator(
                                  color: AppColor().primaryColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : Center(
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
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                String message =
                                    await authController.followCommunity(
                                        widget.item.community!.id!);
                                setState(() {
                                  if (message == "followed") {
                                    _isFollowing = true;
                                  } else if (message == "unfollowed") {
                                    _isFollowing = false;
                                  }
                                  _isLoading = false;
                                });
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _isLoading
                                      ? [
                                          Center(
                                            child: SizedBox(
                                              width: Get.height * 0.03,
                                              height: Get.height * 0.03,
                                              child: CircularProgressIndicator(
                                                color: AppColor().primaryColor,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          )
                                        ]
                                      : [
                                          CustomText(
                                              title: _isFollowing
                                                  ? "Unfollow"
                                                  : "Follow Community",
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
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: AppColor().primaryBgColor,
                                  content: const ComingSoonPopup(),
                                ),
                              ),
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
                          // InkWell(
                          //   onTap: () => launchUrl(
                          //       Uri.parse(widget.item.linkForBracket!)),
                          //   child: CustomText(
                          //       title: widget.item.linkForBracket,
                          //       weight: FontWeight.w400,
                          //       size: Get.height * 0.017,
                          //       fontFamily: 'GilroyMedium',
                          //       underline: TextDecoration.underline,
                          //       color: AppColor().primaryColor),
                          // ),
                        ],
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                          title: widget.item.summary,
                          weight: FontWeight.w400,
                          size: Get.height * 0.015,
                          fontFamily: 'GilroyRegular',
                          textAlign: TextAlign.center,
                          height: 1.5,
                          color: AppColor().greyFour),
                      // Gap(Get.height * 0.02),
                      // InkWell(
                      //   onTap: () =>
                      //       Get.to(() => TournamentDetails(item: widget.item)),
                      //   child: CustomText(
                      //       title: 'See tournament details',
                      //       weight: FontWeight.w400,
                      //       size: Get.height * 0.017,
                      //       fontFamily: 'GilroyMedium',
                      //       underline: TextDecoration.underline,
                      //       color: AppColor().primaryColor),
                      // ),
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
                  GestureDetector(
                    onTap: () => Get.to(
                        AccountCommunityDetail(item: widget.item.community!)),
                    child: Row(
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
                                title: widget.item.community!.name!
                                    .toCapitalCase(),
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
                  GestureDetector(
                    onTap: () => Get.to(
                        AccountCommunityDetail(item: widget.item.community!)),
                    child: Center(
                      child: CustomText(
                          title: 'See full profile',
                          weight: FontWeight.w400,
                          size: Get.height * 0.017,
                          fontFamily: 'GilroyMedium',
                          underline: TextDecoration.underline,
                          color: AppColor().primaryColor),
                    ),
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
            const ComingSoonWidget(),
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
                            onTap: () {
                              Get.to(() => ParticipantList(
                                    event: widget.item,
                                  ));
                            },
                            title: 'Participants List'),
                        Divider(
                            color: AppColor().lightItemsColor.withOpacity(0.3),
                            thickness: 0.5),
                        tournamentDetails(
                            onTap: () => Get.to(() => TournamentDetails(
                                title: "Tournament Structure",
                                value: widget.item.structure!)),
                            title: 'Tournament Structure'),
                        Divider(
                            color: AppColor().lightItemsColor.withOpacity(0.3),
                            thickness: 0.5),
                        tournamentDetails(
                            onTap: () => Get.to(() => TournamentDetails(
                                title: "Rules and Regulations",
                                value: widget.item.rulesRegs!)),
                            title: 'Rules and regulations'),
                        Divider(
                            color: AppColor().lightItemsColor.withOpacity(0.3),
                            thickness: 0.5),
                        tournamentDetails(
                            onTap: () => Get.to(() => TournamentDetails(
                                title: "Tournament Requirements",
                                value: widget.item.requirements!)),
                            title: 'Tournament Requirements'),
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
            const ComingSoonWidget(),
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
            const ComingSoonWidget(),
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
            const ComingSoonWidget(),
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
            const ComingSoonWidget(),
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
            const ComingSoonWidget(),
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
            const ComingSoonWidget(),
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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
                title: title,
                weight: FontWeight.w400,
                size: Get.height * 0.017,
                fontFamily: 'GilroyMedium',
                color: AppColor().greySix),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor().primaryColor,
              size: Get.height * 0.018,
            ),
          ],
        ),
      ),
    );
  }
}
