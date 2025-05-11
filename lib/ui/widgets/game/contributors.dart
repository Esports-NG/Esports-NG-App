import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/screens/account/user_details.dart';
import 'package:e_sport/ui/widgets/community/contributor_item.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Contributors extends StatelessWidget {
  const Contributors({super.key, required this.game});

  final GamePlayed game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 80,
                maxHeight: 80,
                child: Container(
                  color: AppColor().primaryBackGroundColor,
                  padding: EdgeInsets.only(
                      top: Get.height * 0.02,
                      right: Get.height * 0.02,
                      bottom: Get.height * 0.02),
                  child: Row(children: [
                    GoBackButton(onPressed: () => Get.back()),
                    // Gap(Get.height * 0.02),
                    Row(
                      children: [
                        CachedNetworkImage(
                          height: Get.height * 0.08,
                          width: Get.height * 0.08,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: SizedBox(
                              height: Get.height * 0.02,
                              width: Get.height * 0.02,
                              child: CircularProgressIndicator(
                                  color: AppColor().primaryColor,
                                  value: progress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, color: AppColor().primaryColor),
                          imageUrl:
                              "${ApiLink.imageUrl}${game.profilePicture!}",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "${ApiLink.imageUrl}${game.profilePicture!}"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: game.name,
                              size: 16,
                              color: AppColor().primaryWhite,
                            ),
                            Gap(Get.height * 0.005),
                            CustomText(
                              title: "Contributors",
                              color: AppColor().greySix,
                            )
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                    IntrinsicHeight(
                      child: InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.02,
                              vertical: Get.height * 0.01),
                          decoration: BoxDecoration(
                              color: AppColor().primaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: CustomText(
                                title: "Follow",
                                color: AppColor().primaryWhite),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              )),
        ],
        body: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
            children: [
              Gap(Get.height * 0.02),
              GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1 * 0.8,
                  ),
                  itemCount: game.contributors!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          Get.to(() => UserDetails(
                              slug: game.contributors![index].slug!));
                        },
                        child: ContributorItem(
                            isOnContributorsPage: true,
                            contributor: game.contributors![index]));
                  })
            ],
          ),
        ),
      ),
    ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
