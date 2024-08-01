import 'package:e_sport/data/repository/nav_repository.dart';
import 'package:e_sport/ui/account/account.dart';
import 'package:e_sport/ui/events/events.dart';
import 'package:e_sport/ui/home/community/community.dart';
import 'package:e_sport/ui/home/home.dart';
import 'package:e_sport/ui/widget/actionButton.dart';
import 'package:e_sport/ui/widget/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootDashboard extends StatelessWidget {
  const RootDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavRepository());
    final List<Widget> pages = [
      const HomePage(),
      const EventsPage(),
      const CommunityPage(),
      const Account(),
    ];
    return Obx(
      () => Scaffold(
          body: pages[navController.currentIndex.value],
          bottomNavigationBar: const BottomNavigation(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: const ActionButton()),
    );
  }
}
