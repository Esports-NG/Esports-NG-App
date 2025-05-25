import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({super.key, required this.notification});
  final NotificationModel notification;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final authController = Get.put(AuthRepository());

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
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 10),
          //   child: OtherImage(
          //       image:
          //           widget.notification.userActors![0].profile!.profilePicture,
          //       width: 20,
          //       height: 20),
          // ),
          Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // RichText(
                  //     text: TextSpan(
                  //         text: widget.notification.userActors![0].fullName,
                  //         style: TextStyle(fontSize: 12, fontFamily: "Inter"),
                  //         children: [
                  //       TextSpan(
                  //           text:
                  //               ' @${widget.notification.userActors![0].userName!}',
                  //           style: TextStyle(
                  //               fontSize: 12, color: AppColor().greySix))
                  //     ])),
                  Gap(Get.height * 0.005),
                  const SmallCircle(),
                  Gap(Get.height * 0.005),
                  CustomText(
                    title: timeAgo(widget.notification.createdAt!),
                    size: Get.height * 0.015,
                    fontFamily: 'InterMedium',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                ],
              ),
              Gap(2),
              RichText(
                  text: TextSpan(
                      text: 'Commented on your post',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColor().greySix,
                          fontFamily: "Inter"),
                      children: [
                    TextSpan(
                        text: ' @${authController.user!.userName!}',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColor().primaryWhite,
                            fontFamily: "Inter"))
                  ])),
              Gap(4),
              CustomText(
                title: widget.notification.targetComment!.body,
                color: AppColor().greySix,
                size: 12,
              )
            ],
          )
        ]));
  }
}
