import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account_events/create_event_post.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
        title: Row(children: [
          CachedNetworkImage(
            imageUrl: ApiLink.imageUrl + widget.event.banner!,
            imageBuilder: (context, imageProvider) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                  ),
                  borderRadius: BorderRadius.circular(999)),
            ),
          ),
          Gap(Get.height * 0.01),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  title: '${widget.event.name}: Event Posts',
                  color: AppColor().primaryWhite,
                  weight: FontWeight.w600,
                  size: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ]),
        leading: GoBackButton(
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
          // Add your content here
          ),
    );
  }
}
