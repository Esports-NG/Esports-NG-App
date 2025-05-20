import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/screens/account/events/account_events_item.dart';
import 'package:e_sport/ui/screens/event/social_event_details.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../screens/event/account_tournament_detail.dart';
import '../../screens/extra/no_item_page.dart';

class AccountEventsWidget extends StatefulWidget {
  const AccountEventsWidget({
    super.key,
  });

  @override
  State<AccountEventsWidget> createState() => _AccountEventsWidgetState();
}

class _AccountEventsWidgetState extends State<AccountEventsWidget> {
  final eventController = Get.put(EventRepository());
  final authController = Get.put(AuthRepository());

  Future fetchCreatedEvents() async {
    await eventController.getCreatedEvents();
  }

  @override
  void initState() {
    fetchCreatedEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.separated(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: eventController.myEvent.value.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.02),
        itemBuilder: (context, index) {
          var item = eventController.myEvent.value[index];
          return InkWell(
            onTap: () {
              if (eventController.myEvent.value[index].type == "tournament") {
                Get.to(() => AccountTournamentDetail(
                    item: eventController.myEvent.value[index]));
              } else {
                Get.to(() => SocialEventDetails(
                    item: eventController.myEvent.value[index]));
              }
            },
            child: AccountEventsItem(item: item),
          );
        },
      );
    });
  }
}
