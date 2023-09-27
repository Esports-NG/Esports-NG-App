import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostDetails extends StatelessWidget {
  final Posts item;
  const PostDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppColor().primaryBgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        item.pImage!,
                        height: Get.height * 0.05,
                        width: Get.height * 0.05,
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
                    ],
                  ),
                  CustomFillButton(
                    buttonText: 'Follow',
                    fontWeight: FontWeight.w600,
                    textSize: Get.height * 0.016,
                    width: Get.width * 0.3,
                    height: Get.height * 0.04,
                    onTap: () {},
                    isLoading: false,
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
              Gap(Get.height * 0.015),
              CustomText(
                title: 'New quest unlocked!',
                size: Get.height * 0.018,
                fontFamily: 'GilroyBold',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.015),
              CustomText(
                title:
                    'Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain by finding the missing keys from the locked tower at the highest mountain.\n\nGet a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain by finding the missing keys from the locked tower. https://nexalgamingcommunity.com/',
                size: Get.height * 0.015,
                fontFamily: 'GilroyRegular',
                weight: FontWeight.w500,
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.015),
              Stack(
                children: [
                  Container(
                    height: Get.height * 0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(
                            item.image!,
                          ),
                          fit: BoxFit.cover,
                        )),
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
                                  color:
                                      AppColor().primaryColor.withOpacity(0.05),
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
              Gap(Get.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    title: '08/08/23  .  12:34pm',
                    size: Get.height * 0.014,
                    fontFamily: 'GilroyMedium',
                    textAlign: TextAlign.start,
                    color: AppColor().primaryWhite,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            title: item.views!,
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyBold',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                          Gap(Get.height * 0.005),
                          CustomText(
                            title: 'Views',
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyRegular',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                        ],
                      ),
                      Gap(Get.height * 0.01),
                      Row(
                        children: [
                          CustomText(
                            title: item.repost!,
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyBold',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                          Gap(Get.height * 0.005),
                          CustomText(
                            title: 'Repost',
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyRegular',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                        ],
                      ),
                      Gap(Get.height * 0.01),
                      Row(
                        children: [
                          CustomText(
                            title: item.likes!,
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyBold',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                          Gap(Get.height * 0.005),
                          CustomText(
                            title: 'Likes',
                            size: Get.height * 0.014,
                            fontFamily: 'GilroyRegular',
                            textAlign: TextAlign.start,
                            color: AppColor().primaryWhite,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                thickness: 0.4,
                color: AppColor().lightItemsColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.favorite_outline,
                      color: AppColor().primaryWhite,
                      size: Get.height * 0.03,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.autorenew_outlined,
                      color: AppColor().primaryWhite,
                      size: Get.height * 0.03,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.sms_outlined,
                      color: AppColor().primaryWhite,
                      size: Get.height * 0.03,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: AppColor().primaryWhite,
                      size: Get.height * 0.03,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Divider(
                thickness: 0.4,
                color: AppColor().lightItemsColor,
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Comments',
                size: Get.height * 0.018,
                fontFamily: 'GilroyBold',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.02),
              commentItem(
                comment: 'i`m here for it!\ni`m here for it!!',
                like: '1 Like',
                icon: Icons.favorite,
              ),
              Gap(Get.height * 0.01),
              commentItem(
                comment:
                    'I think the part where the snake crossed the narrow scene has a glitch. Is anybody else experiencing this?',
                like: 'Like',
                icon: Icons.favorite_outline,
              )
            ],
          ),
        ),
      ),
    );
  }

  Row commentItem({String? comment, like, IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: Get.height * 0.05,
            width: Get.height * 0.05,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    item.image!,
                  ),
                  fit: BoxFit.cover,
                )),
          ),
        ),
        Gap(Get.height * 0.01),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: 'Southpark #2234',
                size: Get.height * 0.014,
                fontFamily: 'GilroyRegular',
                textAlign: TextAlign.start,
                color: AppColor().lightItemsColor,
              ),
              Gap(Get.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomText(
                      title: comment,
                      size: Get.height * 0.016,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ),
                  Gap(Get.height * 0.01),
                  IconButton(
                    alignment: Alignment.bottomRight,
                    icon: Icon(
                      icon,
                      color: AppColor().primaryColor,
                      size: Get.height * 0.02,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              Gap(Get.height * 0.01),
              Row(
                children: [
                  CustomText(
                    title: like,
                    size: Get.height * 0.012,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'Reply',
                    size: Get.height * 0.012,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  CustomText(
                    title: 'Repost',
                    size: Get.height * 0.012,
                    fontFamily: 'GilroyRegular',
                    textAlign: TextAlign.start,
                    color: AppColor().lightItemsColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
