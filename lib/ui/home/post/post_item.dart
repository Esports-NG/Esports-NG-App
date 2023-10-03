import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostItem extends StatelessWidget {
  final Posts item;
  const PostItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor().bgDark,
            AppColor().primaryBgColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().lightItemsColor,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      item.pImage!,
                      height: Get.height * 0.025,
                      width: Get.height * 0.025,
                    ),
                    Gap(Get.height * 0.01),
                    CustomText(
                      title: item.name!.toUpperCase(),
                      size: Get.height * 0.015,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: item.uName!.toUpperFirstCase(),
                      size: Get.height * 0.015,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: '|  ${item.time!.toSentenceCase()}',
                      size: Get.height * 0.015,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                  ],
                ),
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColor().primaryMenu,
                  offset: const Offset(0, -10),
                  onSelected: (value) {
                    // if value 1 show dialog
                    if (value == 1) {
                      // _showDialog(context);
                      // if value 2 show dialog
                    } else if (value == 2) {
                      // _showDialog(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      height: 20,
                      padding:
                          const EdgeInsets.only(bottom: 20, left: 20, top: 20),
                      child: popUpMenuItems(
                          icon: Icons.bookmark_outline, title: 'Bookmark'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.thumb_down_alt_outlined,
                          title: 'Not interested in this post'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.person_add_alt_outlined,
                          title: 'Follow/Unfollow User'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.notifications_off_outlined,
                          title: 'Turn on/Turn off Notifications'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.volume_off_outlined,
                          title: 'Mute/Unmute User'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.block_outlined, title: 'Block User'),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: popUpMenuItems(
                          icon: Icons.flag, title: 'Report Post'),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: AppColor().primaryWhite,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CustomText(
              title: item.details!.toUpperFirstCase(),
              size: Get.height * 0.015,
              fontFamily: 'GilroyBold',
              textAlign: TextAlign.start,
              color: AppColor().primaryWhite,
            ),
          ),
          Gap(Get.height * 0.015),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                item.image!,
                height: Get.height * 0.25,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                left: Get.height * 0.02,
                bottom: Get.height * 0.02,
                top: Get.height * 0.19,
                child: SizedBox(
                  height: Get.height * 0.03,
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: item.genre!.length,
                      separatorBuilder: (context, index) =>
                          Gap(Get.height * 0.01),
                      itemBuilder: (context, index) {
                        var items = item.genre![index];
                        return Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColor().primaryDark.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColor().primaryColor.withOpacity(0.05),
                              width: 0.5,
                            ),
                          ),
                          child: Center(
                            child: CustomText(
                              title: '# $items',
                              color: AppColor().primaryWhite,
                              textAlign: TextAlign.center,
                              size: Get.height * 0.014,
                              fontFamily: 'GilroyBold',
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColor().primaryMenu,
                  offset: const Offset(0, -10),
                  onSelected: (value) {
                    // if value 1 show dialog
                    if (value == 1) {
                      // _showDialog(context);
                      // if value 2 show dialog
                    } else if (value == 2) {
                      // _showDialog(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      height: 20,
                      padding:
                          const EdgeInsets.only(bottom: 20, left: 20, top: 20),
                      child: CustomText(
                        title: 'Like, Comment and Repost as:',
                        size: Get.height * 0.014,
                        fontFamily: 'GilroyBold',
                        textAlign: TextAlign.start,
                        color: AppColor().primaryWhite,
                      ),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/png/account.png',
                            height: Get.height * 0.02,
                            width: Get.height * 0.02,
                          ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'Paula Bakare',
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyMedium',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      height: 20,
                      padding: const EdgeInsets.only(bottom: 20, left: 20),
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
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyMedium',
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
                      Image.asset(
                        'assets/images/png/drop.png',
                        height: Get.height * 0.02,
                        width: Get.height * 0.02,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.025,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite_outline,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.025,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: '${item.likes!} likes',
                      size: Get.height * 0.014,
                      fontFamily: 'GilroyBold',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.sms_outlined,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.025,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: item.comment!,
                      size: Get.height * 0.014,
                      fontFamily: 'GilroyBold',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.share_outlined,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.025,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: 'Share',
                      size: Get.height * 0.014,
                      fontFamily: 'GilroyBold',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row popUpMenuItems({String? title, IconData? icon}) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColor().primaryWhite,
          size: Get.height * 0.016,
        ),
        Gap(Get.height * 0.02),
        CustomText(
          title: title,
          size: Get.height * 0.014,
          fontFamily: 'GilroyMedium',
          textAlign: TextAlign.start,
          color: AppColor().primaryWhite,
        ),
      ],
    );
  }
}
