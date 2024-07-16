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
import 'package:e_sport/ui/home/community/suggested_profile.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
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
            weight: FontWeight.w600,
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
              GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1 * 0.75,
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
                                game: gameController.allGames[index]));
                          } else if (communityController.typeFilter.value ==
                              "Suggested Profiles") {
                          } else if (communityController.typeFilter.value ==
                              "Trending Teams") {
                            Get.to(() => AccountTeamsDetail(
                                item: teamController.allTeam[index]));
                          } else {
                            Get.to(() => AccountCommunityDetail(
                                item: communityController.allCommunity[index]));
                          }
                        },
                        child: communityController.typeFilter.value ==
                                "Trending Games"
                            ? TrendingGamesItem(
                                isOnTrendingPage: true,
                                game: gameController.allGames[index])
                            : communityController.typeFilter.value ==
                                    "Suggested Profiles"
                                ? SuggestedProfileItem(
                                    item: communityController
                                        .suggestedProfiles[index])
                                : communityController.typeFilter.value ==
                                        "Trending Teams"
                                    ? TrendingTeamsItem(
                                        onFilterPage: true,
                                        item: teamController.allTeam[index])
                                    : CommunityItem(
                                        onFilterPage: true,
                                        item: communityController
                                            .allCommunity[index]));
                  })
            ],
          ),
        )),
      ),
    );
  }
}
