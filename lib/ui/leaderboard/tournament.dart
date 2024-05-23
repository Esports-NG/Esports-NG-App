import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Tournament extends StatelessWidget {
  const Tournament({super.key});

  @override
  Widget build(BuildContext context) {
    final eventController = Get.put(EventRepository());
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: GoBackButton(onPressed: () => Get.back()),
          title: CustomText(
            title: 'Tournament',
            fontFamily: 'GilroySemiBold',
            size: 18,
            color: AppColor().primaryWhite,
          ),
        ),
        backgroundColor: AppColor().primaryBackGroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/png/lImage1.png',
                      height: Get.height * 0.05,
                    ),
                    Gap(Get.height * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: "Call of Duty Mobile",
                          color: AppColor().primaryWhite,
                          fontFamily: "GilroySemiBold",
                          size: 18,
                        ),
                        const Gap(5),
                        Row(
                          children: [
                            CustomText(
                              title: "MP MODE",
                              size: 16,
                              color: AppColor().greySix,
                            ),
                            Gap(Get.height * 0.01),
                            const SmallCircle(
                              size: 5,
                            ),
                            Gap(Get.height * 0.01),
                            CustomText(
                              title: "Arcade",
                              color: AppColor().greySix,
                              size: 16,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
                Divider(
                  height: 50,
                  thickness: 0.5,
                  color: AppColor().greyEight,
                ),
                Row(
                  children: [
                    CustomText(
                      title: "Teams Ranking",
                      color: AppColor().primaryWhite,
                      fontFamily: "GilroySemiBold",
                      size: 18,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor().greySix),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          CustomText(
                            title: "Tier 1",
                            color: AppColor().primaryWhite,
                            fontFamily: "GilroyMedium",
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColor().primaryColor,
                          )
                        ],
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor().greySix),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          CustomText(
                            title: "2024",
                            color: AppColor().primaryWhite,
                            fontFamily: "GilroyMedium",
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColor().primaryColor,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Gap(Get.height * 0.02),
                ListView.separated(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: eventController.allEvent.length,
                    separatorBuilder: (context, index) =>
                        Gap(Get.height * 0.02),
                    itemBuilder: (context, index) {
                      var item = eventController.allEvent[index];
                      return InkWell(child: AccountEventsItem(item: item));
                    })
              ],
            ),
          ),
        ));
  }
}
