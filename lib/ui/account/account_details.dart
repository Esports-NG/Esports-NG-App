import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/account_events/create_event.dart';
import 'package:e_sport/ui/components/account_community_widget.dart';
import 'package:e_sport/ui/components/account_event_widget.dart';
import 'package:e_sport/ui/components/account_team_widget.dart';
import 'package:e_sport/ui/components/games_played_widget.dart';
import 'package:e_sport/ui/components/my_post_widget.dart';
import 'package:e_sport/ui/home/post/create_post.dart';
import 'package:e_sport/ui/home/post/create_team.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountDetails extends StatefulWidget {
  final String title;
  const AccountDetails({super.key, required this.title});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  final communityController = Get.put(CommunityRepository());
  final teamController = Get.put(TeamRepository());
  final playerController = Get.put(PlayerRepository());
  final eventController = Get.put(EventRepository());

  int? accountTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(
          title: widget.title,
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: GoBackButton(onPressed: () => Get.back()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: AppColor().primaryWhite,
            ),
          ),
        ],
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      floatingActionButton: (widget.title == 'Wallet')
          ? null
          : (widget.title == 'Events')
              ? FloatingActionButton.extended(
                  backgroundColor: AppColor().primaryColor,
                  onPressed: () => Get.to(() => const CreateEvent()),
                  label: CustomText(
                    title: 'Create New Event',
                    color: AppColor().greyTwo,
                    weight: FontWeight.w400,
                    size: Get.height * 0.018,
                    fontFamily: 'GilroyMedium',
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColor().primaryColor),
                  child: IconButton(
                    onPressed: () {
                      if (widget.title == 'Posts') {
                        Get.to(() => const CreatePost());
                      } else if (widget.title == 'Player Profile') {
                        // Get.to(()=> const CreatePlayer());
                      } else if (widget.title == 'Teams') {
                        Get.to(() => const CreateTeamPage());
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.delayed(const Duration(seconds: 2), () {
            postController.getAllPost(false);
            communityController.getAllCommunity(false);
            teamController.getAllTeam(false);
            playerController.getAllPlayer(false);
            eventController.getAllTournaments(false);
            eventController.getAllSocialEvents(false);
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Divider(
                color: AppColor().primaryWhite.withOpacity(0.2),
                height: 1,
              ),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title == 'Posts') ...[
                      const MyPostWidget()
                    ] else if (widget.title == 'Player Profile') ...[
                      CustomText(
                        title: 'Games played',
                        size: 14,
                        fontFamily: 'GilroyMedium',
                        textAlign: TextAlign.start,
                        color: AppColor().greyTwo,
                      ),
                      Gap(Get.height * 0.01),
                      const GamesPlayedWidget()
                    ] else if (widget.title == 'Teams') ...[
                      const AccountTeamsWidget()
                    ] else if (widget.title == 'Communities') ...[
                      const AccountCommunityWidget()
                    ] else if (widget.title == 'Events') ...[
                      const AccountEventsWidget()
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
