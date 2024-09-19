import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/events/components/all_event_list.dart';
import 'package:e_sport/ui/events/components/event_filter_dropdown.dart';
import 'package:e_sport/ui/events/components/event_game_filter.dart';
import 'package:e_sport/ui/events/components/social_events_list.dart';
import 'package:e_sport/ui/events/components/tournament_list.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EventTab extends StatefulWidget {
  const EventTab({super.key, this.eventList});
  final List<EventModel>? eventList;

  @override
  State<EventTab> createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  final eventController = Get.find<EventRepository>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: Column(children: [
          Row(
            children: [
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: "Type",
                    color: AppColor().greyFour,
                  ),
                  Gap(Get.height * 0.005),
                  EventFilter(
                      title: "Type", values: eventController.typeFilterList),
                ],
              )),
              const Gap(15),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: "Status",
                    color: AppColor().greyFour,
                  ),
                  Gap(Get.height * 0.005),
                  EventFilter(
                      title: "Status",
                      values: eventController.statusFilterList),
                ],
              )),
              const Gap(15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Game",
                      color: AppColor().greyFour,
                    ),
                    Gap(Get.height * 0.005),
                    const EventGameFilter(),
                  ],
                ),
              )
            ],
          ),
          Gap(Get.height * 0.02),
          eventController.isFiltering.value
              ? Container(
                  margin: EdgeInsets.only(top: Get.height * 0.04),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColor().primaryColor,
                      strokeWidth: 3,
                    ),
                  ),
                )
              : eventController.typeFilter.value == "All"
                  ? AllEventList(
                      eventList: widget.eventList,
                    )
                  : eventController.typeFilter.value == "Tournament"
                      ? const TournamentList()
                      : const SocialEventsList()
        ]),
      ),
    );
  }
}
