import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/leaderboard/ranking_card.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentLeaderboard extends StatefulWidget {
  const TournamentLeaderboard({super.key, required this.event});

  final EventModel event;

  @override
  State<TournamentLeaderboard> createState() => _TournamentLeaderboardState();
}

class _TournamentLeaderboardState extends State<TournamentLeaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(onPressed: () => Get.back()),
        centerTitle: true,
        title: CustomText(
            title: "Tournament Leaderboard",
            fontFamily: "InterSemiBold",
            size: 20,
            color: AppColor().primaryWhite),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      image: DecorationImage(
                          image: NetworkImage(ApiLink.imageUrl +
                              widget.event.games![0].profilePicture!),
                          fit: BoxFit.cover)),
                ),
                Gap(14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: widget.event.games![0].name,
                      color: AppColor().primaryWhite,
                      size: 14,
                    ),
                    CustomText(
                      title: widget.event.games![0].gameModes![0].name,
                      color: AppColor().greySix,
                      size: 12,
                    )
                  ],
                )
              ],
            ),
            Gap(20),
            RankingCard(title: "Rankings")
          ],
        ),
      )),
    );
  }
}
