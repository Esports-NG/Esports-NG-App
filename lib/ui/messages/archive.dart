import 'package:e_sport/data/model/message_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'message_type/chats/chats_item.dart';

class Archives extends StatefulWidget {
  const Archives({super.key});

  @override
  State<Archives> createState() => _DMRequestState();
}

class _DMRequestState extends State<Archives> {
  final authController = Get.put(AuthRepository());
  int? longSelect;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          title: 'Archives',
          weight: FontWeight.w600,
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: AppColor().primaryWhite,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              // Get.to(() => const Messages());
            },
            child: Icon(
              Icons.more_vert,
              color: AppColor().primaryWhite,
            ),
          ),
          Gap(Get.height * 0.01),
        ],
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Column(
        children: [
          Gap(Get.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor().primaryLightColor,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(Get.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColor().primaryWhite,
                    size: 20,
                  ),
                  Gap(Get.height * 0.01),
                  Expanded(
                    child: CustomText(
                      title:
                          'The messages will remain archived even when new messages are received.',
                      weight: FontWeight.w500,
                      size: 14,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(Get.height * 0.02),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: chats.take(3).length,
            separatorBuilder: (context, index) => Divider(
              color: AppColor().lightItemsColor.withOpacity(0.2),
              height: Get.height * 0.05,
              thickness: 0.5,
            ),
            itemBuilder: (context, index) {
              var item = chats[index];
              return GestureDetector(
                onTap: () {
                  // Get.to(
                  //   () => PostDetails(
                  //     item: item,
                  //   ),
                  // );
                },
                onLongPress: () {
                  setState(() {
                    if (longSelect == index) {
                      longSelect = null;
                    } else {
                      longSelect = index;
                    }
                    authController.mOnSelect.value =
                        !authController.mOnSelect.value;
                  });
                },
                child: ChatsItem(item: item, index: index, count: longSelect),
              );
            },
          ),
        ],
      ),
    );
  }
}
