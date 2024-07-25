// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class NewsItem extends StatefulWidget {
  final PostModel item;
  const NewsItem({super.key, required this.item});

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  final navController = Get.put(NavRepository());

  int? _selectedIndex;

  String timeAgo(DateTime itemDate) {
    final now = DateTime.now();
    final difference = now.difference(itemDate);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      (postController.allPost.length);
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor().darkGrey.withOpacity(0.8),
              AppColor().bgDark.withOpacity(0.005),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColor().greyEight.withOpacity(0.4),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(Get.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: widget.item.body!.toUpperCase(),
                    size: Get.height * 0.015,
                    fontFamily: 'GilroyMedium',
                    textAlign: TextAlign.start,
                    color: AppColor().primaryWhite,
                  ),
                  Gap(Get.height * 0.005),
                  Divider(
                    thickness: 0.4,
                    color: AppColor().lightItemsColor.withOpacity(0.5),
                  ),
                  Gap(Get.height * 0.005),
                  CustomText(
                    title: widget.item.body,
                    size: Get.height * 0.015,
                    fontFamily: 'GilroyMedium',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.015),
                  Row(
                    children: [
                      CustomText(
                        title: 'By ',
                        size: Get.height * 0.015,
                        fontFamily: 'GilroyMedium',
                        textAlign: TextAlign.start,
                        color: AppColor().lightItemsColor,
                      ),
                      CustomText(
                        title: widget.item.author!.userName!,
                        size: Get.height * 0.015,
                        fontFamily: 'GilroyMedium',
                        textAlign: TextAlign.start,
                        color: AppColor().primaryGreen,
                      ),
                      Gap(Get.height * 0.01),
                      const SmallCircle(),
                      Gap(Get.height * 0.01),
                      CustomText(
                        title: timeAgo(widget.item.createdAt!),
                        size: Get.height * 0.015,
                        fontFamily: 'GilroyMedium',
                        textAlign: TextAlign.start,
                        color: AppColor().lightItemsColor,
                      ),
                      Gap(Get.height * 0.01),
                      const SmallCircle(),
                      Gap(Get.height * 0.01),
                      CustomText(
                        title: 'Nexal Gaming',
                        size: Get.height * 0.015,
                        fontFamily: 'GilroyMedium',
                        textAlign: TextAlign.start,
                        color: AppColor().lightItemsColor,
                      ),
                    ],
                  ),
                  Gap(Get.height * 0.015),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Helpers()
                  .showImagePopup(context, "${widget.item.repost!.image}"),
              child: (widget.item.repost == null)
                  ? Container(
                      child: widget.item.image == null
                          ? Container()
                          : GestureDetector(
                              onTap: () => Helpers().showImagePopup(
                                  context, widget.item.image!),
                              child: CachedNetworkImage(
                                height: Get.height * 0.25,
                                width: double.infinity,
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: SizedBox(
                                    height: Get.height * 0.05,
                                    width: Get.height * 0.05,
                                    child: CircularProgressIndicator(
                                        color: AppColor().primaryWhite,
                                        value: progress.progress),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: AppColor().primaryWhite),
                                imageUrl: widget.item.image!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            widget.item.image!),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                    )
                  : Container(
                      child: widget.item.repost!.image == null
                          ? Container()
                          : CachedNetworkImage(
                              height: Get.height * 0.25,
                              width: double.infinity,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: SizedBox(
                                  height: Get.height * 0.05,
                                  width: Get.height * 0.05,
                                  child: CircularProgressIndicator(
                                      color: AppColor().primaryWhite,
                                      value: progress.progress),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: AppColor().primaryWhite),
                              imageUrl: widget.item.repost!.image!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.item.repost!.image!),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}
