import 'package:e_sport/data/model/notification_model.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: events.length,
        separatorBuilder: (context, index) => Divider(
          color: AppColor().lightItemsColor.withOpacity(0.3),
          height: Get.height * 0.05,
          thickness: 0.5,
        ),
        itemBuilder: (context, index) {
          var item = events[index];
          return InkWell(
            onTap: () {
              // Get.to(
              //   () => PostDetails(
              //     item: item,
              //   ),
              // );
            },
            child: EventsItem(item: item),
          );
        },
      ),
    );
  }
}

class EventsItem extends StatelessWidget {
  final NotificationModel item;
  const EventsItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Center(child: Image.asset(item.profileImage!))),
          Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: item.infoTag,
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.start,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.016,
                  ),
                  item.type == 'event'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(Get.height * 0.005),
                            CustomText(
                              title: item.details,
                              color: AppColor().primaryWhite,
                              textAlign: TextAlign.start,
                              fontFamily: 'GilroyRegular',
                              size: Get.height * 0.016,
                            ),
                          ],
                        )
                      : Container(),
                  CustomText(
                    title: item.likeDetails,
                    color: AppColor().lightItemsColor,
                    textAlign: TextAlign.start,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.016,
                  ),
                  CustomText(
                    title: item.link,
                    color: AppColor().primaryColor,
                    textAlign: TextAlign.start,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.016,
                  ),
                ],
              )),
          Gap(Get.height * 0.005),
          (item.type == 'events')
              ? IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColor().lightItemsColor,
                  ))
              : Container()
        ],
      ),
    );
  }
}
