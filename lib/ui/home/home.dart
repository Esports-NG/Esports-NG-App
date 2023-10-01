import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/messages/messages.dart';
import 'package:e_sport/ui/notification/notification.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'post/post_details.dart';
import 'post/post_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? categoryType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Gap(Get.height * 0.05),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/png/account.png',
                      height: Get.height * 0.05,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => const Messages());
                      },
                      child: Badge(
                        label: CustomText(
                          title: '4',
                          weight: FontWeight.w500,
                          size: 10,
                          fontFamily: 'GilroyBold',
                          color: AppColor().primaryWhite,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/svg/chat.svg',
                          height: Get.height * 0.025,
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.04),
                    SvgPicture.asset(
                      'assets/images/svg/leaderboard.svg',
                      height: Get.height * 0.025,
                    ),
                    Gap(Get.height * 0.04),
                    InkWell(
                      onTap: () {
                        Get.to(() => const NotificationPage());
                      },
                      child: Badge(
                        label: CustomText(
                          title: '10',
                          weight: FontWeight.w500,
                          size: 10,
                          fontFamily: 'GilroyBold',
                          color: AppColor().primaryWhite,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/svg/notification.svg',
                          height: Get.height * 0.025,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(Get.height * 0.03),
            SizedBox(
              height: Get.height * 0.06,
              child: CustomTextField(
                hint: "Search for gaming news, competitions...",
                fontFamily: 'GilroyMedium',
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: AppColor().lightItemsColor,
                ),
                // textEditingController: authController.emailController,
                onChanged: (text) {},
              ),
            ),
            Gap(Get.height * 0.03),
            SizedBox(
              height: Get.height * 0.045,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const ScrollPhysics(),
                shrinkWrap: false,
                itemCount: categoryItem.length,
                separatorBuilder: (context, index) => Gap(Get.height * 0.03),
                itemBuilder: (context, index) {
                  var item = categoryItem[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        categoryType = index;
                      });
                    },
                    child: Center(
                      child: Column(
                        children: [
                          CustomText(
                            title: item.title,
                            size: 13,
                            fontFamily: categoryType == index
                                ? 'GilroyBold'
                                : 'GilroyRegular',
                            weight: FontWeight.w400,
                            textAlign: TextAlign.start,
                            color: categoryType == index
                                ? AppColor().primaryColor
                                : AppColor().lightItemsColor,
                          ),
                          Gap(Get.height * 0.01),
                          Container(
                            width: Get.height * 0.1,
                            height: 1.5,
                            color: categoryType == index
                                ? AppColor().primaryColor
                                : AppColor().primaryBackGroundColor,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Gap(Get.height * 0.02),
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: postItem.length,
              separatorBuilder: (context, index) => Gap(Get.height * 0.02),
              itemBuilder: (context, index) {
                var item = postItem[index];
                return InkWell(
                  onTap: () {
                    Get.to(
                      () => PostDetails(
                        item: item,
                      ),
                    );
                  },
                  child: PostItem(item: item),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
