import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Posts extends StatelessWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: post.length,
        separatorBuilder: (context, index) => Divider(
          color: AppColor().lightItemsColor.withOpacity(0.2),
          height: Get.height * 0.05,
          thickness: 0.5,
        ),
        itemBuilder: (context, index) {
          var item = post[index];
          return InkWell(
            onTap: () {
              // Get.to(
              //   () => PostDetails(
              //     item: item,
              //   ),
              // );
            },
            child: PostItems(item: item),
          );
        },
      ),
    );
  }
}

class PostItems extends StatelessWidget {
  final NotificationModel item;
  const PostItems({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Center(
                  child: SvgPicture.asset('assets/images/svg/bell.svg'))),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      title: item.likeDetails,
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
              ],
            ),
          ),
          Gap(Get.height * 0.02),
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
