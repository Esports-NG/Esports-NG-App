import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/roaster_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/screens/team/team_add_game.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddTeamGameDialog extends StatefulWidget {
  const AddTeamGameDialog({
    super.key,
    required this.game,
  });

  final GamePlayed game;

  @override
  State<AddTeamGameDialog> createState() => _AddTeamGameDialogState();
}

class _AddTeamGameDialogState extends State<AddTeamGameDialog> {
  final teamController = Get.put(TeamRepository());
  final tournamentController = Get.put(TournamentRepository());

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        backgroundColor: AppColor().primaryDark,
        title: Row(
          children: [
            Text(
              "Select Team",
              style: TextStyle(
                  color: AppColor().primaryWhite, fontFamily: "InterSemiBold"),
            ),
            const Spacer(),
          ],
        ),
        children: teamController.myTeam
            .map((e) => TeamItem(team: e, game: widget.game))
            .toList());
  }
}

class TeamItem extends StatefulWidget {
  const TeamItem({
    super.key,
    required this.team,
    required this.game,
  });
  final TeamModel team;
  final GamePlayed game;

  @override
  State<TeamItem> createState() => _TeamItemState();
}

class _TeamItemState extends State<TeamItem> {
  final tournamentController = Get.put(TournamentRepository());
  final teamController = Get.put(TeamRepository());
  bool _isRegisterLoading = true;
  bool _isRegistered = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () => Get.to(() => TeamAddGame(
            team: widget.team,
            game: widget.game,
          )),
      child: Row(
        children: [
          OtherImage(
              itemSize: Get.height * 0.05,
              image: '${widget.team.profilePicture}'),
          const Gap(10),
          CustomText(
            title: widget.team.name,
            color: AppColor().primaryWhite,
            size: 16,
            fontFamily: "InterMedium",
          ),
        ],
      ),
    );
  }
}
