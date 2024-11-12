import 'dart:math';

// import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/events/components/event_tab.dart';
import 'package:e_sport/ui/search/search_screen.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../components/account_event_widget.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with SingleTickerProviderStateMixin {
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  int? eventType = 0;
  final eventController = Get.put(EventRepository());
  final authController = Get.put(AuthRepository());

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void handleTap() {
    setState(() {
      isSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          physics: const AlwaysScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
                elevation: 0,
                centerTitle: true,
                title: CustomText(
                  title: 'Events',
                  fontFamily: 'InterSemiBold',
                  size: 18,
                  color: AppColor().primaryWhite,
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: Get.width * 0.05),
                    child: Icon(
                      Icons.tv_outlined,
                      color: AppColor().primaryWhite,
                    ),
                  ),
                ]),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Get.height * 0.02),
                    child: SizedBox(
                        height: Get.height * 0.06,
                        child: CupertinoSearchTextField(
                          placeholder: 'Search for events...',
                          onSubmitted: (_) => Get.to(() => SearchScreen(
                                selectedPage: 3,
                              )),
                          borderRadius: BorderRadius.circular(10),
                          prefixInsets:
                              const EdgeInsets.only(right: 5, left: 10),
                          controller: authController.searchController,
                          itemColor: AppColor().primaryWhite.withOpacity(0.5),
                          style: TextStyle(
                            color: AppColor().primaryWhite,
                            fontFamily: 'InterMedium',
                            fontSize: 14,
                            height: Get.height * 0.0019,
                          ),
                        )),
                  ),
                ],
              ),
            ),
            SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                    minHeight: 45,
                    maxHeight: 45,
                    child: Container(
                      color: AppColor().primaryBackGroundColor,
                      child: TabBar(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.015),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle:
                              const TextStyle(fontFamily: "InterMedium"),
                          // dividerColor: AppColor().primaryBackGroundColor,
                          dividerHeight: 0,
                          indicatorColor: AppColor().primaryColor,
                          labelColor: AppColor().primaryColor,
                          unselectedLabelColor: AppColor().lightItemsColor,
                          controller: eventController.tabController,
                          tabs: const [
                            Tab(
                              text: "Active Events",
                            ),
                            Tab(text: "You Registered"),
                            Tab(text: "All Events")
                          ]),
                    )))
          ],
          // backgroundColor: AppColor().primaryBackGroundColor,
          body: TabBarView(
            controller: eventController.tabController,
            children: [
              SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: EventTab(
                    refresh: eventController.getAllEvents,
                    getNext: eventController.getNextEvents,
                    nextLink: eventController.nextLink.value,
                  )),
              SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Obx(
                    () => EventTab(
                      eventList: eventController.myEvent,
                      refresh: eventController.getMyEvents,
                    ),
                  )),
              const SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(), child: EventTab()),
            ],
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
