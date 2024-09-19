import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/components/account_tournament_detail.dart';
import 'package:e_sport/ui/events/components/social_event_details.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AllEventList extends StatefulWidget {
  const AllEventList({super.key, this.eventList});
  final List<EventModel>? eventList;

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
                if ((widget.eventList ?? eventController.allEvent)
                        .reversed
                        .toList()[index]
                        .type ==
                    "tournament") {
                  Get.to(() => AccountTournamentDetail(
                      item: (widget.eventList ?? eventController.allEvent)
                          .reversed
                          .toList()[index]));
                } else {
                  Get.to(() => SocialEventDetails(
                      item: (widget.eventList ?? eventController.allEvent)
                          .reversed
                          .toList()[index]));
                }
              },
              child: AccountEventsItem(
                  item: (widget.eventList ?? eventController.allEvent)
                      .reversed
                      .toList()[index])),
          separatorBuilder: (context, index) => Gap(Get.height * 0.02),
          itemCount: (widget.eventList ?? eventController.allEvent).length),
    );
  }
}
