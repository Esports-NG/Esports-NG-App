import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/di/iterable_extension.dart';
import 'package:e_sport/ui/home/community/components/game_modes_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GameProfile extends StatefulWidget {
  const GameProfile({super.key, required this.game});
  final GamePlayed game;

  @override
  State<GameProfile> createState() => _GameProfileState();
}

class _GameProfileState extends State<GameProfile> {
  GamePlayed? details;
  final gameController = Get.put(GamesRepository());
  final authController = Get.put(AuthRepository());
  bool _isFollowing = true;
  int? _followersCount;
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

  Future<void> getGameDetails() async {
    var response = await gameController.getGameDetails(widget.game.id!);
    setState(() {
      details = response;
      _followersCount = response.followers!;
    });
  }

  @override
  void initState() {
    getGameDetails();
    getGameFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: (details != null)
          ? [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      details!.cover == null
                          ? Container(
                              height: Get.height * 0.15,
                              width: Get.width,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/png/community_cover.png'),
                                    fit: BoxFit.cover,
                                    opacity: 0.2),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => Helpers().showImagePopup(context,
                                  details!.cover!),
                              child: CachedNetworkImage(
                                height: Get.height * 0.15,
                                width: double.infinity,
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: SizedBox(
                                    height: Get.height * 0.05,
                                    width: Get.height * 0.05,
                                    child: CircularProgressIndicator(
                                        color: AppColor().primaryColor,
                                        value: progress.progress),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: AppColor().primaryColor),
                                imageUrl:
                                    details!.cover!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        opacity: 0.5),
                                  ),
                                ),
                              ),
                            ),
                      Positioned(
                        top: Get.height * 0.1,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            details!.profilePicture == null
                                ? Container(
                                    height: Get.height * 0.1,
                                    width: Get.height * 0.1,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: SvgPicture.asset(
                                        'assets/images/svg/people.svg'),
                                  )
                                : GestureDetector(
                                    onTap: () => Helpers().showImagePopup(
                                        context,
                                        details!.profilePicture!),
                                    child: CachedNetworkImage(
                                      height: Get.height * 0.1,
                                      width: Get.height * 0.1,
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
                                        child: SizedBox(
                                          height: Get.height * 0.02,
                                          width: Get.height * 0.02,
                                          child: CircularProgressIndicator(
                                              color: AppColor().primaryColor,
                                              value: progress.progress),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error,
                                              color: AppColor().primaryColor),
                                      imageUrl:
                                          details!.profilePicture!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  details!.profilePicture!),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
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
                      title: details!.name,
                      size: Get.height * 0.02,
                      fontFamily: 'InterBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: '${details!.players} Players',
                      size: Get.height * 0.017,
                      fontFamily: 'Inter',
                      color: AppColor().greyEight),
                  Gap(Get.height * 0.02),
                  Center(
                    child: IntrinsicWidth(
                      child: Row(
                          children: details!.downloadLinks!
                              .map((item) => GestureDetector(
                                  onTap: () async {
                                    print(item.link);
                                    await launchUrl(Uri.parse(item.link!));
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(99),
                                          border: Border.all(
                                              color: Color(0xff1F252F),
                                              width: 1)),
                                      child: ColorFiltered(
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xffEDEDFF),
                                          BlendMode.srcATop,
                                        ),
                                        child: Image.network(
                                              item.platform!.logo!,
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.cover,
                                        ),
                                      ))))
                              .toList()
                              .separator(Gap(16))
                              .toList()),
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ProfileMetric(
                        title: "Teams", value: details!.teams.toString()),
                    Gap(Get.height * 0.03),
                    Container(
                        height: Get.height * 0.03,
                        width: Get.width * 0.005,
                        color: AppColor().greyEight),
                    Gap(Get.height * 0.03),
                    ProfileMetric(
                        title: "Communities",
                        value: details!.communities.toString()),
                    Gap(Get.height * 0.03),
                    Container(
                        height: Get.height * 0.03,
                        width: Get.width * 0.005,
                        color: AppColor().greyEight),
                    Gap(Get.height * 0.03),
                    ProfileMetric(
                        title: "Followers", value: _followersCount.toString()),
                  ]),
                  Gap(Get.height * 0.03),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: InkWell(
                        onTap: () async {
                          setState(() {
                            _isFollowing = true;
                          });

                          var message =
                              await gameController.followGame(widget.game.id!);

                          setState(() {
                            if (message == "followed") {
                              _followersCount = _followersCount! + 1;
                              _isFollowingGame = true;
                            } else {
                              _followersCount = _followersCount! - 1;
                              _isFollowingGame = false;
                            }
                          });

                          setState(() {
                            _isFollowing = false;
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: _isFollowing
                                    ? Colors.transparent
                                    : AppColor().primaryColor),
                            child: Center(
                                child: _isFollowing
                                    ? const ButtonLoader()
                                    : CustomText(
                                        size: 14,
                                        color: AppColor().primaryWhite,
                                        fontFamily: "InterSemiBold",
                                        title: _isFollowingGame
                                            ? "Unfollow"
                                            : "Follow")))),
                  ),
                  Gap(Get.height * 0.03),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: CustomText(
                      size: 13,
                      title: details!.bio,
                      maxLines: 8,
                      color: AppColor().greySix,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(Get.height * 0.03),
                ],
              ),
              Divider(
                color: AppColor().darkGrey,
                thickness: 4,
              ),
              Gap(Get.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: "Categories",
                        fontFamily: "InterSemiBold",
                        size: 18,
                        color: AppColor().primaryWhite,
                      ),
                      Gap(Get.height * 0.02),
                      Wrap(
                        runSpacing: Get.height * 0.01,
                        spacing: Get.height * 0.01,
                        children: details!.categories!
                            .map((category) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                      color: AppColor().primaryDark,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: CustomText(
                                    title: category.type,
                                    color: AppColor().primaryWhite,
                                  ),
                                ))
                            .toList(),
                      )
                    ]),
              ),
              Gap(Get.height * 0.02),
              Divider(
                color: AppColor().darkGrey,
                thickness: 4,
              ),
              Gap(Get.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinkHeader(
                        title: "Game Modes",
                        function: () {},
                      ),
                      Gap(Get.height * 0.02),
                      SizedBox(
                        height: Get.height * 0.205,
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                Gap(Get.height * 0.02),
                            itemCount: details!.gameModes!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {},
                                  child: GameModeItem(
                                    mode: details!.gameModes![index].name!,
                                  ));
                            }),
                      )
                    ]),
              ),
              Gap(Get.height * 0.02),
              Divider(
                color: AppColor().darkGrey,
                thickness: 4,
              ),
              Gap(Get.height * 0.02),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              //   child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         LinkHeader(
              //           title: "Contributors",
              //           function: () {
              //             Get.to(() => Contributors(game: details!));
              //           },
              //         ),
              //         Gap(Get.height * 0.02),
              //         SizedBox(
              //           height: Get.height * 0.17,
              //           child: ListView.separated(
              //               physics: const BouncingScrollPhysics(),
              //               shrinkWrap: true,
              //               scrollDirection: Axis.horizontal,
              //               separatorBuilder: (context, index) =>
              //                   Gap(Get.height * 0.02),
              //               itemCount: details!.contributors!.length,
              //               itemBuilder: (context, index) {
              //                 return InkWell(
              //                     onTap: () {
              //                       Get.to(() => UserDetails(
              //                             id: details!.contributors![index].id!,
              //                           ));
              //                     },
              //                     child: ContributorItem(
              //                       contributor: details!.contributors![index],
              //                     ));
              //               }),
              //         )
              //       ]),
              // )
            ]
          : [
              SizedBox(
                height: Get.height,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor().primaryColor,
                  ),
                ),
              )
            ],
    )));
  }
}

class LinkHeader extends StatelessWidget {
  const LinkHeader({super.key, required this.title, required this.function});
  final String title;
  final function;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title: title,
          size: 18,
          fontFamily: "InterSemiBold",
          color: AppColor().primaryWhite,
        ),
        InkWell(
          onTap: function,
          child: Row(
            children: [
              CustomText(
                title: "See all",
                size: 16,
                color: AppColor().primaryColor,
                fontFamily: "InterMedium",
              ),
              Gap(Get.height * 0.01),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColor().primaryColor,
                size: 16,
              )
            ],
          ),
        )
      ],
    );
  }
}

class ProfileMetric extends StatelessWidget {
  const ProfileMetric({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
            title: value,
            size: Get.height * 0.02,
            fontFamily: 'InterBold',
            color: AppColor().primaryWhite),
        Gap(Get.height * 0.01),
        CustomText(
            title: title,
            size: Get.height * 0.017,
            fontFamily: 'Inter',
            color: AppColor().greyEight),
      ],
    );
  }
}
