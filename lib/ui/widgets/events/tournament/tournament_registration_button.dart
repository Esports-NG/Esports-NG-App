import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/screens/account/games_played/create_player_profile.dart';
import 'package:e_sport/ui/screens/team/create_team.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/team/add_team_game_dialog.dart';
import 'package:e_sport/ui/widgets/team/choose_team_dialog.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class TournamentRegistrationButton extends StatefulWidget {
  final EventModel eventDetails;
  final bool isRegistered;
  final Function onRegistrationChanged;
  final Function onAddGame;
  final String? participantSlug;

  const TournamentRegistrationButton({
    Key? key,
    required this.eventDetails,
    required this.isRegistered,
    required this.onRegistrationChanged,
    required this.onAddGame,
    this.participantSlug,
  }) : super(key: key);

  @override
  State<TournamentRegistrationButton> createState() =>
      _TournamentRegistrationButtonState();
}

class _TournamentRegistrationButtonState
    extends State<TournamentRegistrationButton> {
  final authController = Get.put(AuthRepository());
  final tournamentController = Get.put(TournamentRepository());
  final playerController = Get.put(PlayerRepository());
  final teamController = Get.put(TeamRepository());

  bool _isRegisterLoading = true;
  bool _canRegister = true;
  bool _noTeam = false;

  Future getPlayerProfile() async {
    await playerController.getMyPlayer();
    // print(playerController.myPlayer[0].id);
    // print(widget.eventDetails.games![0].id);
    if (playerController.myPlayer.any((player) =>
        player.gamePlayed!.id == widget.eventDetails.games![0].id)) {
      setState(() {
        _canRegister = true;
      });
    } else {
      setState(() {
        _canRegister = false;
      });
    }
    setState(() {
      _isRegisterLoading = false;
    });
  }

  Future getTeamProfile() async {
    await teamController.getMyTeam(false);
    if (teamController.myTeam.value.isEmpty) {
      setState(() {
        _noTeam = true;
      });
    }
    if (teamController.myTeam.value.any((team) => team.gamesPlayed!
        .any((game) => game.id! == widget.eventDetails.games![0].id!))) {
      setState(() {
        _canRegister = true;
      });
    } else {
      setState(() {
        _canRegister = false;
      });
    }
    setState(() {
      _isRegisterLoading = false;
    });
  }

  @override
  @override
  void initState() {
    if (widget.eventDetails.tournamentType == "team") {
      getTeamProfile();
    } else {
      getPlayerProfile();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_canRegister || _noTeam)
          Row(
            spacing: 8.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                title: _noTeam
                    ? "You don't have a team"
                    : widget.eventDetails.tournamentType == "team"
                        ? "Your teams don't play this game"
                        : "You don't play this game",
                size: 14,
              ),
              // if (widget.eventDetails.tournamentType != 'team')
              Row(
                spacing: 4.w,
                children: [
                  GestureDetector(
                    onTap: _noTeam
                        ? () => Get.to(() => CreateTeamPage())
                        : widget.eventDetails.tournamentType == "team"
                            ? () => showDialog(
                                context: context,
                                // useRootNavigator: true,
                                builder: (context) => AddTeamGameDialog(
                                      game: widget.eventDetails.games![0],
                                    )).whenComplete(() => widget.onAddGame())
                            : () => Get.to(() => CreatePlayerProfile(
                                game: widget.eventDetails.games![0])),
                    child: CustomText(
                      title: _noTeam
                          ? "Create a team"
                          : widget.eventDetails.tournamentType == "team"
                              ? "Add Game to team"
                              : "Add player profile",
                      color: AppColor().primaryColor,
                    ),
                  ),
                  Icon(
                    IconsaxPlusLinear.arrow_right,
                    color: AppColor().primaryColor,
                    size: 16.r,
                  )
                ],
              )
            ],
          ),
        Gap(Get.height * 0.02),
        InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: DateTime.now().isAfter(widget.eventDetails.regEnd!) ||
                  _isRegisterLoading ||
                  !_canRegister
              ? null
              : _handleRegistration,
          child: Container(
            height: Get.height * 0.06,
            width: Get.width,
            decoration: BoxDecoration(
              border: !_isRegisterLoading
                  ? null
                  : Border.all(
                      width: 1,
                      color: AppColor().primaryColor.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(30),
              color: _isRegisterLoading
                  ? Colors.transparent
                  : !DateTime.now().isAfter(widget.eventDetails.regEnd!) &&
                          _canRegister
                      ? AppColor().primaryColor
                      : AppColor().darkGrey,
            ),
            child: _isRegisterLoading
                ? Center(
                    child: SizedBox(
                      width: Get.height * 0.03,
                      height: Get.height * 0.03,
                      child: CircularProgressIndicator(
                        color: AppColor().primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Center(
                    child: CustomText(
                    title: _getButtonText(),
                    color: AppColor().primaryWhite,
                    size: 14,
                    fontFamily: 'InterMedium',
                  )),
          ),
        ),
      ],
    );
  }

  String _getButtonText() {
    if (widget.eventDetails.tournamentType == "team") {
      if (!DateTime.now().isAfter(widget.eventDetails.regEnd!)) {
        return "Pick Team";
      } else if (!DateTime.now().isAfter(widget.eventDetails.endDate!)) {
        return "Registration Ended";
      } else {
        return "Event Ended";
      }
    } else {
      if (DateTime.now().isAfter(widget.eventDetails.endDate!)) {
        return "Event Ended";
      } else if (DateTime.now().isAfter(widget.eventDetails.regEnd!)) {
        return "Registration Ended";
      } else if (widget.isRegistered) {
        return "Unregister";
      } else {
        return 'Register Now';
      }
    }
  }

  Future<void> _handleRegistration() async {
    if (widget.eventDetails.tournamentType == "team") {
      setState(() {
        _isRegisterLoading = true;
      });
      await showDialog(
        context: context,
        builder: (context) => ChooseTeamDialog(
          slug: widget.eventDetails.slug!,
          isRegistered: widget.isRegistered,
        ),
      );
      setState(() {
        _isRegisterLoading = false;
      });
      widget.onRegistrationChanged();
    } else {
      setState(() {
        _isRegisterLoading = true;
      });
      if (widget.isRegistered) {
        await tournamentController.unregisterForEvent(
            widget.eventDetails.slug!, "player", widget.participantSlug!);
        widget.onRegistrationChanged();
      } else {
        var success = await tournamentController
            .registerForTournament(widget.eventDetails.slug!);
        if (success) {
          widget.onRegistrationChanged();
        }
      }
      setState(() {
        _isRegisterLoading = false;
      });
    }
  }
}
