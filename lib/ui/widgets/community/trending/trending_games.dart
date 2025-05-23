import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/ui/screens/game/game_profile.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'trending_games_item.dart';

class TrendingGames extends StatefulWidget {
  const TrendingGames({super.key});

  @override
  State<TrendingGames> createState() => _TrendingGamesState();
}

class _TrendingGamesState extends State<TrendingGames> {
  var gameController = Get.put(GamesRepository());
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
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

  late final PagingController<int, GamePlayed> _pagingController;

  Future<List<GamePlayed>> _fetchPage(int pageKey) async {
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

  void initState() {
    _pagingController = PagingController<int, GamePlayed>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: (pageKey) => _fetchPage(pageKey),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: GoBackButton(onPressed: () => Get.back()),
        title: CustomText(
          title: 'Trending Games',
          fontFamily: 'InterSemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.06,
                child: CustomTextField(
                  hint: "Search for gaming news, competitions...",
                  fontFamily: 'InterMedium',
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: AppColor().lightItemsColor,
                  ),
                  // textEditingController: playerController.searchController,
                  hasText: isSearch!,
                  focusNode: _searchFocusNode,
                  onTap: handleTap,
                  onSubmited: (_) {
                    _searchFocusNode.unfocus();
                  },
                  onChanged: (value) {
                    setState(() {
                      isSearch = value.isNotEmpty;
                    });
                  },
                ),
              ),
              Gap(Get.height * 0.025),
              PagingListener(
                controller: _pagingController,
                builder: (context, state, fetchNextPage) => PagedGridView(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    builderDelegate: PagedChildBuilderDelegate<GamePlayed>(
                        itemBuilder: (context, game, index) {
                      return InkWell(
                          onTap: () {
                            Get.to(() => GameProfile(
                                game: gameController.allGames[index]));
                          },
                          child: TrendingGamesItem(
                              isOnTrendingPage: true,
                              game: gameController.allGames[index]));
                    }),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1 * 0.8,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
