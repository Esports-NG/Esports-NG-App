import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EventFilter extends StatefulWidget {
  const EventFilter(
      {super.key, required this.title, required this.values, this.extreme});

  final String title;
  final List<String> values;
  final bool? extreme;

  @override
  State<EventFilter> createState() => _EventFilterState();
}

class _EventFilterState extends State<EventFilter> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final eventController = Get.put(EventRepository());
  final _link = LayerLink();

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
                targetAnchor: widget.extreme != null
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                followerAnchor: widget.extreme != null
                    ? Alignment.topRight
                    : Alignment.topLeft,
                offset: const Offset(0, 10),
                link: _link,
                child: GestureDetector(
                  child: Align(
                      alignment: widget.extreme != null
                          ? AlignmentDirectional.topEnd
                          : AlignmentDirectional.topStart,
                      child: Container(
                        width: Get.width * 0.5,
                        padding: EdgeInsets.all(Get.height * 0.02),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: AppColor().greyEight, width: 0.5),
                            color: AppColor().primaryDark),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: widget.title,
                              color: AppColor().primaryWhite.withOpacity(0.7),
                              fontFamily: "GilroyMedium",
                              size: 16,
                            ),
                            Gap(Get.height * 0.01),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.values.length,
                              itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    eventController.handleFilterChange(
                                        title: widget.title,
                                        value: widget.values[index]);
                                    _overlayController.hide();
                                  },
                                  child: CustomTile(
                                      title: widget.title,
                                      value: widget.values[index])),
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
                  border: Border.all(color: AppColor().greyEight),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: CustomText(
                        title:
                            eventController.renderFilter(title: widget.title),
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
                : AppColor().greySix,
            width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            title: value,
            size: Get.height * 0.016,
            fontFamily: 'GilroyMedium',
            textAlign: TextAlign.start,
            color: AppColor().primaryWhite,
          ),
          const Spacer(),
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
