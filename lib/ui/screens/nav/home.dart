import 'dart:math';

import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/data/repository/notification_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/screens/account/user_details.dart';
import 'package:e_sport/ui/widgets/posts/all_post_widget.dart';
import 'package:e_sport/ui/widgets/posts/games_to_play_widget.dart';
import 'package:e_sport/ui/widgets/posts/news_widget.dart';
import 'package:e_sport/ui/widgets/posts/activities.dart';
import 'package:e_sport/ui/screens/notification/notification.dart';
import 'package:e_sport/ui/screens/search/search_screen.dart';
import 'package:e_sport/ui/widgets/utils/coming_soon_popup.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../widgets/utils/profile_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int? categoryType = 0;
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  final navController = Get.put(NavRepository());
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  final gameController = Get.put(GamesRepository());
  late final TabController _tabController =
      TabController(length: 4, vsync: this);
  final _scrollController = ScrollController();
  final notificationController = Get.put(NotificationRepository());

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void handleTap() {
    setState(() {
      isSearch = true;
    });
  }

  void _loadMore() {
    print('scrolled');
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
  }

  void updateToken() {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.onTokenRefresh.listen((refreshedToken) {});
  }

  @override
  void initState() {
    super.initState();
    print(authController.user!.id);
    notificationController.getNotifications();
    _scrollController.addListener(_loadMore);
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
              right: Get.height * 0.02,
            ),
            child: NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverToBoxAdapter(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(Get.height * 0.04),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => UserDetails(
                                          slug: authController.user!.slug!));
                                    },
                                    child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          OtherImage(
                                              image: authController.user!
                                                  .profile!.profilePicture),
                                          if (authController
                                                  .user!.isVerified! ==
                                              true)
                                            SvgPicture.asset(
                                              "assets/images/svg/check_badge.svg",
                                              height: Get.height * 0.02,
                                            )
                                        ]),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
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
                                        child: Icon(
                                          Icons.shopping_cart_outlined,
                                          color: AppColor().primaryWhite,
                                          size: Get.height * 0.025,
                                        ),
                                      ),
                                      Gap(Get.height * 0.04),
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
                                          Get.to(
                                              () => const NotificationPage());
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
                              Gap(Get.height * 0.02),
                              SizedBox(
                                  height: Get.height * 0.05,
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
                              Gap(Get.height * 0.004),
                            ]),
                      ),
                      SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverAppBarDelegate(
                            minHeight: Get.height * 0.07,
                            maxHeight: Get.height * 0.07,
                            child: TabBar(
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                labelColor:
                                    AppColor().primaryWhite.withOpacity(0.9),
                                indicatorColor: AppColor().primaryColor,
                                dividerColor: Colors.transparent,
                                labelStyle: TextStyle(
                                  fontFamily: 'InterBold',
                                  fontSize: 12.sp,
                                ),
                                unselectedLabelColor:
                                    AppColor().lightItemsColor,
                                unselectedLabelStyle: TextStyle(
                                  fontFamily: 'InterMedium',
                                  fontSize: 12.sp,
                                ),
                                controller: _tabController,
                                tabs: const [
                                  Tab(text: 'For you'),
                                  Tab(text: 'Games to play'),
                                  Tab(text: 'Activities'),
                                  Tab(text: 'News'),
                                ]),
                          ))
                    ],
                body: TabBarView(controller: _tabController, children: [
                  PostWidget(
                    refresh: postController.getPostForYou,
                    posts: postController.forYouPosts,
                    nextLink: postController.forYouNextlink.value,
                    getNext: postController.getNextForYou,
                  ),
                  GamesToPlayWidget(
                    refresh: gameController.getGameFeed,
                    gameFeed: gameController.gameFeed,
                    nextLink: gameController.feedNextlink.value,
                    getNext: gameController.getNextFeed,
                  ),
                  Activities(),
                  NewsWidget(posts: postController.news),
                ])),
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
