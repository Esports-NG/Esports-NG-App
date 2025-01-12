// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_details.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/components/account_community_detail.dart';
import 'package:e_sport/ui/home/post/components/report_page.dart';
import 'package:e_sport/ui/home/post/edit_post.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

import 'package:e_sport/ui/home/post/components/post_details.dart';

class GamesToPlayItem extends StatefulWidget {
  final PostModel item;
  const GamesToPlayItem({super.key, required this.item});

  @override
  State<GamesToPlayItem> createState() => _GamesToPlayItemState();
}

class _GamesToPlayItemState extends State<GamesToPlayItem> {
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
          image: DecorationImage(
            image: const AssetImage('assets/images/png/bubbles.png'),
            fit: BoxFit.cover,
            ),
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
        child: Padding(
          padding: EdgeInsets.all(Get.width * 0.03),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: Get.width * 0.25,
                  child: CustomText(
                    title: '1',
                    fontFamily: 'InterSemiBold',
                  ),
                ),
              ),
              Gap(Get.height * 0.005),
              Expanded(
                flex: 5,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Get.width * 1),
                    child: Image(
                      image: NetworkImage(widget.item.author!.profile!.profilePicture.toString()),
                      fit: BoxFit.cover,
                      ),
                  ),
                ),
              ),
              Gap(Get.height * 0.02),
              Expanded(
                flex: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      title: 'NAME OF THE GAME',
                      fontFamily: 'InterSemiBold',
                      size: 14,
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: '${widget.item.author!.id} Players',
                      color: AppColor().greySix,
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: 'Play Here',
                      color: AppColor().greySix,
                      size: 12,
                    ),
                    Gap(Get.height * 0.006),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor().primaryColor,
                            borderRadius: BorderRadius.circular(200)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: SvgPicture.asset('assets/images/svg/apple.svg'),
                          )
                        ),
                        Gap(Get.height * 0.01),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor().primaryColor,
                            borderRadius: BorderRadius.circular(200)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: SvgPicture.asset('assets/images/svg/apple.svg'),
                          )
                        ),
                        Gap(Get.height * 0.01),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor().primaryColor,
                            borderRadius: BorderRadius.circular(200)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: SvgPicture.asset('assets/images/svg/apple.svg'),
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(Get.height * 0.005),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    CustomText(
                      title: 'Active Events',
                      fontFamily: 'InterRegular',
                      textAlign: TextAlign.center,
                    ),
                    Stack(
                      children: [
                        Positioned(child: SvgPicture.asset('assets/images/svg/event_icon_2.svg')),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: Get.height * 0.035,
                          bottom: 0,
                          child: CustomText(
                            title: widget.item.author!.id.toString(),
                            textAlign: TextAlign.center,
                            fontFamily: 'InterSemiBold',
                            )
                          ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
