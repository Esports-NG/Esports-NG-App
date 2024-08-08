import 'dart:math';

import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/search/community_search.dart';
import 'package:e_sport/ui/search/event_search.dart';
import 'package:e_sport/ui/search/games_search.dart';
import 'package:e_sport/ui/search/posts_search.dart';
import 'package:e_sport/ui/search/team_search.dart';
import 'package:e_sport/ui/search/users_search.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final authController = Get.put(AuthRepository());
  final gameController = Get.put(GamesRepository());
  final postController = Get.put(PostRepository());
  final eventController = Get.put(EventRepository());
  final teamController = Get.put(TeamRepository());
  final communityController = Get.put(CommunityRepository());

  late final _searchTabController = TabController(length: 6, vsync: this);
  Future<void> search() async {
    authController.searchLoading.value = true;
    // await authController.searchForUsers(authController.searchController.text);
    // await gameController.searchForGames(authController.searchController.text);
    // await postController.searchForPosts(authController.searchController.text);
    var json =
        await authController.searchAll(authController.searchController.text);
    var postList = List.from(json['posts']);
    var posts = postList.map((e) => PostModel.fromJson(e)).toList();
    postController.searchedPosts.assignAll(posts);

    var gameList = List.from(json['games']);
    var games = gameList.map((e) => GamePlayed.fromJson(e)).toList();
    gameController.searchedGames.assignAll(games);

    var userList = List.from(json["users"]);
    var users = userList.map((e) => UserModel.fromJson(e)).toList();
    authController.searchedUsers.assignAll(users);

    var eventList = List.from(json["events"]);
    var events = eventList.map((e) => EventModel.fromJson(e)).toList();
    eventController.searchedEvents.assignAll(events);

    var teamList = List.from(json["teams"]);
    var teams = teamList.map((e) => TeamModel.fromJson(e)).toList();
    teamController.searchedTeams.assignAll(teams);

    var communityList = List.from(json["communities"]);
    var communities =
        communityList.map((e) => CommunityModel.fromJson(e)).toList();
    communityController.searchedCommunities.assignAll(communities);

    authController.searchLoading.value = false;
  }

  @override
  initState() {
    search();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SafeArea(
        child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(right: Get.height * 0.02),
                child: Row(children: [
                  GoBackButton(onPressed: () => Get.back()),
                  const Gap(5),
                  Flexible(
                    child: CupertinoSearchTextField(
                      onSubmitted: (_) async {
                        await search();
                      },
                      prefixInsets: const EdgeInsets.only(right: 10, left: 10),
                      controller: authController.searchController,
                      itemColor: AppColor().primaryWhite.withOpacity(0.5),
                      style: TextStyle(
                          color: AppColor().primaryWhite,
                          fontFamily: 'GilroyMedium'),
                    ),
                  )
                ]),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColor().primaryColor,
                    indicatorColor: AppColor().primaryColor,
                    dividerColor: AppColor().primaryDark,
                    labelStyle: const TextStyle(
                      fontFamily: 'GilroyBold',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    unselectedLabelColor: AppColor().lightItemsColor,
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: 'GilroyMedium',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    controller: _searchTabController,
                    tabs: const [
                      Tab(text: "Posts"),
                      Tab(text: "Users"),
                      Tab(text: "Games"),
                      Tab(text: "Events"),
                      Tab(text: "Teams"),
                      Tab(text: "Communities"),
                    ],
                  )),
            )
          ],
          body: TabBarView(
            controller: _searchTabController,
            children: const [
              PostsSearch(),
              UsersSearch(),
              GamesSearch(),
              EventsSearch(),
              TeamSearch(),
              CommunitySearch()
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
        child:
            Container(color: AppColor().primaryBackGroundColor, child: child));
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
