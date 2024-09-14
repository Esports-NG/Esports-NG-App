import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_details.dart';
import 'package:e_sport/ui/components/account_community_detail.dart';
import 'package:e_sport/ui/components/error_page.dart';
import 'package:e_sport/ui/components/no_item_page.dart';
import 'package:e_sport/ui/home/community/components/community_filter.dart';
import 'package:e_sport/ui/home/community/components/community_filter_page.dart';
import 'package:e_sport/ui/home/community/components/community_item.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/home/community/components/trending_games_item.dart';
import 'package:e_sport/ui/home/community/components/trending_team_item.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/widget/coming_soon.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'components/suggested_profile_item.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({
    super.key,
    this.onFilterPage,
  });

  final bool? onFilterPage;

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  int? eventType = 0;
  final eventController = Get.put(EventRepository());
  final communityController = Get.put(CommunityRepository());
  final playerController = Get.put(PlayerRepository());
  final teamController = Get.put(TeamRepository());
  final postController = Get.put(PostRepository());
  final gamesController = Get.put(GamesRepository());
  final OverlayPortalController _overlayController = OverlayPortalController();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void handleTap() {
    setState(() {
      isSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          title: 'Community',
          fontFamily: 'InterSemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await communityController.getSuggestedProfiles();
          await communityController.getAllCommunity(false);
          await eventController.getAllTournaments(false);
          await postController.getAllPost(false);
          await gamesController.getAllGames();
          await teamController.getAllTeam(false);
          await teamController.getMyTeam(false);
        },
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: Column(
                        children: [
                          const CommunityFilter(
                            title: "All Categories",
                          ),
                          Gap(Get.height * 0.03),
                          PageHeaderWidget(
                            onTap: () {
                              communityController.typeFilter.value =
                                  "Suggested Profiles";
                              if (widget.onFilterPage != true) {
                                Get.to(() => const CommunityFilterPage());
                              }
                              _overlayController.hide();
                            },
                            title: 'Suggested profiles',
                          ),
                          Gap(Get.height * 0.03),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.28,
                      child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.02),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              Gap(Get.height * 0.02),
                          itemCount: communityController.suggestedProfiles
                              .take(5)
                              .length,
                          itemBuilder: (context, index) {
                            var item = communityController
                                .suggestedProfiles.reversed
                                .toList()[index];
                            return SizedBox(
                                child: SuggestedProfileList(item: item));
                          }),
                    ),
                  ],
                ),
                Gap(Get.height * 0.03),
                Divider(
                  color: AppColor().primaryWhite.withOpacity(0.1),
                  thickness: 4,
                ),
                Gap(Get.height * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: PageHeaderWidget(
                        onTap: () {
                          communityController.typeFilter.value =
                              "Trending Games";
                          if (widget.onFilterPage != true) {
                            Get.to(() => const CommunityFilterPage());
                          }
                          _overlayController.hide();
                        },
                        title: 'Trending Games',
                      ),
                    ),
                    Gap(Get.height * 0.03),
                    SizedBox(
                      height: Get.height * 0.28,
                      child: gamesController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.height * 0.02),
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
                                              .allGames.reversed
                                              .toList()[index]));
                                    },
                                    child: TrendingGamesItem(
                                      game: gamesController.allGames.reversed
                                          .toList()[index],
                                    ));
                              }),
                    )
                  ],
                ),
                Gap(Get.height * 0.03),
                Divider(
                  color: AppColor().primaryWhite.withOpacity(0.1),
                  thickness: 4,
                ),
                Gap(Get.height * 0.03),
                Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: PageHeaderWidget(
                        onTap: () {
                          communityController.typeFilter.value =
                              "Trending Communities";
                          if (widget.onFilterPage != true) {
                            Get.to(() => const CommunityFilterPage());
                          }
                          _overlayController.hide();
                        },
                        title: 'Trending Communities',
                      ),
                    ),
                    Gap(Get.height * 0.03),
                    SizedBox(
                      height: Get.height * 0.28,
                      child: (communityController.communityStatus ==
                              CommunityStatus.loading)
                          ? LoadingWidget(color: AppColor().primaryColor)
                          : (communityController.communityStatus ==
                                  CommunityStatus.available)
                              ? ListView.separated(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.height * 0.02),
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      Gap(Get.height * 0.02),
                                  itemCount: communityController
                                      .allCommunity.reversed
                                      .take(5)
                                      .length,
                                  itemBuilder: (context, index) {
                                    var item = communityController
                                        .allCommunity.reversed
                                        .toList()[index];
                                    return InkWell(
                                        onTap: () => Get.to(() =>
                                            AccountCommunityDetail(item: item)),
                                        child: CommunityItem(item: item));
                                  })
                              : (communityController.communityStatus ==
                                      CommunityStatus.empty)
                                  ? const NoItemPage(title: 'Communities')
                                  : const ErrorPage(),
                    ),
                  ],
                ),
                Gap(Get.height * 0.03),
                Divider(
                  color: AppColor().primaryWhite.withOpacity(0.1),
                  thickness: 4,
                ),
                Gap(Get.height * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: PageHeaderWidget(
                        onTap: () {
                          communityController.typeFilter.value =
                              "Trending Teams";
                          if (widget.onFilterPage != true) {
                            Get.to(() => const CommunityFilterPage());
                          }
                          _overlayController.hide();
                        },
                        title: 'Trending Teams',
                      ),
                    ),
                    Gap(Get.height * 0.03),
                    (teamController.teamStatus == TeamStatus.loading)
                        ? LoadingWidget(color: AppColor().primaryColor)
                        : (teamController.teamStatus == TeamStatus.available)
                            ? Container(
                                padding:
                                    EdgeInsets.only(left: Get.height * 0.02),
                                height: Get.height * 0.28,
                                child: ListView.separated(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) =>
                                        Gap(Get.height * 0.02),
                                    itemCount:
                                        teamController.allTeam.take(5).length,
                                    itemBuilder: (context, index) {
                                      var item = teamController.allTeam.reversed
                                          .toList()[index];
                                      return InkWell(
                                          onTap: () => Get.to(() =>
                                              AccountTeamsDetail(item: item)),
                                          child: TrendingTeamsItem(item: item));
                                    }),
                              )
                            : (teamController.teamStatus == TeamStatus.empty)
                                ? const NoItemPage(title: 'Teams')
                                : const ErrorPage(),
                  ],
                ),
                Gap(Get.height * 0.03),
                Divider(
                  color: AppColor().primaryWhite.withOpacity(0.1),
                  thickness: 4,
                ),
                Gap(Get.height * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: "Leaderboard",
                          color: AppColor().primaryWhite,
                          fontFamily: "InterSemiBold",
                          size: 16,
                        ),
                        Gap(Get.height * 0.02),
                        const Center(child: ComingSoonWidget())
                      ]),
                ),
                Gap(Get.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
