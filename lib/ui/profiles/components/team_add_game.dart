import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/game_list_dropdown.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TeamAddGame extends StatefulWidget {
  const TeamAddGame({super.key, required this.team});
  final TeamModel team;

  @override
  State<TeamAddGame> createState() => _TeamAddGameState();
}

class _TeamAddGameState extends State<TeamAddGame> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final teamController = Get.put(TeamRepository());
  bool _isAdding = false;

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
      body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            decoration: BoxDecoration(
                color: AppColor().primaryBackGroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.all(Get.height * 0.02),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                enableFill: true,
                gameValue: teamController.addToGamesPlayedValue,
              ),
              Gap(Get.height * 0.02),
              InkWell(
                onTap: () async {
                  setState(() {
                    _isAdding = true;
                  });
                  await teamController.addGameToTeam(widget.team.id!);
                  setState(() {
                    _isAdding = false;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                      color: _isAdding
                          ? Colors.transparent
                          : AppColor().primaryColor,
                      borderRadius: BorderRadius.circular(90),
                      border: _isAdding
                          ? Border.all(
                              color: AppColor().primaryColor.withOpacity(0.4))
                          : null),
                  child: _isAdding
                      ? Center(child: ButtonLoader())
                      : Center(
                          child: CustomText(
                              title: "Add Game",
                              weight: FontWeight.w600,
                              color: AppColor().primaryWhite),
                        ),
                ),
              ),
            ]),
          )),
    );
  }
}
