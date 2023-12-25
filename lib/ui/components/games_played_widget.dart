import 'package:e_sport/data/model/games_played_model.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/ui/account/games_played/games_played_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: playerController.allPlayer.length,
      separatorBuilder: (context, index) => Gap(Get.height * 0.02),
      itemBuilder: (context, index) {
        var item = playerController.allPlayer[index];
        return InkWell(
          onTap: () {
            // Get.to(
            //   () => PostDetails(
            //     item: item,
            //   ),
            // );
          },
          child: GamesPlayedItem(item: item),
        );
      },
    );
  }
}
