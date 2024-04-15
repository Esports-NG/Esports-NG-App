// ignore_for_file: prefer_final_fields, unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/other_models.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/home/post/edit_post.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/small_circle.dart';

import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class RepostDetails extends StatefulWidget {
  final PostModel item;
  const RepostDetails({super.key, required this.item});

  @override
  State<RepostDetails> createState() => _RepostDetailsState();
}

class _RepostDetailsState extends State<RepostDetails> {
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());

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

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (postController.postStatus != PostStatus.loading) {
      postController.likePost(widget.item.id!);
    }
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        elevation: 0,
        leading: GoBackButton(onPressed: () => Get.back()),
        centerTitle: true,
        title: CustomText(
          title: 'Posts',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(Get.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.item.repost!.author!.profile!
                                        .profilePicture ==
                                    null
                                ? SvgPicture.asset(
                                    'assets/images/svg/people.svg',
                                    height: Get.height * 0.05,
                                    width: Get.height * 0.05,
                                  )
                                : InkWell(
                                    onTap: () => Get.to(() => UserDetails(
                                        id: widget.item.repost!.author!.id!)),
                                    child: CachedNetworkImage(
                                      height: Get.height * 0.05,
                                      width: Get.height * 0.05,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      imageUrl: widget.item.repost!.author!
                                          .profile!.profilePicture!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(widget
                                                  .item
                                                  .repost!
                                                  .author!
                                                  .profile!
                                                  .profilePicture!),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                            Gap(Get.height * 0.01),
                            CustomText(
                              title: widget.item.repost!.author!.fullName!
                                  .toCapitalCase(),
                              size: Get.height * 0.015,
                              fontFamily: 'GilroyMedium',
                              textAlign: TextAlign.start,
                              color: AppColor().lightItemsColor,
                            ),
                            Gap(Get.height * 0.005),
                            const SmallCircle(),
                            Gap(Get.height * 0.005),
                            CustomText(
                              title: timeAgo(widget.item.repost!.createdAt!),
                              size: Get.height * 0.015,
                              fontFamily: 'GilroyMedium',
                              textAlign: TextAlign.start,
                              color: AppColor().lightItemsColor,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (widget.item.repost!.author!.fullName !=
                                authController.user!.fullName)
                              CustomFillButton(
                                buttonText: 'Follow',
                                textSize: Get.height * 0.015,
                                width: Get.width * 0.25,
                                height: Get.height * 0.04,
                                onTap: () {},
                                isLoading: false,
                              ),
                            if (authController.user!.id ==
                                widget.item.repost!.author!.id)
                              IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: AppColor().primaryWhite,
                                ),
                                onPressed: () {},
                                padding:
                                    EdgeInsets.only(left: Get.height * 0.01),
                                constraints: const BoxConstraints(),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Gap(Get.height * 0.015),
                    CustomText(
                      title: widget.item.repost == null
                          ? widget.item.body
                          : widget.item.repost!.body,
                      size: Get.height * 0.015,
                      fontFamily: 'GilroyBold',
                      weight: FontWeight.w500,
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                    Gap(Get.height * 0.015),
                    Stack(
                      children: [
                        widget.item.repost == null
                            ? Container(
                                child: widget.item.image == null
                                    ? Container(
                                        height: Get.height * 0.25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/png/placeholder.png'),
                                              fit: BoxFit.cover),
                                        ),
                                      )
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
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error,
                                                color: AppColor().primaryWhite),
                                        imageUrl: widget.item.image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    widget.item.image!),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                              )
                            : Container(
                                child: widget.item.repost!.image == null
                                    ? Container(
                                        height: Get.height * 0.25,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/png/placeholder.png'),
                                              fit: BoxFit.cover),
                                        ),
                                      )
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
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error,
                                                color: AppColor().primaryWhite),
                                        imageUrl: widget.item.repost!.image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    widget.item.repost!.image!),
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
                                itemCount: widget.item.repost == null
                                    ? widget.item.tags!.length
                                    : widget.item.repost!.tags!.length,
                                separatorBuilder: (context, index) =>
                                    Gap(Get.height * 0.01),
                                itemBuilder: (context, index) {
                                  var items = widget.item.repost == null
                                      ? widget.item.tags![index]
                                      : widget.item.repost!.tags![index];
                                  return Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColor()
                                          .primaryDark
                                          .withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColor()
                                            .primaryColor
                                            .withOpacity(0.05),
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
                    Gap(Get.height * 0.015),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomText(
                                title: widget.item.repost == null
                                    ? DateFormat.yMMMd().format(
                                        widget.item.createdAt!.toLocal())
                                    : DateFormat.yMMMd().format(widget
                                        .item.repost!.createdAt!
                                        .toLocal()),
                                size: Get.height * 0.014,
                                fontFamily: 'GilroyMedium',
                                textAlign: TextAlign.start,
                                color: AppColor().primaryWhite,
                              ),
                              Gap(Get.height * 0.005),
                              const SmallCircle(),
                              Gap(Get.height * 0.005),
                              CustomText(
                                title: widget.item.repost == null
                                    ? DateFormat.jm().format(
                                        widget.item.createdAt!.toLocal())
                                    : DateFormat.jm().format(widget
                                        .item.repost!.createdAt!
                                        .toLocal()),
                                size: Get.height * 0.014,
                                fontFamily: 'GilroyMedium',
                                textAlign: TextAlign.start,
                                color: AppColor().primaryWhite,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                    title: widget.item.repost == null
                                        ? widget.item.viewers!.length.toString()
                                        : widget.item.repost!.viewers!.length
                                            .toString(),
                                    size: Get.height * 0.014,
                                    fontFamily: 'GilroyBold',
                                    textAlign: TextAlign.start,
                                    color: AppColor().primaryWhite,
                                  ),
                                  Gap(Get.height * 0.005),
                                  CustomText(
                                    title: 'Views',
                                    size: Get.height * 0.014,
                                    fontFamily: 'GilroyRegular',
                                    textAlign: TextAlign.start,
                                    color: AppColor().primaryWhite,
                                  ),
                                ],
                              ),
                              Gap(Get.height * 0.01),
                              Row(
                                children: [
                                  CustomText(
                                    title: widget.item.repost == null
                                        ? widget.item.comment!.length.toString()
                                        : widget.item.repost!.comment!.length
                                            .toString(),
                                    size: Get.height * 0.014,
                                    fontFamily: 'GilroyBold',
                                    textAlign: TextAlign.start,
                                    color: AppColor().primaryWhite,
                                  ),
                                  Gap(Get.height * 0.005),
                                  CustomText(
                                    title: 'Repost',
                                    size: Get.height * 0.014,
                                    fontFamily: 'GilroyRegular',
                                    textAlign: TextAlign.start,
                                    color: AppColor().primaryWhite,
                                  ),
                                ],
                              ),
                              Gap(Get.height * 0.01),
                              Row(
                                children: [
                                  CustomText(
                                    title: widget.item.repost == null
                                        ? widget.item.likeCount.toString()
                                        : widget.item.repost!.likeCount
                                            .toString(),
                                    size: Get.height * 0.014,
                                    fontFamily: 'GilroyBold',
                                    textAlign: TextAlign.start,
                                    color: AppColor().primaryWhite,
                                  ),
                                  Gap(Get.height * 0.005),
                                  CustomText(
                                    title: 'Likes',
                                    size: Get.height * 0.014,
                                    fontFamily: 'GilroyRegular',
                                    textAlign: TextAlign.start,
                                    color: AppColor().primaryWhite,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.4,
                      color: AppColor().lightItemsColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LikeButton(
                              size: Get.height * 0.025,
                              onTap: onLikeButtonTapped,
                              circleColor: CircleColor(
                                  start: AppColor().primaryColor,
                                  end: AppColor().primaryColor),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: AppColor().primaryColor,
                                dotSecondaryColor: AppColor().primaryColor,
                              ),
                              likeBuilder: (bool isLiked) {
                                if (widget.item.repost == null) {
                                  return widget.item.likes!
                                          .contains(authController.user!.id)
                                      ? Icon(
                                          isLiked
                                              ? Icons.favorite_outline
                                              : Icons.favorite,
                                          color: AppColor().primaryWhite,
                                          size: Get.height * 0.025)
                                      : Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: AppColor().primaryWhite,
                                          size: Get.height * 0.025);
                                } else {
                                  return widget.item.repost!.likes!
                                          .contains(authController.user!.id)
                                      ? Icon(
                                          isLiked
                                              ? Icons.favorite_outline
                                              : Icons.favorite,
                                          color: AppColor().primaryWhite,
                                          size: Get.height * 0.025)
                                      : Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: AppColor().primaryWhite,
                                          size: Get.height * 0.025);
                                }
                              },
                              likeCount: widget.item.repost == null
                                  ? widget.item.likeCount
                                  : widget.item.repost!.likeCount,
                              countBuilder:
                                  (int? count, bool isLiked, String text) {
                                var color = AppColor().primaryWhite;
                                Widget result;
                                if (count == 0) {
                                  result = CustomText(
                                      title: '0',
                                      size: Get.height * 0.014,
                                      fontFamily: 'GilroyBold',
                                      textAlign: TextAlign.start,
                                      color: color);
                                } else if (count == 1) {
                                  result = CustomText(
                                      title: '$text like',
                                      size: Get.height * 0.014,
                                      fontFamily: 'GilroyBold',
                                      textAlign: TextAlign.start,
                                      color: color);
                                } else {
                                  result = CustomText(
                                      title: '$text likes',
                                      size: Get.height * 0.014,
                                      fontFamily: 'GilroyBold',
                                      textAlign: TextAlign.start,
                                      color: color);
                                }
                                return result;
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.autorenew_outlined,
                            color: AppColor().primaryWhite,
                            size: Get.height * 0.03,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: false,
                                backgroundColor: AppColor().primaryWhite,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: Get.height * 0.2,
                                    padding: EdgeInsets.only(
                                      top: Get.height * 0.005,
                                      left: Get.height * 0.02,
                                      right: Get.height * 0.02,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor().primaryModalColor,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Column(children: [
                                      Center(
                                        child: Container(
                                          height: Get.height * 0.006,
                                          width: Get.height * 0.09,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: AppColor().greyGradient),
                                        ),
                                      ),
                                      Gap(Get.height * 0.03),
                                      ListView.separated(
                                        padding: EdgeInsets.zero,
                                        physics: const ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: repostItem.length,
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                          color: AppColor()
                                              .greyGradient
                                              .withOpacity(0.5),
                                          height: Get.height * 0.04,
                                          thickness: 0.5,
                                        ),
                                        itemBuilder: (context, index) {
                                          var item = repostItem[index];
                                          return InkWell(
                                            onTap: () {
                                              if (index == 0) {
                                                postController.rePost(
                                                    widget.item.id!, 'repost');
                                              } else {}
                                              Get.back();
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  item.icon,
                                                  color: AppColor().greyTwo,
                                                ),
                                                Gap(Get.height * 0.03),
                                                CustomText(
                                                  title: item.title,
                                                  color: AppColor().greyTwo,
                                                  weight: FontWeight.w400,
                                                  fontFamily: 'GilroyMedium',
                                                  size: Get.height * 0.020,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ]),
                                  );
                                });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.sms_outlined,
                              color: AppColor().primaryWhite,
                              size: Get.height * 0.025,
                            ),
                            Gap(Get.height * 0.005),
                            CustomText(
                              title: widget.item.repost == null
                                  ? widget.item.comment!.length.toString()
                                  : widget.item.repost!.comment!.length
                                      .toString(),
                              size: Get.height * 0.014,
                              fontFamily: 'GilroyBold',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.share_outlined,
                            color: AppColor().primaryWhite,
                            size: Get.height * 0.03,
                          ),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.4,
                      color: AppColor().lightItemsColor,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Comments',
                      size: Get.height * 0.018,
                      fontFamily: 'GilroyBold',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                    Gap(Get.height * 0.02),
                    widget.item.repost == null
                        ? Container(
                            child: widget.item.comment!.isEmpty
                                ? Center(
                                    child: CustomText(
                                      title: 'No comment',
                                      size: Get.height * 0.016,
                                      fontFamily: 'GilroyMedium',
                                      textAlign: TextAlign.start,
                                      color: AppColor().lightItemsColor,
                                    ),
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.zero,
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: widget.item.comment!.length,
                                    separatorBuilder: (context, index) =>
                                        Gap(Get.height * 0.025),
                                    itemBuilder: (context, index) {
                                      var item = widget.item.comment![index];
                                      return InkWell(
                                        onTap: () {
                                          if (index == 0) {
                                            // postController
                                            //     .rePost(widget.item.id!);
                                          } else {}
                                          Get.back();
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(
                                                  Get.height * 0.015),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      AppColor().primaryColor),
                                              child: CustomText(
                                                title: item.name![0]
                                                    .toCapitalCase(),
                                                color: AppColor().greyTwo,
                                                weight: FontWeight.w600,
                                                fontFamily: 'GilroyMedium',
                                                size: Get.height * 0.025,
                                              ),
                                            ),
                                            Gap(Get.height * 0.02),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  title: item.name,
                                                  color: AppColor().greySix,
                                                  weight: FontWeight.w400,
                                                  fontFamily: 'GilroyMedium',
                                                  size: Get.height * 0.015,
                                                ),
                                                Gap(Get.height * 0.01),
                                                CustomText(
                                                  title: item.body!,
                                                  color:
                                                      AppColor().primaryWhite,
                                                  weight: FontWeight.w400,
                                                  fontFamily: 'GilroyBold',
                                                  size: Get.height * 0.015,
                                                ),
                                                Gap(Get.height * 0.01),
                                                Row(
                                                  children: [
                                                    CustomText(
                                                        title: item.likes == 0
                                                            ? 'Like'
                                                            : item.likes == 1
                                                                ? '1Like'
                                                                : '${item.likes}Like',
                                                        color:
                                                            AppColor().greySix,
                                                        weight: FontWeight.w400,
                                                        fontFamily:
                                                            'GilroyMedium',
                                                        size:
                                                            Get.height * 0.01),
                                                    Gap(Get.height * 0.01),
                                                    CustomText(
                                                        title: 'Reply',
                                                        color:
                                                            AppColor().greySix,
                                                        weight: FontWeight.w400,
                                                        fontFamily:
                                                            'GilroyMedium',
                                                        size:
                                                            Get.height * 0.01),
                                                    Gap(Get.height * 0.01),
                                                    CustomText(
                                                        title: 'Repost',
                                                        color:
                                                            AppColor().greySix,
                                                        weight: FontWeight.w400,
                                                        fontFamily:
                                                            'GilroyMedium',
                                                        size:
                                                            Get.height * 0.01),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            LikeButton(
                                              size: Get.height * 0.025,
                                              onTap: onLikeButtonTapped,
                                              circleColor: CircleColor(
                                                  start:
                                                      AppColor().primaryColor,
                                                  end: AppColor().primaryColor),
                                              bubblesColor: BubblesColor(
                                                dotPrimaryColor:
                                                    AppColor().primaryColor,
                                                dotSecondaryColor:
                                                    AppColor().primaryColor,
                                              ),
                                              likeBuilder: (bool isLiked) {
                                                return Icon(
                                                    isLiked
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_outline,
                                                    color:
                                                        AppColor().primaryWhite,
                                                    size: Get.height * 0.015);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          )
                        : Container(
                            child: widget.item.repost!.comment!.isEmpty
                                ? Center(
                                    child: CustomText(
                                      title: 'No comment',
                                      size: Get.height * 0.016,
                                      fontFamily: 'GilroyMedium',
                                      textAlign: TextAlign.start,
                                      color: AppColor().lightItemsColor,
                                    ),
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.zero,
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        widget.item.repost!.comment!.length,
                                    separatorBuilder: (context, index) =>
                                        Gap(Get.height * 0.025),
                                    itemBuilder: (context, index) {
                                      var item =
                                          widget.item.repost!.comment![index];
                                      return InkWell(
                                        onTap: () {
                                          if (index == 0) {
                                            // postController
                                            //     .rePost(widget.item.id!);
                                          } else {}
                                          Get.back();
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(
                                                  Get.height * 0.015),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      AppColor().primaryColor),
                                              child: CustomText(
                                                title: item.name![0]
                                                    .toCapitalCase(),
                                                color: AppColor().greyTwo,
                                                weight: FontWeight.w600,
                                                fontFamily: 'GilroyMedium',
                                                size: Get.height * 0.025,
                                              ),
                                            ),
                                            Gap(Get.height * 0.02),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  title: item.name,
                                                  color: AppColor().greySix,
                                                  weight: FontWeight.w400,
                                                  fontFamily: 'GilroyMedium',
                                                  size: Get.height * 0.015,
                                                ),
                                                Gap(Get.height * 0.01),
                                                CustomText(
                                                  title: item.body!,
                                                  color:
                                                      AppColor().primaryWhite,
                                                  weight: FontWeight.w400,
                                                  fontFamily: 'GilroyBold',
                                                  size: Get.height * 0.015,
                                                ),
                                                Gap(Get.height * 0.01),
                                                Row(
                                                  children: [
                                                    CustomText(
                                                        title: item.likes == 0
                                                            ? 'Like'
                                                            : item.likes == 1
                                                                ? '1Like'
                                                                : '${item.likes}Like',
                                                        color:
                                                            AppColor().greySix,
                                                        weight: FontWeight.w400,
                                                        fontFamily:
                                                            'GilroyMedium',
                                                        size:
                                                            Get.height * 0.01),
                                                    Gap(Get.height * 0.01),
                                                    CustomText(
                                                        title: 'Reply',
                                                        color:
                                                            AppColor().greySix,
                                                        weight: FontWeight.w400,
                                                        fontFamily:
                                                            'GilroyMedium',
                                                        size:
                                                            Get.height * 0.01),
                                                    Gap(Get.height * 0.01),
                                                    CustomText(
                                                        title: 'Repost',
                                                        color:
                                                            AppColor().greySix,
                                                        weight: FontWeight.w400,
                                                        fontFamily:
                                                            'GilroyMedium',
                                                        size:
                                                            Get.height * 0.01),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            LikeButton(
                                              size: Get.height * 0.025,
                                              onTap: onLikeButtonTapped,
                                              circleColor: CircleColor(
                                                  start:
                                                      AppColor().primaryColor,
                                                  end: AppColor().primaryColor),
                                              bubblesColor: BubblesColor(
                                                dotPrimaryColor:
                                                    AppColor().primaryColor,
                                                dotSecondaryColor:
                                                    AppColor().primaryColor,
                                              ),
                                              likeBuilder: (bool isLiked) {
                                                return Icon(
                                                    isLiked
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_outline,
                                                    color:
                                                        AppColor().primaryWhite,
                                                    size: Get.height * 0.015);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                    Gap(Get.height * 0.05),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(Get.height * 0.02),
            color: AppColor().chatArea,
            child: Row(
              children: [
                OtherImage(
                  itemSize: Get.height * 0.03,
                  image: authController.user!.profile!.profilePicture,
                ),
                Gap(Get.height * 0.01),
                Expanded(
                    child: ChatCustomTextField(
                  textEditingController: authController.chatController,
                  onSubmited: (_) {
                    if (authController.chatController.text != '') {
                      postController
                          .commentOnPost(widget.item.id!)
                          .then((value) {
                        if (postController.postStatus == PostStatus.success) {
                          authController.chatController.clear();
                        }
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Leave your thoughts here...",
                    fillColor: Colors.transparent,
                    filled: true,
                    isDense: true,
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: AppColor().primaryWhite,
                      fontSize: 13,
                      fontFamily: 'GilroyRegular',
                      fontWeight: FontWeight.w400,
                    ),
                    hintStyle: TextStyle(
                      color: AppColor().primaryWhite,
                      fontSize: 13,
                      fontFamily: 'GilroyRegular',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )),
                Gap(Get.height * 0.01),
                CustomText(
                  title: '@',
                  size: 23,
                  fontFamily: 'GilroyRegular',
                  weight: FontWeight.w600,
                  textAlign: TextAlign.start,
                  color: AppColor().primaryWhite,
                ),
                Gap(Get.height * 0.02),
                Icon(Icons.photo_camera_outlined,
                    color: AppColor().primaryWhite)
              ],
            ),
          )
        ],
      ),
    );
  }

  void showEditPopup() async {
    String? selectedMenuItem = await showMenu(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      constraints: const BoxConstraints(),
      color: AppColor().primaryMenu,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          value: 'ScreenA',
          height: 20,
          padding: const EdgeInsets.only(bottom: 20, left: 20, top: 20),
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: AppColor().primaryWhite,
                size: Get.height * 0.016,
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Edit Post',
                size: Get.height * 0.014,
                fontFamily: 'GilroyMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
        ),
      ],
    );

    if (selectedMenuItem != null) {
      Get.to(() => EditPost(item: widget.item));
    }
  }

  Row commentItem({String? comment, like, IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: Get.height * 0.05,
            width: Get.height * 0.05,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/png/postImage1.png',
                  ),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        Gap(Get.height * 0.01),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: 'Southpark #2234',
                size: Get.height * 0.014,
                fontFamily: 'GilroyRegular',
                textAlign: TextAlign.start,
                color: AppColor().lightItemsColor,
              ),
              Gap(Get.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomText(
                      title: comment,
                      size: Get.height * 0.016,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ),
                  Gap(Get.height * 0.01),
                  IconButton(
                    alignment: Alignment.bottomRight,
                    icon: Icon(
                      icon,
                      color: AppColor().primaryColor,
                      size: Get.height * 0.02,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Gap(Get.height * 0.01),
              Row(
                children: [
                  CustomText(
                    title: like,
                    size: Get.height * 0.012,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'Reply',
                    size: Get.height * 0.012,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'Repost',
                    size: Get.height * 0.012,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
