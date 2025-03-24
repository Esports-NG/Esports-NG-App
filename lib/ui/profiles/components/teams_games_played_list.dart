import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/profiles/components/team_add_game.dart';
import 'package:e_sport/ui/profiles/components/team_games_played_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
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
              ListView.separated(
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
                separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                itemCount: widget.team.gamesPlayed!.length,
              ),
            ],
          ),
        ));
  }
}
