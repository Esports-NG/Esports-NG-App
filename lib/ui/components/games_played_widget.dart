import 'package:e_sport/data/model/games_played_model.dart';
import 'package:e_sport/ui/account/games_played/games_played_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GamesPlayedWidget extends StatelessWidget {
  const GamesPlayedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: gamesPlayedItem.length,
      separatorBuilder: (context, index) => Gap(Get.height * 0.02),
      itemBuilder: (context, index) {
        var item = gamesPlayedItem[index];
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
