import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/ui/screens/account/messages/messages.dart';
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
import 'package:iconsax_plus/iconsax_plus.dart';
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
      const Messages(),
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
                  icon: Icon(
                    IconsaxPlusLinear.home_2,
                    size: 24.sp,
                  ))),
          PersistentTabConfig(
              screen: EventsPage(),
              navigatorConfig: NavigatorConfig(),
              item: ItemConfig(
                  activeForegroundColor: Colors.white,
                  title: "Events",
                  icon: Icon(
                    IconsaxPlusLinear.calendar,
                    size: 24.sp,
                  ))),
          PersistentTabConfig(
              screen: CommunityPage(),
              item: ItemConfig(
                  activeForegroundColor: Colors.white,
                  title: "Community",
                  icon: Icon(
                    IconsaxPlusLinear.profile_2user,
                    size: 28,
                  ))),
          PersistentTabConfig(
              screen: Messages(),
              item: ItemConfig(
                  activeForegroundColor: Colors.white,
                  title: "Messages",
                  icon: Icon(
                    IconsaxPlusLinear.message,
                    size: 28,
                  ))),
        ],
        navBarBuilder: (value) => CustomNavBar(
              navBarConfig: value,
              navBarDecoration: NavBarDecoration(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                  color: AppColor().primaryBackGroundColor),
            ));
  }
}
