import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';

class RepostOption {
  final String title;
  final IconData icon;

  const RepostOption({required this.title, required this.icon});
}

class PostInteractionButtons extends StatelessWidget {
  final PostModel post;
  final AuthRepository authController;
  final PostRepository postController;
  final Function() onRepostActive;
  final bool isAuthor;

  // Define repostItem list as static constant
  static const List<RepostOption> _repostItems = [
    RepostOption(title: 'Repost', icon: IconsaxPlusLinear.repeat),
    RepostOption(title: 'Quote with comment', icon: IconsaxPlusLinear.message),
  ];

  const PostInteractionButtons({
    Key? key,
    required this.post,
    required this.authController,
    required this.postController,
    required this.onRepostActive,
    this.isAuthor = false,
  }) : super(key: key);

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (postController.postStatus != PostStatus.loading) {
      postController.likePost(post.slug!);
    }
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 20.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LikeButton(
            size: Get.height * 0.025,
            onTap: onLikeButtonTapped,
            likeCountPadding: EdgeInsets.only(left: 5.r),
            likeCount: post.likeCount,
            isLiked:
                post.likes!.any((item) => item.id == authController.user!.id),
            circleColor: CircleColor(
                start: AppColor().primaryColor, end: AppColor().primaryColor),
            bubblesColor: BubblesColor(
              dotPrimaryColor: AppColor().primaryColor,
              dotSecondaryColor: AppColor().primaryColor,
            ),
            countBuilder: (likeCount, isLiked, text) => CustomText(
              title: likeCount.toString(),
              color: AppColor().primaryWhite,
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                  isLiked ? IconsaxPlusBold.heart : IconsaxPlusLinear.heart,
                  color: isLiked
                      ? AppColor().primaryColor
                      : AppColor().primaryWhite,
                  size: 22.sp);
            },
          ),
          Row(
            spacing: 5.r,
            children: [
              GestureDetector(
                onTap: () {
                  if (!isAuthor) {
                    _showRepostOptions(context);
                  }
                },
                child: Icon(
                  IconsaxPlusLinear.repeat,
                  color: AppColor().primaryWhite,
                  size: 22.sp,
                ),
              ),
              CustomText(
                title: post.repostCount.toString(),
                fontFamily: "InterSemiBold",
              )
            ],
          ),
          Row(
            children: [
              Icon(
                IconsaxPlusLinear.message,
                color: AppColor().primaryWhite,
                size: 22.sp,
              ),
              SizedBox(width: Get.height * 0.005),
              CustomText(
                title: post.comment!.length.toString(),
                size: 12,
                fontFamily: 'InterBold',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
          GestureDetector(
            child: Icon(
              IconsaxPlusLinear.export,
              color: AppColor().primaryWhite,
              size: 22.sp,
            ),
            onTap: () async {
              await Share.share(
                  '${post.author!.userName} posted on Esports NG \nhttps://esportsng.com/post/${post.id}');
            },
          ),
        ],
      ),
    );
  }

  void _showRepostOptions(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
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
              color: AppColor().bgDark,
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
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor().primaryWhite.withOpacity(0.5),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              ListView.separated(
                padding: EdgeInsets.zero,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _repostItems.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColor().greyGradient.withOpacity(0.5),
                  height: Get.height * 0.04,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  var item = _repostItems[index];
                  return InkWell(
                    onTap: () {
                      if (index == 0) {
                        postController.rePost(post.id!, "repost");
                      } else {
                        onRepostActive();
                      }
                      Get.back();
                    },
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          color: AppColor().greyTwo,
                        ),
                        SizedBox(width: Get.height * 0.03),
                        CustomText(
                          title: item.title,
                          color: AppColor().greyTwo,
                          weight: FontWeight.w400,
                          fontFamily: 'InterMedium',
                          size: 18,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ]),
          );
        });
  }
}
