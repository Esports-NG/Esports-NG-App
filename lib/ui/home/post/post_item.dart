import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
            AppColor().pureBlackColor,
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
                      'assets/images/png/photo.png',
                      height: Get.height * 0.025,
                      width: Get.height * 0.025,
                    ),
                    Gap(Get.height * 0.01),
                    CustomText(
                      title: item.name!.toUpperCase(),
                      size: Get.height * 0.014,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: item.uName!.toUpperFirstCase(),
                      size: Get.height * 0.014,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                    Gap(Get.height * 0.005),
                    CustomText(
                      title: '|  ${item.time!.toSentenceCase()}',
                      size: Get.height * 0.014,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().lightItemsColor,
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColor().primaryWhite,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CustomText(
              title: item.details!.toUpperFirstCase(),
              size: Get.height * 0.014,
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
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/png/drop.png',
                      height: Get.height * 0.02,
                      width: Get.height * 0.02,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.02,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite_outline,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.02,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
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
                        size: Get.height * 0.02,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
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
                    CustomText(
                      title: 'Share',
                      size: Get.height * 0.014,
                      fontFamily: 'GilroyBold',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share_outlined,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.02,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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
}
