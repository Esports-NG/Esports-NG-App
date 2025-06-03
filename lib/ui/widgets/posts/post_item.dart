// ignore_for_file: prefer_const_constructors

import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/screens/post/post_details.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/posts/post_actions.dart';
import 'package:e_sport/ui/widgets/posts/post_author_info.dart';
import 'package:e_sport/ui/widgets/posts/post_media.dart';
import 'package:e_sport/ui/widgets/posts/post_menu_options.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostItem extends StatefulWidget {
  final PostModel item;
  const PostItem({super.key, required this.item});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem>
    with AutomaticKeepAliveClientMixin {
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  final navController = Get.put(NavRepository());

  @override
  bool get wantKeepAlive => true;

  String timeAgo(DateTime itemDate) {
    final now = DateTime.now();
    final difference = now.difference(itemDate);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(() {
      (postController.allPost.length);
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor().primaryWhite.withOpacity(0.1),
              AppColor().primaryWhite.withOpacity(0.0),
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
            // Repost Header (if it's a repost)
            if (widget.item.repost != null) _buildRepostHeader(),

            // Post Header
            Padding(
              padding: EdgeInsets.all(Get.height * 0.006),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PostAuthorInfo(
                    post: widget.item,
                    timeAgo: timeAgo(widget.item.repost == null
                        ? widget.item.createdAt!
                        : widget.item.repost!.createdAt!),
                    isRepost: widget.item.repost != null,
                  ),
                  if (widget.item.repost == null)
                    PostMenuOptions(
                      post: widget.item,
                      authController: authController,
                      postController: postController,
                    ),
                ],
              ),
            ),

            // Post Body Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.012),
              child: CustomText(
                title: widget.item.repost == null
                    ? widget.item.body!.characters.take(200).toString()
                    : widget.item.repost!.body!.characters.take(200).toString(),
                size: 14,
                fontFamily: 'Inter',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ),
            Gap(Get.height * 0.01),

            // Post Media
            PostMedia(
              post: widget.item,
              isRepost: widget.item.repost != null,
            ),

            // Post Actions
            Padding(
              padding: EdgeInsets.all(Get.height * 0.012),
              child: PostActions(
                post: widget.item,
                postController: postController,
                authController: authController,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRepostHeader() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Get.to(() => PostDetails(item: widget.item));
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: Get.height * 0.002,
          left: Get.height * 0.012,
          right: Get.height * 0.012,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PostAuthorInfo(
                  post: widget.item,
                  timeAgo: timeAgo(widget.item.createdAt!),
                ),
                PostMenuOptions(
                  post: widget.item,
                  authController: authController,
                  postController: postController,
                ),
              ],
            ),
            if (widget.item.body != '')
              CustomText(
                title: widget.item.body!.characters.take(200).toString(),
                size: Get.height * 0.016,
                fontFamily: 'Inter',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            if (widget.item.body != '') Gap(Get.height * 0.005),
            Divider(
              thickness: 0.4,
              color: AppColor().lightItemsColor,
            ),
          ],
        ),
      ),
    );
  }
}
