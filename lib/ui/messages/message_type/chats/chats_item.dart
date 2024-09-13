// ignore_for_file: prefer_const_constructors

import 'package:e_sport/data/model/message_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatsItem extends StatelessWidget {
  final MessageModel item;
  final int? index, count;
  const ChatsItem({
    super.key,
    required this.item,
    required this.index,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(right: Get.height * 0.02, left: Get.height * 0.01),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: Get.height * 0.06,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:
                          DecorationImage(image: AssetImage(item.userImage!))),
                ),
                if (count == index)
                  Positioned(
                    right: Get.height * 0.01,
                    child: Container(
                      padding: EdgeInsets.all(Get.height * 0.002),
                      decoration: BoxDecoration(
                          color: AppColor().primaryGreen,
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.done,
                        color: AppColor().primaryWhite,
                        size: Get.height * 0.018,
                      ),
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: item.userName,
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.start,
                  fontFamily: 'InterMedium',
                  size: Get.height * 0.018,
                ),
                CustomText(
                  title: item.lastMessage,
                  size: Get.height * 0.016,
                  fontFamily: 'InterMedium',
                  color: AppColor().lightItemsColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  title: item.time,
                  color: AppColor().lightItemsColor,
                  textAlign: TextAlign.start,
                  fontFamily: 'InterMedium',
                  size: Get.height * 0.018,
                ),
                Gap(Get.height * 0.005),
                item.newMessage == '0'
                    ? Container()
                    : Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor().primaryRed,
                        ),
                        child: Center(
                          child: CustomText(
                            title: item.newMessage,
                            size: Get.height * 0.016,
                            fontFamily: 'InterMedium',
                            color: AppColor().primaryWhite,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
