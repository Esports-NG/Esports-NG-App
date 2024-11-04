import 'package:e_sport/di/iterable_extension.dart';
import 'package:e_sport/ui/leaderboard/ranking_item.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RankingCard extends StatelessWidget {
  const RankingCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColor().bgDark,
          border: Border.all(
            color: AppColor().darkGrey,
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/png/leaderboard_bg.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              CustomText(
                title: "Rankings",
                color: AppColor().primaryWhite,
                fontFamily: "InterMedium",
                size: 16,
              ),
              const Spacer(),
              GestureDetector(
                  child: Icon(
                Icons.edit,
                color: AppColor().primaryColor,
              ))
            ],
          ),
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Rankingitem(index: 1),
              Rankingitem(
                index: 2,
              ),
              Rankingitem(
                index: 3,
              ),
              Rankingitem(
                index: 4,
              ),
              Rankingitem(
                index: 5,
              ),
            ].separator(Gap(10)).toList(),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
