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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: ListView.separated(
                physics: const ScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: accountItem.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColor().lightItemsColor.withOpacity(0.2),
                  height: 0,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  var item = accountItem[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        accountTab = index;
                      });
                    },
                    child: Container(
                      height: Get.height * 0.07,
                      padding: EdgeInsets.all(Get.height * 0.02),
                      decoration: BoxDecoration(
                          color: accountTab == index
                              ? AppColor().primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            title: item.title,
                            size: Get.height * 0.017,
                            fontFamily: 'GilroySemiBold',
                            weight: FontWeight.w400,
                            textAlign: TextAlign.start,
                            color: accountTab == index
                                ? AppColor().primaryWhite
                                : AppColor().lightItemsColor,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: accountTab == index
                                ? AppColor().primaryWhite
                                : AppColor().lightItemsColor,
                            size: Get.height * 0.02,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
