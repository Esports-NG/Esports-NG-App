import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/game/game_list_dropdown.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TeamAddGame extends StatefulWidget {
  const TeamAddGame({super.key, required this.team, this.game});
  final TeamModel team;
  final GamePlayed? game;

  @override
  State<TeamAddGame> createState() => _TeamAddGameState();
}

class _TeamAddGameState extends State<TeamAddGame> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final teamController = Get.put(TeamRepository());
  final tournamentController = Get.put(TournamentRepository());

  bool _isAdding = false;
  List<GamePlayed> _games = [];
  bool _loading = true;

  Future getGames() async {
    var dio = tournamentController.dio;
    var response = await dio.get(ApiLink.getUntrimmedGames);
    // print(response.data['data']);
    var gamesList = List<GamePlayed>.from(
        response.data['data'].map((x) => GamePlayed.fromJson(x)));
    setState(() {
      _games = gamesList;
      _loading = false;
    });
  }

  @override
  void initState() {
    if (widget.game != null) {
      print(widget.game);
      teamController.addToGamesPlayedValue.value = widget.game;
    }
    getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(
          title: 'Add Game To Your Team',
          fontFamily: 'InterSemiBold',
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
      body: _loading
          ? LoadingWidget()
          : Form(
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
                        fontFamily: 'Inter',
                        size: 14,
                      ),
                      Gap(Get.height * 0.01),
                      GameDropdown(
                        gameList: _games,
                        enableFill: true,
                        gameValue: teamController.addToGamesPlayedValue,
                      ),
                      Gap(Get.height * 0.02),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            _isAdding = true;
                          });
                          await teamController.addGameToTeam(widget.team.slug!);
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
                                      color: AppColor()
                                          .primaryColor
                                          .withOpacity(0.4))
                                  : null),
                          child: _isAdding
                              ? const Center(child: ButtonLoader())
                              : Center(
                                  child: CustomText(
                                      title: "Add Game",
                                      fontFamily: "InterSemiBold",
                                      color: AppColor().primaryWhite),
                                ),
                        ),
                      ),
                    ]),
              )),
    );
  }
}
