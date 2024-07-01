import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GameSelectionChip extends StatefulWidget {
  const GameSelectionChip({super.key, this.postCreation, this.teamApplication});
  final bool? postCreation;
  final bool? teamApplication;

  @override
  State<GameSelectionChip> createState() => _GameSelectionChipState();
}

class _GameSelectionChipState extends State<GameSelectionChip> {
  final teamController = Get.put(TeamRepository());
  final gameController = Get.put(GamesRepository());
  final postController = Get.put(PostRepository());

  bool _isShowing = false;

  LayerLink _link = LayerLink();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
            controller: gameController.gameChipOverlayController,
            overlayChildBuilder: (context) => Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        gameController.hideGameChip();
                        setState(() {
                          _isShowing = false;
                        });
                      },
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
                            border: Border.all(
                                color: AppColor().secondaryGreenColor),
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
                                  gameController.gameSearchText,
                              hint: "Search For Game",
                            ),
                            Gap(Get.height * 0.02),
                            gameController.isLoading.value
                                ? const Center(child: ButtonLoader())
                                : Obx(
                                    () => ListView.separated(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                              onTap: () {
                                                if (widget.postCreation ==
                                                    true) {
                                                  postController.addToGameTags(
                                                      (widget.teamApplication ==
                                                              true
                                                          ? gameController
                                                              .filteredUserGames
                                                          : gameController
                                                              .filteredGames)[index]);
                                                } else {
                                                  teamController.addToGamesPlayed(
                                                      (widget.teamApplication ==
                                                              true
                                                          ? gameController
                                                              .filteredUserGames
                                                          : gameController
                                                              .filteredGames)[index]);
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        Get.height * 0.015,
                                                    horizontal:
                                                        Get.height * 0.01),
                                                child: CustomText(
                                                    title: (widget.teamApplication ==
                                                                    true
                                                                ? gameController
                                                                    .filteredUserGames
                                                                : gameController
                                                                    .filteredGames)[
                                                            index]
                                                        .name,
                                                    color: AppColor()
                                                        .primaryWhite
                                                        .withOpacity(0.6)),
                                              ),
                                            ),
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              thickness: 0.5,
                                              color: AppColor().darkGrey,
                                              height: 0,
                                            ),
                                        itemCount:
                                            (widget.teamApplication == true
                                                    ? gameController
                                                        .filteredUserGames
                                                    : gameController
                                                        .filteredGames)
                                                .length),
                                  )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
            child: GestureDetector(
              onTap: () {
                gameController.gameChipOverlayController.toggle();
                setState(() {
                  _isShowing = !_isShowing;
                });
              },
              child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      border: _isShowing
                          ? Border.all(color: AppColor().secondaryGreenColor)
                          : null,
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor().primaryDark),
                  child: (widget.postCreation == true
                              ? postController.gameTags
                              : teamController.gamesPlayed)
                          .isEmpty
                      ? CustomText(
                          title: "Tap here to add games",
                          color: AppColor().primaryWhite.withOpacity(0.6),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 10,
                                children: (widget.postCreation == true
                                        ? postController.gameTags
                                        : teamController.gamesPlayed)
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
                                            const Gap(5),
                                            GestureDetector(
                                              onTap: () {
                                                if (widget.postCreation ==
                                                    true) {
                                                  postController
                                                      .addToGameTags(element);
                                                } else {
                                                  teamController
                                                      .addToGamesPlayed(
                                                          element);
                                                }
                                              },
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
