import 'package:e_sport/data/model/message_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatsItem extends StatelessWidget {
  final MessageModel item;
  const ChatsItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(right: Get.height * 0.02, left: Get.height * 0.01),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: Get.height * 0.055,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage(item.userImage!))),
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
                  weight: FontWeight.w500,
                  fontFamily: 'GilroyMedium',
                  size: Get.height * 0.018,
                ),
                CustomText(
                  title: item.lastMessage,
                  weight: FontWeight.w500,
                  size: Get.height * 0.016,
                  fontFamily: 'GilroyMedium',
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
                  weight: FontWeight.w500,
                  fontFamily: 'GilroyMedium',
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
                            weight: FontWeight.w500,
                            size: Get.height * 0.016,
                            fontFamily: 'GilroyMedium',
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
