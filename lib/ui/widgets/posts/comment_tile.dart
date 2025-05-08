import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/screens/account/user_details.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/ui/screens/post/report_page.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:like_button/like_button.dart';

class CommentTile extends StatefulWidget {
  const CommentTile({super.key, required this.item});

  final Comment item;

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  final postController = Get.put(PostRepository());
  final authController = Get.put(AuthRepository());
  int? _likeCount;
  bool _isLiked = false;

  @override
  initState() {
    _likeCount = widget.item.likes!.length;
    if (widget.item.likes!
        .where((e) => e.id! == authController.user!.id!)
        .isNotEmpty) {
      _isLiked = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => Get.to(() => UserDetails(slug: widget.item.user!.slug!)),
          child: OtherImage(
              image: widget.item.user!.profile!.profilePicture,
              width: 40,
              height: 40),
        ),
        Gap(Get.height * 0.02),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: widget.item.user!.userName!,
              color: AppColor().greySix,
              fontFamily: 'InterMedium',
              size: Get.height * 0.015,
            ),
            Gap(Get.height * 0.01),
            SizedBox(
              width: Get.width * 0.65,
              child: CustomText(
                title: widget.item.body!,
                color: AppColor().primaryWhite,
                fontFamily: 'InterSemiBold',
                size: Get.height * 0.015,
              ),
            ),
            Gap(Get.height * 0.01),
            Row(
              children: [
                CustomText(
                    title: _likeCount == 0
                        ? 'Like'
                        : _likeCount == 1
                            ? '1 Like'
                            : '$_likeCount Like',
                    color: AppColor().greySix,
                    fontFamily: 'InterMedium',
                    size: 12),
                Gap(Get.height * 0.02),
                CustomText(
                    title: 'Reply',
                    color: AppColor().greySix,
                    fontFamily: 'InterMedium',
                    size: 12),
                Gap(Get.height * 0.02),
                CustomText(
                    title: 'Repost',
                    color: AppColor().greySix,
                    fontFamily: 'InterMedium',
                    size: 12),
                Gap(Get.height * 0.03),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: AppColor().primaryBgColor,
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Get.to(() => ReportPage(
                                      type: "comment", id: widget.item.id!));
                                },
                                child: CustomText(
                                  title:
                                      'Report Comment by ${widget.item.user!.userName}',
                                  // Additional fields after this should be Comment details, Reason for reporting etc
                                  color: AppColor().primaryWhite,

                                  fontFamily: 'InterBold',
                                  size: Get.height * 0.015,
                                ),
                              ),
                              Gap(Get.height * 0.03),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Get.to(() => ReportPage(
                                      type: "user", id: widget.item.user!.id!));
                                },
                                child: CustomText(
                                  title: 'Report ${widget.item.user!.userName}',
                                  // Additional fields after this should be Comment details, Reason for reporting etc
                                  color: AppColor().primaryWhite,

                                  fontFamily: 'InterBold',
                                  size: Get.height * 0.015,
                                ),
                              ),
                              Gap(Get.height * 0.03),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  postController.blockUserOrPost(
                                      widget.item.user!.id!, "block");
                                },
                                child: CustomText(
                                  title: 'Block ${widget.item.user!.userName}',
                                  // Additional fields after this should be Comment details, Reason for reporting etc
                                  color: AppColor().primaryWhite,

                                  fontFamily: 'InterBold',
                                  size: Get.height * 0.015,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: CustomText(
                      title: 'Report',
                      color: AppColor().primaryRed,
                      fontFamily: 'InterMedium',
                      size: 12),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        LikeButton(
          isLiked: _isLiked,
          onTap: (isLiked) async {
            setState(() {
              if (isLiked) {
                _likeCount = _likeCount! - 1;
              } else {
                _likeCount = _likeCount! + 1;
              }
              _isLiked = !isLiked;
            });
            await postController.likeComment(widget.item.id!);
            return null;
          },
          circleColor: CircleColor(
              start: AppColor().primaryColor, end: AppColor().primaryColor),
          bubblesColor: BubblesColor(
            dotPrimaryColor: AppColor().primaryColor,
            dotSecondaryColor: AppColor().primaryColor,
          ),
          likeBuilder: (bool isLiked) {
            return Icon(
                isLiked ? IconsaxPlusBold.heart : IconsaxPlusLinear.heart,
                color: AppColor().primaryWhite,
                size: 20.sp);
          },
        ),
      ],
    );
  }
}
