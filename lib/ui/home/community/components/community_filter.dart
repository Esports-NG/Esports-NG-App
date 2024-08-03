import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/home/community/components/community_filter_page.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommunityFilter extends StatefulWidget {
  const CommunityFilter(
      {super.key, required this.title, this.extreme, this.onFilterPage});

  final String title;
  final bool? extreme;
  final bool? onFilterPage;

  @override
  State<CommunityFilter> createState() => _CommunityFilterState();
}

class _CommunityFilterState extends State<CommunityFilter> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final communityController = Get.put(CommunityRepository());
  final _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) => Stack(
          children: [
            GestureDetector(
              onTap: () => communityController.hideAllOverlays(),
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
                      width: Get.width - Get.height * 0.04,
                      padding: EdgeInsets.all(Get.height * 0.015),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: AppColor().darkGrey, width: 0.5),
                          color: AppColor().primaryDark),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CustomText(
                          //   title: widget.title,
                          //   color: AppColor().primaryWhite.withOpacity(0.7),
                          //   fontFamily: "GilroyMedium",
                          //   size: 16,
                          // ),
                          // Gap(Get.height * 0.01),
                          InkWell(
                            onTap: () {
                              communityController.typeFilter.value =
                                  "All Categories";
                              if (widget.onFilterPage != true) {
                                 Get.back();
                              }
                              else {
                                (Get.back());
                              }
                              _overlayController.hide();
                            },
                            child: const CustomTile(
                              value: "All Categories",
                            ),
                          ),
                          Gap(Get.height * 0.01),
                          InkWell(
                            onTap: () {
                              communityController.typeFilter.value =
                                  "Suggested Profiles";
                              if (widget.onFilterPage != true) {
                                Get.to(() => const CommunityFilterPage());
                              }
                              _overlayController.hide();
                            },
                            child: const CustomTile(
                              value: "Suggested Profiles",
                            ),
                          ),
                          Gap(Get.height * 0.01),
                          InkWell(
                            onTap: () {
                              communityController.typeFilter.value =
                                  "Trending Games";
                              if (widget.onFilterPage != true) {
                                Get.to(() => const CommunityFilterPage());
                              }
                              _overlayController.hide();
                            },
                            child: const CustomTile(
                              value: "Trending Games",
                            ),
                          ),
                          Gap(Get.height * 0.01),
                          InkWell(
                            onTap: () {
                              communityController.typeFilter.value =
                                  "Trending Communities";
                              if (widget.onFilterPage != true) {
                                Get.to(() => const CommunityFilterPage());
                              }
                              _overlayController.hide();
                            },
                            child: const CustomTile(
                              value: "Trending Communities",
                            ),
                          ),
                          Gap(Get.height * 0.01),
                          InkWell(
                            onTap: () {
                              communityController.typeFilter.value =
                                  "Trending Teams";
                              if (widget.onFilterPage != true) {
                                Get.to(() => const CommunityFilterPage());
                              }
                              _overlayController.hide();
                            },
                            child: const CustomTile(
                              value: "Trending Teams",
                            ),
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
            communityController.currentOverlay.add(_overlayController);
          },
          child: Container(
            padding: EdgeInsets.all(Get.height * 0.02),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor().darkGrey, width: 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: widget.title,
                  fontFamily: 'GilroyMedium',
                  size: 12,
                  color: AppColor().primaryWhite,
                ),
                Gap(Get.height * 0.01),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColor().primaryColor,
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  const CustomTile({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final communityController = Get.find<CommunityRepository>();
    bool isSelected = communityController.typeFilter.value == value;
    return Container(
      padding: EdgeInsets.all(Get.height * 0.02),
      decoration: BoxDecoration(
        color: isSelected ? AppColor().primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
            color: isSelected
                ? AppColor().primaryColor
                : AppColor().greyEight.withOpacity(0.8),
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
            color: Colors.transparent,
            bColor: AppColor().primaryWhite,
          )
        ],
      ),
    );
  }
}
