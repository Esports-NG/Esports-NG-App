// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account_community/edit_community_profile.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/home/post/components/report_page.dart';
import 'package:e_sport/ui/profiles/components/community_games_covered_item.dart';
import 'package:e_sport/ui/profiles/components/community_games_covered_list.dart';
import 'package:e_sport/ui/profiles/components/recent_posts.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/coming_soon.dart';
import 'package:e_sport/ui/widget/coming_soon_popup.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
  final gamesController = Get.put(GamesRepository());
  final postController = Get.put(PostRepository());

  List<PostModel> _recentPosts = [];
  bool _fetchingPosts = false;

  Future fetchRecentPosts() async {
    setState(() {
      _fetchingPosts = true;
    });
    var response = await http.get(
        Uri.parse(ApiLink.postFromGroup(widget.item.id!, "comm")),
        headers: {
          "Authorization": "JWT ${authController.token}",
          "Content-type": "application/json"
        });

    var json = jsonDecode(response.body);
    var list = List.from(json);

    setState(() {
      _recentPosts = list.map((e) => PostModel.fromJson(e)).toList();
      _fetchingPosts = false;
    });
  }

  List<Map<String, dynamic>>? _communityFollowers;
  bool _isFollowing = false;
  bool _isLoading = true;
  int? followerCount;
  int? followingCount;
  CommunityModel? details;

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
  void initState() {
    getCommunityFollowers();
    getDetails();
    fetchRecentPosts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getDetails();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: details != null
            ? Column(
                children: [
                  GestureDetector(
                    onTap: () =>
                        Helpers().showImagePopup(context, "${details!.cover}"),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        details!.cover == null
                            ? Container(
                                height: Get.height * 0.15,
                                width: Get.width,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/png/community_cover.png'),
                                      fit: BoxFit.cover,
                                      opacity: 0.2),
                                ),
                              )
                            : CachedNetworkImage(
                                height: Get.height * 0.15,
                                width: Get.width,
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: SizedBox(
                                    height: Get.height * 0.02,
                                    width: Get.height * 0.02,
                                    child: CircularProgressIndicator(
                                        color: AppColor().primaryColor,
                                        value: progress.progress),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: AppColor().primaryColor),
                                imageUrl: details!.cover!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(details!.cover!),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                        Positioned(
                          top: Get.height * 0.1,
                          child: GestureDetector(
                            onTap: () => Helpers()
                                .showImagePopup(context, "${details!.logo}"),
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
                                  onTap: () async {
                                    await showMenu(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide.none),
                                      constraints: const BoxConstraints(),
                                      color: AppColor().primaryMenu,
                                      position: const RelativeRect.fromLTRB(
                                          100, 100, 0, 0),
                                      items: widget.item.owner!.id! ==
                                              authController.user!.id!
                                          ? [
                                              PopupMenuItem(
                                                  value: "0",
                                                  onTap: () async {
                                                    await Get.to(() =>
                                                            EditCommunityPage(
                                                                community:
                                                                    details!))
                                                        ?.whenComplete(
                                                            () async {
                                                      await getDetails();
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(CupertinoIcons.pen,
                                                          color: AppColor()
                                                              .primaryWhite),
                                                      const Gap(10),
                                                      CustomText(
                                                        title: 'Edit Community',
                                                        color: AppColor()
                                                            .primaryWhite,
                                                      )
                                                    ],
                                                  )),
                                              PopupMenuItem(
                                                  value: "1",
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                          CupertinoIcons.delete,
                                                          color: AppColor()
                                                              .primaryRed),
                                                      const Gap(10),
                                                      CustomText(
                                                        title:
                                                            'Delete Community',
                                                        color: AppColor()
                                                            .primaryRed,
                                                      )
                                                    ],
                                                  )),
                                            ]
                                          : [
                                              PopupMenuItem(
                                                onTap: () async {
                                                  await communityController
                                                      .blockCommunity(
                                                          widget.item.id!);
                                                },
                                                value: '2',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.block,
                                                        color: AppColor()
                                                            .primaryWhite),
                                                    const Gap(10),
                                                    CustomText(
                                                      title: 'Block Community',
                                                      color: AppColor()
                                                          .primaryWhite,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                onTap: () {
                                                  Get.to(ReportPage(
                                                      id: widget.item.id!,
                                                      type: "community"));
                                                },
                                                value: '3',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.report,
                                                      color: AppColor()
                                                          .primaryWhite,
                                                    ),
                                                    const Gap(10),
                                                    CustomText(
                                                      title: 'Report Community',
                                                      color: AppColor()
                                                          .primaryWhite,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                    );
                                  },
                                  child: Icon(Icons.more_vert,
                                      color: AppColor().primaryWhite),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(Get.height * 0.07),
                  CustomText(
                      title: details!.name,
                      size: Get.height * 0.02,
                      fontFamily: 'InterBold',
                      color: AppColor().primaryWhite),
                  Gap(Get.height * 0.01),
                  CustomText(
                      title: 'No Member',
                      size: Get.height * 0.017,
                      fontFamily: 'Inter',
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
                                  size: Get.height * 0.02,
                                  fontFamily: 'InterBold',
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
                              size: Get.height * 0.017,
                              fontFamily: 'Inter',
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
                                  size: Get.height * 0.02,
                                  fontFamily: 'InterBold',
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
                              size: Get.height * 0.017,
                              fontFamily: 'Inter',
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
                                                size: Get.height * 0.017,
                                                fontFamily: 'Inter',
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
                                borderColor: AppColor().darkGrey,
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
                                          size: Get.height * 0.017,
                                          fontFamily: 'Inter',
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
                          borderColor: AppColor().darkGrey,
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
                              size: Get.height * 0.017,
                              fontFamily: 'Inter',
                              color: AppColor().primaryWhite),
                        ),
                        Gap(Get.height * 0.02),
                        CustomFillOption(
                          buttonColor: AppColor()
                              .primaryBackGroundColor
                              .withOpacity(0.7),
                          borderColor: AppColor().darkGrey,
                          onTap: () {},
                          child: CustomText(
                              title: 'Join community',
                              size: Get.height * 0.017,
                              fontFamily: 'Inter',
                              color: AppColor().primaryWhite),
                        ),
                        Gap(Get.height * 0.04),
                        CustomText(
                            title: details?.bio,
                            size: Get.height * 0.015,
                            fontFamily: 'Inter',
                            textAlign: TextAlign.center,
                            height: 1.5,
                            color: AppColor().greyEight),
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
                              size: Get.height * 0.019,
                              fontFamily: 'InterSemiBold',
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
                                    size: Get.height * 0.017,
                                    fontFamily: 'InterMedium',
                                    color: AppColor().primaryWhite),
                              ],
                            ),
                          ),
                          Gap(Get.height * 0.01),
                          CustomText(
                              title: details?.owner?.bio,
                              size: Get.height * 0.015,
                              fontFamily: 'Inter',
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
                                  size: Get.height * 0.017,
                                  fontFamily: 'InterMedium',
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
                      title: 'Recent Posts',
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: SizedBox(
                      width: double.infinity,
                      height: Get.height * 0.46,
                      child: _fetchingPosts
                          ? const Center(child: ButtonLoader())
                          : _recentPosts.isEmpty
                              ? Center(
                                  child: CustomText(
                                      title: "No Posts",
                                      color: AppColor().primaryWhite))
                              : ListView.separated(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      Gap(Get.height * 0.02),
                                  itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        Get.to(() => PostDetails(
                                            item: _recentPosts[index]));
                                      },
                                      child: SizedBox(
                                          width: Get.height * 0.35,
                                          child: PostItemForProfile(
                                              item: _recentPosts[index]))),
                                  itemCount: _recentPosts.length),
                    ),
                  ),
                  Gap(Get.height * 0.005),
                  Divider(
                    color: AppColor().lightItemsColor.withOpacity(0.3),
                    height: Get.height * 0.05,
                    thickness: 4,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {
                        Get.to(() => CommunityGamesCoveredList(
                              community: widget.item,
                            ));
                      },
                      title: 'Games Covered',
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  SizedBox(
                    height: Get.height * 0.17,
                    width: double.infinity,
                    child: details!.gamesPlayed!.isEmpty
                        ? Center(
                            child: CustomText(
                              title: "No game added yet",
                              color: AppColor().primaryWhite,
                              // fontFamily: "InterMedium",
                              size: 16,
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.height * 0.02),
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                Gap(Get.height * 0.02),
                            itemCount: details!.gamesPlayed!.take(5).length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    Get.to(() => GameProfile(
                                        game: details!.gamesPlayed![index]));
                                  },
                                  child: CommunityGamesCoveredItem(
                                    game: details!.gamesPlayed![index],
                                  ));
                            }),
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
                      title: 'Tournaments',
                    ),
                  ),
                  NoItemPage(title: 'Tournaments', size: Get.height * 0.05),
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
                      title: 'Social Events',
                    ),
                  ),
                  NoItemPage(title: 'Social events', size: Get.height * 0.05),
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
                      title: 'Media, Links and Documents',
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  const ComingSoonWidget(),
                  Gap(Get.height * 0.04),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          title: 'Join our Community:',
                          fontFamily: 'InterSemiBold',
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
