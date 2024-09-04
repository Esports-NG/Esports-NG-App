import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/ui/account/account_events/create_event_post.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventPostsAndAnnouncements extends StatefulWidget {
  const EventPostsAndAnnouncements({super.key, required this.event});

  final EventModel event;

  @override
  State<EventPostsAndAnnouncements> createState() =>
      _EventPostsAndAnnouncementsState();
}

class _EventPostsAndAnnouncementsState
    extends State<EventPostsAndAnnouncements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreateEventPost(event: widget.event));
        },
        backgroundColor: AppColor().primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        child: Icon(
          Icons.add,
          color: AppColor().primaryWhite,
        ),
      ),
      appBar: AppBar(
        title: CustomText(
          title: 'Event Posts',
          color: AppColor().primaryWhite,
          fontFamily: 'GilroySemiBold',
          size: 18,
        ),
        backgroundColor: AppColor().primaryBackGroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor().primaryWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
          // Add your content here
          ),
    );
  }
}
