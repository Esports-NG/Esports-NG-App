import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/components/account_tournament_detail.dart';
import 'package:e_sport/ui/events/components/social_event_details.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FixtureList extends StatefulWidget {
  const FixtureList({super.key});

  @override
  State<FixtureList> createState() => _FixtureListState();
}

class _FixtureListState extends State<FixtureList> {
  var eventController = Get.put(EventRepository());
  final _colors = [
    LinearGradient(
      colors: [
        AppColor().fixturePurple,
        AppColor().fixturePurple,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    LinearGradient(
      colors: [
        AppColor().darkGrey.withOpacity(0.8),
        AppColor().bgDark.withOpacity(0.005),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomCenter,
    ),
  ];
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
              child: Container()),
          separatorBuilder: (context, index) => Gap(Get.height * 0.02),
          itemCount: eventController.filteredEvent.length),
    );
  }
}
