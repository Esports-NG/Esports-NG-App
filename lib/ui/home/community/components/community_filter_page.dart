import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_details.dart';
import 'package:e_sport/ui/components/account_community_detail.dart';
import 'package:e_sport/ui/home/community/components/community_filter.dart';
import 'package:e_sport/ui/home/community/components/community_item.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/home/community/components/suggested_profile_item.dart';
import 'package:e_sport/ui/home/community/components/trending_games_item.dart';
import 'package:e_sport/ui/home/community/components/trending_team_item.dart';
import 'package:e_sport/ui/search/search_screen.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommunityFilterPage extends StatefulWidget {
  const CommunityFilterPage({super.key});

  @override
  State<CommunityFilterPage> createState() => _CommunityFilterPageState();
}

class _CommunityFilterPageState extends State<CommunityFilterPage> {
  final communityController = Get.put(CommunityRepository());
  final gameController = Get.put(GamesRepository());
  final teamController = Get.put(TeamRepository());
  final authController = Get.put(AuthRepository());

  @override
  void dispose() {
    communityController.typeFilter.value = "All";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: GoBackButton(onPressed: () => Get.back()),
          title: CustomText(
            title: communityController.typeFilter.value,
            color: AppColor().primaryWhite,
            fontFamily: "InterSemiBold",
            size: 18,
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
            children: [
              CommunityFilter(
                title: communityController.typeFilter.value,
                onFilterPage: true,
              ),
              Gap(Get.height * 0.02),
              SizedBox(
                  height: Get.height * 0.06,
                  child: CupertinoSearchTextField(
                    placeholder:
                        'Search ${communityController.typeFilter.value}...',
                    onSubmitted: (_) => Get.to(() => SearchScreen(
                        selectedPage: communityController.typeFilter.value ==
                                "Trending Games"
                            ? 2
                            : communityController.typeFilter.value ==
                                    "Suggested Profiles"
                                ? 1
                                : communityController.typeFilter.value ==
                                        "Trending Teams"
                                    ? 4
                                    : 5)),
                    borderRadius: BorderRadius.circular(10),
                    prefixInsets: const EdgeInsets.only(right: 5, left: 10),
                    controller: authController.searchController,
                    itemColor: AppColor().primaryWhite.withOpacity(0.5),
                    style: TextStyle(
                      color: AppColor().primaryWhite,
                      fontFamily: 'InterMedium',
                      fontSize: 14,
                      height: Get.height * 0.0019,
                    ),
                  )),
              Gap(Get.height * 0.02),
              GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: communityController.typeFilter.value == "Trending Games" ? 1 * 0.63 : 1 *0.7,
                  ),
                  itemCount:
                      communityController.typeFilter.value == "Trending Games"
                          ? gameController.allGames.length
                          : communityController.typeFilter.value ==
                                  "Suggested Profiles"
                              ? communityController.suggestedProfiles.length
                              : communityController.typeFilter.value ==
                                      "Trending Teams"
                                  ? teamController.allTeam.length
                                  : communityController.allCommunity.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          if (communityController.typeFilter.value ==
                              "Trending Games") {
                            Get.to(() => GameProfile(
                                game: gameController.allGames.reversed
                                    .toList()[index]));
                          } else if (communityController.typeFilter.value ==
                              "Suggested Profiles") {
                          } else if (communityController.typeFilter.value ==
                              "Trending Teams") {
                            Get.to(() => AccountTeamsDetail(
                                item: teamController.allTeam.reversed
                                    .toList()[index]));
                          } else {
                            Get.to(() => AccountCommunityDetail(
                                item: communityController.allCommunity.reversed
                                    .toList()[index]));
                          }
                        },
                        child: communityController.typeFilter.value ==
                                "Trending Games"
                            ? TrendingGamesItem(
                                isOnTrendingPage: true,
                                game: gameController.allGames.reversed
                                    .toList()[index])
                            : communityController.typeFilter.value ==
                                    "Suggested Profiles"
                                ? SuggestedProfileItem(
                                    item: communityController
                                        .suggestedProfiles.reversed
                                        .toList()[index])
                                : communityController.typeFilter.value ==
                                        "Trending Teams"
                                    ? TrendingTeamsItem(
                                        onFilterPage: true,
                                        item: teamController.allTeam.reversed
                                            .toList()[index])
                                    : CommunityItem(
                                        onFilterPage: true,
                                        item: communityController
                                            .allCommunity.reversed
                                            .toList()[index]));
                  })
            ],
          ),
        )),
      ),
    );
  }
}
