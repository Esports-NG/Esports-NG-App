import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/components/account_tournament_detail.dart';
import 'package:e_sport/ui/events/components/social_event_details.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EventsSearch extends StatefulWidget {
  const EventsSearch({super.key});

  @override
  State<EventsSearch> createState() => _EventsSearchState();
}

class _EventsSearchState extends State<EventsSearch> {
  final eventController = Get.put(EventRepository());
  final authController = Get.put(AuthRepository());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Container(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: authController.searchLoading.value
              ? const Center(
                  child: ButtonLoader(),
                )
              : eventController.searchedEvents.isEmpty
                  ? Center(
                      child: CustomText(
                        title: "No event found.",
                        color: AppColor().primaryWhite,
                      ),
                    )
                  : Column(
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  if (eventController
                                          .searchedEvents[index].type ==
                                      "tournament") {
                                    Get.to(() => AccountTournamentDetail(
                                        item: eventController
                                            .searchedEvents[index]));
                                  } else {
                                    Get.to(() => SocialEventDetails(
                                        item: eventController
                                            .searchedEvents[index]));
                                  }
                                },
                                child: AccountEventsItem(
                                    item:
                                        eventController.searchedEvents[index])),
                            separatorBuilder: (context, index) =>
                                Gap(Get.height * 0.02),
                            itemCount: eventController.searchedEvents.length)
                      ],
                    ),
        ),
      ),
    );
  }
}
