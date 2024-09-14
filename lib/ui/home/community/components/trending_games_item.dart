import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TrendingGamesItem extends StatefulWidget {
  const TrendingGamesItem(
      {super.key, required this.game, this.isOnTrendingPage});

  final GamePlayed game;
  final bool? isOnTrendingPage;

  @override
  State<TrendingGamesItem> createState() => _TrendingGamesItemState();
}

class _TrendingGamesItemState extends State<TrendingGamesItem> {
  final gameController = Get.put(GamesRepository());
  final authController = Get.put(AuthRepository());
  bool _isFollowing = true;
  bool _isFollowingGame = false;
  List<UserModel>? _gameFollowers;

  Future<void> getGameFollowers() async {
    var followersJson = await gameController.getGameFollower(widget.game.id!);
    List<UserModel> followers =
        List.from(followersJson).map((e) => UserModel.fromJson(e)).toList();
    setState(() {
      _isFollowing = false;
      _gameFollowers = followers;
      var inList =
          followers.where((e) => e.id! == authController.user?.id!).toList();
      if (inList.isNotEmpty) {
        _isFollowingGame = true;
      }
    });
  }

  @override
  initState() {
    getGameFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.55,
      decoration: BoxDecoration(
        color: AppColor().bgDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().darkGrey,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.game.cover == null
                  ? Container(
                      height: Get.height * 0.1,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/png/placeholder.png'),
                            fit: BoxFit.cover),
                      ),
                    )
                  : CachedNetworkImage(
                      height: widget.isOnTrendingPage != null
                          ? Get.height * 0.1
                          : Get.height * 0.12,
                      width: double.infinity,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: SizedBox(
                          height: Get.height * 0.05,
                          width: Get.height * 0.05,
                          child: CircularProgressIndicator(
                              color: AppColor().primaryColor,
                              value: progress.progress),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: AppColor().primaryColor),
                      imageUrl: "${ApiLink.imageUrl}${widget.game.cover!}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${ApiLink.imageUrl}${widget.game.cover!}"),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
              const Spacer(),
              CustomText(
                title: widget.game.name!.toCapitalCase(),
                size: 15,
                fontFamily: 'InterMedium',
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.005),
              CustomText(
                title: '${widget.game.players} Player(s)',
                size: 12,
                fontFamily: 'Inter',
                color: AppColor().greySix,
              ),
              Gap(Get.height * 0.01),
              InkWell(
                onTap: () async {
                  setState(() {
                    _isFollowing = true;
                  });

                  var message =
                      await gameController.followGame(widget.game.id!);

                  setState(() {
                    if (message == "followed") {
                      _isFollowingGame = true;
                    } else {
                      _isFollowingGame = false;
                    }
                  });

                  setState(() {
                    _isFollowing = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(Get.height * 0.015),
                  margin: EdgeInsets.only(
                      left: Get.height * 0.02,
                      right: Get.height * 0.02,
                      bottom: Get.height * 0.02),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: _isFollowingGame
                          ? Border.all(
                              color: AppColor().primaryColor,
                            )
                          : null,
                      color: _isFollowingGame || _isFollowing
                          ? null
                          : AppColor().primaryColor),
                  child: Center(
                    child: _isFollowing
                        ? const ButtonLoader()
                        : CustomText(
                            title: _isFollowingGame ? "Unfollow" : 'Follow',
                            size: 14,
                            fontFamily: 'InterMedium',
                            color: _isFollowingGame
                                ? AppColor().primaryColor
                                : AppColor().primaryWhite,
                          ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
              top: Get.height * 0.065,
              child: widget.game.profilePicture == null
                  ? Container(
                      height: Get.height * 0.07,
                      width: Get.height * 0.07,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/svg/people.svg',
                      ),
                    )
                  : CachedNetworkImage(
                      height: widget.isOnTrendingPage != null
                          ? Get.height * 0.06
                          : Get.height * 0.08,
                      width: widget.isOnTrendingPage != null
                          ? Get.height * 0.06
                          : Get.height * 0.08,
                      progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: SizedBox(
                          height: Get.height * 0.02,
                          width: Get.height * 0.02,
                          child: CircularProgressIndicator(
                              color: AppColor().primaryColor,
                              value: progress.progress),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: AppColor().primaryColor),
                      imageUrl:
                          "${ApiLink.imageUrl}${widget.game.profilePicture!}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColor().primaryWhite, width: 0.5),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${ApiLink.imageUrl}${widget.game.profilePicture!}"),
                              fit: BoxFit.cover),
                        ),
                      ),
                    )),
        ],
      ),
    );
  }
}
