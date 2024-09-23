import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/ui/account/games_played/games_played_item.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
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
  final authController = Get.put(AuthRepository());
  @override
  Widget build(BuildContext context) {
    if (playerController.playerStatus == PlayerStatus.loading) {
      return const ButtonLoader();
    } else if (playerController.playerStatus == PlayerStatus.available) {
      return ListView.separated(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: playerController.allPlayer
            .where((e) => e.player!.id! == authController.user!.id!)
            .toList()
            .length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.02),
        itemBuilder: (context, index) {
          var item = playerController.allPlayer
              .where((e) => e.player!.id! == authController.user!.id!)
              .toList()[index];
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
