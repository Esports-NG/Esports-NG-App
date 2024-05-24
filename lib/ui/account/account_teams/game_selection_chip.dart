import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GameSelectionChip extends StatefulWidget {
  const GameSelectionChip({super.key});

  @override
  State<GameSelectionChip> createState() => _GameSelectionChipState();
}

class _GameSelectionChipState extends State<GameSelectionChip> {
  final teamController = Get.put(TeamRepository());
  final gameController = Get.put(GamesRepository());
  LayerLink _link = LayerLink();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
            controller: teamController.gameChipOverlayController,
            overlayChildBuilder: (context) => Stack(
                  children: [
                    GestureDetector(
                      onTap: () => teamController.hideGameChip(),
                      child: SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: CustomText(title: ""),
                      ),
                    ),
                    CompositedTransformFollower(
                      offset: const Offset(0, 5),
                      targetAnchor: Alignment.bottomLeft,
                      followerAnchor: Alignment.topLeft,
                      link: _link,
                      child: Container(
                        width: Get.width - Get.height * 0.04,
                        padding: EdgeInsets.all(Get.height * 0.01),
                        decoration: BoxDecoration(
                            color: AppColor().primaryDark,
                            border: Border.all(color: AppColor().darkGrey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColor().greyEight,
                              ),
                              fillColor: Colors.transparent,
                              borderColor: AppColor().greyEight,
                              enabled: true,
                              enabledBorder: BorderSide(
                                  width: 0.5, color: AppColor().greyEight),
                              textEditingController:
                                  teamController.gameSearchController,
                              hint: "Search For Game",
                            ),
                            Gap(Get.height * 0.02),
                            ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () =>
                                          teamController.addToGamesPlayed(
                                              gameController.allGames[index]),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: Get.height * 0.015,
                                            horizontal: Get.height * 0.01),
                                        child: CustomText(
                                            title: gameController
                                                .allGames[index].name,
                                            color: AppColor()
                                                .primaryWhite
                                                .withOpacity(0.6)),
                                      ),
                                    ),
                                separatorBuilder: (context, index) => Divider(
                                      thickness: 0.5,
                                      color: AppColor().darkGrey,
                                      height: 0,
                                    ),
                                itemCount: gameController.allGames.length)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
            child: GestureDetector(
              onTap: () => teamController.gameChipOverlayController.toggle(),
              child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor().bgDark),
                  child: !teamController.gamesPlayed.isNotEmpty
                      ? CustomText(
                          title: "Tap here to add games",
                          color: AppColor().primaryWhite.withOpacity(0.6),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 10,
                                children: teamController.gamesPlayed
                                    .map(
                                      (element) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                AppColor().secondaryGreenColor),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                              fontFamily: "GilroyMedium",
                                              title: element.abbrev,
                                            ),
                                            Gap(5),
                                            GestureDetector(
                                              onTap: () => teamController
                                                  .addToGamesPlayed(element),
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                              color: AppColor().primaryWhite,
                            )
                          ],
                        )),
            )),
      ),
    );
  }
}
