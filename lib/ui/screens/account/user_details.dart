import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:dio/dio.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/model/user_profile.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/screens/account/team/account_teams_details.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/ui/screens/game/games_played_details.dart';
import 'package:e_sport/ui/widgets/utils/page_header.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/ui/screens/post/post_details.dart';
import 'package:e_sport/ui/screens/post/report_page.dart';
import 'package:e_sport/ui/widgets/community/community_owned_item.dart';
import 'package:e_sport/ui/widgets/profile/profile_action_buttons.dart';
import 'package:e_sport/ui/widgets/profile/profile_header.dart';
import 'package:e_sport/ui/widgets/profile/profile_ownership.dart';
import 'package:e_sport/ui/widgets/profile/profile_recent_posts.dart';
import 'package:e_sport/ui/widgets/profile/profile_sections.dart';
import 'package:e_sport/ui/widgets/profile/profile_social_links.dart';
import 'package:e_sport/ui/widgets/profile/profile_stats.dart';
import 'package:e_sport/ui/widgets/profile/recent_posts.dart';
import 'package:e_sport/ui/screens/team/teams_owned_item.dart';
import 'package:e_sport/ui/widgets/profile/user_game_played_item.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/utils/coming_soon.dart';
import 'package:e_sport/ui/widgets/utils/coming_soon_popup.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class UserDetails extends StatelessWidget {
  final String slug;
  const UserDetails({super.key, required this.slug});

  Future<UserDataWithFollowers> fetchUserProfile(String token) async {
    try {
      final dio = Dio();
      dio.options.headers = {
        "Content-Type": "application/json",
        "Authorization": 'JWT $token'
      };

      final response = await dio.get(
        ApiLink.getUserDataWithFollowers(slug: slug),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          return UserDataWithFollowers.fromJson(responseData['data']);
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load profile');
        }
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
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
  final List<bool> _isOpen2 = [true, true];
  final List<bool> _isOpen3 = [false];
  final playerItem = Get.put(PlayerRepository());
  List<PostModel> _recentPosts = [];
  bool _fetchingPosts = false;
  List<CommunityModel> _ownedCommunities = [];
  List<TeamModel> _ownedTeams = [];

  Future fetchRecentPosts() async {
    setState(() {
      _fetchingPosts = true;
    });
    var response = await http.get(
        Uri.parse(ApiLink.postFromGroup(widget.userData.slug!, "user")),
        headers: {
          "Authorization": "JWT ${authController.token}",
          "Content-type": "application/json"
        });

    var json = jsonDecode(response.body);
    print(response.body);
    var list = List.from(json['data']);

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
        await authController.getProfileFollowerList(widget.userData.slug!);
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

  Future<void> getOwnedCommunities() async {
    try {
      final dio = Dio();
      dio.options.headers = {"Authorization": "JWT ${authController.token}"};

      final response = await dio.get(
        ApiLink.getCommunityByOwner(widget.userData.slug!),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          final list = List.from(responseData['data']);
          final communities =
              list.map((e) => CommunityModel.fromJson(e)).toList();
          setState(() {
            _ownedCommunities = communities;
          });
        } else {
          print("Error: ${responseData['message']}");
        }
      }
    } catch (e) {
      print("Error fetching owned communities: $e");
    }
  }

  Future<void> getOwnedTeams() async {
    try {
      final dio = Dio();
      dio.options.headers = {"Authorization": "JWT ${authController.token}"};

      final response = await dio.get(
        ApiLink.getTeamByOwner(widget.userData.slug!),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          final teamsData = responseData['data'];
          final teams =
              (teamsData as List).map((e) => TeamModel.fromJson(e)).toList();
          setState(() {
            _ownedTeams = teams;
          });
        } else {
          print("Error: ${responseData['message']}");
        }
      }
    } catch (e) {
      print("Error fetching owned teams: $e");
    }
  }

  @override
  initState() {
    getFollowersList();
    fetchRecentPosts();
    getOwnedCommunities();
    getOwnedTeams();
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
          size: 12,
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
          onTap: () async {
            await Share.share(
                '${widget.userData.userName} on Esports NG \nhttps://esportsng.com/${widget.userData.userName}');
          },
          value: '3',
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: popUpMenuItems(
              icon: Icons.share_outlined, title: 'Share Profile'),
        ),
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

  showPopUpMenu2() async {
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
          onTap: () async {
            await Share.share(
                '${widget.userData.userName} on Esports NG \nhttps://esportsng.com/${widget.userData.userName}');
          },
          value: '3',
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: popUpMenuItems(
              icon: Icons.share_outlined, title: 'Share Profile'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ProfileHeader(
        userData: widget.userData,
        onBackPressed: () => Get.back(),
        onMenuPressed: () => widget.userData.id == authController.user!.id
            ? showPopUpMenu2()
            : showPopUpMenu(),
      ),
      ProfileUserInfo(userData: widget.userData),
      ProfileStats(
        followersCount: followersCount!,
        followingCount: followingCount!,
      ),

      // Show follow/message buttons only for other users' profiles
      Visibility(
        visible: widget.userData.id != authController.user!.id!,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
          child: Column(
            children: [
              Gap(Get.height * 0.04),
              ProfileActionButtons(
                isFollowing: _isFollowing,
                isLoading: _isLoading,
                onFollowTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  var message =
                      await authController.followUser(widget.userData.slug!);

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
                onMessageTap: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: AppColor().primaryBgColor,
                    content: const ComingSoonPopup(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      Gap(Get.height * 0.02),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: CustomText(
            title: widget.userData.bio ?? "",
            size: 14,
            fontFamily: 'Inter',
            textAlign: TextAlign.center,
            height: 1.5,
            color: AppColor().greyFour),
      ),
      Gap(Get.height * 0.02),

      // Section for Recent Posts
      SectionDivider(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: PageHeaderWidget(
          onTap: () {},
          title: 'Recent Posts',
        ),
      ),
      Gap(Get.height * 0.02),
      ProfileRecentPosts(
        posts: _recentPosts,
        isLoading: _fetchingPosts,
      ),

      // Section for Player Profile
      SectionDivider(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomText(
            title: "Player Profile",
            size: 16,
            color: AppColor().primaryWhite,
            fontFamily: "InterSemiBold",
          ),
          ProfileExpandableSection(
            title: "Games Played",
            emptyMessage: "No game played",
            isEmpty: playerItem.allPlayer
                .where((e) => e.player!.id == widget.userData.id)
                .toList()
                .isEmpty,
            count: playerItem.allPlayer
                .where((e) => e.player!.id == widget.userData.id)
                .toList()
                .take(5)
                .length
                .toString(),
            isExpanded: _isOpen[0],
            onExpansionChanged: (isExpanded) {
              setState(() {
                _isOpen[0] = isExpanded;
              });
            },
            expandedContent: Column(
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
                          .where((e) => e.player!.id == widget.userData.id)
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
          ),
          ProfileExpandableSection(
            title: "Team History",
            isExpanded: _isOpen3[0],
            isEmpty: true,
            onExpansionChanged: (isExpanded) {
              setState(() {
                _isOpen3[0] = isExpanded;
              });
            },
            expandedContent: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: Get.height * 0.17,
                ),
                Gap(Get.height * 0.02),
                InkWell(
                  onTap: () {},
                  child: Center(
                    child: CustomText(
                        title: 'See all',
                        size: 14,
                        fontFamily: 'InterMedium',
                        underline: TextDecoration.underline,
                        color: AppColor().primaryColor),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),

      // Section for Ownerships
      SectionDivider(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomText(
            title: "Ownerships",
            size: 16,
            color: AppColor().primaryWhite,
            fontFamily: "InterSemiBold",
          ),
          ProfileExpandableSection(
            title: "Teams Owned",
            isEmpty: _ownedTeams.isEmpty,
            count: _ownedTeams.length.toString(),
            isExpanded: _isOpen2[0],
            onExpansionChanged: (isExpanded) {
              setState(() {
                _isOpen2[0] = isExpanded;
              });
            },
            expandedContent: ProfileOwnedTeams(teams: _ownedTeams),
          ),
          ProfileExpandableSection(
            title: "Communities Owned",
            count: _ownedCommunities.length.toString(),
            isExpanded: _isOpen2[1],
            isEmpty: _ownedCommunities.isEmpty,
            onExpansionChanged: (isExpanded) {
              setState(() {
                _isOpen2[1] = isExpanded;
              });
            },
            expandedContent:
                ProfileOwnedCommunities(communities: _ownedCommunities),
          ),
        ]),
      ),
      Gap(Get.height * 0.02),

      // Other sections
      SectionDivider(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: PageHeaderWidget(
          onTap: () {},
          title: 'Livestreams',
        ),
      ),
      Gap(Get.height * 0.02),
      const ComingSoonWidget(),

      SectionDivider(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: PageHeaderWidget(
          onTap: () {},
          title: 'Qualifications',
        ),
      ),
      Gap(Get.height * 0.02),
      const ComingSoonWidget(),

      SectionDivider(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: PageHeaderWidget(
          onTap: () {},
          title: 'Media, Links and Document',
        ),
      ),
      Gap(Get.height * 0.02),
      const ComingSoonWidget(),

      SectionDivider(),

      // Social Links Section
      ProfileSocialLinks(socialLinks: [
        // Uncomment and add your social links as needed
        // SocialLink(
        //   iconPath: 'assets/images/svg/discord.svg',
        //   url: 'https://discord.com/username',
        //   onTap: () {/* handle tap */},
        // ),
        // SocialLink(
        //   iconPath: 'assets/images/svg/twitter.svg',
        //   url: 'https://twitter.com/username',
        //   onTap: () {/* handle tap */},
        // ),
        // SocialLink(
        //   iconPath: 'assets/images/svg/telegram.svg',
        //   url: 'https://t.me/username',
        //   onTap: () {/* handle tap */},
        // ),
        // SocialLink(
        //   iconPath: 'assets/images/svg/meduim.svg',
        //   url: 'https://medium.com/@username',
        //   onTap: () {/* handle tap */},
        // ),
      ]),
      Gap(Get.height * 0.02),
    ]);
  }
}
