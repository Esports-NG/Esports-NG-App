import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/ui/widgets/notification/notification_type/comment_card.dart';
import 'package:e_sport/ui/widgets/notification/notification_type/follow_card.dart';
import 'package:e_sport/ui/widgets/notification/notification_type/like_card.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({super.key, required this.notification});
  final NotificationModel notification;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return widget.notification.actionType! == "comment"
        ? CommentCard(notification: widget.notification)
        : widget.notification.actionType! == "like"
            ? LikeCard(notification: widget.notification)
            : widget.notification.actionType == "followed"
                ? FollowCard(notification: widget.notification)
                : Container(
                    color: AppColor().primaryColor,
                    child: CustomText(title: widget.notification.actionType));
  }
}
