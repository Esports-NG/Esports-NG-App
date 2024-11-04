import 'dart:math';

import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/components/all_post_widget.dart';
import 'package:e_sport/ui/components/news_widget.dart';
import 'package:e_sport/ui/search/search_screen.dart';
import 'package:e_sport/ui/widget/coming_soon_popup.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'components/profile_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int? categoryType = 0;
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  final navController = Get.put(NavRepository());
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void handleTap() {
    setState(() {
      isSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: Get.height * 0.02,
                left: Get.height * 0.02,
                right: Get.height * 0.02),
            child: NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(Get.height * 0.06),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => UserDetails(
                                          id: authController.user!.id!));
                                    },
                                    child: OtherImage(
                                        image: authController
                                            .user!.profile!.profilePicture),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Get.to(() => const Messages());
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              backgroundColor:
                                                  AppColor().primaryBgColor,
                                              content: const ComingSoonPopup(),
                                            ),
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/svg/chat.svg',
                                          height: Get.height * 0.025,
                                        ),
                                      ),
                                      Gap(Get.height * 0.04),
                                      InkWell(
                                        onTap: () {
                                          // Get.to(() => const Leaderboard());
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              backgroundColor:
                                                  AppColor().primaryBgColor,
                                              content: const ComingSoonPopup(),
                                            ),
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/svg/leaderboard.svg',
                                          height: Get.height * 0.025,
                                        ),
                                      ),
                                      Gap(Get.height * 0.04),
                                      InkWell(
                                        onTap: () {
                                          // Get.to(() => const NotificationPage());
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              backgroundColor:
                                                  AppColor().primaryBgColor,
                                              content: const ComingSoonPopup(),
                                            ),
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/svg/notification_icon.svg',
                                          height: Get.height * 0.025,
                                          color: AppColor().primaryWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Gap(Get.height * 0.025),
                              SizedBox(
                                  height: Get.height * 0.06,
                                  child: CupertinoSearchTextField(
                                    placeholder: 'Search recent posts...',
                                    onSubmitted: (_) =>
                                        Get.to(() => const SearchScreen(
                                              selectedPage: 0,
                                            )),
                                    borderRadius: BorderRadius.circular(10),
                                    prefixInsets: const EdgeInsets.only(
                                        right: 5, left: 10),
                                    controller: authController.searchController,
                                    itemColor: AppColor()
                                        .primaryWhite
                                        .withOpacity(0.5),
                                    style: TextStyle(
                                      color: AppColor().primaryWhite,
                                      fontFamily: 'InterMedium',
                                      fontSize: 14,
                                      height: Get.height * 0.0019,
                                    ),
                                  )),
                              Gap(Get.height * 0.02),
                            ]),
                      ),
                      SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverAppBarDelegate(
                            minHeight: 45,
                            maxHeight: 45,
                            child: TabBar(
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                labelColor: AppColor().primaryColor,
                                indicatorColor: AppColor().primaryColor,
                                dividerColor: Colors.transparent,
                                labelStyle: const TextStyle(
                                  fontFamily: 'InterBold',
                                  fontSize: 13,
                                ),
                                unselectedLabelColor:
                                    AppColor().lightItemsColor,
                                unselectedLabelStyle: const TextStyle(
                                  fontFamily: 'InterMedium',
                                  fontSize: 13,
                                ),
                                controller: _tabController,
                                tabs: const [
                                  Tab(text: 'For you'),
                                  Tab(text: 'Following'),
                                  Tab(text: 'Activities'),
                                  Tab(text: 'News'),
                                ]),
                          ))
                    ],
                body: RefreshIndicator(
                  notificationPredicate: (notification) =>
                      notification.depth == 1,
                  onRefresh: () async {
                    await postController.getAllPost(false);
                    await postController.getPostForYou(false);
                    await postController.getBookmarkedPost(false);
                    // await postController.getAdverts();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TabBarView(controller: _tabController, children: [
                      PostWidget(posts: postController.forYouPosts),
                      PostWidget(posts: postController.followingPost),
                      PostWidget(posts: postController.bookmarkedPost),
                      NewsWidget(posts: postController.news),
                    ]),
                  ),
                )),
          ),
          Center(
            child: Visibility(
                visible: authController.isLoading.value,
                child: const ProgressLoader()),
          )
        ],
      );
    });
  }

  SizedBox categoryWidget() {
    return SizedBox(
      height: Get.height * 0.045,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        shrinkWrap: false,
        itemCount: categoryItem.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.05),
        itemBuilder: (context, index) {
          var item = categoryItem[index];
          return InkWell(
            onTap: () {
              setState(() {
                categoryType = index;
              });
            },
            child: Center(
              child: Column(
                children: [
                  CustomText(
                    title: item.title,
                    size: 13,
                    fontFamily:
                        categoryType == index ? 'InterBold' : 'InterMedium',
                    textAlign: TextAlign.start,
                    color: categoryType == index
                        ? AppColor().primaryColor
                        : AppColor().lightItemsColor,
                  ),
                  Gap(Get.height * 0.01),
                  Container(
                    width: Get.height * 0.08,
                    height: 1.5,
                    color: categoryType == index
                        ? AppColor().primaryColor
                        : AppColor().primaryBackGroundColor,
                  ),
                ],
              ),
            ),
          );
        },
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
    return SizedBox.expand(
        child:
            Container(color: AppColor().primaryBackGroundColor, child: child));
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
