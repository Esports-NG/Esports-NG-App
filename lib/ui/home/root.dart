import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/ui/account/account.dart';
import 'package:e_sport/ui/events/events.dart';
import 'package:e_sport/ui/home/community/community.dart';
import 'package:e_sport/ui/home/home.dart';
import 'package:e_sport/ui/widget/actionButton.dart';
import 'package:e_sport/ui/widget/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
