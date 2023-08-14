import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  var _pages = <Widget>[
    const HomePage(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().pureBlackColor,
      body: _pages.elementAt(_selectedIndex),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6.0),
        child: FloatingActionButton(
          backgroundColor: AppColor().primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // WAQrScannerScreen().launch(context);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: AppColor().pureBlackColor,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedLabelStyle: TextStyle(
            color: AppColor().primaryColor,
            fontFamily: 'GilroyMedium',
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          unselectedLabelStyle: TextStyle(
            color: AppColor().lightItemsColor,
            fontFamily: 'GilroyMedium',
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColor().primaryColor,
          unselectedItemColor: Colors.grey,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/svg/home_icon.svg',
                  height: Get.height * 0.03,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/svg/event_icon.svg',
                  height: Get.height * 0.03,
                ),
                label: 'Events'),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/svg/community_icon.svg',
                  height: Get.height * 0.03,
                ),
                label: 'Wallet'),
            BottomNavigationBarItem(icon:SvgPicture.asset(
                  'assets/images/svg/account_icon.svg',
                  height: Get.height * 0.03,
                ), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
