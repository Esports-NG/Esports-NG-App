import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/game_list_dropdown.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TeamAddGame extends StatefulWidget {
  const TeamAddGame({super.key});

  @override
  State<TeamAddGame> createState() => _TeamAddGameState();
}

class _TeamAddGameState extends State<TeamAddGame> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final tournamentController = Get.put(TournamentRepository());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(
          title: 'Add Game To Your Team',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: GoBackButton(onPressed: () => Get.back()),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.settings,
        //       color: AppColor().primaryWhite,
        //     ),
        //   ),
        // ],
      ),
      body: Obx(() => Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          decoration: BoxDecoration(
                    color: AppColor().primaryBackGroundColor,
                    borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Game to be played *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                GameDropdown(
                    gamePlayedController: tournamentController.gamePlayedController,
                    enableFill: tournamentController.isGame.value,
                    gameValue: tournamentController.gameValue,
                    handleTap: () => tournamentController.handleTap('game')),
                Gap(Get.height * 0.05),
                CustomFillButton(
                          buttonText: "Add Game",
                          onTap: () {
                            tournamentController.createTournament();
                          })
              ]
          ),
        )
      )),
    );
  }
}