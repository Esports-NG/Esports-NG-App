import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/events/components/social_event_details.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'account_tournament_detail.dart';
import 'error_page.dart';
import 'no_item_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (eventController.myEventStatus.value == EventStatus.loading) {
        return const ButtonLoader();
      } else if (eventController.myEventStatus.value == EventStatus.available) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: eventController.allEvent.where((e)=> e.community!.owner!.id == authController.user!.id).toList().length,
          separatorBuilder: (context, index) => Gap(Get.height * 0.02),
          itemBuilder: (context, index) {
            var item = eventController.allEvent.where((e)=> e.community!.owner!.id == authController.user!.id).toList()[index];
            return InkWell(
              onTap: () {
                if (eventController.allEvent.where((e)=> e.community!.owner!.id == authController.user!.id).toList()[index].type == "tournament") {
                  Get.to(() => AccountTournamentDetail(
                      item: eventController.allEvent.where((e)=> e.community!.owner!.id == authController.user!.id).toList()[index]));
                } else {
                  Get.to(() =>
                      SocialEventDetails(item: eventController.allEvent.where((e)=> e.community!.owner!.id == authController.user!.id).toList()[index]));
                }
              },
              child: AccountEventsItem(item: item),
            );
          },
        );
      } else if (eventController.allEvent.where((e)=> e.community!.owner!.id == authController.user!.id).toList().isEmpty) {
        return const NoItemPage(title: 'Event');
      } else {
        return const ErrorPage();
      }
    });
  }
}
