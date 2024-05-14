import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EventGameFilter extends StatefulWidget {
  const EventGameFilter({super.key});

  @override
  State<EventGameFilter> createState() => _EventGameFilterState();
}

class _EventGameFilterState extends State<EventGameFilter> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final eventController = Get.put(EventRepository());
  final _link = LayerLink();
  final gameController = Get.put(GamesRepository());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CompositedTransformTarget(
        link: _link,
        child: OverlayPortal(
          controller: _overlayController,
          overlayChildBuilder: (context) => Stack(
            children: [
              GestureDetector(
                onTap: () => eventController.hideAllOverlays(),
                child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: const CustomText(
                    title: "",
                  ),
                ),
              ),
              CompositedTransformFollower(
                targetAnchor: Alignment.bottomRight,
                followerAnchor: Alignment.topRight,
                offset: const Offset(0, 10),
                link: _link,
                child: GestureDetector(
                  child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Container(
                        width: Get.width - Get.height * 0.04,
                        padding: EdgeInsets.all(Get.height * 0.02),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: AppColor().darkGrey, width: 0.5),
                            color: AppColor().primaryDark),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: "Games",
                              color: AppColor().primaryWhite.withOpacity(0.7),
                              fontFamily: "GilroyMedium",
                              size: 16,
                            ),
                            Gap(Get.height * 0.01),
                            CustomTextField(
                              hint: "Search for Games",
                            ),
                            Gap(Get.height * 0.02),
                            InkWell(
                                onTap: () {
                                  eventController.handleFilterChange(
                                      title: "Game", value: "All");
                                  _overlayController.hide();
                                },
                                child: CustomTile(title: "Game", value: "All")),
                            Gap(Get.height * 0.01),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: gameController.allGames.take(5).length,
                              itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    eventController.handleFilterChange(
                                        title: "Game",
                                        value: gameController
                                            .allGames[index].name!);
                                    _overlayController.hide();
                                  },
                                  child: CustomTile(
                                      title: "Game",
                                      value: gameController
                                          .allGames[index].name!)),
                              separatorBuilder: (context, index) =>
                                  const Gap(10),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              _overlayController.toggle();
              eventController.currentOverlay.add(_overlayController);
            },
            child: Container(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColor().darkGrey),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: CustomText(
                        title: eventController.renderFilter(title: "Game"),
                        color: AppColor().primaryWhite,
                        overflow: TextOverflow.ellipsis,
                        // size: 16,
                        fontFamily: "GilroyMedium",
                      ),
                    ),
                    // const Spacer(),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColor().primaryColor,
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  const CustomTile({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final eventController = Get.find<EventRepository>();

    return Container(
      padding: EdgeInsets.all(Get.height * 0.02),
      decoration: BoxDecoration(
        color: eventController.renderFilter(title: title) == value
            ? AppColor().primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
            color: eventController.renderFilter(title: title) == value
                ? AppColor().primaryColor
                : AppColor().darkGrey,
            width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: CustomText(
              title: value,
              size: Get.height * 0.016,
              fontFamily: 'GilroyMedium',
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              color: AppColor().primaryWhite,
            ),
          ),
          // const Spacer(),
          SmallCircle(
            size: 10,
            color: eventController.renderFilter(title: title) == value
                ? AppColor().primaryWhite
                : Colors.transparent,
            bColor: AppColor().primaryWhite,
          )
        ],
      ),
    );
    ;
  }
}
