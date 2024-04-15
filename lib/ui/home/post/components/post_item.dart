// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'post_details.dart';

class PostItem extends StatefulWidget {
  final PostModel item;
  const PostItem({super.key, required this.item});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
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

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (postController.postStatus != PostStatus.loading) {
      postController.likePost(widget.item.id!);
    }
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      (postController.allPost.length);
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
            color: AppColor().greyEight,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.item.repost != null)
              InkWell(
                onTap: () {
                  Get.to(() => PostDetails(item: widget.item));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.item.author!.profile!.profilePicture ==
                                      null
                                  ? SvgPicture.asset(
                                      'assets/images/svg/people.svg',
                                      height: Get.height * 0.025,
                                      width: Get.height * 0.025,
                                    )
                                  : InkWell(
                                      onTap: () => Get.to(() => UserDetails(
                                          id: widget.item.author!.id!)),
                                      child: CachedNetworkImage(
                                        height: Get.height * 0.025,
                                        width: Get.height * 0.025,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        imageUrl: widget.item.author!.profile!
                                            .profilePicture!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(widget
                                                    .item
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
                                title:
                                    '${widget.item.author!.fullName!.toCapitalCase()} Reposted this',
                                size: Get.height * 0.015,
                                fontFamily: 'GilroyMedium',
                                textAlign: TextAlign.start,
                                color: AppColor().lightItemsColor,
                              ),
                            ],
                          ),
                          InkWell(
                            child: Icon(
                              Icons.more_vert,
                              color: AppColor().primaryWhite,
                            ),
                            onTap: () => postMenu(),
                          ),
                        ],
                      ),
                      Gap(Get.height * 0.01),
                      if (widget.item.body != '')
                        CustomText(
                          title: widget.item.body!.toUpperFirstCase(),
                          size: Get.height * 0.015,
                          fontFamily: 'GilroyBold',
                          textAlign: TextAlign.start,
                          color: AppColor().primaryWhite,
                        ),
                      if (widget.item.body != '') Gap(Get.height * 0.01),
                      Divider(
                        thickness: 0.4,
                        color: AppColor().lightItemsColor,
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.item.repost == null
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (widget.item.author!.profile!.profilePicture ==
                                    null)
                                ? InkWell(
                                    onTap: () {
                                      Get.to(() => UserDetails(
                                          id: widget.item.author!.id!));
                                    },
                                    child: SvgPicture.asset(
                                        'assets/images/svg/people.svg',
                                        height: Get.height * 0.035,
                                        width: Get.height * 0.035),
                                  )
                                : InkWell(
                                    onTap: () {
                                      Get.to(() => UserDetails(
                                          id: widget.item.author!.id!));
                                    },
                                    child: CachedNetworkImage(
                                      height: Get.height * 0.035,
                                      width: Get.height * 0.035,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      imageUrl: widget.item.author!.profile!
                                          .profilePicture!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(widget
                                                  .item
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
                              title:
                                  widget.item.author!.fullName!.toCapitalCase(),
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
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (widget.item.repost!.author!.profile!
                                        .profilePicture ==
                                    null)
                                ? SvgPicture.asset(
                                    'assets/images/svg/people.svg',
                                    height: Get.height * 0.035,
                                    width: Get.height * 0.035)
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
                              title: timeAgo(widget.item.createdAt!),
                              size: Get.height * 0.015,
                              fontFamily: 'GilroyMedium',
                              textAlign: TextAlign.start,
                              color: AppColor().lightItemsColor,
                            ),
                          ],
                        ),
                  if (widget.item.repost == null)
                    InkWell(
                      child: Icon(
                        Icons.more_vert,
                        color: AppColor().primaryWhite,
                      ),
                      onTap: () => postMenu(),
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
                fontFamily: 'GilroyMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ),
            Gap(Get.height * 0.015),
            Stack(
              alignment: Alignment.center,
              children: [
                (widget.item.repost == null)
                    ? Container(
                        child: widget.item.image == null
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
                                imageUrl: widget.item.image!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(widget.item.image!),
                                        fit: BoxFit.cover),
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
                                color:
                                    AppColor().primaryColor.withOpacity(0.05),
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
                  profileMenu(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LikeButton(
                        size: Get.height * 0.025,
                        onTap: onLikeButtonTapped,
                        isLiked: widget.item.likes!
                            .any((item) => item.id == authController.user!.id),
                        circleColor: CircleColor(
                            start: AppColor().primaryColor,
                            end: AppColor().primaryColor),
                        bubblesColor: BubblesColor(
                          dotPrimaryColor: AppColor().primaryColor,
                          dotSecondaryColor: AppColor().primaryColor,
                        ),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                              isLiked ? Icons.favorite : Icons.favorite_outline,
                              color: isLiked
                                  ? AppColor().primaryColor
                                  : AppColor().primaryWhite,
                              size: Get.height * 0.025);
                        },
                        likeCount: widget.item.likeCount,
                        countBuilder: (int? count, bool isLiked, String text) {
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
                  Row(
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.sms_outlined,
                          color: AppColor().primaryWhite,
                          size: Get.height * 0.025,
                        ),
                        onTap: () {},
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
                      InkWell(
                        child: Icon(
                          Icons.share_outlined,
                          color: AppColor().primaryWhite,
                          size: Get.height * 0.025,
                        ),
                        onTap: () {},
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
    });
  }

  profileMenu() {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide.none),
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
                content: Text('This is the content of the alert dialog.'),
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
          padding: const EdgeInsets.only(bottom: 20, left: 20, top: 20),
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
              widget.item.author!.profile!.profilePicture == null
                  ? SvgPicture.asset(
                      'assets/images/svg/people.svg',
                      height: Get.height * 0.02,
                      width: Get.height * 0.02,
                    )
                  : CachedNetworkImage(
                      height: Get.height * 0.02,
                      width: Get.height * 0.02,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: widget.item.author!.profile!.profilePicture!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.item.author!.profile!.profilePicture!),
                              fit: BoxFit.cover),
                        ),
                      ),
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
    );
  }

  void postMenu() async {
    String? selectedMenuItem = await showMenu(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      constraints: const BoxConstraints(),
      color: AppColor().primaryMenu,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          value: '0',
          height: 20,
          padding: const EdgeInsets.only(bottom: 20, left: 20, top: 20),
          child:
              popUpMenuItems(icon: Icons.bookmark_outline, title: 'Bookmark'),
        ),
        PopupMenuItem(
          value: '1',
          height: 20,
          padding: const EdgeInsets.only(bottom: 20, left: 20),
          child: popUpMenuItems(
              icon: Icons.thumb_down_alt_outlined,
              title: 'Not interested in this post'),
        ),
        PopupMenuItem(
          value: '2',
          height: 20,
          padding: const EdgeInsets.only(bottom: 20, left: 20),
          child: popUpMenuItems(
              icon: Icons.person_add_alt_outlined,
              title: 'Follow/Unfollow @${widget.item.author!.userName}'),
        ),
        PopupMenuItem(
          value: '3',
          height: 20,
          padding: const EdgeInsets.only(bottom: 20, left: 20),
          child: popUpMenuItems(
              icon: Icons.notifications_off_outlined,
              title: 'Turn on/Turn off Notifications'),
        ),
        PopupMenuItem(
          value: '4',
          height: 20,
          padding: const EdgeInsets.only(bottom: 20, left: 20),
          child: popUpMenuItems(
              icon: Icons.volume_off_outlined,
              title: 'Mute/Unmute @${widget.item.author!.userName}'),
        ),
        PopupMenuItem(
          value: '5',
          height: 20,
          padding: const EdgeInsets.only(bottom: 20, left: 20),
          child: popUpMenuItems(
              icon: Icons.block_outlined,
              title: 'Block @${widget.item.author!.userName}'),
        ),
        PopupMenuItem(
          value: '6',
          height: 20,
          padding: const EdgeInsets.only(bottom: 20, left: 20),
          child: popUpMenuItems(icon: Icons.flag, title: 'Report Post'),
        ),
      ],
    );

    if (selectedMenuItem == '0' &&
        postController.bookmarkPostStatus != BookmarkPostStatus.loading) {
      debugPrint('bookmark');
      await postController.bookmarkPost(widget.item.id!);
    } else if (selectedMenuItem == '1' &&
        postController.blockPostStatus != BlockPostStatus.loading) {
      debugPrint('uninterested post');
      await postController.blockUserOrPost(widget.item.id!, 'uninterested');
    } else if (selectedMenuItem == '2' &&
        authController.followStatus != FollowStatus.loading) {
      debugPrint('follow / unfollow user');
      await authController.followUser(widget.item.author!.id!);
    } else if (selectedMenuItem == '3' &&
        authController.followStatus != FollowStatus.loading) {
      debugPrint('turning notification');
      await authController.turnNotification(widget.item.author!.id.toString());
    } else if (selectedMenuItem == '5' &&
        postController.blockPostStatus != BlockPostStatus.loading) {
      debugPrint('block user');
      await postController.blockUserOrPost(widget.item.author!.id!, 'block');
    }
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
