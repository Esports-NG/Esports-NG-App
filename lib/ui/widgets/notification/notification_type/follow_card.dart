import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/ui/screens/account/user_details.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FollowCard extends StatelessWidget {
  const FollowCard({super.key, required this.notification});
  final NotificationModel notification;
  @override
  Widget build(BuildContext context) {
    var firstUser = notification.userActors![0];
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
                  children: notification.userActors!
                      .take(4)
                      .map((user) => GestureDetector(
                            onTap: () =>
                                Get.to(() => UserDetails(slug: user.slug!)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: OtherImage(
                                image: user.profile!.profilePicture,
                                width: 30.r,
                                height: 30.r,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                Gap(5),
                CustomText(
                    size: 12,
                    title: notification.totalCount! == 1
                        ? "${firstUser.fullName} followed you"
                        : "${firstUser.fullName} and ${notification.totalCount! - 1} followed you"),
                Gap(4),
                // CustomText(
                //   title: widget.notification.targetPost!.body,
                //   color: AppColor().greySix,
                //   fontFamily: "InterMedium",
                //   maxLines: 3,
                //   size: 12,
                // )
              ],
            )
          ],
        ));
  }
}
