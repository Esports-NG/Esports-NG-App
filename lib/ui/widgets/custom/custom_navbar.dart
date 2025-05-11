import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final ItemAnimation itemAnimationProperties;

  const CustomNavBar({
    super.key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimation(),
  });

  Widget _buildItem(ItemConfig item, bool isSelected) {
    final title = item.title;
    return Container(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(
              size: 28,
              color: isSelected
                  ? item.activeForegroundColor
                  : item.inactiveForegroundColor,
            ),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
          if (title != null)
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Material(
                type: MaterialType.transparency,
                child: FittedBox(
                  child: Text(
                    title,
                    style: item.textStyle.apply(
                      color: isSelected
                          ? item.activeForegroundColor
                          : item.inactiveForegroundColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double itemWidth = (MediaQuery.of(context).size.width -
            navBarDecoration.padding.horizontal) /
        navBarConfig.items.length;
    return DecoratedNavBar(
      decoration: navBarDecoration,
      height: navBarConfig.navBarHeight,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: navBarConfig.selectedIndex == 0
                ? 0
                : navBarConfig.selectedIndex == 1
                    ? 70
                    : navBarConfig.selectedIndex == 2
                        ? Get.width - 140 - navBarDecoration.padding.right * 2
                        : Get.width - 70 - navBarDecoration.padding.right * 2,
            // right: navController.currentIndex.value == 2
            //     ? 70
            //     : navController.currentIndex.value == 3
            //         ? 0
            //         : null,
            child: AnimatedContainer(
              height: 5,
              width: 70,
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: AppColor().primaryColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Get.height * 0.005),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (final (index, item) in navBarConfig.items.indexed) ...[
                  if (index == 2) Spacer(flex: 4),
                  InkWell(
                    // This is the most important part. Without this, nothing would happen if you tap on an item.
                    onTap: () => navBarConfig.onItemSelected(index),
                    child:
                        _buildItem(item, navBarConfig.selectedIndex == index),
                  )
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
