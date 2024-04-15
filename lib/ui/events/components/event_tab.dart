import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/components/account_tournament_detail.dart';
import 'package:e_sport/ui/events/components/event_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EventTab extends StatefulWidget {
  const EventTab({super.key, required this.events});

  final List<EventModel> events;

  @override
  State<EventTab> createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  final eventController = Get.find<EventRepository>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.height * 0.02),
      child: Column(children: [
        Row(
          children: [
            Flexible(
                child: EventFilter(
                    title: "Type", values: eventController.typeFilterList)),
            const Gap(15),
            Flexible(
                child: EventFilter(
                    title: "Status", values: eventController.statusFilterList)),
            const Gap(15),
            Flexible(
                child: EventFilter(
                    extreme: true,
                    title: "Game",
                    values: eventController.gameFilterList)),
          ],
        ),
        Gap(Get.height * 0.02),
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Get.to(() =>
                      AccountTournamentDetail(item: widget.events[index]));
                },
                child: AccountEventsItem(item: widget.events[index])),
            separatorBuilder: (context, index) => Gap(Get.height * 0.02),
            itemCount: widget.events.length),
      ]),
    );
  }
}
