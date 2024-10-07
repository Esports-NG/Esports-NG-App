import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/delete_account.dart';
import 'package:e_sport/ui/account/faq.dart';
import 'package:e_sport/ui/account/privacy_policy.dart';
import 'package:e_sport/ui/components/my_post_widget.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/coming_soon_popup.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'account_details.dart';
import 'my_profile.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  int? accountTab;

  @override
  void dispose() {
    super.dispose();

    setState(() {
      accountTab = null;
    });
  }

  void toProfile() async {
    await Future.delayed(const Duration(milliseconds: 10));
    Get.to(() => Profile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                authController.user!.profile!.cover == null
                    ? Container(
                        height: Get.height * 0.15,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/png/account_header.png'),
                              opacity: 0.2),
                        ),
                      )
                    : GestureDetector(
                        onTap: () => Helpers().showImagePopup(
                            context, "${authController.user!.profile!.cover}"),
                        child: CachedNetworkImage(
                          height: Get.height * 0.15,
                          width: double.infinity,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: SizedBox(
                              height: Get.height * 0.05,
                              width: Get.height * 0.05,
                              child: CircularProgressIndicator(
                                  color: AppColor().primaryWhite,
                                  value: progress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, color: AppColor().primaryColor),
                          imageUrl: '${authController.user!.profile!.cover}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  opacity: 0.6),
                            ),
                          ),
                        ),
                      ),
                Positioned(
                  top: Get.height * 0.1,
                  child: GestureDetector(
                    onTap: () => Helpers().showImagePopup(context,
                        "${authController.user!.profile!.profilePicture}"),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        OtherImage(
                          itemSize: Get.height * 0.13,
                          image: authController.user!.profile!.profilePicture,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: Get.height * 0.03,
                  bottom: Get.height * 0.05,
                  child: InkWell(
                    onTap: () => showPopupMenu(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: AppColor().primaryWhite.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.settings,
                        size: 25,
                        color: AppColor().primaryWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(Get.height * 0.1),
            Obx(() {
              return CustomText(
                title: '@ ${authController.user?.userName ?? 'yourusername'}',
                size: 16,
                fontFamily: 'Inter',
                textAlign: TextAlign.start,
                color: AppColor().lightItemsColor,
              );
            }),
            Gap(Get.height * 0.01),
            Obx(() {
              return CustomText(
                title: authController.user!.fullName!.toCapitalCase(),
                size: 20,
                fontFamily: 'InterBold',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              );
            }),
            const Gap(5),
            CustomText(
              title: authController.user?.bio,
              size: 16,
              fontFamily: 'Inter',
              textAlign: TextAlign.start,
              color: AppColor().lightItemsColor,
            ),
            Gap(Get.height * 0.03),
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
                    splashColor: AppColor().primaryColor,
                    onTap: () {
                      debugPrint(item.title);
                      setState(() {
                        accountTab = index;
                        if (item.title == 'Logout') {
                          logOutDialog(context);
                        } else if (item.title == 'Ads') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: AppColor().primaryBgColor,
                              content: const ComingSoonPopup(),
                            ),
                          );
                        } else if (item.title == 'Posts') {
                          Get.to(() => const MyPostWidget());
                        } else if (item.title == "Referrals") {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: AppColor().primaryBgColor,
                              content: const ComingSoonPopup(),
                            ),
                          );
                        } else if (item.title == "Wallet") {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: AppColor().primaryBgColor,
                              content: const ComingSoonPopup(),
                            ),
                          );
                        } else {
                          Get.to(() => AccountDetails(
                                title: item.title,
                              ));
                        }
                      });
                    },
                    child: Container(
                      height: Get.height * 0.065,
                      padding: EdgeInsets.all(Get.height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            title: item.title,
                            size: 16,
                            fontFamily: 'InterMedium',
                            textAlign: TextAlign.start,
                            color: item.title == 'Logout'
                                ? AppColor().primaryRed
                                : accountTab == index
                                    ? AppColor().primaryWhite
                                    : AppColor().lightItemsColor,
                          ),
                          Visibility(
                              visible: item.title != "Logout",
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: accountTab == index
                                    ? AppColor().primaryWhite
                                    : AppColor().lightItemsColor,
                                size: 16,
                              ))
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
  }

  void showPopupMenu() async {
    String? selectedMenuItem = await showMenu(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide.none),
      constraints: const BoxConstraints(),
      color: AppColor().primaryMenu,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          value: 'ScreenA',
          height: 20,
          padding: const EdgeInsets.only(bottom: 10, left: 20, top: 10),
          child: Row(
            children: [
              Icon(
                Icons.edit,
                color: AppColor().primaryWhite,
                size: Get.height * 0.016,
              ),
              Gap(Get.height * 0.015),
              CustomText(
                title: 'Edit Profile',
                size: Get.height * 0.014,
                fontFamily: 'InterMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'ScreenB',
          height: 20,
          padding: const EdgeInsets.only(
            bottom: 10,
            left: 20,
            top: 10,
          ),
          child: Row(
            children: [
              Icon(
                Icons.alternate_email,
                color: AppColor().primaryWhite,
                size: Get.height * 0.016,
              ),
              Gap(Get.height * 0.015),
              CustomText(
                title: 'Edit Socials',
                size: Get.height * 0.014,
                fontFamily: 'InterMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'ScreenC',
          height: 20,
          padding: const EdgeInsets.only(bottom: 10, left: 20, top: 10),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.lock_fill,
                color: AppColor().primaryWhite,
                size: Get.height * 0.016,
              ),
              Gap(Get.height * 0.015),
              CustomText(
                title: 'Privacy and Security',
                size: Get.height * 0.014,
                fontFamily: 'InterMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'ScreenD',
          height: 20,
          padding: const EdgeInsets.only(
            bottom: 10,
            left: 20,
            top: 10,
          ),
          child: Row(
            children: [
              Icon(
                Icons.privacy_tip,
                color: AppColor().primaryWhite,
                size: Get.height * 0.016,
              ),
              Gap(Get.height * 0.015),
              CustomText(
                title: 'Privacy and User Policy',
                size: Get.height * 0.014,
                fontFamily: 'InterMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'ScreenE',
          height: 20,
          padding: const EdgeInsets.only(
            bottom: 10,
            left: 20,
            top: 10,
          ),
          child: Row(
            children: [
              Icon(
                Icons.question_mark_rounded,
                color: AppColor().primaryWhite,
                size: Get.height * 0.016,
              ),
              Gap(Get.height * 0.015),
              CustomText(
                title: 'FAQs/Report Bug',
                size: Get.height * 0.014,
                fontFamily: 'InterMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryWhite,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'ScreenF',
          height: 20,
          padding: const EdgeInsets.only(
            bottom: 10,
            left: 20,
            top: 10,
          ),
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: AppColor().primaryRed,
                size: Get.height * 0.016,
              ),
              Gap(Get.height * 0.015),
              CustomText(
                title: 'Delete your Account',
                size: Get.height * 0.014,
                fontFamily: 'InterMedium',
                textAlign: TextAlign.start,
                color: AppColor().primaryRed,
              ),
            ],
          ),
        ),
      ],
    );

    if (selectedMenuItem != null) {
      _navigateToScreen(selectedMenuItem);
    }
  }

  void _navigateToScreen(String screen) {
    switch (screen) {
      case 'ScreenA':
        Get.to(() => const MyProfile());
        break;
      case 'ScreenB':
        // Get.to(() => const Social());
        break;
      case 'ScreenC':
        // Get.to(() => const Privacy());
        break;
      case 'ScreenD':
        Get.to(() => PrivacyPolicy());
        break;
      case 'ScreenE':
        Get.to(() => Faq());
        break;
      case 'ScreenF':
        Get.to(() => DeleteAccount());
        break;
    }
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
                    fontFamily: 'InterSemiBold',
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
                              fontFamily: 'InterMedium',
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
                              fontFamily: 'InterMedium',
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
