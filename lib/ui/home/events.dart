import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().pureBlackColor,
      body: Center(
        child: CustomText(
          title: 'Events',
          color: AppColor().primaryWhite,
          textAlign: TextAlign.center,
          fontFamily: 'GilroyRegular',
          size: Get.height * 0.015,
        ),
      ),
    );
  }
}
