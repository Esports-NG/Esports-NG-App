// ignore_for_file: deprecated_member_use

import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account_teams/apply_as_player.dart';
import 'package:e_sport/ui/account/account_teams/team_players_list.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/profiles/components/team_games_played_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:e_sport/util/helpers.dart';

import 'account_teams_full_profile.dart';

class AccountTeamsDetail extends StatefulWidget {
  final TeamModel item;
  const AccountTeamsDetail({super.key, required this.item});

  @override
  State<AccountTeamsDetail> createState() => _AccountTeamsDetailState();
}

class _AccountTeamsDetailState extends State<AccountTeamsDetail> {
  final teamController = Get.put(TeamRepository());
  final authController = Get.put(AuthRepository());
  final gamesController = Get.put(GamesRepository());

  List<Map<String, dynamic>>? _teamFollowers;
  bool _isFollowing = false;
  bool _isLoading = true;
  int? _followerCount;
  List<bool> _isOpen = [true];

  Future getTeamFollowers() async {
    var followers = await teamController.getTeamFollowers(widget.item.id!);
    setState(() {
      _teamFollowers = followers;
      _followerCount = followers.length;
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
  void initState() {
    super.initState();
    getTeamFollowers();
    // teamController.getTeamInbox(true, widget.item.id!);
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
                child: GestureDetector(
                  onTap: () =>
                      Helpers().showImagePopup(context, "${widget.item.cover}"),
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
                  _teamFollowers != null
                      ? CustomText(
                          title: _followerCount.toString(),
                          weight: FontWeight.w500,
                          size: Get.height * 0.02,
                          fontFamily: 'GilroyBold',
                          color: AppColor().primaryWhite)
                      : const ButtonLoader(),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: 'Followers',
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
                  _teamFollowers != null
                      ? CustomText(
                          title: _followerCount.toString(),
                          weight: FontWeight.w500,
                          size: Get.height * 0.02,
                          fontFamily: 'GilroyBold',
                          color: AppColor().primaryWhite)
                      : const ButtonLoader(),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: 'Players',
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
                        buttonColor: _isLoading ? Colors.transparent : null,
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          var message =
                              await authController.followTeam(widget.item.id!);
                          print(message);

                          setState(() {
                            if (message == "unfollowed") {
                              _isFollowing = false;
                              _followerCount = _followerCount! - 1;
                            } else if (message == "followed") {
                              _isFollowing = true;
                              _followerCount = _followerCount! + 1;
                            }
                            _isLoading = false;
                          });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _isLoading
                                ? [const ButtonLoader()]
                                : [
                                    SvgPicture.asset(
                                        'assets/images/svg/account_icon.svg',
                                        height: Get.height * 0.015,
                                        color: AppColor().primaryWhite),
                                    Gap(Get.height * 0.01),
                                    CustomText(
                                        title: _isFollowing
                                            ? 'Unfollow'
                                            : 'Follow',
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
                        borderColor: AppColor().darkGrey,
                        onTap: () {
                          Helpers().showComingSoonDialog(context);
                        },
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
                  borderColor: AppColor().darkGrey,
                  onTap: () {
                    Get.to(ApplyAsPlayer(
                      item: widget.item,
                    ));
                  },
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
                      size: 18,
                      fontFamily: 'GilroySemiBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.02),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Get.to(
                            () => UserDetails(id: widget.item.owner!.id!)),
                        child: Stack(
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
                      ),
                      Gap(Get.height * 0.015),
                      InkWell(
                        onTap: () => Get.to(
                            () => UserDetails(id: widget.item.owner!.id!)),
                        child: CustomText(
                            title: widget.item.owner!.fullName!.toCapitalCase(),
                            weight: FontWeight.w400,
                            size: Get.height * 0.017,
                            fontFamily: 'GilroyMedium',
                            color: AppColor().primaryWhite),
                      ),
                    ],
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: widget.item.owner!.bio!,
                      weight: FontWeight.w400,
                      size: Get.height * 0.015,
                      fontFamily: 'GilroyRegular',
                      textAlign: TextAlign.left,
                      height: 1.5,
                      color: AppColor().greyEight),
                  Gap(Get.height * 0.02),
                  InkWell(
                    onTap: () =>
                        Get.to(() => UserDetails(id: widget.item.owner!.id!)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "Personnel List",
                  size: 18,
                  color: AppColor().primaryWhite,
                  fontFamily: "GilroySemiBold",
                ),
                Gap(Get.height * 0.02),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(TeamPlayersList(item: widget.item)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                title: "Players",
                                size: 14,
                                color: AppColor().primaryWhite,
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: AppColor().primaryColor,
                              )
                            ]),
                      ),
                      Divider(
                        thickness: 0.1,
                        height: Get.height * 0.03,
                      ),
                      GestureDetector(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                title: "Staff List",
                                size: 14,
                                color: AppColor().primaryWhite,
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: AppColor().primaryColor,
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "Team Records",
                  size: 18,
                  color: AppColor().primaryWhite,
                  fontFamily: "GilroySemiBold",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(children: [
                    ExpansionPanelList(
                      expansionCallback: (panelIndex, isExpanded) =>
                          setState(() {
                        _isOpen[panelIndex] = isExpanded;
                      }),
                      expandIconColor: AppColor().primaryColor,
                      children: [
                        ExpansionPanel(
                          isExpanded: _isOpen[0],
                          backgroundColor: AppColor().primaryBackGroundColor,
                          headerBuilder: (context, isExpanded) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  title: "Games Played",
                                  size: 14,
                                  color: AppColor().primaryWhite,
                                ),
                              ]),
                          body: SizedBox(
                            height: Get.height * 0.17,
                            child: gamesController.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.separated(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) =>
                                        Gap(Get.height * 0.02),
                                    itemCount:
                                        gamesController.allGames.take(5).length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () {
                                            Get.to(() => GameProfile(
                                                game: gamesController
                                                    .allGames[index]));
                                          },
                                          child: TeamsGamesPlayedItem(
                                            game:
                                                gamesController.allGames[index],
                                          ));
                                    }),
                          ),
                        )
                      ],
                    ),
                    Gap(Get.height * 0.02),
                    InkWell(
                      onTap: () =>
                          Get.to(() => UserDetails(id: widget.item.owner!.id!)),
                      child: Center(
                        child: CustomText(
                            title: 'See all games',
                            weight: FontWeight.w400,
                            size: Get.height * 0.017,
                            fontFamily: 'GilroyMedium',
                            underline: TextDecoration.underline,
                            color: AppColor().primaryColor),
                      ),
                    ),
                    Divider(
                      thickness: 0.1,
                      height: Get.height * 0.03,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: "Tournament History",
                              size: 14,
                              color: AppColor().primaryWhite,
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: AppColor().primaryColor,
                            )
                          ]),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Gap(Get.height * 0.02),
          Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.05,
            thickness: 4,
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
