import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/ui/screens/nav/account.dart';
import 'package:e_sport/ui/widgets/custom/custom_navbar.dart';
import 'package:e_sport/ui/screens/nav/events.dart';
import 'package:e_sport/ui/screens/nav/community.dart';
import 'package:e_sport/ui/screens/nav/home.dart';
import 'package:e_sport/ui/widgets/utils/actionButton.dart';
import 'package:e_sport/ui/widgets/utils/bottom_nav.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class RootDashboard extends StatefulWidget {
  const RootDashboard({super.key});

  @override
  State<RootDashboard> createState() => _RootDashboardState();
}

class _RootDashboardState extends State<RootDashboard>
    with TickerProviderStateMixin {
  late PageController _pageViewController;

  @override
  void initState() {
    _pageViewController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void setPage(int index) {
    _pageViewController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavRepository());
    final List<Widget> _pages = [
      const HomePage(),
      const EventsPage(),
      const CommunityPage(),
      const Account(),
    ];

    return PersistentTabView(
        backgroundColor: AppColor().primaryBackGroundColor,
        screenTransitionAnimation: ScreenTransitionAnimation.none(),
        floatingActionButton: ActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        navBarHeight: 55.h,
        tabs: [
          PersistentTabConfig(
              screen: HomePage(),
              item: ItemConfig(
                  activeForegroundColor: Colors.white,
                  title: "Home",
                  icon: HeroIcon(
                    HeroIcons.home,
                    size: 28,
                  ))),
          PersistentTabConfig(
              screen: EventsPage(),
              navigatorConfig: NavigatorConfig(),
              item: ItemConfig(
                  activeForegroundColor: Colors.white,
                  title: "Events",
                  icon: HeroIcon(
                    HeroIcons.calendar,
                    size: 28,
                  ))),
          PersistentTabConfig(
              screen: CommunityPage(),
              item: ItemConfig(
                  activeForegroundColor: Colors.white,
                  title: "Community",
                  icon: HeroIcon(
                    HeroIcons.userGroup,
                    size: 28,
                  ))),
          PersistentTabConfig(
              screen: Account(),
              item: ItemConfig(
                  activeForegroundColor: Colors.white,
                  title: "Account",
                  icon: HeroIcon(
                    HeroIcons.user,
                    size: 28,
                  ))),
        ],
        navBarBuilder: (value) => CustomNavBar(
              navBarConfig: value,
              navBarDecoration: NavBarDecoration(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  color: AppColor().primaryBackGroundColor),
            ));
    return Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageViewController,
          children: _pages,
          onPageChanged: (value) {
            navController.currentIndex.value = value;
          },
        ),
        bottomNavigationBar: BottomNavigation(
          setPage: setPage,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const ActionButton());
  }
}
