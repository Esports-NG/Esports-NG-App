import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/screens/account/team/account_teams_details.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/ui/widgets/community/community_filter.dart';
import 'package:e_sport/ui/widgets/community/community_item.dart';
import 'package:e_sport/ui/screens/game/game_profile.dart';
import 'package:e_sport/ui/widgets/community/trending/suggested_profile_item.dart';
import 'package:e_sport/ui/widgets/community/trending/trending_games_item.dart';
import 'package:e_sport/ui/widgets/community/trending/trending_team_item.dart';
import 'package:e_sport/ui/screens/search/search_screen.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  late final PagingController<int, GamePlayed> _gamePagingController;
  late final PagingController<int, CommunityModel> _communityPagingController;
  late final PagingController<int, TeamModel> _teamPagingController;

  Future<List<GamePlayed>> _fetchGames(int pageKey) async {
    try {
      if (gameController.gamesNextLink.value != "" && pageKey > 1) {
        var games = await gameController.getNextGames();
        return games;
      } else {
        if (pageKey == 1) {
          var games = await gameController.getAllGames();
          print(games);
          return games;
        } else {
          return [];
        }
      }
    } catch (err) {
      return [];
    }
  }

  Future<List<CommunityModel>> _fetchCommunites(int pageKey) async {
    try {
      if (gameController.gamesNextLink.value != "" && pageKey > 1) {
        var community = await communityController.getAllCommunity(false);
        return community;
      } else {
        if (pageKey == 1) {
          var community = await communityController.getNextCommunity(false);
          print(community);
          return community;
        } else {
          return [];
        }
      }
    } catch (err) {
      return [];
    }
  }

  Future<List<TeamModel>> _fetchTeams(int pageKey) async {
    try {
      if (gameController.gamesNextLink.value != "" && pageKey > 1) {
        var teams = await teamController.getAllTeam(false);
        return teams;
      } else {
        if (pageKey == 1) {
          var teams = await teamController.getNextTeam(false);
          return teams;
        } else {
          return [];
        }
      }
    } catch (err) {
      return [];
    }
  }

  @override
  void dispose() {
    communityController.typeFilter.value = "All";
    super.dispose();
  }

  void initState() {
    _gamePagingController = PagingController<int, GamePlayed>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) => _fetchGames(pageKey),
    );
    _communityPagingController = PagingController<int, CommunityModel>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) => _fetchCommunites(pageKey),
    );
    _teamPagingController = PagingController<int, TeamModel>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) => _fetchTeams(pageKey),
    );
    super.initState();
  }

  // Get the selected page number for search
  int _getSelectedPage() {
    switch (communityController.typeFilter.value) {
      case "Trending Games":
        return 2;
      case "Suggested Profiles":
        return 1;
      case "Trending Teams":
        return 4;
      default:
        return 5;
    }
  }

  // Build the search field widget
  Widget _buildSearchField() {
    return SizedBox(
      height: Get.height * 0.06,
      child: CupertinoSearchTextField(
        placeholder: 'Search ${communityController.typeFilter.value}...',
        onSubmitted: (_) => Get.to(() => SearchScreen(
              selectedPage: _getSelectedPage(),
            )),
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
      ),
    );
  }

  // Build Trending Games grid
  Widget _buildTrendingGames() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        // 2
        () => _gamePagingController.refresh(),
      ),
      child: PagingListener(
        controller: _gamePagingController,
        builder: (context, state, fetchNextPage) => PagedGridView(
            state: state,
            fetchNextPage: fetchNextPage,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            builderDelegate: PagedChildBuilderDelegate<GamePlayed>(
                firstPageProgressIndicatorBuilder: (context) =>
                    Center(child: ButtonLoader()),
                newPageProgressIndicatorBuilder: (context) =>
                    Center(child: ButtonLoader()),
                itemBuilder: (context, game, index) {
                  return InkWell(
                      onTap: () {
                        Get.to(() => GameProfile(game: game));
                      },
                      child: TrendingGamesItem(
                          isOnTrendingPage: true, game: game));
                }),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1 * 0.8,
            )),
      ),
    );
  }

  // Build Suggested Profiles grid
  Widget _buildSuggestedProfiles() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1 * 0.7,
      ),
      itemCount: communityController.suggestedProfiles.length,
      itemBuilder: (context, index) {
        final profile =
            communityController.suggestedProfiles.reversed.toList()[index];
        return InkWell(
          onTap: () {
            // Navigation for suggested profiles
            // Note: This was empty in the original code
          },
          child: SuggestedProfileItem(item: profile),
        );
      },
    );
  }

  // Build Trending Teams grid
  Widget _buildTrendingTeams() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        // 2
        () => _teamPagingController.refresh(),
      ),
      child: PagingListener(
        controller: _teamPagingController,
        builder: (context, state, fetchNextPage) => PagedGridView(
            state: state,
            fetchNextPage: fetchNextPage,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            builderDelegate: PagedChildBuilderDelegate<TeamModel>(
                firstPageProgressIndicatorBuilder: (context) =>
                    Center(child: ButtonLoader()),
                newPageProgressIndicatorBuilder: (context) =>
                    Center(child: ButtonLoader()),
                itemBuilder: (context, team, index) {
                  return InkWell(
                      onTap: () {
                        Get.to(() => AccountTeamsDetail(item: team));
                      },
                      child: TrendingTeamsItem(
                        onFilterPage: true,
                        item: team,
                      ));
                }),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1 * 0.8,
            )),
      ),
    );
  }

  // Build Community grid
  Widget _buildCommunity() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        // 2
        () => _communityPagingController.refresh(),
      ),
      child: PagingListener(
        controller: _communityPagingController,
        builder: (context, state, fetchNextPage) => PagedGridView(
            state: state,
            fetchNextPage: fetchNextPage,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            builderDelegate: PagedChildBuilderDelegate<CommunityModel>(
                firstPageProgressIndicatorBuilder: (context) =>
                    Center(child: ButtonLoader()),
                newPageProgressIndicatorBuilder: (context) =>
                    Center(child: ButtonLoader()),
                itemBuilder: (context, community, index) {
                  return InkWell(
                      onTap: () {
                        Get.to(() => AccountCommunityDetail(item: community));
                      },
                      child: CommunityItem(
                        onFilterPage: true,
                        item: community,
                      ));
                }),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1 * 0.8,
            )),
      ),
    );
  }

  // Get the appropriate content based on filter type
  Widget _getFilterContent() {
    switch (communityController.typeFilter.value) {
      case "Trending Games":
        return _buildTrendingGames();
      case "Suggested Profiles":
        return _buildSuggestedProfiles();
      case "Trending Teams":
        return _buildTrendingTeams();
      default:
        return _buildCommunity();
    }
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
                _buildSearchField(),
                Gap(Get.height * 0.02),
                _getFilterContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
