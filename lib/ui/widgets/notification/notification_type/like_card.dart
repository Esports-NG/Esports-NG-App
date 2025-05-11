import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

class LikeCard extends StatefulWidget {
  const LikeCard({super.key, required this.notification});
  final NotificationModel notification;
  @override
  State<LikeCard> createState() => _LikeCardState();
}

class _LikeCardState extends State<LikeCard> {
  @override
  Widget build(BuildContext context) {
    var firstUser = widget.notification.userActors![0];
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Icon(
                CupertinoIcons.heart_fill,
                color: Color(0xffCE3939),
              ),
            ),
            Gap(13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  children: widget.notification.userActors!
                      .take(4)
                      .map((user) => Padding(
                            padding: const EdgeInsets.all(5),
                            child: OtherImage(
                              image: user.profile!.profilePicture,
                              width: 30,
                              height: 30,
                            ),
                          ))
                      .toList(),
                ),
                Gap(5),
                CustomText(
                    size: 12,
                    title: widget.notification.totalCount! == 1
                        ? "${firstUser.fullName} liked your post"
                        : "${firstUser.fullName} and ${widget.notification.totalCount! - 1} others liked your post"),
                Gap(4),
                CustomText(
                  title: widget.notification.targetPost!.body,
                  color: AppColor().greySix,
                  fontFamily: "InterMedium",
                  maxLines: 3,
                  size: 12,
                )
              ],
            )
          ],
        ));
  }
}
