import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/home/community/components/contributor_item.dart';
import 'package:e_sport/ui/home/community/components/game_modes_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'contributors.dart';

class GameProfile extends StatefulWidget {
  const GameProfile({super.key, required this.game});
  final GamePlayed game;

  @override
  State<GameProfile> createState() => _GameProfileState();
}

class _GameProfileState extends State<GameProfile> {
  GamePlayed? details;
  final gameController = Get.put(GamesRepository());

  Future<void> getGameDetails() async {
    var response = await gameController.getGameDetails(widget.game.id!);
    setState(() {
      details = response;
    });
  }

  @override
  void initState() {
    getGameDetails();
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
                          : CachedNetworkImage(
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
                              imageUrl: "${ApiLink.imageUrl}${details!.cover!}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "${ApiLink.imageUrl}${details!.cover!}"),
                                      fit: BoxFit.cover),
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
                                : CachedNetworkImage(
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
                                    errorWidget: (context, url, error) => Icon(
                                        Icons.error,
                                        color: AppColor().primaryColor),
                                    imageUrl:
                                        "${ApiLink.imageUrl}${details!.profilePicture!}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "${ApiLink.imageUrl}${details!.profilePicture!}"),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  )
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
                      weight: FontWeight.w500,
                      size: Get.height * 0.02,
                      fontFamily: 'GilroyBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: '${details!.players} Players',
                      weight: FontWeight.w400,
                      size: Get.height * 0.017,
                      fontFamily: 'GilroyRegular',
                      color: AppColor().greyEight),
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
                        title: "Followers",
                        value: details!.communities.toString()),
                  ]),
                  Gap(Get.height * 0.03),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: const CustomFillButton(buttonText: "Follow"),
                  ),
                  Gap(Get.height * 0.03),
                  // Padding(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  //   child: CustomText(
                  //     size: 13,
                  //     title: "",
                  //     color: AppColor().greySix,
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  // Gap(Get.height * 0.03),
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
                        fontFamily: "GilroySemiBold",
                        size: 18,
                        color: AppColor().primaryWhite,
                      ),
                      Gap(Get.height * 0.02),
                      Wrap(
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
                        height: Get.height * 0.26,
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                Gap(Get.height * 0.02),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {}, child: const GameModeItem());
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinkHeader(
                        title: "Contributors",
                        function: () {
                          Get.to(() => Contributors(game: details!));
                        },
                      ),
                      Gap(Get.height * 0.02),
                      SizedBox(
                        height: Get.height * 0.17,
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                Gap(Get.height * 0.02),
                            itemCount: details!.contributors!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    Get.to(() => UserDetails(
                                          id: details!.contributors![index].id!,
                                        ));
                                  },
                                  child: ContributorItem(
                                    contributor: details!.contributors![index],
                                  ));
                            }),
                      )
                    ]),
              )
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
          fontFamily: "GilroySemibold",
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
                fontFamily: "GilroyMedium",
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
            weight: FontWeight.w500,
            size: Get.height * 0.02,
            fontFamily: 'GilroyBold',
            color: AppColor().primaryWhite),
        Gap(Get.height * 0.01),
        CustomText(
            title: title,
            weight: FontWeight.w400,
            size: Get.height * 0.017,
            fontFamily: 'GilroyRegular',
            color: AppColor().greyEight),
      ],
    );
  }
}
