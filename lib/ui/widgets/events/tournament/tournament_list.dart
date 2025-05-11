import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/screens/account/events/account_events_item.dart';
import 'package:e_sport/ui/screens/event/account_tournament_detail.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentList extends StatefulWidget {
  const TournamentList({super.key});

  @override
  State<TournamentList> createState() => _TournamentListState();
}

class _TournamentListState extends State<TournamentList> {
  var eventController = Get.put(EventRepository());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => InkWell(
              onTap: () {
                Get.to(() => AccountTournamentDetail(
                    item: eventController.allTournaments[index]));
              },
              child: AccountEventsItem(
                  item: eventController.allTournaments[index])),
          separatorBuilder: (context, index) => Gap(Get.height * 0.02),
          itemCount: eventController.allTournaments.length),
    );
  }
}
