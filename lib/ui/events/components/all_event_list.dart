import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/components/account_tournament_detail.dart';
import 'package:e_sport/ui/events/components/social_event_details.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AllEventList extends StatefulWidget {
  const AllEventList({super.key});

  @override
  State<AllEventList> createState() => _AllEventListState();
}

class _AllEventListState extends State<AllEventList> {
  var eventController = Get.put(EventRepository());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => InkWell(
              onTap: () {
                if (eventController.filteredEvent[index].type == "tournament") {
                  Get.to(() => AccountTournamentDetail(
                      item: eventController.filteredEvent[index]));
                } else {
                  Get.to(() => SocialEventDetails(
                      item: eventController.filteredEvent[index]));
                }
              },
              child: AccountEventsItem(
                  item: eventController.filteredEvent[index])),
          separatorBuilder: (context, index) => Gap(Get.height * 0.02),
          itemCount: eventController.filteredEvent.length),
    );
  }
}
