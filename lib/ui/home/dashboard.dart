import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'account.dart';
import 'community.dart';
import 'events.dart';
import 'home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  var pages = <Widget>[
    const HomePage(),
    const EventsPage(),
    const CommunityPage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBgColor,
      body: pages.elementAt(_selectedIndex),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor().primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        color: AppColor().primaryBgColor,
        notchMargin: 1,
        padding: const EdgeInsets.only(top: 10),
        child: BottomNavigationBar(
          backgroundColor: AppColor().primaryBgColor,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedLabelStyle: TextStyle(
            color: AppColor().primaryColor,
            fontFamily: 'GilroyMedium',
            fontWeight: FontWeight.normal,
          ),
          unselectedLabelStyle: TextStyle(
            color: AppColor().lightItemsColor,
            fontFamily: 'GilroyMedium',
            fontWeight: FontWeight.normal,
          ),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColor().primaryColor,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/svg/home_icon.svg',
                  height: Get.height * 0.03,
                  color: _selectedIndex == 0
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/svg/event_icon.svg',
                  height: Get.height * 0.03,
                  color: _selectedIndex == 1
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                ),
                label: 'Events'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/svg/community_icon.svg',
                  height: Get.height * 0.03,
                  color: _selectedIndex == 2
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                ),
                label: 'Community'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/svg/account_icon.svg',
                  height: Get.height * 0.03,
                  color: _selectedIndex == 3
                      ? AppColor().primaryColor
                      : AppColor().lightItemsColor,
                ),
                label: 'Account'),
          ],
        ),
      ),
    );
  }
}
