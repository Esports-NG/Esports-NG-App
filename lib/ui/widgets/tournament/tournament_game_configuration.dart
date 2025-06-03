import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/game/game_list_dropdown.dart';
import 'package:e_sport/ui/widgets/game/game_mode_dropdown.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/util/colors.dart';

class TournamentGameConfiguration extends StatelessWidget {
  final TournamentRepository tournamentController;
  final GamesRepository gameController;
  final List<GamePlayed> games;

  const TournamentGameConfiguration({
    super.key,
    required this.tournamentController,
    required this.gameController,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Games
            CustomText(
              title: 'Games you cover *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: 14,
            ),
            Gap(Get.height * 0.01),
            gameController.isLoading.value
                ? const ButtonLoader()
                : games.isEmpty
                    ? CustomText(
                        title:
                            "This community does not have a game. Please add a game to the community then try again.",
                        color: AppColor().primaryRed,
                      )
                    : GameDropdown(
                        gameList: games,
                        enableFill: tournamentController.isGame.value,
                        gameValue: tournamentController.gameValue,
                        handleTap: () => tournamentController.handleTap('game'),
                      ),
            Gap(Get.height * 0.02),

            // Game Modes
            CustomText(
              title: 'Game Modes',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: 14,
            ),
            Gap(Get.height * 0.01),
            tournamentController.gameValue.value != null
                ? GameModeDropDown(
                    gameModeController:
                        tournamentController.gameModesController.value,
                    gameValue: tournamentController.gameValue,
                    gameModeValue: tournamentController.gameModeValue,
                    enableFill: tournamentController.isGameMode.value,
                    handleTap: () => tournamentController.handleTap('gameMode'),
                  )
                : CustomText(
                    title: "Please select a game",
                    color: AppColor().primaryRed,
                  ),
          ],
        ));
  }
}
