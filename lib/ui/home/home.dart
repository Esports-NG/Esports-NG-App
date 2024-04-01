import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/components/all_post_widget.dart';
import 'package:e_sport/ui/widget/coming_soon_popup.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
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
      TabController(length: 3, vsync: this);
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
                        child: Column(children: [
                          Gap(Get.height * 0.06),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  BorderRadius.circular(10)),
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
                                                  BorderRadius.circular(10)),
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
                                                  BorderRadius.circular(10)),
                                          backgroundColor:
                                              AppColor().primaryBgColor,
                                          content: const ComingSoonPopup(),
                                        ),
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/svg/notification.svg',
                                      height: Get.height * 0.025,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Gap(Get.height * 0.025),
                          SizedBox(
                            height: Get.height * 0.06,
                            child: CustomTextField(
                              hint: "Search for gaming news, competitions...",
                              fontFamily: 'GilroyMedium',
                              prefixIcon: Icon(
                                CupertinoIcons.search,
                                color: AppColor().lightItemsColor,
                              ),
                              textEditingController:
                                  authController.searchController,
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
                          Gap(Get.height * 0.025),
                          TabBar(
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              labelColor: AppColor().primaryColor,
                              indicatorColor: AppColor().primaryColor,
                              dividerColor: Colors.transparent,
                              labelStyle: const TextStyle(
                                fontFamily: 'GilroyBold',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              unselectedLabelColor: AppColor().lightItemsColor,
                              unselectedLabelStyle: const TextStyle(
                                fontFamily: 'GilroyMedium',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              controller: _tabController,
                              tabs: const [
                                Tab(text: 'For you'),
                                Tab(text: 'Following'),
                                Tab(text: 'Bookmark'),
                              ]),
                          Gap(Get.height * 0.02)
                        ]),
                      )
                    ],
                body: RefreshIndicator(
                  notificationPredicate: (notification) =>
                      notification.depth == 1,
                  onRefresh: () async {
                    return Future.delayed(const Duration(seconds: 2), () {
                      postController.getAllPost(false);
                    });
                  },
                  child: TabBarView(controller: _tabController, children: [
                    PostWidget(posts: postController.allPost),
                    PostWidget(posts: postController.followingPost),
                    PostWidget(posts: postController.bookmarkedPost)
                  ]),
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
                        categoryType == index ? 'GilroyBold' : 'GilroyMedium',
                    weight: FontWeight.w400,
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
