import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/referral/referral_widget.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'account_details.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final authController = Get.put(AuthRepository());
  int? accountTab = 0;
  String? _selectedIndex;

  void toProfile() async {
    await Future.delayed(const Duration(milliseconds: 10));
    Get.to(() => Profile());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColor().primaryBackGroundColor,
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
                          image: AssetImage(
                              'assets/images/png/account_header.png'),
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
                              image:
                                  AssetImage('assets/images/png/account2.png'),
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
                    child: PopupMenuButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide.none),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: AppColor().primaryMenu,
                      offset: const Offset(0, -10),
                      initialValue: _selectedIndex,
                      onSelected: (value) {
                        setState(() {
                          if (value == '1') {
                            _selectedIndex = value;
                          } else if (value == '2') {
                            _selectedIndex = value;
                          } else if (value == '3') {
                            _selectedIndex = value;
                          }
                        });
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: '1',
                          height: 20,
                          onTap: () {
                            SchedulerBinding.instance
                                .addPersistentFrameCallback((_) {
                              Get.to(() => Profile());
                            });
                          },
                          padding: const EdgeInsets.only(
                              bottom: 20, left: 20, top: 20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColor().primaryWhite,
                                size: Get.height * 0.016,
                              ),
                              Gap(Get.height * 0.02),
                              CustomText(
                                title: 'Edit Profile',
                                size: Get.height * 0.014,
                                fontFamily: 'GilroyMedium',
                                textAlign: TextAlign.start,
                                color: AppColor().primaryWhite,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: '2',
                          height: 20,
                          padding: const EdgeInsets.only(bottom: 20, left: 20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColor().primaryWhite,
                                size: Get.height * 0.016,
                              ),
                              Gap(Get.height * 0.02),
                              CustomText(
                                title: 'Edit Socials',
                                size: Get.height * 0.014,
                                fontFamily: 'GilroyMedium',
                                textAlign: TextAlign.start,
                                color: AppColor().primaryWhite,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: '3',
                          height: 20,
                          padding: const EdgeInsets.only(bottom: 20, left: 20),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.lock_fill,
                                color: AppColor().primaryWhite,
                                size: Get.height * 0.016,
                              ),
                              Gap(Get.height * 0.02),
                              CustomText(
                                title: 'Privacy and Security',
                                size: Get.height * 0.014,
                                fontFamily: 'GilroyMedium',
                                textAlign: TextAlign.start,
                                color: AppColor().primaryWhite,
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Icon(
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
                title: '@ ${authController.user?.userName}',
                size: 16,
                fontFamily: 'GilroyRegular',
                textAlign: TextAlign.start,
                color: AppColor().lightItemsColor,
              ),
              Gap(Get.height * 0.01),
              CustomText(
                title: authController.user!.fullName!.toCapitalCase(),
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
                          if (item.title == 'Logout') {
                            logOutDialog(context);
                          } else if (item.title == 'Referrals') {
                            Get.to(() => const Referral());
                          } else {
                            Get.to(() => AccountDetails(
                                  title: item.title,
                                ));
                          }
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
                              color: item.title == 'Logout'
                                  ? AppColor().primaryRed
                                  : accountTab == index
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
              Gap(Get.height * 0.04),
            ],
          ),
        ),
      );
    });
  }

  void logOutDialog(BuildContext context) {
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
                    title: 'Are you sure you want to log out?',
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
                height: Get.height * 0.2,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => authController.logout(),
                      child: Container(
                        padding: EdgeInsets.all(Get.height * 0.025),
                        decoration: BoxDecoration(
                          color: AppColor().primaryColor,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: AppColor().primaryColor, width: 1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              title: 'Yes',
                              size: Get.height * 0.016,
                              fontFamily: 'GilroyMedium',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                            const Spacer(),
                            SmallCircle(
                              size: Get.height * 0.015,
                              color: AppColor().primaryWhite,
                              bColor: AppColor().primaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(Get.height * 0.025),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: AppColor().lightItemsColor, width: 1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              title: 'No',
                              size: Get.height * 0.016,
                              fontFamily: 'GilroyMedium',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                            const Spacer(),
                            SmallCircle(
                              size: Get.height * 0.015,
                              color: AppColor().primaryWhite,
                              bColor: AppColor().primaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
      },
    );
  }
}
