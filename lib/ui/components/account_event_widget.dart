import 'package:e_sport/data/model/account_events_model.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountEventsWidget extends StatefulWidget {
  const AccountEventsWidget({
    super.key,
  });

  @override
  State<AccountEventsWidget> createState() => _AccountEventsWidgetState();
}

class _AccountEventsWidgetState extends State<AccountEventsWidget> {
  final eventController = Get.put(EventRepository());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.separated(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: eventController.allEvent.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.02),
        itemBuilder: (context, index) {
          var item = eventController.allEvent[index];
          return InkWell(
            onTap: () {
              // Get.to(
              //   () => PostDetails(
              //     item: item,
              //   ),
              // );
            },
            child: AccountEventsItem(item: item),
          );
        },
      );
    });
  }
}
