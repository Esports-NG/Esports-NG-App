import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AllNotification extends StatelessWidget {
  const AllNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthRepository());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: 4,
          separatorBuilder: (context, index) => Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.05,
            thickness: 0.5,
          ),
          itemBuilder: (context, index) {
            var item = authController.notifications[index];
            return GestureDetector(
              child: GroupedPost(
                notifications: authController.notifications,
                postId: authController.notifications[0].postId,
              ),
            );
          },
        ),
      ),
    );
  }
}

class GroupedPost extends StatelessWidget {
  const GroupedPost({super.key, required this.notifications, this.postId});
  final List<NotificationModel> notifications;
  final int? postId;

  @override
  Widget build(BuildContext context) {
    final selectedNotifications = notifications
        .where(
          (element) => element.postId == postId,
        )
        .toList();
    final first = selectedNotifications[0];
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Image.asset(
              "assets/images/png/heart.png",
              fit: BoxFit.cover,
              width: 20,
            ),
          ),
          Gap(10),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: selectedNotifications.length,
                    separatorBuilder: (context, index) => Gap(10),
                    itemBuilder: (context, index) {
                      final item = selectedNotifications[index];
                      return Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(89),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    ApiLink.imageUrl + (item.profile ?? "")))),
                      );
                    },
                  ),
                ),
                Gap(Get.height * 0.01),
                CustomText(
                  title:
                      "${first.name} and ${selectedNotifications.length - 1} others liked your post",
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.start,
                  fontFamily: 'Inter',
                  size: 14,
                ),
                Gap(Get.height * 0.01),
                CustomText(
                  title: first.content,
                  color: AppColor().lightItemsColor,
                  fontFamily: 'Inter',
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class PersonalItem extends StatelessWidget {
//   final NotificationModel item;
//   const PersonalItem({super.key, required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:
//           EdgeInsets.only(left: 20, right: item.type == 'tournament' ? 0 : 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: EdgeInsets.only(
//                 top: item.type == "like" || item.type == "repost" ? 10 : 0),
//             child: Image.asset(
//               item.profile!,
//               fit: BoxFit.cover,
//               width: 20,
//             ),
//           ),
//           Gap(10),
//           Expanded(
//             flex: 5,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (item.type == 'post') ...[
//                   Row(
//                     children: [
//                       CustomText(
//                         title: '${item.likeDetails} ',
//                         color: AppColor().primaryWhite,
//                         textAlign: TextAlign.start,
//                         fontFamily: 'Inter',
//                         size: 14,
//                       ),
//                       Gap(Get.height * 0.01),
//                       const SmallCircle(),
//                       Gap(Get.height * 0.01),
//                       CustomText(
//                         title: item.time,
//                         color: AppColor().lightItemsColor,
//                         textAlign: TextAlign.start,
//                         fontFamily: 'Inter',
//                         size: 14,
//                       ),
//                     ],
//                   ),
//                   Gap(Get.height * 0.01),
//                   Text.rich(
//                     TextSpan(
//                       text: item.details,
//                       style: TextStyle(
//                         color: AppColor().lightItemsColor,
//                         fontFamily: 'Inter',
//                         fontSize: 14,
//                       ),
//                       children: <TextSpan>[
//                         TextSpan(
//                             text: item.link,
//                             style: TextStyle(
//                                 color: AppColor().primaryColor,
//                                 decoration: TextDecoration.underline),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () {
//                                 // open link here
//                               }),
//                       ],
//                     ),
//                   ),
//                 ] else if (item.type == 'personal') ...[
//                   if (item.subType == 'comment' ||
//                       item.subType == 'tagged') ...[
//                     Row(
//                       children: [
//                         CustomText(
//                           title: '${item.infoName} ',
//                           color: AppColor().primaryWhite,
//                           textAlign: TextAlign.start,
//                           fontFamily: 'Inter',
//                           size: 14,
//                         ),
//                         CustomText(
//                           title: item.infoTag,
//                           color: AppColor().lightItemsColor,
//                           textAlign: TextAlign.start,
//                           fontFamily: 'Inter',
//                           size: 14,
//                         ),
//                         Gap(Get.height * 0.01),
//                         const SmallCircle(),
//                         Gap(Get.height * 0.01),
//                         CustomText(
//                           title: item.time,
//                           color: AppColor().lightItemsColor,
//                           textAlign: TextAlign.start,
//                           fontFamily: 'Inter',
//                           size: 14,
//                         ),
//                       ],
//                     )
//                   ] else ...[
//                     SizedBox(
//                       height: 40,
//                       child: ListView.separated(
//                         padding: EdgeInsets.zero,
//                         physics: const ScrollPhysics(),
//                         scrollDirection: Axis.horizontal,
//                         shrinkWrap: true,
//                         itemCount: item.likeImages!.length,
//                         separatorBuilder: (context, index) => Gap(10),
//                         itemBuilder: (context, index) {
//                           var images = item.likeImages![index];
//                           return Image.asset(
//                             images,
//                             height: 30,
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                   Gap(Get.height * 0.01),
//                   CustomText(
//                     title: item.likeDetails,
//                     color:
//                         (item.subType == 'comment' || item.subType == 'tagged')
//                             ? AppColor().lightItemsColor
//                             : AppColor().primaryWhite,
//                     textAlign: TextAlign.start,
//                     fontFamily: 'Inter',
//                     size: 14,
//                   ),
//                   Gap(Get.height * 0.01),
//                   Text.rich(
//                     TextSpan(
//                       text: item.details,
//                       style: TextStyle(
//                         color: AppColor().lightItemsColor,
//                         fontFamily: 'Inter',
//                         fontSize: 14,
//                       ),
//                       children: <TextSpan>[
//                         TextSpan(
//                             text: item.link,
//                             style: TextStyle(
//                                 color: AppColor().primaryColor,
//                                 decoration: TextDecoration.underline),
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = () {
//                                 // open link here
//                               }),
//                       ],
//                     ),
//                   ),
//                 ] else if (item.type == 'tournament') ...[
//                   CustomText(
//                     title: item.infoTag,
//                     color: AppColor().primaryWhite,
//                     textAlign: TextAlign.start,
//                     fontFamily: 'Inter',
//                     size: 14,
//                   ),
//                   Gap(Get.height * 0.02),
//                   SizedBox(
//                     height: Get.height * 0.14,
//                     child: ListView.separated(
//                       padding: EdgeInsets.zero,
//                       physics: const ScrollPhysics(),
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       itemCount: item.likeImages!.length,
//                       separatorBuilder: (context, index) =>
//                           Gap(Get.height * 0.01),
//                       itemBuilder: (context, index) {
//                         var images = item.likeImages![index];
//                         return Image.asset(
//                           images,
//                         );
//                       },
//                     ),
//                   ),
//                 ] else ...[
//                   CustomText(
//                     title: item.infoTag,
//                     color: AppColor().primaryWhite,
//                     textAlign: TextAlign.start,
//                     fontFamily: 'Inter',
//                     size: 14,
//                   ),
//                   Gap(Get.height * 0.005),
//                   CustomText(
//                     title: item.details,
//                     color: AppColor().primaryWhite,
//                     textAlign: TextAlign.start,
//                     fontFamily: 'Inter',
//                     size: 14,
//                   ),
//                   CustomText(
//                     title: item.likeDetails,
//                     color: AppColor().lightItemsColor,
//                     textAlign: TextAlign.start,
//                     fontFamily: 'Inter',
//                     size: 12,
//                   ),
//                   CustomText(
//                     title: item.link,
//                     color: AppColor().primaryColor,
//                     textAlign: TextAlign.start,
//                     fontFamily: 'Inter',
//                     size: 14,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           if (item.type == 'post')
//             IconButton(
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//               onPressed: () {},
//               icon: Icon(
//                 Icons.more_vert,
//                 color: AppColor().lightItemsColor,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
