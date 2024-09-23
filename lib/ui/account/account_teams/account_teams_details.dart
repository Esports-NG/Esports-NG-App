// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account_teams/apply_as_player.dart';
import 'package:e_sport/ui/account/account_teams/edit_team_profile.dart';
import 'package:e_sport/ui/account/account_teams/player_application_list.dart';
import 'package:e_sport/ui/account/account_teams/team_players_list.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/components/no_item_page.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/home/post/components/report_page.dart';
import 'package:e_sport/ui/profiles/components/recent_posts.dart';
import 'package:e_sport/ui/profiles/components/team_games_played_item.dart';
import 'package:e_sport/ui/profiles/components/teams_games_played_list.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
  final postController = Get.put(PostRepository());

  List<Map<String, dynamic>>? _teamFollowers;
  bool _isFollowing = false;
  bool _isLoading = true;
  bool _isFetching = false;
  int? _followerCount;
  final List<bool> _isOpen = [true];
  TeamModel? _details = null;

  Future getTeamDetails() async {
    setState(() {
      _isFetching = true;
    });
    var response = await http
        .get(Uri.parse("${ApiLink.getAllTeam}${widget.item.id}/"), headers: {
      "Authorization": "JWT ${authController.token}",
      "Content-type": "application/json"
    });
    print(response.body);

    var json = jsonDecode(response.body);
    setState(() {
      _details = TeamModel.fromJson(json);
      _isFetching = false;
    });
  }

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
    getTeamDetails();
    // teamController.getTeamInbox(true, widget.item.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: _details == null || _isFetching
          ? const Center(child: ButtonLoader())
          : SingleChildScrollView(
              child: Column(
              children: [
                GestureDetector(
                  onTap: () => Helpers().showImagePopup(
                      context, "${ApiLink.imageUrl}${_details!.cover}"),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      _details!.cover == null
                          ? Container(
                              height: Get.height * 0.15,
                              width: Get.width,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/png/team_cover.png'),
                                    fit: BoxFit.cover,
                                    opacity: 0.2),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: "${ApiLink.imageUrl}${_details!.cover}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    height: Get.height * 0.15,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          opacity: 0.2),
                                    ),
                                  )),
                      Positioned(
                        top: Get.height * 0.1,
                        child: GestureDetector(
                          onTap: () => Helpers().showImagePopup(
                              context, "${_details!.profilePicture}"),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              _details!.profilePicture == null
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
                                      image: _details!.profilePicture),
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
                              padding:
                                  EdgeInsets.only(right: Get.height * 0.02),
                              child: InkWell(
                                onTap: () async {
                                  await showMenu(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide.none),
                                    constraints: const BoxConstraints(),
                                    color: AppColor().primaryMenu,
                                    position: const RelativeRect.fromLTRB(
                                        100, 100, 0, 0),
                                    items: _details!.owner!.id! ==
                                            authController.user!.id!
                                        ? [
                                            PopupMenuItem(
                                                value: "0",
                                                onTap: () async {
                                                  await Get.to(() =>
                                                          EditTeamPage(
                                                              team: _details!))!
                                                      .whenComplete(() async {
                                                    await getTeamDetails();
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(CupertinoIcons.pen,
                                                        color: AppColor()
                                                            .primaryWhite),
                                                    const Gap(10),
                                                    CustomText(
                                                      title: 'Edit Team',
                                                      color: AppColor()
                                                          .primaryWhite,
                                                    )
                                                  ],
                                                )),
                                            PopupMenuItem(
                                                value: "1",
                                                child: Row(
                                                  children: [
                                                    Icon(CupertinoIcons.delete,
                                                        color: AppColor()
                                                            .primaryRed),
                                                    const Gap(10),
                                                    CustomText(
                                                      title: 'Delete Team',
                                                      color:
                                                          AppColor().primaryRed,
                                                    )
                                                  ],
                                                )),
                                          ]
                                        : [
                                            PopupMenuItem(
                                              onTap: () async {
                                                await teamController
                                                    .blockTeam(_details!.id!);
                                              },
                                              value: '2',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.block,
                                                      color: AppColor()
                                                          .primaryWhite),
                                                  const Gap(10),
                                                  CustomText(
                                                    title: 'Block Team',
                                                    color:
                                                        AppColor().primaryWhite,
                                                  )
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () {
                                                Get.to(ReportPage(
                                                    id: _details!.id!,
                                                    type: "team"));
                                              },
                                              value: '3',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.report,
                                                    color:
                                                        AppColor().primaryWhite,
                                                  ),
                                                  const Gap(10),
                                                  CustomText(
                                                    title: 'Report Team',
                                                    color:
                                                        AppColor().primaryWhite,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                  );
                                },
                                child: Icon(Icons.more_vert,
                                    color: AppColor().primaryWhite),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(Get.height * 0.07),
                CustomText(
                    title: _details!.name,
                    size: Get.height * 0.02,
                    fontFamily: 'InterBold',
                    color: AppColor().primaryWhite),
                Gap(Get.height * 0.01),
                CustomText(
                    title: _details!.members!.isEmpty
                        ? 'No Member'
                        : _details!.members!.length == 1
                            ? '1 Member'
                            : '${_details!.members!.length} Members',
                    size: Get.height * 0.017,
                    fontFamily: 'Inter',
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
                            size: Get.height * 0.02,
                            fontFamily: 'InterBold',
                            color: AppColor().primaryWhite),
                        Gap(Get.height * 0.01),
                        CustomText(
                            title: 'Following',
                            size: Get.height * 0.017,
                            fontFamily: 'Inter',
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
                                size: Get.height * 0.02,
                                fontFamily: 'InterBold',
                                color: AppColor().primaryWhite)
                            : const ButtonLoader(),
                        Gap(Get.height * 0.01),
                        CustomText(
                            title: 'Followers',
                            size: Get.height * 0.017,
                            fontFamily: 'Inter',
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
                                title: _details!.playersCount.toString(),
                                size: Get.height * 0.02,
                                fontFamily: 'InterBold',
                                color: AppColor().primaryWhite)
                            : const ButtonLoader(),
                        Gap(Get.height * 0.01),
                        CustomText(
                            title: 'Players',
                            size: Get.height * 0.017,
                            fontFamily: 'Inter',
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
                              buttonColor:
                                  _isLoading ? Colors.transparent : null,
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                var message = await authController
                                    .followTeam(_details!.id!);
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
                                              size: Get.height * 0.017,
                                              fontFamily: 'Inter',
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
                                        size: Get.height * 0.017,
                                        fontFamily: 'Inter',
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
                            item: _details!,
                          ));
                        },
                        child: CustomText(
                            title: 'Apply to team',
                            size: Get.height * 0.017,
                            fontFamily: 'Inter',
                            color: AppColor().primaryWhite),
                      ),
                      Gap(Get.height * 0.04),
                      CustomText(
                          title:
                              'This team is made up of skilled gamers who are passionate\nabout the Attack on Titan series.',
                          size: Get.height * 0.015,
                          fontFamily: 'Inter',
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
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            title: 'Team Owner',
                            size: 18,
                            fontFamily: 'InterSemiBold',
                            color: AppColor().primaryWhite),
                        Gap(Get.height * 0.02),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Get.to(
                                  () => UserDetails(id: _details!.owner!.id!)),
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  _details!.owner!.profile!.profilePicture ==
                                          null
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
                                          image: _details!
                                              .owner!.profile!.profilePicture),
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
                                  () => UserDetails(id: _details!.owner!.id!)),
                              child: CustomText(
                                  title: _details!.owner!.fullName!
                                      .toCapitalCase(),
                                  size: Get.height * 0.017,
                                  fontFamily: 'InterMedium',
                                  color: AppColor().primaryWhite),
                            ),
                          ],
                        ),
                        Gap(Get.height * 0.01),
                        CustomText(
                            title: _details!.owner!.bio!,
                            size: Get.height * 0.015,
                            fontFamily: 'Inter',
                            textAlign: TextAlign.left,
                            height: 1.5,
                            color: AppColor().greyEight),
                        Gap(Get.height * 0.02),
                        InkWell(
                          onTap: () => Get.to(
                              () => UserDetails(id: _details!.owner!.id!)),
                          child: Center(
                            child: CustomText(
                                title: 'See full profile',
                                size: Get.height * 0.017,
                                fontFamily: 'InterMedium',
                                underline: TextDecoration.underline,
                                color: AppColor().primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(Get.height * 0.01),
                Divider(
                  color: AppColor().lightItemsColor.withOpacity(0.3),
                  height: Get.height * 0.05,
                  thickness: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: PageHeaderWidget(
                    onTap: () {},
                    title: 'Recent Posts',
                  ),
                ),
                Gap(Get.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: SizedBox(
                    width: double.infinity,
                    height: Get.height * 0.46,
                    child: ListView.separated(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            Gap(Get.height * 0.02),
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Get.to(() => PostDetails(
                                  item: postController.forYouPosts[index]));
                            },
                            child: SizedBox(
                                width: Get.height * 0.35,
                                child: PostItemForProfile(
                                    item: postController.forYouPosts[index]))),
                        itemCount: postController.forYouPosts.length),
                  ),
                ),
                Gap(Get.height * 0.005),
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
                        fontFamily: "InterSemiBold",
                      ),
                      Gap(Get.height * 0.02),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  Get.to(TeamPlayersList(item: _details!)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      title: "Squad",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                            Visibility(
                              visible: _details!.owner!.id ==
                                  authController.user!.id,
                              child: Column(
                                children: [
                                  Divider(
                                    thickness: 0.1,
                                    height: Get.height * 0.03,
                                  ),
                                  Visibility(
                                    child: GestureDetector(
                                      onTap: () => Get.to(() =>
                                          PlayerApplicationList(
                                              item: _details!)),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              title: "Player Applications",
                                              size: 14,
                                              color: AppColor().primaryWhite,
                                            ),
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              color: AppColor().primaryColor,
                                            )
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(Get.height * 0.01),
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
                        fontFamily: "InterSemiBold",
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpansionPanelList(
                                expansionCallback: (panelIndex, isExpanded) =>
                                    setState(() {
                                  _isOpen[panelIndex] = isExpanded;
                                }),
                                expandIconColor: AppColor().primaryColor,
                                children: [
                                  ExpansionPanel(
                                    isExpanded: _isOpen[0],
                                    backgroundColor:
                                        AppColor().primaryBackGroundColor,
                                    headerBuilder: (context, isExpanded) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            title: "Games Played",
                                            size: 14,
                                            color: AppColor().primaryWhite,
                                          ),
                                        ]),
                                    body: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: Get.height * 0.17,
                                          child: ListView.separated(
                                              physics: const ScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              separatorBuilder:
                                                  (context, index) =>
                                                      Gap(Get.height * 0.02),
                                              itemCount: widget
                                                  .item.gamesPlayed!.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                    onTap: () {
                                                      Get.to(() => GameProfile(
                                                          game: _details!
                                                                  .gamesPlayed![
                                                              index]));
                                                    },
                                                    child: TeamsGamesPlayedItem(
                                                      game: _details!
                                                          .gamesPlayed![index],
                                                      team: TeamModel(),
                                                    ));
                                              }),
                                        ),
                                        Gap(Get.height * 0.02),
                                        InkWell(
                                          onTap: () =>
                                              Get.to(() => TeamsGamesPlayedList(
                                                    team: _details!,
                                                  )),
                                          child: Center(
                                            child: CustomText(
                                                title: 'See all',
                                                size: Get.height * 0.017,
                                                fontFamily: 'InterMedium',
                                                underline:
                                                    TextDecoration.underline,
                                                color: AppColor().primaryColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                thickness: 0.1,
                                height: Get.height * 0.03,
                              ),
                              GestureDetector(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                Gap(Get.height * 0.01),
                Divider(
                  color: AppColor().lightItemsColor.withOpacity(0.3),
                  height: Get.height * 0.05,
                  thickness: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: PageHeaderWidget(
                    onTap: () {},
                    title: 'Social Events',
                  ),
                ),
                NoItemPage(title: 'Social Events', size: Get.height * 0.05),
                Gap(Get.height * 0.01),
                Divider(
                  color: AppColor().lightItemsColor.withOpacity(0.3),
                  height: Get.height * 0.05,
                  thickness: 4,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: PageHeaderWidget(
                    onTap: () {},
                    title: 'Achievements',
                  ),
                ),
                NoItemPage(title: 'Achievements', size: Get.height * 0.05),
                Gap(Get.height * 0.01),
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
                        fontFamily: 'InterSemiBold',
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
