import 'package:e_sport/data/model/account_events_model.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'components/tournament_item.dart';

class Tournament extends StatefulWidget {
  const Tournament({super.key});

  @override
  State<Tournament> createState() => _TournamentState();
}

class _TournamentState extends State<Tournament> {
  final eventController = Get.put(EventRepository());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: GoBackButton(onPressed: () => Get.back()),
          title: CustomText(
            title: 'Tournament',
            fontFamily: 'GilroySemiBold',
            size: 18,
            color: AppColor().primaryWhite,
          ),
        ),
        backgroundColor: AppColor().primaryBackGroundColor,
        body: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: SingleChildScrollView(
            child: ListView.separated(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventController.allEvent.length,
                separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                itemBuilder: (context, index) {
                  var item = eventController.allEvent[index];
                  return InkWell(child: AccountEventsItem(item: item));
                }),
          ),
        ),
      );
    });
  }
}
