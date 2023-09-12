import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
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
                SizedBox(
                  height: Get.height * 0.05,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: item.likeImages!.length,
                    separatorBuilder: (context, index) => Divider(),
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
                Gap(Get.height * 0.01),
                CustomText(
                  title: item.likeDetails,
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.start,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.016,
                ),
                Gap(Get.height * 0.01),
                CustomText(
                  title: item.details,
                  color: AppColor().lightItemsColor,
                  textAlign: TextAlign.start,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.016,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
