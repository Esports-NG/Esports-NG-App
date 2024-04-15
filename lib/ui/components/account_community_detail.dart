// ignore_for_file: deprecated_member_use

import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/coming_soon_popup.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'no_item_page.dart';

class AccountCommunityDetail extends StatefulWidget {
  final CommunityModel item;
  const AccountCommunityDetail({super.key, required this.item});

  @override
  State<AccountCommunityDetail> createState() => _AccountCommunityDetailState();
}

class _AccountCommunityDetailState extends State<AccountCommunityDetail> {
  final authController = Get.put(AuthRepository());
  final communityController = Get.put(CommunityRepository());

  List<Map<String, dynamic>>? _communityFollowers;
  bool _isFollowing = false;
  bool _isLoading = true;
  int? followerCount;
  int? followingCount;
  Community? details;

  Future getCommunityFollowers() async {
    print(widget.item.id);
    var followers =
        await communityController.getCommunityFollowers(widget.item.id!);
    setState(() {
      _communityFollowers = followers;

      if (followers.any(
          (element) => element["user_id"]["id"] == authController.user!.id)) {
        _isFollowing = true;
      } else {
        _isFollowing = false;
      }
      _isLoading = false;
    });
  }

  Future getDetails() async {
    var communityDetails =
        await communityController.getCommunityData(widget.item.id!);
    setState(() {
      details = communityDetails;
      followerCount = details!.followers;
      followingCount = details!.following;
    });
  }

  @override
  initState() {
    getCommunityFollowers();
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: details != null
            ? Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: Get.height * 0.15,
                        width: Get.width,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/png/community_cover.png'),
                              fit: BoxFit.cover,
                              opacity: 0.2),
                        ),
                      ),
                      Positioned(
                        top: Get.height * 0.1,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            details!.logo == null
                                ? Container(
                                    height: Get.height * 0.1,
                                    width: Get.height * 0.1,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: SvgPicture.asset(
                                        'assets/images/svg/people.svg'),
                                  )
                                : OtherImage(
                                    itemSize: Get.height * 0.1,
                                    image: details!.logo),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GoBackButton(onPressed: () => Get.back()),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: Get.height * 0.02),
                              child: InkWell(
                                child: Icon(Icons.settings,
                                    color: AppColor().primaryWhite),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(Get.height * 0.07),
                  CustomText(
                      title: details!.name,
                      weight: FontWeight.w500,
                      size: Get.height * 0.02,
                      fontFamily: 'GilroyBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: 'No Member',
                      weight: FontWeight.w400,
                      size: Get.height * 0.017,
                      fontFamily: 'GilroyRegular',
                      color: AppColor().greyEight),
                  Gap(Get.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          followingCount != null
                              ? CustomText(
                                  title: followingCount?.toString(),
                                  weight: FontWeight.w500,
                                  size: Get.height * 0.02,
                                  fontFamily: 'GilroyBold',
                                  color: AppColor().primaryWhite)
                              : SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColor().primaryColor,
                                    strokeCap: StrokeCap.round,
                                    strokeWidth: 2,
                                  ),
                                ),
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
                          followerCount != null
                              ? CustomText(
                                  title: followerCount?.toString(),
                                  weight: FontWeight.w500,
                                  size: Get.height * 0.02,
                                  fontFamily: 'GilroyBold',
                                  color: AppColor().primaryWhite)
                              : SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColor().primaryColor,
                                    strokeCap: StrokeCap.round,
                                    strokeWidth: 2,
                                  ),
                                ),
                          Gap(Get.height * 0.01),
                          CustomText(
                              title: 'Follower(s)',
                              weight: FontWeight.w400,
                              size: Get.height * 0.017,
                              fontFamily: 'GilroyRegular',
                              color: AppColor().greyEight),
                        ],
                      ),
                    ],
                  ),
                  Gap(Get.height * 0.04),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomFillOption(
                                buttonColor:
                                    _isLoading ? Colors.transparent : null,
                                onTap: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  var message = await authController
                                      .followCommunity(details!.id!);

                                  if (message != "error") {
                                    setState(() {
                                      _isFollowing = !_isFollowing;
                                      if (message == "unfollowed") {
                                        followerCount = followerCount! - 1;
                                      } else {
                                        followerCount = followerCount! + 1;
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
                                                    ? 'Unfollow'
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                        Gap(Get.height * 0.02),
                        CustomFillOption(
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
                          child: CustomText(
                              title: 'Apply as a staff',
                              weight: FontWeight.w400,
                              size: Get.height * 0.017,
                              fontFamily: 'GilroyRegular',
                              color: AppColor().primaryWhite),
                        ),
                        Gap(Get.height * 0.02),
                        CustomFillOption(
                          buttonColor: AppColor()
                              .primaryBackGroundColor
                              .withOpacity(0.7),
                          borderColor: AppColor().greyEight,
                          onTap: () {},
                          child: CustomText(
                              title: 'Join community',
                              weight: FontWeight.w400,
                              size: Get.height * 0.017,
                              fontFamily: 'GilroyRegular',
                              color: AppColor().primaryWhite),
                        ),
                        Gap(Get.height * 0.04),
                        CustomText(
                            title: details?.bio,
                            weight: FontWeight.w400,
                            size: Get.height * 0.015,
                            fontFamily: 'GilroyRegular',
                            textAlign: TextAlign.center,
                            height: 1.5,
                            color: AppColor().greyEight),
                        Gap(Get.height * 0.02),
                        CustomText(
                            title: 'See full profile',
                            weight: FontWeight.w400,
                            size: Get.height * 0.017,
                            fontFamily: 'GilroyMedium',
                            underline: TextDecoration.underline,
                            color: AppColor().primaryColor),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              title: 'Community Owner',
                              weight: FontWeight.w400,
                              size: Get.height * 0.019,
                              fontFamily: 'GilroySemiBold',
                              color: AppColor().primaryWhite),
                          Gap(Get.height * 0.02),
                          InkWell(
                            onTap: () {
                              Get.to(
                                  () => UserDetails(id: details!.owner!.id!));
                            },
                            child: Row(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    details!.owner!.profile!.profilePicture ==
                                            null
                                        ? Container(
                                            height: Get.height * 0.04,
                                            width: Get.height * 0.04,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/svg/people.svg',
                                            ),
                                          )
                                        : OtherImage(
                                            itemSize: Get.height * 0.04,
                                            image: widget.item.owner!.profile!
                                                .profilePicture),
                                  ],
                                ),
                                Gap(Get.height * 0.015),
                                CustomText(
                                    title: details!.owner!.fullName!
                                        .toCapitalCase(),
                                    weight: FontWeight.w400,
                                    size: Get.height * 0.017,
                                    fontFamily: 'GilroyMedium',
                                    color: AppColor().primaryWhite),
                              ],
                            ),
                          ),
                          Gap(Get.height * 0.01),
                          CustomText(
                              title: details?.owner?.bio,
                              weight: FontWeight.w400,
                              size: Get.height * 0.015,
                              fontFamily: 'GilroyRegular',
                              textAlign: TextAlign.left,
                              height: 1.5,
                              color: AppColor().greyEight),
                          Gap(Get.height * 0.02),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                    () => UserDetails(id: details!.owner!.id!));
                              },
                              child: CustomText(
                                  title: 'See full profile',
                                  weight: FontWeight.w400,
                                  size: Get.height * 0.017,
                                  fontFamily: 'GilroyMedium',
                                  underline: TextDecoration.underline,
                                  color: AppColor().primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {},
                      title: 'Recent Post',
                    ),
                  ),
                  NoItemPage(title: 'Recent post', size: Get.height * 0.05),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {},
                      title: 'Games Covered',
                    ),
                  ),
                  NoItemPage(title: 'Games covered', size: Get.height * 0.05),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {},
                      title: 'Tournament',
                    ),
                  ),
                  NoItemPage(title: 'Tournament', size: Get.height * 0.05),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {},
                      title: 'Social Event',
                    ),
                  ),
                  NoItemPage(title: 'Social event', size: Get.height * 0.05),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {},
                      title: 'Community Staff',
                    ),
                  ),
                  NoItemPage(title: 'Community staff', size: Get.height * 0.05),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {},
                      title: 'Badges',
                    ),
                  ),
                  NoItemPage(title: 'Badges', size: Get.height * 0.05),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {},
                      title: 'Media, Links and Document',
                    ),
                  ),
                  Gap(Get.height * 0.01),
                  SizedBox(
                    height: Get.height * 0.12,
                    child: ListView.separated(
                        physics: const ScrollPhysics(),
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) =>
                            Gap(Get.height * 0.01),
                        itemCount: mediaItems.length,
                        itemBuilder: (context, index) {
                          var item = mediaItems[index];
                          return Container(
                            padding: EdgeInsets.all(Get.height * 0.02),
                            width: Get.width * 0.25,
                            decoration: BoxDecoration(
                              color: AppColor().bgDark,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColor().greySix,
                              ),
                              image: DecorationImage(
                                image: AssetImage(item.image!),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          );
                        }),
                  ),
                  Gap(Get.height * 0.04),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          title: 'Join our Community:',
                          fontFamily: 'GilroySemiBold',
                          size: 16,
                          color: AppColor().primaryWhite,
                        ),
                        Gap(Get.height * 0.02),
                      ],
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/images/svg/discord.svg'),
                        Gap(Get.height * 0.01),
                        SvgPicture.asset('assets/images/svg/twitter.svg'),
                        Gap(Get.height * 0.01),
                        SvgPicture.asset('assets/images/svg/telegram.svg'),
                        Gap(Get.height * 0.01),
                        SvgPicture.asset('assets/images/svg/meduim.svg'),
                      ],
                    ),
                  ),
                  Gap(Get.height * 0.02),
                ],
              )
            : SizedBox(
                height: Get.height,
                child: Center(
                    child: CircularProgressIndicator(
                  color: AppColor().primaryColor,
                ))),
      ),
    );
  }
}
