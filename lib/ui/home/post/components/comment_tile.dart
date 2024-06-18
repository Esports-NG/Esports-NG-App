import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class CommentTile extends StatefulWidget {
  const CommentTile({super.key, required this.item});

  final Comment item;

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  final postController = Get.put(PostRepository()); // Access the controller
  int likeCount = 0;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    likeCount = widget.item.likes ?? 0; // Initialize from the widget's item
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (postController.postStatus != PostStatus.loading) {
      // postController.likeComment(item.id!);
    }

// temp like function
    if (postController.postStatus != PostStatus.loading) {
      setState(() {
        this.isLiked = !isLiked;
        likeCount = isLiked ? 0 : 1;
      });
    }

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    // final isLiked = item.userLikes != null && item.userLikes!.isNotEmpty &&
    //                 item.userLikes!.contains(authController.user!.id); // Check if liked
    // final likeCount = item.likes ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => Get.to(() => UserDetails(id: widget.item.user!.id!)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:
                      NetworkImage(widget.item.user!.profile!.profilePicture!),
                  fit: BoxFit.cover),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Gap(Get.height * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: widget.item.user!.userName!,
              color: AppColor().greySix,
              weight: FontWeight.w400,
              fontFamily: 'GilroyMedium',
              size: Get.height * 0.015,
            ),
            Gap(Get.height * 0.01),
            CustomText(
              title: widget.item.body!,
              color: AppColor().primaryWhite,
              weight: FontWeight.w400,
              fontFamily: 'GilroyBold',
              size: Get.height * 0.015,
            ),
            Gap(Get.height * 0.01),
            Row(
              children: [
                CustomText(
                    // title: item.likes == 0
                    //     ? 'Like'
                    //     : item.likes == 1
                    //         ? '1 Like'
                    //         : '${item.likes} Like',
                    title: likeCount == 0 ? 'Like' : '$likeCount Like',
                    color: AppColor().greySix,
                    weight: FontWeight.w400,
                    fontFamily: 'GilroyMedium',
                    size: 12),
                Gap(Get.height * 0.02),
                CustomText(
                    title: 'Reply',
                    color: AppColor().greySix,
                    weight: FontWeight.w400,
                    fontFamily: 'GilroyMedium',
                    size: 12),
                Gap(Get.height * 0.02),
                CustomText(
                    title: 'Repost',
                    color: AppColor().greySix,
                    weight: FontWeight.w400,
                    fontFamily: 'GilroyMedium',
                    size: 12),
              ],
            ),
          ],
        ),
        const Spacer(),
        LikeButton(
          onTap: onLikeButtonTapped,
          circleColor: CircleColor(
              start: AppColor().primaryColor, end: AppColor().primaryColor),
          bubblesColor: BubblesColor(
            dotPrimaryColor: AppColor().primaryColor,
            dotSecondaryColor: AppColor().primaryColor,
          ),
          likeBuilder: (bool isLiked) {
            return Icon(isLiked ? Icons.favorite : Icons.favorite_outline,
                color: AppColor().primaryWhite, size: 20);
          },
          isLiked: isLiked,
        ),
      ],
    );
  }
}
