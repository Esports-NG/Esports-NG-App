import 'dart:math';

import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/account_events/create_event_post.dart';
import 'package:e_sport/ui/components/all_post_widget.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
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

class _EventPostsAndAnnouncementsState extends State<EventPostsAndAnnouncements>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  final postController = Get.put(PostRepository());

  List<PostModel> _posts = [];
  bool _isLoading = true;

  Future getEventPosts() async {
    var posts = await postController.getEventPosts(widget.event.id!);
    setState(() {
      _posts = posts;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getEventPosts();
    super.initState();
  }

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
        elevation: 0,
        scrolledUnderElevation: 0,
        title: CustomText(
          title: 'Event Posts',
          color: AppColor().primaryWhite,
          fontFamily: 'InterSemiBold',
          size: 18,
        ),
        backgroundColor: AppColor().primaryBackGroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor().primaryWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: NestedScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                    minHeight: 45,
                    maxHeight: 45,
                    child: Container(
                      color: AppColor().primaryBackGroundColor,
                      child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelColor: AppColor().secondaryGreenColor,
                          indicatorColor: AppColor().secondaryGreenColor,
                          dividerColor: Colors.transparent,
                          labelStyle: const TextStyle(
                            fontFamily: 'InterSemiBold',
                            fontSize: 13,
                          ),
                          unselectedLabelColor: AppColor().lightItemsColor,
                          unselectedLabelStyle: const TextStyle(
                            fontFamily: 'InterMedium',
                            fontSize: 13,
                          ),
                          controller: _tabController,
                          tabs: [
                            Tab(
                                text:
                                    'Announcements (${_posts.where((e) => e.announcement! == true).length})'),
                            Tab(text: 'Posts (${_posts.length})'),
                            Tab(
                                text:
                                    'Participant Announcements (${_posts.where((e) => e.participantAnnouncement! == true).length})'),
                          ]),
                    )))
          ],
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _isLoading
                ? const Center(child: ButtonLoader())
                : _posts.isEmpty
                    ? const Center(
                        child: CustomText(
                          title: "No posts",
                          size: 16,
                          fontFamily: "InterMedium",
                        ),
                      )
                    : TabBarView(controller: _tabController, children: [
                        PostWidget(
                          posts: _posts
                              .where((e) => e.announcement! == true)
                              .toList(),
                        ),
                        PostWidget(
                          posts: _posts,
                        ),
                        PostWidget(
                          posts: _posts
                              .where((e) => e.participantAnnouncement! == true)
                              .toList(),
                        ),
                      ]),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
