// ignore_for_file: prefer_const_constructors

import 'package:e_sport/data/model/games_played_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/di/iterable_extension.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GamesToPlayItem extends StatefulWidget {
  final GameToPlay item;
  final int index;
  const GamesToPlayItem({super.key, required this.item, required this.index});

  @override
  State<GamesToPlayItem> createState() => _GamesToPlayItemState();
}

class _GamesToPlayItemState extends State<GamesToPlayItem> {
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  final navController = Get.put(NavRepository());

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
              SizedBox(
                height: Get.width * 0.25,
                child: CustomText(
                  title: (widget.index + 1).toString(),
                  fontFamily: 'InterSemiBold',
                ),
              ),
              // Gap(Get.height * 0.0025),
              Expanded(
                flex: 5,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Get.width * 1),
                    child: Image(
                      image: NetworkImage(
                          ApiLink.imageUrl + widget.item.profilePicture!),
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
                      title: widget.item.name,
                      fontFamily: 'InterSemiBold',
                      size: 14,
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: '${widget.item.players} Players',
                      color: AppColor().greySix,
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: 'Play Here:',
                      color: AppColor().greySix,
                      size: 12,
                    ),
                    Gap(Get.height * 0.006),
                    Row(
                      children: widget.item.downloadLinks!
                          .map((feed) => GestureDetector(
                              onTap: () => launchUrl(Uri.parse(feed.link!)),
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: AppColor().primaryColor,
                                      borderRadius: BorderRadius.circular(99)),
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xffEDEDFF),
                                      BlendMode.srcATop,
                                    ),
                                    child: Image.network(
                                        ApiLink.imageUrl + feed.platform!.logo!,
                                        width: 16,
                                        height: 16,
                                        fit: BoxFit.cover),
                                  ))))
                          .toList()
                          .separator(Gap(8))
                          .toList(),
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
                        Positioned(
                            child: SvgPicture.asset(
                                'assets/images/svg/event_icon_2.svg')),
                        Positioned(
                            left: 0,
                            right: 0,
                            top: Get.height * 0.035,
                            bottom: 0,
                            child: CustomText(
                              title: widget.item.events.toString(),
                              textAlign: TextAlign.center,
                              fontFamily: 'InterSemiBold',
                            )),
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
