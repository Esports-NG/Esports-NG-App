import 'dart:math';

import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/components/all_post_widget.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPostWidget extends StatefulWidget {
  const MyPostWidget({
    super.key,
  });

  @override
  State<MyPostWidget> createState() => _MyPostWidgetState();
}

class _MyPostWidgetState extends State<MyPostWidget>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostRepository());
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: CustomText(
            title: 'Posts',
            fontFamily: 'InterSemiBold',
            size: 18,
            color: AppColor().primaryWhite,
          ),
          leading: GoBackButton(onPressed: () => Get.back())),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(const Duration(seconds: 2), () {
            postController.getMyPost(false);
          });
        },
        child: Padding(
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
                            labelColor: AppColor().primaryWhite.withOpacity(0.9),
                            indicatorColor: AppColor().primaryColor,
                            dividerColor: Colors.transparent,
                            labelStyle: const TextStyle(
                              fontFamily: 'InterBold',
                              fontSize: 13,
                            ),
                            unselectedLabelColor: AppColor().lightItemsColor,
                            unselectedLabelStyle: const TextStyle(
                              fontFamily: 'InterMedium',
                              fontSize: 13,
                            ),
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'My Posts'),
                              Tab(text: 'Bookmarks'),
                            ]),
                      )))
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TabBarView(controller: _tabController, children: [
                PostWidget(
                  refresh: postController.getMyPost,
                  posts: postController.myPost,
                ),
                PostWidget(
                  refresh: postController.getBookmarkedPost,
                  posts: postController.bookmarkedPost,
                ),
              ]),
            ),
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
