// ignore_for_file: deprecated_member_use

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
import 'package:e_sport/ui/screens/account/events/components/tournament_details.dart';
import 'package:e_sport/ui/screens/event/event_posts_and_announcements.dart';
import 'package:e_sport/ui/screens/event/fixtures_and_results.dart';
import 'package:e_sport/ui/screens/event/participant_list.dart';
import 'package:e_sport/ui/screens/team/team_participant_list.dart';
import 'package:e_sport/ui/widgets/events/tournament/tournament_announcements_section.dart';
import 'package:e_sport/ui/widgets/events/tournament/tournament_community_follow_button.dart';
import 'package:e_sport/ui/widgets/events/tournament/tournament_community_info_section.dart';
import 'package:e_sport/ui/widgets/events/tournament/tournament_details_section_widget.dart';
import 'package:e_sport/ui/widgets/events/tournament/tournament_fixtures_section.dart';
import 'package:e_sport/ui/widgets/events/tournament/tournament_header.dart';
import 'package:e_sport/ui/widgets/events/tournament/tournament_registration_button.dart';
import 'package:e_sport/ui/widgets/events/tournament/tournament_summary.dart';
import 'package:e_sport/ui/widgets/events/tournament/social_links_section.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/utils/page_header.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountTournamentDetail extends StatefulWidget {
  final EventModel item;
  const AccountTournamentDetail({super.key, required this.item});

  @override
  State<AccountTournamentDetail> createState() =>
      _AccountTournamentDetailState();
}

class _AccountTournamentDetailState extends State<AccountTournamentDetail> {
  // Controllers
  final authController = Get.put(AuthRepository());
  final communityController = Get.put(CommunityRepository());
  final tournamentController = Get.put(TournamentRepository());
  final teamController = Get.put(TeamRepository());
  final eventController = Get.put(EventRepository());
  final postController = Get.put(PostRepository());

  // State variables
  List<FixtureModel> _fixturesList = [];
  List<PostModel> _posts = [];
  List<Map<String, dynamic>>? _communityFollowers;
  bool _isLoading = true;
  bool _isFollowing = false;
  bool _isRegisterLoading = true;
  List<PlayerModel>? _participantList;
  List<RoasterModel>? _teamParticipantList;
  List<WaitlistModel>? _waitlist;
  bool _isRegistered = false;
  RoasterModel? _registeredTeam;
  PlayerModel? _participantProfile;
  bool _isFetchingPosts = true;
  EventModel? _eventDetails;
  bool _isFetchingFixtures = true;

  // Gradients for fixtures
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    getCommunityFollowers();
    getParticipants();
    getFixtures();
    getEventDetails();
    getEventPosts();
  }

  // Data fetching methods
  Future<void> getEventPosts() async {
    setState(() {
      _isFetchingPosts = true;
    });
    List<PostModel>? postsResponse =
        await postController.getEventPosts(widget.item.slug!);
    setState(() {
      _posts = postsResponse ?? [];
      _isFetchingPosts = false;
    });
  }

  Future<void> getParticipants() async {
    if (widget.item.tournamentType == "team") {
      await _getTeamParticipants();
    } else {
      await _getIndividualParticipants();
    }
  }

  Future<void> _getTeamParticipants() async {
    List<dynamic> participantResponse = (await tournamentController
        .getTeamTournamentParticipants(widget.item.slug!))!;
    List<RoasterModel> teamParticipantList =
        participantResponse.map((item) => RoasterModel.fromJson(item)).toList();

    setState(() {
      _teamParticipantList = teamParticipantList;

      // Check if user's team is registered
      if (teamParticipantList
          .where((e) =>
              teamController.myTeam.where((item) => item.id == e.id).isNotEmpty)
          .isNotEmpty) {
        _isRegistered = true;
        _registeredTeam = teamParticipantList
            .where((e) => teamController.myTeam
                .where((item) => item.id == e.id)
                .isNotEmpty)
            .toList()[0];
      }

      _isRegisterLoading = false;
    });
  }

  Future<void> _getIndividualParticipants() async {
    List<dynamic> participantResponse = (await tournamentController
        .getTournamentParticipants(widget.item.slug!))!;
    List<PlayerModel> participantList = List<PlayerModel>.from(
        participantResponse.map((item) => PlayerModel.fromJson(item)).toList());

    List<WaitlistModel> waitlist =
        (await tournamentController.getTournamentWaitlist(widget.item.slug!))!;

    setState(() {
      _waitlist = waitlist;
      _participantList = participantList;

      // Check if user is registered
      if (participantList
              .where(
                  (element) => element.player!.id! == authController.user!.id!)
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

  Future<void> getFixtures() async {
    setState(() {
      _isFetchingFixtures = true;
    });
    var fixturesList =
        await tournamentController.getFixtures(widget.item.slug!);
    setState(() {
      _fixturesList = fixturesList!;
      _isFetchingFixtures = false;
    });
  }

  Future<void> getCommunityFollowers() async {
    var followers = await communityController
        .getCommunityFollowers(widget.item.community!.slug!);
    setState(() {
      _communityFollowers = followers;
      _isFollowing = followers.any(
          (element) => element["user_id"]["id"] == authController.user!.id);
      _isLoading = false;
    });
  }

  Future<void> getEventDetails() async {
    var event = await tournamentController.getEventDetails(widget.item.slug!);
    setState(() {
      _eventDetails = event;
      _isLoading = false;
    });
  }

  void onRegistrationChanged() {
    setState(() {
      _isRegistered = !_isRegistered;
    });
    getParticipants();
  }

  void onFollowChanged(bool isFollowing) {
    setState(() {
      _isFollowing = isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _eventDetails == null && _isLoading
          ? const Center(child: ButtonLoader())
          : RefreshIndicator(
              onRefresh: () => getEventDetails(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Tournament Header with Banner and Profile Image
                    TournamentHeader(event: _eventDetails!),
                    Gap(Get.height * 0.07),

                    // Tournament Summary Section
                    TournamentSummary(eventDetails: _eventDetails!),
                    Gap(Get.height * 0.05),

                    // Registration Button
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: TournamentRegistrationButton(
                        eventDetails: _eventDetails!,
                        isRegistered: _isRegistered,
                        onRegistrationChanged: onRegistrationChanged,
                        participantSlug: _participantProfile?.slug,
                      ),
                    ),
                    Gap(Get.height * 0.02),

                    // Follow Community Button
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: TournamentCommunityFollowButton(
                        eventDetails: _eventDetails!,
                        isFollowing: _isFollowing,
                        onFollowChanged: onFollowChanged,
                      ),
                    ),

                    // Section Divider
                    _buildSectionDivider(),

                    // Community Info Section
                    TournamentCommunityInfoSection(
                        eventDetails: _eventDetails!),

                    // Section Divider
                    _buildSectionDivider(),

                    // Announcements Section
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: PageHeaderWidget(
                        onTap: () {
                          Get.to(() => EventPostsAndAnnouncements(
                              event: _eventDetails!));
                        },
                        title: 'Announcements and Posts',
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: TournamentAnnouncementsSection(
                        posts: _posts,
                        isFetchingPosts: _isFetchingPosts,
                      ),
                    ),

                    // Section Divider
                    _buildSectionDivider(),

                    // Fixtures Section
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: PageHeaderWidget(
                        onTap: () {
                          Get.to(
                              () => FixturesAndResults(event: _eventDetails!));
                        },
                        title: 'Fixtures and Results',
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: TournamentFixturesSection(
                        fixturesList: _fixturesList,
                        isFetchingFixtures: _isFetchingFixtures,
                        event: widget.item,
                        getFixtures: getFixtures,
                        backgroundColors: _colors,
                      ),
                    ),
                    Gap(Get.height * 0.005),

                    // Section Divider
                    _buildSectionDivider(),

                    // Tournament Details Section
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: _buildTournamentDetailsSection(),
                    ),
                    Gap(Get.height * 0.04),

                    // Social Links Section
                    const SocialLinksSection(),
                    Gap(Get.height * 0.02),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionDivider() {
    return Divider(
      color: AppColor().lightItemsColor.withOpacity(0.3),
      height: Get.height * 0.05,
      thickness: 4,
    );
  }

  Widget _buildTournamentDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Tournament Details',
          style: TextStyle(
            fontFamily: 'InterSemiBold',
            fontSize: 16,
            color: AppColor().primaryWhite,
          ),
        ),
        Gap(Get.height * 0.02),

        // Details Items
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
          child: Column(
            children: [
              _buildDetailItem(
                title: 'Participants List',
                onTap: () {
                  Get.to(() => _eventDetails!.tournamentType == "team"
                      ? TeamParticipantList(event: _eventDetails!)
                      : ParticipantList(event: _eventDetails!));
                },
              ),
              _buildDivider(),
              _buildDetailItem(
                title: 'Tournament Structure',
                onTap: () => Get.to(() => TournamentDetails(
                      title: "Tournament Structure",
                      value: _eventDetails!.structure!,
                    )),
              ),
              _buildDivider(),
              _buildDetailItem(
                title: 'Rules and regulations',
                onTap: () => Get.to(() => TournamentDetails(
                      title: "Rules and Regulations",
                      value: _eventDetails!.rulesRegs!,
                    )),
              ),
              _buildDivider(),
              _buildDetailItem(
                title: 'Tournament Requirements',
                onTap: () => Get.to(() => TournamentDetails(
                      title: "Tournament Requirements",
                      value: _eventDetails!.requirements!,
                    )),
              ),
              Gap(Get.height * 0.01),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(
      {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'InterMedium',
                color: AppColor().greySix,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColor().primaryColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColor().lightItemsColor.withOpacity(0.3),
      thickness: 0.5,
    );
  }
}
