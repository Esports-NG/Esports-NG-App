// ignore_for_file: deprecated_member_use

import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/ui/widget/custom_navbar.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../account/account.dart';
import 'community.dart';
import 'events.dart';
import 'home.dart';
import 'post/create_post.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  int? _selectedMenu;
  var pages = <Widget>[
    const HomePage(),
    const EventsPage(),
    const CommunityPage(),
    const Account(),
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
        onPressed: () {
          _showItemListDialog(context);
        },
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
                        if (_selectedMenu == 0) {
                          Get.back();
                          Get.to(() => const CreatePost());
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

class CreateMenu extends StatelessWidget {
  final CategoryItem? item;
  final int? selectedItem, index;
  const CreateMenu({
    super.key,
    this.item,
    this.index,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.025),
      decoration: BoxDecoration(
        color: selectedItem == index
            ? AppColor().primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColor().primaryColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            title: item!.title,
            size: Get.height * 0.016,
            fontFamily: 'GilroyMedium',
            textAlign: TextAlign.start,
            color: AppColor().primaryWhite,
          ),
          Gap(Get.height * 0.1),
          const Spacer(),
          SmallCircle(
            size: Get.height * 0.015,
            color: AppColor().primaryWhite,
            bColor: AppColor().primaryColor,
          )
        ],
      ),
    );
  }
}
