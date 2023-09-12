import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Personal extends StatelessWidget {
  const Personal({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: personal.length,
        separatorBuilder: (context, index) => Divider(
          color: AppColor().lightItemsColor.withOpacity(0.2),
          height: Get.height * 0.05,
          thickness: 0.5,
        ),
        itemBuilder: (context, index) {
          var item = personal[index];
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
    );
  }
}

class PersonalItem extends StatelessWidget {
  final NotificationModel item;
  const PersonalItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: Get.height * 0.05,
              width: Get.height * 0.05,
              child: Center(child: Image.asset(item.profileImage!))),
          Gap(Get.height * 0.01),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (item.type == 'comment' || item.type == 'tagged')
                    ? Row(
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
                    : SizedBox(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(Get.height * 0.01),
                    CustomText(
                      title: item.likeDetails,
                      color: (item.type == 'comment' || item.type == 'tagged')
                          ? AppColor().lightItemsColor
                          : AppColor().primaryWhite,
                      textAlign: TextAlign.start,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.016,
                    ),
                  ],
                ),
                Gap(Get.height * 0.01),
                item.type == 'follow'
                    ? Container()
                    : Text.rich(
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
              ],
            ),
          ),
          (item.type == 'comment' || item.type == 'tagged')
              ? IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColor().lightItemsColor,
                  ))
              : Container()
        ],
      ),
    );
  }
}
