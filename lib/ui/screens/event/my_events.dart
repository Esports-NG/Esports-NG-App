import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/events/account_event_widget.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final eventController = Get.put(EventRepository());
  bool _loading = true;

  Future getMyEvents() async {
    await eventController.getMyEvents(false);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getMyEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(
          title: "My Events",
          fontFamily: 'InterSemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: GoBackButton(onPressed: () => Get.back()),
      ),
      body: _loading ? LoadingWidget() : AccountEventsWidget(),
    );
  }
}
