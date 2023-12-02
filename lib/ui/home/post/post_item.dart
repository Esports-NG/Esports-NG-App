// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class PostItem extends StatefulWidget {
  final PostModel item;
  const PostItem({super.key, required this.item});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
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
                    widget.item.author!.profile!.profilePicture == null
                        ? SvgPicture.asset(
                            'assets/images/svg/people.svg',
                            height: Get.height * 0.025,
                            width: Get.height * 0.025,
                          )
                        : CachedNetworkImage(
                            height: Get.height * 0.025,
                            width: Get.height * 0.025,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageUrl:
                                widget.item.author!.profile!.profilePicture,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(widget
                                        .item.author!.profile!.profilePicture),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                    Gap(Get.height * 0.01),
                    CustomText(
                      title: widget.item.author!.fullName!.toCapitalCase(),
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
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColor().primaryMenu,
                  offset: const Offset(0, -10),
                  initialValue: _selectedIndex,
                  onSelected: (value) {
                    setState(() {
                      if (value == 0) {
                        _selectedIndex = value;
                      } else if (value == 1) {
                        _selectedIndex = value;
                      } else if (value == 2) {}
                    });
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      height: 20,
                      padding:
                          const EdgeInsets.only(bottom: 20, left: 20, top: 20),
                      child: popUpMenuItems(
                          icon: Icons.bookmark_outline, title: 'Bookmark'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.thumb_down_alt_outlined,
                          title: 'Not interested in this post'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.person_add_alt_outlined,
                          title: 'Follow/Unfollow User'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.notifications_off_outlined,
                          title: 'Turn on/Turn off Notifications'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.volume_off_outlined,
                          title: 'Mute/Unmute User'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.block_outlined, title: 'Block User'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.flag, title: 'Report Post'),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: AppColor().primaryWhite,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CustomText(
              title: widget.item.title!.toUpperFirstCase(),
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
              widget.item.image == null
                  ? Container(
                      height: Get.height * 0.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/png/placeholder.png'),
                            fit: BoxFit.cover),
                      ),
                    )
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
                      imageUrl:
                          'http://res.cloudinary.com/dkykwpryb/${widget.item.image!}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'http://res.cloudinary.com/dkykwpryb/${widget.item.image!}'),
                              fit: BoxFit.cover),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColor().primaryMenu,
                  offset: const Offset(0, -10),
                  initialValue: _selectedIndex,
                  onSelected: (value) {
                    if (value == 0) {
                      _selectedIndex = value;
                    } else if (value == 1) {
                      _selectedIndex = value;
                    } else if (value == 2) {
                      _selectedIndex = value;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Alert Dialog Title'),
                            content: Text(
                                'This is the content of the alert dialog.'),
                            actions: [
                              // Define actions like "OK" or "Cancel" buttons.
                              TextButton(
                                onPressed: () {
                                  // Close the dialog when the "OK" button is pressed.
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      height: 20,
                      padding:
                          const EdgeInsets.only(bottom: 20, left: 20, top: 20),
                      child: CustomText(
                        title: 'Like, Comment and Repost as:',
                        size: Get.height * 0.014,
                        fontFamily: 'GilroyBold',
                        textAlign: TextAlign.start,
                        color: AppColor().primaryWhite,
                      ),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/png/account.png',
                            height: Get.height * 0.02,
                            width: Get.height * 0.02,
                          ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: widget.item.author!.fullName,
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyMedium',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.group_outlined,
                            color: AppColor().primaryWhite,
                            size: Get.height * 0.016,
                          ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'Your Team Profile',
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyMedium',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                          Gap(Get.height * 0.02),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColor().primaryWhite,
                            size: Get.height * 0.016,
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/png/drop.png',
                        height: Get.height * 0.02,
                        width: Get.height * 0.02,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.025,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LikeButton(
                      size: Get.height * 0.025,
                      circleColor: CircleColor(
                          start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: isLiked
                              ? AppColor().primaryColor
                              : AppColor().primaryWhite,
                          size: Get.height * 0.025,
                        );
                      },
                      likeCount: widget.item.likes!.length,
                      countBuilder: (int? count, bool isLiked, String text) {
                        var color = isLiked
                            ? AppColor().primaryColor
                            : AppColor().primaryWhite;
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
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.sms_outlined,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.025,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: widget.item.comment!.length.toString(),
                      size: Get.height * 0.014,
                      fontFamily: 'GilroyBold',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.share_outlined,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.025,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: 'Share',
                      size: Get.height * 0.014,
                      fontFamily: 'GilroyBold',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row popUpMenuItems({String? title, IconData? icon}) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColor().primaryWhite,
          size: Get.height * 0.016,
        ),
        Gap(Get.height * 0.02),
        CustomText(
          title: title,
          size: Get.height * 0.014,
          fontFamily: 'GilroyMedium',
          textAlign: TextAlign.start,
          color: AppColor().primaryWhite,
        ),
      ],
    );
  }
}
