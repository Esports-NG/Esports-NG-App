import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';

class PostActions extends StatelessWidget {
  final PostModel post;
  final PostRepository postController;
  final AuthRepository authController;

  const PostActions({
    Key? key,
    required this.post,
    required this.postController,
    required this.authController,
  }) : super(key: key);

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    if (postController.postStatus != PostStatus.loading) {
      postController.likePost(post.slug!);
    }
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProfileMenu(),
        _buildLikeButton(),
        _buildCommentButton(),
        _buildShareButton(),
      ],
    );
  }

  Widget _buildLikeButton() {
    return LikeButton(
      size: Get.height * 0.025,
      onTap: onLikeButtonTapped,
      isLiked: post.likes!.any((item) => item.id == authController.user!.id),
      circleColor: CircleColor(
          start: AppColor().primaryColor, end: AppColor().primaryColor),
      bubblesColor: BubblesColor(
        dotPrimaryColor: AppColor().primaryColor,
        dotSecondaryColor: AppColor().primaryColor,
      ),
      likeBuilder: (bool isLiked) {
        return Icon(isLiked ? IconsaxPlusBold.heart : IconsaxPlusLinear.heart,
            color: isLiked ? AppColor().primaryColor : AppColor().greyTwo,
            size: 20.sp);
      },
      likeCountPadding: EdgeInsets.only(left: 5.r),
      likeCount: post.likeCount,
      countBuilder: (int? count, bool isLiked, String text) {
        var color = AppColor().greyTwo;
        return CustomText(
            title: "$count ${count == 1 ? "like" : "likes"}",
            size: 12,
            fontFamily: 'InterSemiBold',
            textAlign: TextAlign.start,
            color: color);
      },
    );
  }

  Widget _buildCommentButton() {
    return Row(
      children: [
        InkWell(
          child: Icon(
            IconsaxPlusLinear.message,
            color: AppColor().greyTwo,
            size: 20.sp,
          ),
          onTap: () {},
        ),
        Gap(Get.height * 0.005),
        CustomText(
          title: post.comment!.length.toString(),
          size: 12,
          fontFamily: 'InterSemiBold',
          textAlign: TextAlign.start,
          color: AppColor().greyTwo,
        ),
      ],
    );
  }

  Widget _buildShareButton() {
    return InkWell(
      onTap: () async {
        await Share.share(
            '${post.author!.userName} posted on Esports NG \nhttps://esportsng.com/post/${post.id}');
      },
      child: Row(
        children: [
          Icon(
            IconsaxPlusLinear.export,
            color: AppColor().greyTwo,
            size: 20.sp,
          ),
          Gap(Get.height * 0.01),
          CustomText(
            title: 'Share',
            size: 12,
            fontFamily: "InterSemiBold",
            textAlign: TextAlign.start,
            color: AppColor().greyTwo,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      color: AppColor().primaryMenu,
      offset: const Offset(0, -10),
      onSelected: (value) {},
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: CustomText(
            title: 'Like, Comment and Repost as:',
            size: 12,
            fontFamily: 'InterMedium',
            textAlign: TextAlign.start,
            color: AppColor().primaryWhite,
          ),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              authController.user!.profile!.profilePicture == null
                  ? Image.asset(
                      'assets/images/svg/people.svg',
                      height: Get.height * 0.02,
                      width: Get.height * 0.02,
                    )
                  : Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: Get.height * 0.02,
                          width: Get.height * 0.02,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                authController.user!.profile!.profilePicture,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (authController.user!.isVerified! == true)
                          Image.asset(
                            "assets/images/svg/check_badge.svg",
                            height: Get.height * 0.01,
                          )
                      ],
                    ),
              Gap(Get.height * .02),
              CustomText(
                title: authController.user!.fullName,
                size: 12,
                fontFamily: 'InterMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
        ),
        PopupMenuItem(
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
                size: 12,
                fontFamily: 'InterMedium',
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
          authController.user!.profile!.profilePicture == null
              ? Image.asset(
                  'assets/images/svg/people.svg',
                  height: Get.height * 0.02,
                  width: Get.height * 0.02,
                )
              : Container(
                  height: Get.height * 0.02,
                  width: Get.height * 0.02,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        authController.user!.profile!.profilePicture ?? "",
                      ),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor().greyTwo,
                      width: 1,
                    ),
                  ),
                ),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColor().greyTwo,
            size: Get.height * 0.025,
          ),
        ],
      ),
    );
  }
}
