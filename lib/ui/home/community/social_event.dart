import 'package:e_sport/data/model/account_events_model.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../events/components/social_event_item.dart';

class SocialEvent extends StatelessWidget {
  const SocialEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GoBackButton(onPressed: () => Get.back()),
        centerTitle: true,
        title: CustomText(
          title: 'Social Event',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ListView.separated(
              //     physics: const ScrollPhysics(),
              //     shrinkWrap: true,
              //     separatorBuilder: (context, index) => Gap(Get.height * 0.03),
              //     itemCount: socialEventItem.length,
              //     itemBuilder: (context, index) {
              //       var item = socialEventItem[index];
              //       return SocialEventItem(item: item);
              //     }),
            ],
          ),
        ),
      ),
    );
  }
}
