import 'package:e_sport/data/model/message_model.dart';
import 'package:e_sport/ui/messages/request.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'chats_item.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => const DMRequest());
              },
              child: Container(
                color: AppColor().primaryLightColor,
                padding: EdgeInsets.all(Get.height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: '4 Requests',
                      weight: FontWeight.w500,
                      size: 14,
                      fontFamily: 'GilroyMedium',
                      color: AppColor().primaryColor,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColor().primaryColor,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            Gap(Get.height * 0.02),
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: chats.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColor().lightItemsColor.withOpacity(0.2),
                height: Get.height * 0.05,
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                var item = chats[index];
                return InkWell(
                  onTap: () {
                    // Get.to(
                    //   () => PostDetails(
                    //     item: item,
                    //   ),
                    // );
                  },
                  child: ChatsItem(item: item),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
