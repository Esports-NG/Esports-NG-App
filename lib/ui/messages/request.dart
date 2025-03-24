import 'package:e_sport/data/model/message_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'message_type/chats/chats_item.dart';

class DMRequest extends StatefulWidget {
  const DMRequest({super.key});

  @override
  State<DMRequest> createState() => _DMRequestState();
}

class _DMRequestState extends State<DMRequest> {
  final authController = Get.put(AuthRepository());
  int? longSelect;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          title: 'DM Request',
          fontFamily: "InterSemiBold",
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
                          'Messages here will remain un-read until you’ve accepted the request',
                      size: 14,
                      fontFamily: 'InterMedium',
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
            itemCount: chats.take(4).length,
            separatorBuilder: (context, index) => Divider(
              color: AppColor().lightItemsColor.withOpacity(0.2),
              height: Get.height * 0.05,
              thickness: 0.5,
            ),
            itemBuilder: (context, index) {
              var item = chats[index];
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => RequestOption(
                      item: item,
                    ),
                  );
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

class RequestOption extends StatelessWidget {
  final MessageModel item;
  const RequestOption({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      appBar: AppBar(
          backgroundColor: AppColor().primaryBackGroundColor,
          centerTitle: true,
          elevation: 0,
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
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: AppColor().primaryWhite,
              ),
            ),
            Gap(Get.height * 0.01),
          ],
          title: Row(
            children: [
              Container(
                height: Get.height * 0.06,
                width: Get.height * 0.06,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage(item.userImage!))),
              ),
              Gap(Get.height * 0.02),
              Column(
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
                    title: 'Last seen recently',
                    size: Get.height * 0.016,
                    fontFamily: 'InterMedium',
                    color: AppColor().lightItemsColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: AppColor().lightItemsColor.withOpacity(0.3),
            height: Get.height * 0.05,
            thickness: 0.5,
          ),
          Center(
            child: CustomText(
              title: 'Today',
              weight: FontWeight.w100,
              size: Get.height * 0.016,
              fontFamily: 'InterBold',
              color: AppColor().lightItemsColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gap(Get.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor().primaryLightColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(Get.height * 0.01),
                      topLeft: Radius.circular(Get.height * 0.015),
                      bottomLeft: Radius.circular(Get.height * 0.002),
                      bottomRight: Radius.circular(Get.height * 0.010))),
              padding: EdgeInsets.all(Get.height * 0.02),
              child: CustomText(
                title: 'Hi, How are you doing? ',
                weight: FontWeight.w100,
                size: Get.height * 0.018,
                fontFamily: 'InterMedium',
                color: AppColor().primaryWhite,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Gap(Get.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: CustomText(
              title: '02:30PM',
              weight: FontWeight.w100,
              size: Get.height * 0.016,
              fontFamily: 'Inter',
              color: AppColor().lightItemsColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Row(
              children: [
                CustomFillButton(
                  buttonText: 'Accept',
                  textSize: Get.height * 0.018,
                  width: Get.width / 2 - Get.height * 0.027,
                  onTap: () {
                    // Get.to(() => const RegisterScreen());
                  },
                  isLoading: false,
                ),
                const Spacer(),
                CustomFillButton(
                  buttonText: 'Reject',
                  textColor: AppColor().primaryColor,
                  buttonColor:
                      AppColor().primaryBackGroundColor.withOpacity(0.7),
                  textSize: Get.height * 0.018,
                  width: Get.width / 2 - Get.height * 0.027,
                  onTap: () {
                    // Get.to(() => const LoginScreen());
                  },
                  isLoading: false,
                ),
              ],
            ),
          ),
          Gap(Get.height * 0.04),
        ],
      ),
    );
  }
}
