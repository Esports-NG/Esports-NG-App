import 'package:e_sport/data/model/account_teams_model.dart';
import 'package:e_sport/ui/leaderboard/ranking_item.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class RankingCard extends StatelessWidget {
  const RankingCard({super.key, required this.title, required this.teamRanks});

  final String title;
  final List<AccountTeamsModel> teamRanks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColor().bgDark,
          border: Border.all(
            color: AppColor().greyEight,
          ),
          image: const DecorationImage(
              image: AssetImage('assets/images/png/leaderboard_bg.png')),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 230,
            child: Row(
              children: [
                CustomText(
                  title: "Rankings",
                  color: AppColor().primaryWhite,
                  fontFamily: "GilroySemiBold",
                  size: 18,
                ),
              ],
            ),
          ),
          const Gap(10),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Rankingitem(
                  index: 1,
                  team: teamRanks[0],
                ),
                Rankingitem(
                  index: 2,
                  team: teamRanks[1],
                ),
                Rankingitem(
                  index: 3,
                  team: teamRanks[2],
                ),
                Rankingitem(
                  index: 4,
                  team: teamRanks[3],
                ),
                Rankingitem(
                  index: 5,
                  team: teamRanks[4],
                ),
              ],
            ),
          ),
          const Gap(10),
          Center(
            child: CustomText(
              color: AppColor().primaryWhite,
              title: "See full details",
              underline: TextDecoration.underline,
              decorationColor: AppColor().primaryWhite,
            ),
          )
        ],
      ),
    );
  }
}
