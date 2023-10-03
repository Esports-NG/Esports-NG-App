// ignore_for_file: deprecated_member_use

import 'package:e_sport/ui/widget/custom_navbar.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: AppColor().primaryBackGroundColor,
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
        color: AppColor().primaryBackGroundColor,
        notchMargin: 1,
        child: CustomNavBar(
          selectedIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
