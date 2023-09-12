import 'package:e_sport/data/model/post_model.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBgColor,
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
                    SvgPicture.asset(
                      'assets/images/svg/chat.svg',
                      height: Get.height * 0.025,
                    ),
                    Gap(Get.height * 0.04),
                    SvgPicture.asset(
                      'assets/images/svg/chart.svg',
                      height: Get.height * 0.025,
                    ),
                    Gap(Get.height * 0.04),
                    InkWell(
                      onTap: () {
                        Get.to(() => const NotificationPage());
                      },
                      child: SvgPicture.asset(
                        'assets/images/svg/notification.svg',
                        height: Get.height * 0.025,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(Get.height * 0.03),
            CustomTextField(
              hint: "Search for gaming news, competitions...",
              fontFamily: 'GilroyMedium',
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: AppColor().lightItemsColor,
              ),
              // textEditingController: authController.emailController,
              onChanged: (text) {},
            ),
            Gap(Get.height * 0.03),
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
