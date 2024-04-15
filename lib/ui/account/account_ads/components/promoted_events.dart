import 'package:e_sport/ui/components/account_event_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromotedEvents extends StatefulWidget {
  const PromotedEvents({super.key});

  @override
  State<PromotedEvents> createState() => _PromotedEventsState();
}

class _PromotedEventsState extends State<PromotedEvents> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: const Column(children: [AccountEventsWidget()]),
      ),
    );
  }
}
