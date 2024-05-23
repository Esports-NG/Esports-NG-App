import 'package:e_sport/data/model/account_teams_model.dart';
import 'package:e_sport/ui/components/leaderboard_dropdown.dart';
import 'package:e_sport/ui/leaderboard/ranking_card.dart';
import 'package:e_sport/ui/leaderboard/tournament.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'team_rank_item.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        elevation: 0,
        title: CustomText(
          title: 'Leaderboard',
          weight: FontWeight.w600,
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: AppColor().primaryWhite,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Icon(
              Icons.info_outline,
              color: AppColor().primaryWhite,
              size: 30,
            ),
          )
        ],
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/png/lImage1.png',
                      height: Get.height * 0.05,
                    ),
                    Gap(Get.height * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: 'Call of Duty Mobile',
                          size: 14,
                          fontFamily: 'GilroySemiBold',
                          textAlign: TextAlign.start,
                          color: AppColor().primaryWhite,
                        ),
                        Gap(Get.height * 0.005),
                        CustomText(
                          title: 'MP MODE',
                          size: 12,
                          fontFamily: 'GilroyRegular',
                          textAlign: TextAlign.start,
                          color: AppColor().greyTwo,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColor().greyTwo,
                        size: 18,
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor().primaryColor,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(Get.height * 0.02),
            SizedBox(
              width: Get.width,
              height: 350,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    RankingCard(title: "Ranking", teamRanks: teamRankItem),
                itemCount: 2,
                shrinkWrap: true,
                separatorBuilder: (context, index) => Gap(Get.width * 0.05),
              ),
            ),
            Gap(Get.height * 0.02),
            Row(
              children: [
                const Expanded(
                    child: LeaderboardDropdown(
                  title: "Game",
                  left: true,
                )),
                Gap(Get.height * 0.02),
                const Expanded(
                    child: LeaderboardDropdown(title: "Mode", left: false))
              ],
            ),
            Gap(Get.height * 0.02),
            const Row(
              children: [
                Expanded(
                    child: LeaderboardDropdown(
                  title: "Tournament Type",
                  left: true,
                )),
              ],
            ),
            Gap(Get.height * 0.02),
            Container(
              decoration: BoxDecoration(
                  color: AppColor().bgDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColor().greySix,
                  ),
                  image: const DecorationImage(
                      image:
                          AssetImage('assets/images/png/leaderboard_bg.png'))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(Get.height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/png/lImage1.png',
                          height: Get.height * 0.05,
                        ),
                        Gap(Get.height * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: 'Call of Duty Mobile',
                              size: 14,
                              fontFamily: 'GilroySemiBold',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                            Gap(Get.height * 0.005),
                            Row(
                              children: [
                                CustomText(
                                  title: 'MP MODE',
                                  size: 12,
                                  fontFamily: 'GilroyRegular',
                                  textAlign: TextAlign.start,
                                  color: AppColor().greyTwo,
                                ),
                                Gap(Get.height * 0.01),
                                SmallCircle(
                                  size: Get.height * 0.008,
                                  color: AppColor().primaryWhite,
                                ),
                                Gap(Get.height * 0.01),
                                CustomText(
                                  title: 'Arcade',
                                  size: 12,
                                  fontFamily: 'GilroyRegular',
                                  textAlign: TextAlign.start,
                                  color: AppColor().greyTwo,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(Get.height * 0.01),
                  Divider(
                      color: AppColor().primaryWhite.withOpacity(0.1),
                      thickness: 1),
                  Gap(Get.height * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: 'Teams Ranking',
                              size: 14,
                              fontFamily: 'GilroySemiBold',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                            Gap(Get.height * 0.005),
                            CustomText(
                              title: 'Updated 2hours ago',
                              size: 10,
                              fontFamily: 'GilroyRegular',
                              textAlign: TextAlign.start,
                              color: AppColor().greyTwo,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.all(Get.height * 0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColor().primaryWhite,
                                        width: 0.8)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      title: 'Tier 1',
                                      fontFamily: 'GilroyMedium',
                                      size: 12,
                                      color: AppColor().primaryWhite,
                                    ),
                                    Gap(Get.height * 0.02),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColor().primaryColor,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Gap(Get.height * 0.02),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.all(Get.height * 0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColor().primaryWhite,
                                        width: 0.8)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: AppColor().primaryWhite,
                                      size: 18,
                                    ),
                                    Gap(Get.height * 0.01),
                                    CustomText(
                                      title: '2023',
                                      fontFamily: 'GilroyMedium',
                                      size: 12,
                                      color: AppColor().primaryWhite,
                                    ),
                                    Gap(Get.height * 0.01),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColor().primaryColor,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            title: 'Pos',
                            size: 12,
                            fontFamily: 'GilroySemiBold',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            title: '',
                            size: 12,
                            fontFamily: 'GilroySemiBold',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: CustomText(
                            title: 'Team',
                            size: 12,
                            fontFamily: 'GilroySemiBold',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CustomText(
                              title: 'PTS',
                              size: 12,
                              fontFamily: 'GilroySemiBold',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  ListView.separated(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                            color: AppColor().primaryWhite.withOpacity(0.1),
                            thickness: 1,
                            height: Get.height * 0.03,
                          ),
                      itemCount: teamRankItem.length,
                      itemBuilder: (context, index) {
                        var item = teamRankItem[index];
                        return TeamRankItem(item: item, index: index);
                      }),
                  Gap(Get.height * 0.05),
                  Center(
                    child: InkWell(
                      onTap: () => Get.to(const Tournament()),
                      child: CustomText(
                        title: 'See tournaments for this leaderboard',
                        size: 14,
                        fontFamily: 'GilroySemiBold',
                        textAlign: TextAlign.start,
                        color: AppColor().primaryWhite,
                        underline: TextDecoration.underline,
                        decorationColor: AppColor().greyEight,
                      ),
                    ),
                  ),
                  Gap(Get.height * 0.03),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
