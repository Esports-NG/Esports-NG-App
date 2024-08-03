import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GameDropdown extends StatefulWidget {
  const GameDropdown({
    super.key,
    this.enableFill,
    this.toggleArrow,
    required this.gameValue,
    this.handleTap,
  });
  final bool? enableFill;
  final bool? toggleArrow;
  final Rx<GamePlayed?> gameValue;
  final dynamic handleTap;

  @override
  State<GameDropdown> createState() => _GameDropdownState();
}

class _GameDropdownState extends State<GameDropdown> {
  final gameController = Get.put(GamesRepository());
  final eventController = Get.put(EventRepository());
  final LayerLink _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
            controller: gameController.gameDropdownOverlayController,
            overlayChildBuilder: (context) => Stack(
                  children: [
                    GestureDetector(
                      onTap: () => gameController.hideGameDropdown(),
                      child: SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: const CustomText(title: ""),
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
                                  gameController.gameSearchText,
                              hint: "Search For Game",
                            ),
                            Gap(Get.height * 0.02),
                            Obx(
                              () => ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () {
                                          widget.gameValue.value =
                                              gameController
                                                  .filteredGames[index];
                                          gameController.hideGameDropdown();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: Get.height * 0.015,
                                              horizontal: Get.height * 0.01),
                                          child: CustomText(
                                              title: gameController
                                                  .filteredGames[index].name,
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
                                  itemCount:
                                      gameController.filteredGames.length),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
            child: GestureDetector(
                onTap: () =>
                    gameController.gameDropdownOverlayController.toggle(),
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor().primaryDark),
                    child: widget.gameValue.value == null
                        ? CustomText(
                            title: "Search For Game",
                            color: AppColor().primaryWhite.withOpacity(0.6),
                          )
                        : CustomText(
                            title: widget.gameValue.value!.name,
                            color: AppColor().primaryWhite,
                          )))),
      ),
    );
  }
}
