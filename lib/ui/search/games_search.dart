import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/home/community/components/trending_games_item.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GamesSearch extends StatefulWidget {
  const GamesSearch({super.key});
  @override
  State<GamesSearch> createState() => _GamesSearchState();
}

class _GamesSearchState extends State<GamesSearch> {
  final authController = Get.put(AuthRepository());
  final gameController = Get.put(GamesRepository());
  List<GamePlayed> _gameList = [];
  bool _isLoading = false;

  Future<void> searchForGames() async {
    setState(() {
      _isLoading = true;
    });
    List<GamePlayed> gameList = await gameController
        .searchForGames(authController.searchController.text);
    setState(() {
      _gameList = gameList;
      _isLoading = false;
    });
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Container(
          child: authController.searchLoading.value
              ? const Center(child: ButtonLoader())
              : gameController.searchedGames.isEmpty
                  ? Center(
                      child: CustomText(
                        title: "No game found.",
                        color: AppColor().primaryWhite,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(Get.height * 0.02),
                      child: Column(
                        children: [
                          GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 1 * 0.8,
                              ),
                              itemCount: gameController.searchedGames.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Get.to(() => GameProfile(
                                          game: gameController
                                              .searchedGames[index]));
                                    },
                                    child: TrendingGamesItem(
                                        isOnTrendingPage: true,
                                        game: gameController
                                            .searchedGames[index]));
                              })
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
