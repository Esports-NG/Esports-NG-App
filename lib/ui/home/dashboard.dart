// ignore_for_file: deprecated_member_use

import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/account/account_events/create_event.dart';
import 'package:e_sport/ui/home/post/create_community_page.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../account/account.dart';
import 'community/community.dart';
import '../events/events.dart';
import 'home.dart';
import 'post/create_post.dart';
import 'post/create_post_item.dart';
import 'post/create_team.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final authController = Get.put(AuthRepository());
  final _controller = PersistentTabController(initialIndex: 0);
  int? _selectedMenu;

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const EventsPage(),
      const CommunityPage(),
      const Account(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: AppColor().primaryBackGroundColor,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: false,
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          navBarStyle: NavBarStyle.style3,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: Get.height * 0.05),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: AppColor().primaryColor),
            child: IconButton(
              onPressed: () {
                _showItemListDialog(context);
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/images/svg/home_icon.svg',
          height: Get.height * 0.025,
          color: AppColor().lightItemsColor,
        ),
        title: "Home",
        activeColorPrimary: AppColor().primaryColor,
        inactiveColorPrimary: AppColor().lightItemsColor,
        textStyle: TextStyle(
          fontFamily: 'GilroyMedium',
          fontWeight: FontWeight.normal,
          fontSize: Get.height * 0.015,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/images/svg/event_icon.svg',
          height: Get.height * 0.025,
          color: AppColor().lightItemsColor,
        ),
        title: "Events",
        activeColorPrimary: AppColor().primaryColor,
        inactiveColorPrimary: AppColor().lightItemsColor,
        textStyle: TextStyle(
          fontFamily: 'GilroyMedium',
          fontWeight: FontWeight.normal,
          fontSize: Get.height * 0.015,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/images/svg/community_icon.svg',
          height: Get.height * 0.025,
          color: AppColor().lightItemsColor,
        ),
        title: "Community",
        activeColorPrimary: AppColor().primaryColor,
        inactiveColorPrimary: AppColor().lightItemsColor,
        textStyle: TextStyle(
          fontFamily: 'GilroyMedium',
          fontWeight: FontWeight.normal,
          fontSize: Get.height * 0.015,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/images/svg/account_icon.svg',
          height: Get.height * 0.025,
          color: AppColor().lightItemsColor,
        ),
        title: "Account",
        activeColorPrimary: AppColor().primaryColor,
        inactiveColorPrimary: AppColor().lightItemsColor,
        textStyle: TextStyle(
          fontFamily: 'GilroyMedium',
          fontWeight: FontWeight.normal,
          fontSize: Get.height * 0.015,
        ),
      ),
    ];
  }

  void _showItemListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: AppColor().primaryWhite,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomText(
                    title: 'Select what you would like\nto create',
                    size: Get.height * 0.018,
                    fontFamily: 'GilroySemiBold',
                    textAlign: TextAlign.center,
                    color: AppColor().primaryWhite,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColor().primaryLightColor,
            content: Container(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                width: Get.width * 0.5,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: createMenu.length,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.03),
                  itemBuilder: (context, index) {
                    var item = createMenu[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMenu = index;
                        });
                        Get.back();
                        if (_selectedMenu == 0) {
                          Get.to(() => const CreatePost());
                        } else if (_selectedMenu == 1) {
                          Get.to(() => const CreateEvent());
                        } else if (_selectedMenu == 2) {
                          Get.to(() => const CreateTeamPage());
                        } else {
                          Get.to(() => const CreateCommunityPage());
                        }
                      },
                      child: CreateMenu(
                        item: item,
                        selectedItem: _selectedMenu,
                        index: index,
                      ),
                    );
                  },
                )),
          );
        });
      },
    );
  }
}
