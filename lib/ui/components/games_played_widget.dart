import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/ui/account/games_played/games_played_item.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'error_page.dart';
import 'games_played_details.dart';
import 'no_item_page.dart';

class GamesPlayedWidget extends StatefulWidget {
  const GamesPlayedWidget({
    super.key,
  });

  @override
  State<GamesPlayedWidget> createState() => _GamesPlayedWidgetState();
}

class _GamesPlayedWidgetState extends State<GamesPlayedWidget> {
  final playerController = Get.put(PlayerRepository());
  @override
  Widget build(BuildContext context) {
    if (playerController.playerStatus == PlayerStatus.loading) {
      return LoadingWidget(color: AppColor().primaryColor);
    } else if (playerController.playerStatus == PlayerStatus.available) {
      return ListView.separated(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: playerController.allPlayer.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.02),
        itemBuilder: (context, index) {
          var item = playerController.allPlayer[index];
          return InkWell(
            onTap: () => Get.to(() => GamesPlayedDetails(item: item)),
            child: GamesPlayedItem(item: item),
          );
        },
      );
    } else if (playerController.playerStatus == PlayerStatus.empty) {
      return const NoItemPage(title: 'Player');
    } else {
      return const ErrorPage();
    }
  }
}
