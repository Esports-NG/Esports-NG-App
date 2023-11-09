import 'package:e_sport/data/model/account_events_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/home/community/components/trending_games_item.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'components/latest_news_item.dart';
import 'components/social_event_item.dart';
import 'components/suggested_profile_item.dart';
import 'components/tournament_item.dart';
import 'components/trending_community_item.dart';
import 'latest_news.dart';
import 'social_event.dart';
import 'suggested_profile.dart';
import 'tournament.dart';
import 'trending_community.dart';
import 'trending_games.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  int? eventType = 0;
  final eventController = Get.put(EventRepository());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          title: 'Community',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.06,
                    child: CustomTextField(
                      hint: "Search for gaming news, competitions...",
                      fontFamily: 'GilroyMedium',
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: AppColor().lightItemsColor,
                      ),
                      textEditingController: eventController.searchController,
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
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(Get.height * 0.02),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColor().primaryWhite, width: 0.8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            title: 'Filter by Category:',
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
                  Gap(Get.height * 0.03),
                  PageHeaderWidget(
                    onTap: () => Get.to(() => const SuggestedProfile()),
                    title: 'Suggested profiles',
                  ),
                  Gap(Get.height * 0.03),
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
                      itemCount: suggestedProfileItems.take(2).length,
                      itemBuilder: (context, index) {
                        var item = suggestedProfileItems[index];
                        return SuggestedProfileItem(item: item);
                      }),
                ],
              ),
            ),
            Gap(Get.height * 0.03),
            Divider(
              color: AppColor().primaryWhite.withOpacity(0.1),
              thickness: 4,
            ),
            Gap(Get.height * 0.03),
            Padding(
              padding: EdgeInsets.only(left: Get.height * 0.02),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () => Get.to(() => const LatestNews()),
                      title: 'Latest News',
                    ),
                  ),
                  Gap(Get.height * 0.03),
                  SizedBox(
                    height: Get.height * 0.4,
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            Gap(Get.height * 0.03),
                        itemCount: latestNewsItems.take(2).length,
                        itemBuilder: (context, index) {
                          var item = latestNewsItems[index];
                          return LatestNewsItem(item: item);
                        }),
                  ),
                ],
              ),
            ),
            Gap(Get.height * 0.03),
            Divider(
              color: AppColor().primaryWhite.withOpacity(0.1),
              thickness: 4,
            ),
            Gap(Get.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Column(
                children: [
                  PageHeaderWidget(
                    onTap: () => Get.to(() => const TrendingGames()),
                    title: 'Trending Games',
                  ),
                  Gap(Get.height * 0.03),
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
                      itemCount: trendingGamesItems.take(2).length,
                      itemBuilder: (context, index) {
                        var item = trendingGamesItems[index];
                        return TrendingGamesItem(item: item);
                      }),
                ],
              ),
            ),
            Gap(Get.height * 0.03),
            Divider(
              color: AppColor().primaryWhite.withOpacity(0.1),
              thickness: 4,
            ),
            Gap(Get.height * 0.03),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: PageHeaderWidget(
                    onTap: () => Get.to(() => const Tournament()),
                    title: 'Tournaments',
                  ),
                ),
                Gap(Get.height * 0.03),
                Container(
                  height: Get.height * 0.42,
                  padding: EdgeInsets.only(left: Get.height * 0.02),
                  child: ListView.separated(
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          Gap(Get.height * 0.02),
                      itemCount: tournamentItem.take(2).length,
                      itemBuilder: (context, index) {
                        var item = tournamentItem[index];
                        return TournamentItem(item: item);
                      }),
                ),
              ],
            ),
            Gap(Get.height * 0.03),
            Divider(
              color: AppColor().primaryWhite.withOpacity(0.1),
              thickness: 4,
            ),
            Gap(Get.height * 0.03),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: PageHeaderWidget(
                    onTap: () => Get.to(() => const TrendingCommunity()),
                    title: 'Trending Communities',
                  ),
                ),
                Gap(Get.height * 0.03),
                Container(
                  padding: EdgeInsets.only(left: Get.height * 0.02),
                  height: Get.height * 0.28,
                  child: ListView.separated(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          Gap(Get.height * 0.02),
                      itemCount: trendingCommunitiesItems.take(2).length,
                      itemBuilder: (context, index) {
                        var item = trendingCommunitiesItems[index];
                        return TrendingCommunityItem(item: item);
                      }),
                ),
              ],
            ),
            Gap(Get.height * 0.03),
            Divider(
              color: AppColor().primaryWhite.withOpacity(0.1),
              thickness: 4,
            ),
            Gap(Get.height * 0.03),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  child: PageHeaderWidget(
                    onTap: () => Get.to(() => const SocialEvent()),
                    title: 'Social Events',
                  ),
                ),
                Gap(Get.height * 0.03),
                Container(
                  padding: EdgeInsets.only(left: Get.height * 0.02),
                  height: Get.height * 0.44,
                  child: ListView.separated(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          Gap(Get.height * 0.02),
                      itemCount: socialEventItem.take(2).length,
                      itemBuilder: (context, index) {
                        var item = socialEventItem[index];
                        return SocialEventItem(item: item);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
