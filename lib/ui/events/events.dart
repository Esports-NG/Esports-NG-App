import 'dart:math';

// import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/events/components/event_tab.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
                fontFamily: 'GilroySemiBold',
                size: 18,
                color: AppColor().primaryWhite,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Get.height * 0.02),
                    child: SizedBox(
                      height: Get.height * 0.06,
                      child: CustomTextField(
                        hint: "Search for events...",
                        fontFamily: 'GilroyMedium',
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: AppColor().lightItemsColor,
                        ),
                        textEditingController: eventController.searchController,
                        hasText: isSearch!,
                        focusNode: _searchFocusNode,
                        onTap: handleTap,
                        onSubmited: (_) {
                          _searchFocusNode.unfocus();
                        },
                        onChanged: (value) {
                          setState(() {
                            isSearch = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
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
                              horizontal: Get.height * 0.02),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle:
                              const TextStyle(fontFamily: "GilroySemiBold"),
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
                            Tab(text: "My Events"),
                            Tab(text: "All Events")
                          ]),
                    )))
          ],
          // backgroundColor: AppColor().primaryBackGroundColor,
          body: RefreshIndicator(
              notificationPredicate: (notification) => notification.depth == 1,
              onRefresh: () async {
                await eventController.getAllEvents();
                // await eventController.getAllSocialEvents(false);
                // await eventController.getAllTournaments(false);
                await eventController.filterEvents();
              },
              child: TabBarView(
                controller: eventController.tabController,
                children: const [
                  SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: EventTab()),
                  SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: EventTab()),
                  SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: EventTab()),
                ],
              )),
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
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
