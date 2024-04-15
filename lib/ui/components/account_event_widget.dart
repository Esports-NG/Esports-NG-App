import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
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
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (eventController.eventStatus == EventStatus.loading) {
        return LoadingWidget(color: AppColor().primaryColor);
      } else if (eventController.eventStatus == EventStatus.available) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: eventController.allEvent.length,
          separatorBuilder: (context, index) => Gap(Get.height * 0.02),
          itemBuilder: (context, index) {
            var item = eventController.allEvent[index];
            return InkWell(
              onTap: () => Get.to(
                () => AccountTournamentDetail(item: item),
              ),
              child: AccountEventsItem(item: item),
            );
          },
        );
      } else if (eventController.eventStatus == EventStatus.empty) {
        return const NoItemPage(title: 'Event');
      } else {
        return const ErrorPage();
      }
    });
  }
}
