// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RepostItem extends StatefulWidget {
  final PostModel item;
  const RepostItem({super.key, required this.item});

  @override
  State<RepostItem> createState() => _RepostItemState();
}

class _RepostItemState extends State<RepostItem> {
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor().bgDark,
            AppColor().primaryBackGroundColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().lightItemsColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (widget.item.repost!.author!.profile!.profilePicture ==
                            null)
                        ? SvgPicture.asset(
                            'assets/images/svg/people.svg',
                            height: Get.height * 0.035,
                            width: Get.height * 0.035,
                          )
                        : InkWell(
                            onTap: () => Get.to(() => UserDetails(
                                id: widget.item.repost!.author!.id!)),
                            child: CachedNetworkImage(
                              height: Get.height * 0.035,
                              width: Get.height * 0.035,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              imageUrl: widget.item.repost!.author!.profile!
                                  .profilePicture!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        widget.item.repost!.author!.profile!
                                            .profilePicture!,
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                    Gap(Get.height * 0.01),
                    CustomText(
                      title:
                          widget.item.repost!.author!.fullName!.toCapitalCase(),
                      size: Get.height * 0.015,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                    Gap(Get.height * 0.005),
                    const SmallCircle(),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: timeAgo(widget.item.createdAt!),
                      size: Get.height * 0.015,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CustomText(
              title: widget.item.repost == null
                  ? widget.item.body!.toUpperFirstCase()
                  : widget.item.repost!.body!.toUpperFirstCase(),
              size: Get.height * 0.015,
              fontFamily: 'GilroyBold',
              textAlign: TextAlign.start,
              color: AppColor().primaryWhite,
            ),
          ),
          Gap(Get.height * 0.015),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                child: widget.item.repost!.image == null
                    ? Container()
                    : CachedNetworkImage(
                        height: Get.height * 0.25,
                        width: double.infinity,
                        progressIndicatorBuilder: (context, url, progress) =>
                            Center(
                          child: SizedBox(
                            height: Get.height * 0.05,
                            width: Get.height * 0.05,
                            child: CircularProgressIndicator(
                                color: AppColor().primaryWhite,
                                value: progress.progress),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, color: AppColor().primaryWhite),
                        imageUrl: widget.item.repost!.image!,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            image: DecorationImage(
                                image: NetworkImage(widget.item.repost!.image!),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
              ),
              Positioned.fill(
                left: Get.height * 0.02,
                bottom: Get.height * 0.02,
                top: Get.height * 0.19,
                child: SizedBox(
                  height: Get.height * 0.03,
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.item.tags!.length,
                      separatorBuilder: (context, index) =>
                          Gap(Get.height * 0.01),
                      itemBuilder: (context, index) {
                        var items = widget.item.tags![index];
                        return Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColor().primaryDark.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColor().primaryColor.withOpacity(0.05),
                              width: 0.5,
                            ),
                          ),
                          child: Center(
                            child: CustomText(
                              title: items.title,
                              color: AppColor().primaryWhite,
                              textAlign: TextAlign.center,
                              size: Get.height * 0.014,
                              fontFamily: 'GilroyBold',
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
