import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_details.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/home/community/components/suggested_profile_item.dart';
import 'package:e_sport/ui/home/community/components/trending_games_item.dart';
import 'package:e_sport/ui/home/community/components/trending_team_item.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AdList extends StatefulWidget {
  const AdList({super.key, required this.ads});
  final List<PostModel> ads;

  @override
  State<AdList> createState() => _AdListState();
}

class _AdListState extends State<AdList> {
  @override
  Widget build(BuildContext context) {
    var firstAd = widget.ads.toList()[0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: firstAd.type == "game"
              ? "Games to play"
              : "${firstAd.type!.capitalize}s to follow",
          color: AppColor().primaryWhite,
          fontFamily: "InterMedium",
          size: 18,
        ),
        Gap(10),
        SizedBox(
            height: Get.height * 0.28,
            child: ListView.separated(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                itemCount: widget.ads.take(4).length,
                itemBuilder: (context, index) {
                  var item = widget.ads.toList()[index];
                  return item.type == "team"
                      ? InkWell(
                          onTap: () => Get.to(
                              () => AccountTeamsDetail(item: item.team!)),
                          child: TrendingTeamsItem(item: item.team!))
                      : item.type == "game"
                          ? InkWell(
                              onTap: () {
                                Get.to(() => GameProfile(game: item.game!));
                              },
                              child: TrendingGamesItem(
                                game: item.game!,
                              ))
                          : item.type == "user"
                              ? SizedBox(
                                  child:
                                      SuggestedProfileList(item: item.owner!))
                              : Gap(1);
                })),
      ],
    );
  }
}
