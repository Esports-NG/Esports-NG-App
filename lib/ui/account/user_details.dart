import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/user_profile.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/components/games_played_details.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/home/post/components/report_page.dart';
import 'package:e_sport/ui/profiles/components/recent_posts.dart';
import 'package:e_sport/ui/profiles/components/user_game_played_item.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/coming_soon.dart';
import 'package:e_sport/ui/widget/coming_soon_popup.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
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
        "Authorization": 'JWT $token'
      },
    );

    var json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw (json['detail']);
    } else {
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
                    return SizedBox(
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
  final postController = Get.put(PostRepository());
  int? followersCount;
  int? followingCount;
  bool _isLoading = false;
  bool _isFollowing = false;
  final List<bool> _isOpen = [true];
  final List<bool> _isOpen2 = [false];
  final playerItem = Get.put(PlayerRepository());
  List<PostModel> _recentPosts = [];
  bool _fetchingPosts = false;

  Future fetchRecentPosts() async {
    setState(() {
      _fetchingPosts = true;
    });
    var response = await http.get(
        Uri.parse(ApiLink.postFromGroup(widget.userData.id!, "user")),
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
    fetchRecentPosts();
    setState(() {
      followersCount = widget.userData.followers;
      followingCount = widget.userData.following;
    });
    super.initState();
  }

  Row popUpMenuItems({String? title, IconData? icon}) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColor().primaryWhite,
          size: Get.height * 0.016,
        ),
        Gap(Get.height * 0.02),
        CustomText(
          title: title,
          size: Get.height * 0.014,
          fontFamily: 'InterMedium',
          textAlign: TextAlign.start,
          color: AppColor().primaryWhite,
        ),
      ],
    );
  }

  showPopUpMenu() async {
    String? selectedMenuItem = await showMenu(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide.none,
      ),
      constraints: const BoxConstraints(),
      color: AppColor().primaryMenu,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          value: '4',
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: popUpMenuItems(
              icon: Icons.volume_off_outlined,
              title: 'Mute/Unmute @${widget.userData.userName}'),
        ),
        PopupMenuItem(
          value: '5',
          height: 20,
          onTap: () async {
            await postController.blockUserOrPost(widget.userData.id!, "block");
          },
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: popUpMenuItems(
              icon: Icons.block_outlined,
              title: 'Block @${widget.userData.userName}'),
        ),
        PopupMenuItem(
          onTap: () =>
              Get.to(() => ReportPage(id: widget.userData.id!, type: "user")),
          value: '6',
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: popUpMenuItems(
              icon: Icons.flag, title: 'Report @${widget.userData.userName}'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          widget.userData.profile?.cover == null
              ? Container(
                  height: Get.height * 0.15,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/png/account_header.png'),
                        opacity: 0.2),
                  ),
                )
              : GestureDetector(
                  onTap: () => Helpers().showImagePopup(
                      context, "${widget.userData.profile!.cover}"),
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
                    imageUrl: '${widget.userData.profile!.cover}',
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
            top: Get.height * 0.11,
            child: GestureDetector(
              onTap: () => Helpers().showImagePopup(
                  context, "${widget.userData.profile!.profilePicture}"),
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
                Visibility(
                  visible: widget.userData.id != authController.user!.id,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => showPopUpMenu(),
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
        fontFamily: 'Inter',
        textAlign: TextAlign.start,
        color: AppColor().lightItemsColor,
      ),
      Gap(Get.height * 0.01),
      CustomText(
        title: widget.userData.fullName!.toCapitalCase(),
        size: 20,
        fontFamily: 'InterBold',
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
                  size: Get.height * 0.02,
                  fontFamily: 'InterBold',
                  color: AppColor().primaryWhite),
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
              CustomText(
                  title: followersCount.toString(),
                  size: Get.height * 0.02,
                  fontFamily: 'InterBold',
                  color: AppColor().primaryWhite),
              Gap(Get.height * 0.01),
              CustomText(
                  title: 'Followers',
                  size: Get.height * 0.017,
                  fontFamily: 'Inter',
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
                ],
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
                title: widget.userData.bio ?? "",
                size: 14,
                fontFamily: 'Inter',
                textAlign: TextAlign.center,
                height: 1.5,
                color: AppColor().greyFour),
            Visibility(
                visible: widget.userData.id != authController.user!.id,
                child: Gap(Get.height * 0.02)),
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
          title: 'Recent Posts',
        ),
      ),
      Gap(Get.height * 0.02),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: SizedBox(
          width: double.infinity,
          height: Get.height * 0.46,
          child: _fetchingPosts
              ? const Center(child: ButtonLoader())
              : _recentPosts.isEmpty
                  ? Center(
                      child: CustomText(
                          title: "No posts", color: AppColor().primaryWhite))
                  : ListView.separated(
                      reverse: true,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          Gap(Get.height * 0.02),
                      itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Get.to(
                                () => PostDetails(item: _recentPosts[index]));
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
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomText(
            title: "Player Profile",
            size: 16,
            color: AppColor().primaryWhite,
            fontFamily: "InterSemiBold",
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) => setState(() {
                _isOpen[panelIndex] = isExpanded;
              }),
              expandIconColor: AppColor().primaryColor,
              children: [
                ExpansionPanel(
                  isExpanded: _isOpen[0],
                  backgroundColor: AppColor().primaryBackGroundColor,
                  headerBuilder: (context, isExpanded) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          title: "Games Played",
                          size: 14,
                          color: AppColor().primaryWhite,
                        ),
                      ]),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: Get.height * 0.215,
                        child: ListView.separated(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              Gap(Get.height * 0.02),
                          itemCount: playerItem.allPlayer
                              .where((e) => e.player!.id == widget.userData.id)
                              .toList()
                              .take(5)
                              .length,
                          itemBuilder: (context, index) {
                            var item = playerItem.allPlayer
                                .where(
                                    (e) => e.player!.id == widget.userData.id)
                                .toList()[index];
                            return InkWell(
                              onTap: () =>
                                  Get.to(() => GamesPlayedDetails(item: item)),
                              child: UserGamesPlayedItem(player: item),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(
            thickness: 0.1,
            height: Get.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) => setState(() {
                _isOpen2[panelIndex] = isExpanded;
              }),
              expandIconColor: AppColor().primaryColor,
              children: [
                ExpansionPanel(
                  isExpanded: _isOpen2[0],
                  backgroundColor: AppColor().primaryBackGroundColor,
                  headerBuilder: (context, isExpanded) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          title: "Team History",
                          size: 14,
                          color: AppColor().primaryWhite,
                        ),
                      ]),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: Get.height * 0.17,
                        // child: ListView.separated(
                        //     physics: const ScrollPhysics(),
                        //     shrinkWrap: true,
                        //     scrollDirection: Axis.horizontal,
                        //     separatorBuilder: (context, index) =>
                        //         Gap(Get.height * 0.02),
                        //     itemCount:
                        //         widget.item.gamesPlayed!.length,
                        //     itemBuilder: (context, index) {
                        //       return InkWell(
                        //           onTap: () {
                        //             Get.to(() => GameProfile(
                        //                 game: widget.item
                        //                     .gamesPlayed![index]));
                        //           },
                        //           child: TeamsGamesPlayedItem(
                        //             game: widget
                        //                 .item.gamesPlayed![index],
                        //             team: TeamModel(),
                        //           ));
                        //     }),
                      ),
                      Gap(Get.height * 0.02),
                      InkWell(
                        onTap: () {},
                        child: Center(
                          child: CustomText(
                              title: 'See all',
                              size: Get.height * 0.017,
                              fontFamily: 'InterMedium',
                              underline: TextDecoration.underline,
                              color: AppColor().primaryColor),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
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
          title: 'Qualifications',
        ),
      ),
      Gap(Get.height * 0.02),
      const ComingSoonWidget(),
      Divider(
        color: AppColor().lightItemsColor.withOpacity(0.3),
        height: Get.height * 0.05,
        thickness: 4,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: PageHeaderWidget(
          onTap: () {},
          title: 'Ownerships',
        ),
      ),
      Gap(Get.height * 0.02),
      const ComingSoonWidget(),
      Divider(
        color: AppColor().lightItemsColor.withOpacity(0.3),
        height: Get.height * 0.05,
        thickness: 4,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: PageHeaderWidget(
          onTap: () {},
          title: 'Social Events',
        ),
      ),
      Gap(Get.height * 0.02),
      const ComingSoonWidget(),
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
      Divider(
        color: AppColor().lightItemsColor.withOpacity(0.3),
        height: Get.height * 0.05,
        thickness: 4,
      ),

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
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              title: 'Follow my socials:',
              fontFamily: 'InterSemiBold',
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
