import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/events/components/social_event_details.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SocialEventsList extends StatefulWidget {
  const SocialEventsList({super.key});

  @override
  State<SocialEventsList> createState() => _SocialEventsListState();
}

class _SocialEventsListState extends State<SocialEventsList> {
  var eventController = Get.put(EventRepository());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => InkWell(
              onTap: () {
                Get.to(() => SocialEventDetails(
                    item: eventController.allSocialEvent[index]));
              },
              child:
                  AccountEventsItem(item: eventController.allSocialEvent[index])),
          separatorBuilder: (context, index) => Gap(Get.height * 0.02),
          itemCount: eventController.allSocialEvent.length),
    );
  }
}
