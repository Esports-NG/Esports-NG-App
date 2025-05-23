import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/screens/game/game_profile.dart';
import 'package:e_sport/ui/screens/team/team_add_game.dart';
import 'package:e_sport/ui/screens/team/team_games_played_item.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TeamsGamesPlayedList extends StatefulWidget {
  final TeamModel team;
  const TeamsGamesPlayedList({super.key, required this.team});

  @override
  State<TeamsGamesPlayedList> createState() => _TeamsGamesPlayedListState();
}

class _TeamsGamesPlayedListState extends State<TeamsGamesPlayedList> {
  // final gamesController = Get.put(GamesRepository());
  final authController = Get.put(AuthRepository());
  final teamController = Get.put(TeamRepository());

  void _showTeamSelectionDialog() async {
    // We're already on the team's screen, just navigate to add game directly
    Get.to(() => TeamAddGame(team: widget.team));

    // For future enhancement: If we want to allow selecting from multiple teams:
    // If the user has multiple teams, show a dialog to select which team to add a game to
    /*
    await teamController.getMyTeam(false);
    
    if (teamController.myTeam.isEmpty) {
      // No teams available, show a message
      Get.snackbar(
        "No Teams Available", 
        "You don't have any teams. Create a team first to add games.",
        backgroundColor: AppColor().primaryDark,
        colorText: AppColor().primaryWhite,
      );
      return;
    } 
    
    // If the user only has one team and it's the current one, go directly to add game
    if (teamController.myTeam.length == 1 && teamController.myTeam[0].id == widget.team.id) {
      Get.to(() => TeamAddGame(team: widget.team));
      return;
    }
    
    // Show a dialog to select which team to add a game to
    Get.dialog(
      SimpleDialog(
        title: CustomText(
          title: "Select Team", 
          fontFamily: 'InterSemiBold',
          color: AppColor().primaryWhite,
        ),
        backgroundColor: AppColor().primaryDark,
        children: teamController.myTeam.map((team) => 
          SimpleDialogOption(
            onPressed: () {
              Get.back(); // Close dialog
              Get.to(() => TeamAddGame(team: team));
            },
            child: Row(
              children: [
                if (team.profilePicture != null)
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(team.profilePicture!),
                  ),
                Gap(10),
                Expanded(
                  child: CustomText(
                    title: team.name!,
                    fontFamily: 'InterMedium',
                    color: AppColor().primaryWhite,
                  ),
                ),
              ],
            ),
          )
        ).toList(),
      ),
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: CustomText(
            title: 'Games Played',
            fontFamily: 'InterSemiBold',
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
        floatingActionButton: authController.user!.id == widget.team.owner!.id
            ? FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: AppColor().primaryColor,
                onPressed: () => Get.to(() => TeamAddGame(team: widget.team)),
                child: Icon(
                  Icons.add,
                  color: AppColor().primaryWhite,
                ),
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Get.height * 0.02,
                    top: Get.height * 0.02,
                    bottom: Get.height * 0.01),
                child: CustomText(
                  title: 'Games Played By ${widget.team.name}:',
                  size: 14,
                  fontFamily: 'InterBold',
                  textAlign: TextAlign.start,
                  color: AppColor().greyTwo,
                ),
              ),
              widget.team.gamesPlayed == null ||
                      widget.team.gamesPlayed!.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(Get.height * 0.02),
                      child: Column(
                        children: [
                          CustomText(
                            title: 'This team does not play any games yet.',
                            size: 14,
                            fontFamily: 'InterMedium',
                            textAlign: TextAlign.center,
                            color: AppColor().greyTwo,
                          ),
                          Gap(Get.height * 0.02),
                          GestureDetector(
                            onTap: () {
                              _showTeamSelectionDialog();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CustomText(
                                title: 'Add Game To Team',
                                size: 16,
                                fontFamily: 'InterSemiBold',
                                textAlign: TextAlign.center,
                                color: AppColor().primaryColor,
                                underline: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(Get.height * 0.02),
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var item = widget.team.gamesPlayed![index];
                        return InkWell(
                          onTap: () => Get.to(() => GameProfile(game: item)),
                          child: TeamsGamesPlayedItemForList(
                            game: item,
                            team: TeamModel(),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Gap(Get.height * 0.02),
                      itemCount: widget.team.gamesPlayed!.length,
                    ),

              // Add option to add more games even if the team already plays some games
              if (authController.user!.id == widget.team.owner!.id &&
                  widget.team.gamesPlayed != null &&
                  widget.team.gamesPlayed!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.height * 0.02,
                      vertical: Get.height * 0.01),
                  child: GestureDetector(
                    onTap: () {
                      _showTeamSelectionDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomText(
                        title: 'Add More Games To Team',
                        size: 16,
                        fontFamily: 'InterSemiBold',
                        textAlign: TextAlign.center,
                        color: AppColor().primaryColor,
                        underline: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
