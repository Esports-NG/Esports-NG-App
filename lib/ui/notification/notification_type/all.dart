import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AllNotification extends StatelessWidget {
  const AllNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: all.length,
          separatorBuilder: (context, index) => Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.05,
            thickness: 0.5,
          ),
          itemBuilder: (context, index) {
            var item = all[index];
            return InkWell(
              onTap: () {
                // Get.to(
                //   () => PostDetails(
                //     item: item,
                //   ),
                // );
              },
              child: PersonalItem(item: item),
            );
          },
        ),
      ),
    );
  }
}

class PersonalItem extends StatelessWidget {
  final NotificationModel item;
  const PersonalItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: item.type == 'tournament' ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
                height: Get.height * 0.05,
                width: Get.height * 0.05,
                child: Center(child: Image.asset(item.profileImage!))),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.type == 'post') ...[
                  Row(
                    children: [
                      CustomText(
                        title: '${item.likeDetails} ',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.start,
                        fontFamily: 'GilroyRegular',
                        size: Get.height * 0.016,
                      ),
                      Gap(Get.height * 0.01),
                      const SmallCircle(),
                      Gap(Get.height * 0.01),
                      CustomText(
                        title: item.time,
                        color: AppColor().lightItemsColor,
                        textAlign: TextAlign.start,
                        fontFamily: 'GilroyRegular',
                        size: Get.height * 0.016,
                      ),
                    ],
                  ),
                  Gap(Get.height * 0.01),
                  Text.rich(
                    TextSpan(
                      text: item.details,
                      style: TextStyle(
                        color: AppColor().lightItemsColor,
                        fontFamily: 'GilroyRegular',
                        fontSize: Get.height * 0.016,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: item.link,
                            style: TextStyle(
                                color: AppColor().primaryColor,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // open link here
                              }),
                      ],
                    ),
                  ),
                ] else if (item.type == 'personal') ...[
                  if (item.subType == 'comment' ||
                      item.subType == 'tagged') ...[
                    Row(
                      children: [
                        CustomText(
                          title: '${item.infoName} ',
                          color: AppColor().primaryWhite,
                          textAlign: TextAlign.start,
                          fontFamily: 'GilroyRegular',
                          size: Get.height * 0.016,
                        ),
                        CustomText(
                          title: item.infoTag,
                          color: AppColor().lightItemsColor,
                          textAlign: TextAlign.start,
                          fontFamily: 'GilroyRegular',
                          size: Get.height * 0.016,
                        ),
                        Gap(Get.height * 0.01),
                        const SmallCircle(),
                        Gap(Get.height * 0.01),
                        CustomText(
                          title: item.time,
                          color: AppColor().lightItemsColor,
                          textAlign: TextAlign.start,
                          fontFamily: 'GilroyRegular',
                          size: Get.height * 0.016,
                        ),
                      ],
                    )
                  ] else ...[
                    SizedBox(
                      height: Get.height * 0.05,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: item.likeImages!.length,
                        separatorBuilder: (context, index) =>
                            Gap(Get.height * 0.001),
                        itemBuilder: (context, index) {
                          var images = item.likeImages![index];
                          return Image.asset(
                            images,
                            height: Get.height * 0.05,
                            width: Get.height * 0.05,
                          );
                        },
                      ),
                    ),
                  ],
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: item.likeDetails,
                    color:
                        (item.subType == 'comment' || item.subType == 'tagged')
                            ? AppColor().lightItemsColor
                            : AppColor().primaryWhite,
                    textAlign: TextAlign.start,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.016,
                  ),
                  Gap(Get.height * 0.01),
                  Text.rich(
                    TextSpan(
                      text: item.details,
                      style: TextStyle(
                        color: AppColor().lightItemsColor,
                        fontFamily: 'GilroyRegular',
                        fontSize: Get.height * 0.016,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: item.link,
                            style: TextStyle(
                                color: AppColor().primaryColor,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // open link here
                              }),
                      ],
                    ),
                  ),
                ] else if (item.type == 'tournament') ...[
                  CustomText(
                    title: item.infoTag,
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.start,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.016,
                  ),
                  Gap(Get.height * 0.02),
                  SizedBox(
                    height: Get.height * 0.14,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: item.likeImages!.length,
                      separatorBuilder: (context, index) =>
                          Gap(Get.height * 0.01),
                      itemBuilder: (context, index) {
                        var images = item.likeImages![index];
                        return Image.asset(
                          images,
                        );
                      },
                    ),
                  ),
                ] else ...[
                  CustomText(
                    title: item.infoTag,
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.start,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.016,
                  ),
                  Gap(Get.height * 0.005),
                  CustomText(
                    title: item.details,
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.start,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.016,
                  ),
                  CustomText(
                    title: item.likeDetails,
                    color: AppColor().lightItemsColor,
                    textAlign: TextAlign.start,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.016,
                  ),
                  CustomText(
                    title: item.link,
                    color: AppColor().primaryColor,
                    textAlign: TextAlign.start,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.016,
                  ),
                ],
              ],
            ),
          ),
          if (item.type == 'post')
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: AppColor().lightItemsColor,
              ),
            ),
        ],
      ),
    );
  }
}
