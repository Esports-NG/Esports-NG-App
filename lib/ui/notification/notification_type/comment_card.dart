import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: OtherImage(
                image:
                    widget.notification.userActors![0].profile!.profilePicture,
                width: 20,
                height: 20),
          ),
          Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                      text: widget.notification.userActors![0].fullName,
                      style: TextStyle(fontSize: 12, fontFamily: "Inter"),
                      children: [
                    TextSpan(
                        text:
                            ' @${widget.notification.userActors![0].userName!}',
                        style:
                            TextStyle(fontSize: 12, color: AppColor().greySix))
                  ])),
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
