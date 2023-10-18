import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final authController = Get.put(AuthRepository());
  int? accountTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(Get.height * 0.06),
      //   child: Container(
      //     height: Get.height * 0.15,
      //     decoration: const BoxDecoration(
      //       image: DecorationImage(
      //           image: AssetImage('assets/images/png/account_header.png'),
      //           opacity: 0.2),
      //     ),
      //     child: Stack(
      //       children: [
      //         IconButton(
      //           padding: EdgeInsets.zero,
      //           constraints: const BoxConstraints(),
      //           onPressed: () => authController.logout(),
      //           icon: Icon(
      //             Icons.settings,
      //             color: AppColor().primaryWhite,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: Get.height * 0.15,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/png/account_header.png'),
                        opacity: 0.2),
                  ),
                ),
                Positioned(
                  top: Get.height * 0.1,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: Get.height * 0.15,
                        width: Get.height * 0.15,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/png/account2.png'),
                          ),
                        ),
                      ),
                      Positioned(
                        right: Get.height * 0.01,
                        bottom: Get.height * 0.015,
                        child: SvgPicture.asset(
                          'assets/images/svg/check_badge.svg',
                          height: Get.height * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: Get.height * 0.03,
                  bottom: Get.height * 0.05,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => authController.logout(),
                    icon: Icon(
                      Icons.settings,
                      size: 25,
                      color: AppColor().primaryWhite,
                    ),
                  ),
                ),
              ],
            ),
            Gap(Get.height * 0.1),
            CustomText(
              title: '@ realmischaxyz',
              size: 16,
              fontFamily: 'GilroyRegular',
              textAlign: TextAlign.start,
              color: AppColor().lightItemsColor,
            ),
            Gap(Get.height * 0.01),
            CustomText(
              title: 'Ava Sanchez',
              size: 20,
              fontFamily: 'GilroyBold',
              textAlign: TextAlign.start,
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.04),
            Stack(
              children: [
                Divider(
                  color: AppColor().lightItemsColor.withOpacity(0.5),
                  height: Get.height * 0.06,
                  thickness: 0.5,
                ),
                SizedBox(
                  height: Get.height * 0.035,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const ScrollPhysics(),
                    shrinkWrap: false,
                    itemCount: accountItem.length,
                    separatorBuilder: (context, index) =>
                        Gap(Get.height * 0.02),
                    itemBuilder: (context, index) {
                      var item = accountItem[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            accountTab = index;
                          });
                        },
                        child: Center(
                          child: Column(
                            children: [
                              CustomText(
                                title: item.title,
                                size: 13,
                                fontFamily: 'GilroyRegular',
                                weight: accountTab == index
                                    ? FontWeight.w600
                                    : FontWeight.w100,
                                textAlign: TextAlign.start,
                                color: accountTab == index
                                    ? AppColor().primaryColor
                                    : AppColor().lightItemsColor,
                              ),
                              Gap(Get.height * 0.01),
                              Container(
                                width: Get.height * 0.1,
                                height: 1,
                                color: accountTab == index
                                    ? AppColor().primaryColor
                                    : AppColor().primaryBackGroundColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
