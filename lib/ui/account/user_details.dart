import 'dart:convert';
import 'dart:developer';

import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/model/user_profile.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/coming_soon.dart';
import 'package:e_sport/ui/widget/coming_soon_popup.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserDetails extends StatelessWidget {
  final int id;
  const UserDetails({super.key, required this.id});

  Future<UserDataWithFollowers> fetchUserProfile(String token) async {
    var response = await http.get(
      Uri.parse(ApiLink.getUserDataWithFollowers(id: id)),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${token}'
      },
    );

    var json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw (json['detail']);
    } else {
      print(response.body.runtimeType);

      return userDataWithFollowersFromJson(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthRepository());

    return Obx(
      () => Scaffold(
          backgroundColor: AppColor().primaryBackGroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: fetchUserProfile(authController.mToken.value),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: Get.height,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor().primaryColor,
                        ),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return UserProfile(
                        userData: snapshot.data!,
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error.toString());
                    }
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColor().primaryColor,
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
    required this.userData,
  });

  final UserDataWithFollowers userData;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final authController = Get.find<AuthRepository>();
  int? followersCount;
  int? followingCount;
  bool _isLoading = false;
  bool _isFollowing = false;

  Future<void> getFollowersList() async {
    setState(() {
      _isLoading = true;
    });
    var followersList =
        await authController.getProfileFollowerList(widget.userData.id!);
    setState(() {
      if (followersList.any(
          (element) => element["user_id"]["id"] == authController.user!.id)) {
        _isFollowing = true;
      } else {
        _isFollowing = false;
      }
      _isLoading = false;
    });
  }

  @override
  initState() {
    getFollowersList();
    setState(() {
      followersCount = widget.userData.followers;
      followingCount = widget.userData.following;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: Get.height * 0.15,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/png/account_header.png'),
                  opacity: 0.2),
            ),
          ),
          Positioned(
            top: Get.height * 0.11,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                OtherImage(
                  itemSize: Get.height * 0.11,
                  image: widget.userData.profile!.profilePicture,
                ),
              ],
            ),
          ),
          Positioned(
            right: Get.height * 0.03,
            left: Get.height * 0.03,
            top: Get.height * 0.02,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: AppColor().primaryWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColor().primaryWhite,
                    ),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      // onTap: () => showPopupMenu(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: AppColor().primaryWhite.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.notifications_outlined,
                          size: 20,
                          color: AppColor().primaryWhite,
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    InkWell(
                      // onTap: () => showPopupMenu(),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: AppColor().primaryWhite.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.more_vert,
                          size: 20,
                          color: AppColor().primaryWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      Gap(Get.height * 0.09),
      CustomText(
        title: '@ ${widget.userData.userName}',
        size: 16,
        fontFamily: 'GilroyRegular',
        textAlign: TextAlign.start,
        color: AppColor().lightItemsColor,
      ),
      Gap(Get.height * 0.01),
      CustomText(
        title: widget.userData.fullName!.toCapitalCase(),
        size: 20,
        fontFamily: 'GilroyBold',
        textAlign: TextAlign.start,
        color: AppColor().primaryWhite,
      ),
      Gap(Get.height * 0.02),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  title: followingCount.toString(),
                  weight: FontWeight.w500,
                  size: Get.height * 0.02,
                  fontFamily: 'GilroyBold',
                  color: AppColor().primaryWhite),
              Gap(Get.height * 0.01),
              CustomText(
                  title: 'Following',
                  weight: FontWeight.w400,
                  size: Get.height * 0.017,
                  fontFamily: 'GilroyRegular',
                  color: AppColor().greyEight),
            ],
          ),
          Gap(Get.height * 0.04),
          Container(
              height: Get.height * 0.03,
              width: Get.width * 0.005,
              color: AppColor().greyEight),
          Gap(Get.height * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                  title: followersCount.toString(),
                  weight: FontWeight.w500,
                  size: Get.height * 0.02,
                  fontFamily: 'GilroyBold',
                  color: AppColor().primaryWhite),
              Gap(Get.height * 0.01),
              CustomText(
                  title: 'Followers',
                  weight: FontWeight.w400,
                  size: Get.height * 0.017,
                  fontFamily: 'GilroyRegular',
                  color: AppColor().greyEight),
            ],
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: Column(
          children: [
            Visibility(
              visible: widget.userData.id != authController.user!.id!,
              child: Column(
                children: [
                  Gap(Get.height * 0.04),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFillOption(
                          buttonColor: _isLoading ? Colors.transparent : null,
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            var message = await authController
                                .followUser(widget.userData.id!);

                            if (message != "error") {
                              setState(() {
                                _isFollowing = !_isFollowing;
                                if (message == "unfollowed") {
                                  followersCount = followersCount! - 1;
                                } else {
                                  followersCount = followersCount! + 1;
                                }
                              });
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _isLoading
                                  ? [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: AppColor().primaryColor,
                                          strokeCap: StrokeCap.round,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ]
                                  : [
                                      SvgPicture.asset(
                                          'assets/images/svg/account_icon.svg',
                                          height: Get.height * 0.015,
                                          color: AppColor().primaryWhite),
                                      Gap(Get.height * 0.01),
                                      CustomText(
                                          title: _isFollowing
                                              ? "Unfollow"
                                              : 'Follow',
                                          weight: FontWeight.w400,
                                          size: Get.height * 0.017,
                                          fontFamily: 'GilroyRegular',
                                          color: AppColor().primaryWhite),
                                    ]),
                        ),
                      ),
                      Gap(Get.height * 0.02),
                      Expanded(
                        child: CustomFillOption(
                          buttonColor: AppColor()
                              .primaryBackGroundColor
                              .withOpacity(0.7),
                          borderColor: AppColor().greyEight,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: AppColor().primaryBgColor,
                              content: const ComingSoonPopup(),
                            ),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sms_outlined,
                                  color: AppColor().primaryWhite,
                                  size: Get.height * 0.015,
                                ),
                                Gap(Get.height * 0.01),
                                CustomText(
                                    title: 'Message',
                                    weight: FontWeight.w400,
                                    size: Get.height * 0.017,
                                    fontFamily: 'GilroyRegular',
                                    color: AppColor().primaryWhite),
                                Gap(Get.height * 0.01),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColor().primaryColor,
                                  size: Get.height * 0.015,
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
                title: widget.userData.bio ?? "",
                weight: FontWeight.w400,
                size: 14,
                fontFamily: 'GilroyRegular',
                textAlign: TextAlign.center,
                height: 1.5,
                color: AppColor().greyFour),
            Visibility(
                visible: widget.userData.id != authController.user!.id,
                child: Gap(Get.height * 0.02)),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: AppColor().primaryBgColor,
                  content: const ComingSoonPopup(),
                ),
              ),
              child: CustomText(
                  title: 'See full profile',
                  weight: FontWeight.w400,
                  size: Get.height * 0.017,
                  fontFamily: 'GilroyMedium',
                  underline: TextDecoration.underline,
                  color: AppColor().primaryColor),
            ),
          ],
        ),
      ),
      Divider(
        color: AppColor().lightItemsColor.withOpacity(0.3),
        height: Get.height * 0.05,
        thickness: 4,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: PageHeaderWidget(
          onTap: () {},
          title: 'Media, Links and Document',
        ),
      ),
      Gap(Get.height * 0.02),
      const ComingSoonWidget(),
      // SizedBox(
      //   height: Get.height * 0.12,
      //   child: ListView.separated(
      //       physics: const ScrollPhysics(),
      //       padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
      //       shrinkWrap: true,
      //       scrollDirection: Axis.horizontal,
      //       separatorBuilder: (context, index) => Gap(Get.height * 0.01),
      //       itemCount: mediaItems.length,
      //       itemBuilder: (context, index) {
      //         var item = mediaItems[index];
      //         return Container(
      //           padding: EdgeInsets.all(Get.height * 0.02),
      //           width: Get.width * 0.25,
      //           decoration: BoxDecoration(
      //             color: AppColor().bgDark,
      //             borderRadius: BorderRadius.circular(10),
      //             border: Border.all(
      //               color: AppColor().greySix,
      //             ),
      //             image: DecorationImage(
      //               image: AssetImage(item.image!),
      //               fit: BoxFit.fitWidth,
      //               alignment: Alignment.topCenter,
      //             ),
      //           ),
      //         );
      //       }),
      // ),
      Gap(Get.height * 0.04),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              title: 'Follow my socials:',
              fontFamily: 'GilroySemiBold',
              size: 16,
              color: AppColor().primaryWhite,
            ),
            Gap(Get.height * 0.02),
          ],
        ),
      ),
      Gap(Get.height * 0.02),
      const ComingSoonWidget(),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
      //   child: Row(
      //     children: [
      //       SvgPicture.asset('assets/images/svg/discord.svg'),
      //       Gap(Get.height * 0.01),
      //       SvgPicture.asset('assets/images/svg/twitter.svg'),
      //       Gap(Get.height * 0.01),
      //       SvgPicture.asset('assets/images/svg/telegram.svg'),
      //       Gap(Get.height * 0.01),
      //       SvgPicture.asset('assets/images/svg/meduim.svg'),
      //     ],
      //   ),
      // ),
      Gap(Get.height * 0.02),
    ]);
  }
}
