// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/fixture_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/team/roaster_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/model/waitlist_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account_events/account_events_item.dart';
import 'package:e_sport/ui/account/account_events/components/tournament_details.dart';
import 'package:e_sport/ui/account/account_events/event_posts_and_announcements.dart';
import 'package:e_sport/ui/account/account_events/tournament_leaderboard.dart';
import 'package:e_sport/ui/components/account_community_detail.dart';
import 'package:e_sport/ui/components/choose_team_dialog.dart';
import 'package:e_sport/ui/components/participant_list.dart';
import 'package:e_sport/ui/components/team_participant_list.dart';
import 'package:e_sport/ui/events/components/fixture_item.dart';
import 'package:e_sport/ui/events/components/fixtures_and_results.dart';
import 'package:e_sport/ui/home/components/page_header.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/home/post/components/post_details.dart';
import 'package:e_sport/ui/leaderboard/ranking_card.dart';
import 'package:e_sport/ui/profiles/components/recent_posts.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/coming_soon.dart';
import 'package:e_sport/ui/widget/coming_soon_popup.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountTournamentDetail extends StatefulWidget {
  final EventModel item;
  const AccountTournamentDetail({super.key, required this.item});

  @override
  State<AccountTournamentDetail> createState() =>
      _AccountTournamentDetailState();
}

class _AccountTournamentDetailState extends State<AccountTournamentDetail> {
  final authController = Get.put(AuthRepository());
  final communityController = Get.put(CommunityRepository());
  final tournamentController = Get.put(TournamentRepository());
  final teamController = Get.put(TeamRepository());
  var eventController = Get.put(EventRepository());
  final postController = Get.put(PostRepository());
  List<FixtureModel> _fixturesList = [];

  List<PostModel> _posts = [];
  bool _isLoading = true;

  Future getEventPosts() async {
    setState(() {
      _isFetchingPosts = true;
    });
    var posts = await postController.getEventPosts(widget.item.id!);
    setState(() {
      _posts = posts;
      _isFetchingPosts = false;
    });
  }

  final _colors = [
    LinearGradient(
      colors: [
        AppColor().fixturePurple,
        AppColor().fixturePurple,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    LinearGradient(
      colors: [
        AppColor().darkGrey.withOpacity(0.8),
        AppColor().bgDark.withOpacity(0.005),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomCenter,
    ),
  ];

  List<Map<String, dynamic>>? _communityFollowers;
  bool _isFollowing = false;
  bool _isRegisterLoading = true;
  List<PlayerModel>? _participantList;
  List<RoasterModel>? _teamParticipantList;
  List<WaitlistModel>? _waitlist;
  bool _isRegistered = false;
  TeamModel? _registeredTeam;
  PlayerModel? _participantProfile;
  bool _isFetchingPosts = true;
  EventModel? _eventDetails;
  bool _isFetchingFixtures = true;

  Future getParticipants() async {
    if (widget.item.tournamentType == "team") {
      List<RoasterModel> teamParticipantList = await tournamentController
          .getTeamTournamentParticipants(widget.item.id!);
      setState(() {
        _teamParticipantList = teamParticipantList;
        if (teamParticipantList
            .where((e) => teamController.myTeam
                .where((item) => item.id == e.id)
                .isNotEmpty)
            .isNotEmpty) {
          _isRegistered = true;
          _registeredTeam ==
              teamParticipantList
                  .where((e) => teamController.myTeam
                      .where((item) => item.id == e.id)
                      .isNotEmpty)
                  .toList()[0];
        }
        _isRegisterLoading = false;
      });
    } else {
      List<PlayerModel> participantList =
          await tournamentController.getTournamentParticipants(widget.item.id!);
      List<WaitlistModel> waitlist =
          await tournamentController.getTournamentWaitlist(widget.item.id!);
      setState(() {
        _waitlist = waitlist;
        _participantList = participantList;
        if (participantList
                .where((element) =>
                    element.player!.id! == authController.user!.id!)
                .isNotEmpty ||
            waitlist
                .where((element) =>
                    element.player!.player!.id! == authController.user!.id!)
                .isNotEmpty) {
          _isRegistered = true;
          _participantProfile = participantList.isNotEmpty
              ? participantList
                  .where((element) =>
                      element.player!.id! == authController.user!.id!)
                  .toList()[0]
              : waitlist
                  .where((e) => e.player!.player!.id == authController.user!.id)
                  .toList()[0]
                  .player;
        }
        _isRegisterLoading = false;
      });
    }
  }

  Future getFixtures() async {
    setState(() {
      _isFetchingFixtures = true;
    });
    var fixturesList = await tournamentController.getFixtures(widget.item.id!);
    setState(() {
      _fixturesList = fixturesList;
      _isFetchingFixtures = false;
    });
  }

  Future getCommunityFollowers() async {
    var followers = await communityController
        .getCommunityFollowers(widget.item.community!.id!);
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

  Future getEventDetails() async {
    var event = await tournamentController.getEventDetails(widget.item.id!);
    setState(() {
      _eventDetails = event;
      _isLoading = false;
    });
    print(event.regEnd);
  }

  @override
  initState() {
    getCommunityFollowers();
    getParticipants();
    getFixtures();
    getEventDetails();
    getEventPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _eventDetails == null && _isLoading
          ? const Center(child: ButtonLoader())
          : SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Helpers().showImagePopup(
                        context, "${ApiLink.imageUrl}${widget.item.banner}"),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        _eventDetails!.banner == null
                            ? Container(
                                height: Get.height * 0.15,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/png/tournament_cover.png'),
                                      opacity: 0.2),
                                ),
                              )
                            : CachedNetworkImage(
                                height: Get.height * 0.15,
                                width: double.infinity,
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: SizedBox(
                                    height: Get.height * 0.05,
                                    width: Get.height * 0.05,
                                    child: CircularProgressIndicator(
                                        color: AppColor().primaryWhite,
                                        value: progress.progress),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: AppColor().primaryColor),
                                imageUrl:
                                    '${ApiLink.imageUrl}${_eventDetails!.banner}',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            '${ApiLink.imageUrl}${_eventDetails!.banner}'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                        Positioned(
                          top: Get.height * 0.1,
                          child: GestureDetector(
                            onTap: () => Helpers().showImagePopup(
                                context, "${_eventDetails!.profile}"),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                OtherImage(
                                    itemSize: Get.height * 0.1,
                                    image: '${_eventDetails!.profile}'),
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
                                  child: Icon(
                                    Icons.settings,
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
                  Gap(Get.height * 0.07),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Column(
                      children: [
                        CustomText(
                            title: _eventDetails!.name,
                            size: Get.height * 0.02,
                            fontFamily: 'InterBold',
                            color: AppColor().primaryWhite),
                        Gap(Get.height * 0.02),
                        AccountEventsItem(
                          item: _eventDetails!,
                          onDetailsPage: true,
                        ),
                        Gap(Get.height * 0.05),
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: DateTime.now().isAfter(_eventDetails!.regEnd!)
                              ? null
                              : () async {
                                  if (_eventDetails!.tournamentType == "team") {
                                    setState(() {
                                      _isRegisterLoading = true;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (context) => ChooseTeamDialog(
                                        id: _eventDetails!.id!,
                                        isRegistered: _isRegistered,
                                      ),
                                    );

                                    setState(() {
                                      _isRegisterLoading = false;
                                    });
                                  } else {
                                    setState(() {
                                      _isRegisterLoading = true;
                                    });
                                    if (_isRegistered) {
                                      await tournamentController
                                          .unregisterForEvent(
                                              _eventDetails!.id!,
                                              "player",
                                              _participantProfile!.id!);
                                      _isRegistered = false;
                                    } else {
                                      var success = await tournamentController
                                          .registerForTournament(
                                              _eventDetails!.id!);
                                      if (success) {
                                        setState(() {
                                          _isRegistered = true;
                                        });
                                      }
                                    }
                                    setState(() {
                                      _isRegisterLoading = false;
                                    });
                                  }
                                },
                          child: Container(
                            height: Get.height * 0.06,
                            width: Get.width,
                            decoration: BoxDecoration(
                              border: !_isRegisterLoading
                                  ? null
                                  : Border.all(
                                      width: 1,
                                      color: AppColor()
                                          .primaryColor
                                          .withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(30),
                              color: _isRegisterLoading
                                  ? Colors.transparent
                                  : AppColor().primaryColor,
                            ),
                            child: _isRegisterLoading
                                ? Center(
                                    child: SizedBox(
                                      width: Get.height * 0.03,
                                      height: Get.height * 0.03,
                                      child: CircularProgressIndicator(
                                        color: AppColor().primaryColor,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: CustomText(
                                    title:
                                        _eventDetails!.tournamentType == "team"
                                            ? "Pick Team"
                                            : _isRegistered
                                                ? "Unregister"
                                                : !DateTime.now().isAfter(
                                                        _eventDetails!.regEnd!)
                                                    ? 'Register Now'
                                                    : 'Registration Ended',
                                    color: AppColor().primaryWhite,
                                    size: Get.height * 0.018,
                                    fontFamily: 'InterMedium',
                                  )),
                          ),
                        ),
                        Gap(Get.height * 0.02),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomFillOption(
                                    buttonColor: AppColor()
                                        .primaryBackGroundColor
                                        .withOpacity(0.7),
                                    borderColor: AppColor().greyEight,
                                    onTap: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      String message =
                                          await authController.followCommunity(
                                              _eventDetails!.community!.id!);
                                      setState(() {
                                        if (message == "followed") {
                                          _isFollowing = true;
                                        } else if (message == "unfollowed") {
                                          _isFollowing = false;
                                        }
                                        _isLoading = false;
                                      });
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: _isLoading
                                            ? [
                                                Center(
                                                  child: SizedBox(
                                                    width: Get.height * 0.03,
                                                    height: Get.height * 0.03,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: AppColor()
                                                          .primaryColor,
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                )
                                              ]
                                            : [
                                                CustomText(
                                                    title: _isFollowing
                                                        ? "Unfollow"
                                                        : "Follow Community",
                                                    size: Get.height * 0.017,
                                                    fontFamily: 'Inter',
                                                    color: AppColor()
                                                        .primaryWhite),
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
                                        backgroundColor:
                                            AppColor().primaryBgColor,
                                        content: const ComingSoonPopup(),
                                      ),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                            Gap(Get.height * 0.03),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                    title: 'Tournament/Bracket Link: ',
                                    size: Get.height * 0.017,
                                    fontFamily: 'InterMedium',
                                    underline: TextDecoration.underline,
                                    color: AppColor().primaryWhite),
                                Gap(Get.height * 0.01),
                                InkWell(
                                  onTap: () => launchUrl(Uri.parse(
                                      _eventDetails!.linkForBracket!)),
                                  child: CustomText(
                                    title: _eventDetails!.linkForBracket,
                                    size: Get.height * 0.017,
                                    fontFamily: 'InterMedium',
                                    underline: TextDecoration.underline,
                                    color: AppColor().primaryColor,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Gap(Get.height * 0.02),
                            CustomText(
                                title: _eventDetails!.summary,
                                size: Get.height * 0.015,
                                fontFamily: 'Inter',
                                textAlign: TextAlign.center,
                                height: 1.5,
                                color: AppColor().greyFour),
                            // Gap(Get.height * 0.02),
                            // InkWell(
                            //   onTap: () =>
                            //       Get.to(() => TournamentDetails(item: _eventDetails!)),
                            //   child: CustomText(
                            //       title: 'See tournament details',
                            //
                            //       size: Get.height * 0.017,
                            //       fontFamily: 'InterMedium',
                            //       underline: TextDecoration.underline,
                            //       color: AppColor().primaryColor),
                            // ),
                          ],
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
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            title: 'Organising Community',
                            size: Get.height * 0.019,
                            fontFamily: 'InterSemiBold',
                            color: AppColor().primaryWhite),
                        Gap(Get.height * 0.02),
                        GestureDetector(
                          onTap: () => Get.to(AccountCommunityDetail(
                              item: _eventDetails!.community!)),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  _eventDetails!.community!.logo == null
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
                                          image:
                                              _eventDetails!.community!.logo),
                                      if (_eventDetails!.community!.isVerified!) SvgPicture.asset(
                                              "assets/images/svg/check_badge.svg",
                                              width: Get.height * 0.015),
                                ],
                              ),
                              Gap(Get.height * 0.015),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      title: _eventDetails!.community!.name!
                                          .toCapitalCase(),
                                      size: Get.height * 0.017,
                                      fontFamily: 'InterMedium',
                                      color: AppColor().primaryWhite),
                                  Gap(Get.height * 0.005),
                                  CustomText(
                                      title: 'No members',
                                      size: Get.height * 0.015,
                                      fontFamily: 'Inter',
                                      textAlign: TextAlign.left,
                                      height: 1.5,
                                      color: AppColor().greyEight),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Gap(Get.height * 0.01),
                        CustomText(
                            title: _eventDetails!.community!.bio != ''
                                ? _eventDetails!.community!.bio!
                                    .toSentenceCase()
                                : 'Bio: Nil',
                            size: Get.height * 0.015,
                            fontFamily: 'Inter',
                            textAlign: TextAlign.left,
                            height: 1.5,
                            color: AppColor().greyEight),
                        Gap(Get.height * 0.02),
                        GestureDetector(
                          onTap: () => Get.to(AccountCommunityDetail(
                              item: _eventDetails!.community!)),
                          child: Center(
                            child: CustomText(
                                title: 'See full profile',
                                size: Get.height * 0.017,
                                fontFamily: 'InterMedium',
                                underline: TextDecoration.underline,
                                color: AppColor().primaryColor),
                          ),
                        ),
                        Divider(
                          color: AppColor().lightItemsColor.withOpacity(0.3),
                          height: Get.height * 0.05,
                          thickness: 0.5,
                        ),
                        CustomText(
                            title: 'Partners',
                            size: Get.height * 0.019,
                            fontFamily: 'InterSemiBold',
                            color: AppColor().primaryWhite),
                        Gap(Get.height * 0.02),
                        Row(
                          children: [
                            _eventDetails!.community!.logo == null
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
                                    image: _eventDetails!.community!.logo),
                            Gap(Get.height * 0.015),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                    title: _eventDetails!.community!.name!
                                        .toCapitalCase(),
                                    size: Get.height * 0.017,
                                    fontFamily: 'InterMedium',
                                    color: AppColor().primaryWhite),
                                Gap(Get.height * 0.005),
                                CustomText(
                                    title: 'No members',
                                    size: Get.height * 0.015,
                                    fontFamily: 'Inter',
                                    textAlign: TextAlign.left,
                                    height: 1.5,
                                    color: AppColor().greyEight),
                              ],
                            ),
                          ],
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
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {
                        Get.to(() => EventPostsAndAnnouncements(
                              event: _eventDetails!,
                            ));
                      },
                      title: 'Announcements and Posts',
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: SizedBox(
                      width: double.infinity,
                      height: _isFetchingPosts || _posts.isEmpty ? 50 : 390,
                      child: _isFetchingPosts
                          ? const Center(child: ButtonLoader())
                          : _posts.isEmpty
                              ? Center(
                                  child: CustomText(
                                      title: "No posts",
                                      size: 16,
                                      fontFamily: "InterMedium",
                                      color: AppColor().lightItemsColor))
                              : ListView.separated(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      Gap(Get.height * 0.02),
                                  itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        Get.to(() =>
                                            PostDetails(item: _posts[index]));
                                      },
                                      child: SizedBox(
                                          width: Get.height * 0.35,
                                          child: PostItemForProfile(
                                              item: _posts[index]))),
                                  itemCount: _posts.length),
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
                      onTap: () {
                        Get.to(() => FixturesAndResults(
                              event: _eventDetails!,
                            ));
                      },
                      title: 'Fixtures and Results',
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: SizedBox(
                      width: double.infinity,
                      height: _isFetchingFixtures || _fixturesList.isEmpty
                          ? 50
                          : Get.height * 0.25,
                      child: _isFetchingFixtures
                          ? const Center(child: ButtonLoader())
                          : _fixturesList.isEmpty
                              ? Center(
                                  child: CustomText(
                                      title: "No fixtures",
                                      size: 16,
                                      fontFamily: "InterMedium",
                                      color: AppColor().lightItemsColor))
                              : ListView.separated(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      Gap(Get.height * 0.02),
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                          onTap: () {},
                                          child: FixtureCardScrollable(
                                              fixture: _fixturesList[index],
                                              backgroundColor: _colors[
                                                  index % _colors.length])),
                                  itemCount: _fixturesList.take(5).length),
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
                        Get.to(() => FixturesAndResults(
                              event: _eventDetails!,
                            ));
                      },
                      title: 'Livestreams',
                    ),
                  ),
                  Gap(Get.height * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: SizedBox(
                      width: double.infinity,
                      height: _isFetchingFixtures || _fixturesList.isEmpty
                          ? 50
                          : Get.height * 0.25,
                      child: _isFetchingFixtures
                          ? const Center(child: ButtonLoader())
                          : _fixturesList.isEmpty
                              ? Center(
                                  child: CustomText(
                                      title: "No streams",
                                      size: 16,
                                      fontFamily: "InterMedium",
                                      color: AppColor().lightItemsColor))
                              : ListView.separated(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      Gap(Get.height * 0.02),
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                          onTap: () {},
                                          child: FixtureCardScrollable(
                                              fixture: _fixturesList[index],
                                              backgroundColor: _colors[
                                                  index % _colors.length])),
                                  itemCount: _fixturesList.take(5).length),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: 'Tournament Details',
                          fontFamily: 'InterSemiBold',
                          size: 16,
                          color: AppColor().primaryWhite,
                        ),
                        Gap(Get.height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.02),
                          child: Column(
                            children: [
                              tournamentDetails(
                                  onTap: () {
                                    Get.to(() =>
                                        _eventDetails!.tournamentType == "team"
                                            ? TeamParticipantList(
                                                event: _eventDetails!)
                                            : ParticipantList(
                                                event: _eventDetails!,
                                              ));
                                  },
                                  title: 'Participants List'),
                              Divider(
                                  color: AppColor()
                                      .lightItemsColor
                                      .withOpacity(0.3),
                                  thickness: 0.5),
                              tournamentDetails(
                                  onTap: () => Get.to(() => TournamentDetails(
                                      title: "Tournament Structure",
                                      value: _eventDetails!.structure!)),
                                  title: 'Tournament Structure'),
                              Divider(
                                  color: AppColor()
                                      .lightItemsColor
                                      .withOpacity(0.3),
                                  thickness: 0.5),
                              tournamentDetails(
                                  onTap: () => Get.to(() => TournamentDetails(
                                      title: "Rules and Regulations",
                                      value: _eventDetails!.rulesRegs!)),
                                  title: 'Rules and regulations'),
                              Divider(
                                  color: AppColor()
                                      .lightItemsColor
                                      .withOpacity(0.3),
                                  thickness: 0.5),
                              tournamentDetails(
                                  onTap: () => Get.to(() => TournamentDetails(
                                      title: "Tournament Requirements",
                                      value: _eventDetails!.requirements!)),
                                  title: 'Tournament Requirements'),
                              Gap(Get.height * 0.01),
                            ],
                          ),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: PageHeaderWidget(
                      onTap: () {},
                      title: 'Tournament Staff',
                    ),
                  ),
                  const ComingSoonWidget(),
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
                        Get.to(
                            () => TournamentLeaderboard(event: _eventDetails!));
                      },
                      title: 'Tournament Leaderboard',
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: RankingCard(title: "Rankings"),
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
                      title: 'Other Tournaments',
                    ),
                  ),
                  const ComingSoonWidget(),
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
                  const ComingSoonWidget(),
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
              ),
            ),
    );
  }

  tournamentDetails({String? title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
                title: title,
                size: Get.height * 0.017,
                fontFamily: 'InterMedium',
                color: AppColor().greySix),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor().primaryColor,
              size: Get.height * 0.018,
            ),
          ],
        ),
      ),
    );
  }
}
