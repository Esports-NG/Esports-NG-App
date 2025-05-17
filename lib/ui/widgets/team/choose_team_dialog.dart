import 'package:e_sport/data/model/team/roaster_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChooseTeamDialog extends StatefulWidget {
  const ChooseTeamDialog(
      {super.key, required this.slug, required this.isRegistered});
  final String slug;
  final bool isRegistered;

  @override
  State<ChooseTeamDialog> createState() => _ChooseTeamDialogState();
}

class _ChooseTeamDialogState extends State<ChooseTeamDialog> {
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
            .map((e) => TeamItem(team: e, slug: widget.slug))
            .toList());
  }
}

class TeamItem extends StatefulWidget {
  const TeamItem({super.key, required this.team, required this.slug});
  final TeamModel team;
  final String slug;

  @override
  State<TeamItem> createState() => _TeamItemState();
}

class _TeamItemState extends State<TeamItem> {
  final tournamentController = Get.put(TournamentRepository());
  final teamController = Get.put(TeamRepository());
  bool _isRegisterLoading = true;
  bool _isRegistered = false;
  List<RoasterModel>? _teamParticipantList;

  Future getTeamParticipants() async {
    List<RoasterModel> teamParticipantList =
        await tournamentController.getTeamTournamentParticipants(widget.slug);
    setState(() {
      _teamParticipantList = teamParticipantList;
      if (teamParticipantList
          .where((e) =>
              teamController.myTeam.where((item) => item.id == e.id).isNotEmpty)
          .isNotEmpty) {
        _isRegistered = true;
      }
      _isRegisterLoading = false;
    });
  }

  @override
  initState() {
    getTeamParticipants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () async {
        setState(() {
          _isRegisterLoading = true;
        });
        if (_isRegistered) {
          await tournamentController.unregisterForEvent(
              widget.slug, "team", widget.team.slug!);
          setState(() {
            _isRegistered = false;
          });
        } else {
          await tournamentController.registerForTeamTournament(
              widget.slug, widget.team.slug!);
          setState(() {
            _isRegistered = true;
          });
        }
        setState(() {
          _isRegisterLoading = false;
        });
      },
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
          const Spacer(),
          GestureDetector(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: _isRegisterLoading ? null : AppColor().primaryColor,
                borderRadius: BorderRadius.circular(99)),
            child: Center(
              child: _isRegisterLoading
                  ? const ButtonLoader()
                  : CustomText(
                      title: _isRegistered ? "Unregister" : "Register",
                      fontFamily: "InterSemiBold",
                      color: AppColor().primaryWhite,
                    ),
            ),
          ))
        ],
      ),
    );
  }
}
