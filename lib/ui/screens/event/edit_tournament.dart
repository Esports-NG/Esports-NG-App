import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/tournament/tournament_section_title.dart';
import 'package:e_sport/ui/widgets/tournament/tournament_basic_info_form.dart';
import 'package:e_sport/ui/widgets/tournament/tournament_game_configuration.dart';
import 'package:e_sport/ui/widgets/tournament/tournament_settings_form.dart';
import 'package:e_sport/ui/widgets/tournament/tournament_schedule_form.dart';
import 'package:e_sport/ui/widgets/tournament/tournament_prize_pool_form.dart';
import 'package:e_sport/ui/widgets/tournament/tournament_participant_settings.dart';
import 'package:e_sport/ui/widgets/tournament/tournament_details_form.dart';
import 'package:e_sport/ui/widgets/tournament/tournament_images_section.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditTournament extends StatefulWidget {
  final EventModel tournament;
  const EditTournament({super.key, required this.tournament});

  @override
  State<EditTournament> createState() => _EditTournamentState();
}

class _EditTournamentState extends State<EditTournament> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final communityController = Get.put(CommunityRepository());
  final tournamentController = Get.put(TournamentRepository());
  final eventController = Get.put(EventRepository());
  final authController = Get.put(AuthRepository());
  final gameController = Get.put(GamesRepository());

  // Local state
  List<GamePlayed> _games = [];
  bool _isLoading = false;

  // Focus nodes
  final FocusNode _tournamentnameFocusNode = FocusNode();
  final FocusNode _tournamentHashtagFocusNode = FocusNode();
  final FocusNode _tournamentLinkFocusNode = FocusNode();
  final FocusNode _registrationDateFocusNode = FocusNode();
  final FocusNode _registrationEndDateFocusNode = FocusNode();
  final FocusNode _tournamentStartDateFocusNode = FocusNode();
  final FocusNode _tournamentEndDateFocusNode = FocusNode();
  final FocusNode _prizePoolFocusNode = FocusNode();
  final FocusNode _entryFeeFocusNode = FocusNode();
  final FocusNode _firstPrizeFocusNode = FocusNode();
  final FocusNode _secondPrizeFocusNode = FocusNode();
  final FocusNode _thirdPrizeFocusNode = FocusNode();
  final FocusNode _tournamentSummaryFocusNode = FocusNode();
  final FocusNode _tournamentRequirementsFocusNode = FocusNode();
  final FocusNode _tournamentStructureFocusNode = FocusNode();
  final FocusNode _tournamentRegulationsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadTournamentData();
    _loadCommunityGames();
  }

  @override
  void dispose() {
    _tournamentnameFocusNode.dispose();
    _tournamentHashtagFocusNode.dispose();
    _tournamentLinkFocusNode.dispose();
    _registrationDateFocusNode.dispose();
    _registrationEndDateFocusNode.dispose();
    _tournamentStartDateFocusNode.dispose();
    _tournamentEndDateFocusNode.dispose();
    _prizePoolFocusNode.dispose();
    _entryFeeFocusNode.dispose();
    _firstPrizeFocusNode.dispose();
    _secondPrizeFocusNode.dispose();
    _thirdPrizeFocusNode.dispose();
    _tournamentSummaryFocusNode.dispose();
    _tournamentRequirementsFocusNode.dispose();
    _tournamentStructureFocusNode.dispose();
    _tournamentRegulationsFocusNode.dispose();
    super.dispose();
  }

  void _loadTournamentData() {
    // Pre-populate form fields with existing tournament data
    tournamentController.tournamentNameController.text =
        widget.tournament.name ?? '';
    tournamentController.tournamentHashtagController.text =
        widget.tournament.hashtag ?? '';
    tournamentController.tournamentLinkController.text =
        widget.tournament.linkForBracket?.replaceAll('https://', '') ?? '';
    tournamentController.tournamentSummaryController.text =
        widget.tournament.summary ?? '';
    tournamentController.tournamentRequirementsController.text =
        widget.tournament.requirements ?? '';
    tournamentController.tournamentStructureController.text =
        widget.tournament.structure ?? '';
    tournamentController.tournamentRegulationsController.text =
        widget.tournament.rulesRegs ?? '';

    // Set dates
    if (widget.tournament.regStart != null) {
      tournamentController.regDateController.text =
          DateFormat("yyyy-MM-dd").format(widget.tournament.regStart!);
    }
    if (widget.tournament.regEnd != null) {
      tournamentController.regEndDateController.text =
          DateFormat("yyyy-MM-dd").format(widget.tournament.regEnd!);
    }
    if (widget.tournament.startDate != null) {
      tournamentController.startDateController.text =
          DateFormat("yyyy-MM-dd").format(widget.tournament.startDate!);
    }
    if (widget.tournament.endDate != null) {
      tournamentController.endDateController.text =
          DateFormat("yyyy-MM-dd").format(widget.tournament.endDate!);
    }

    // Set prize money fields (remove currency symbol)
    if (widget.tournament.prizePool != null) {
      String prizePool =
          widget.tournament.prizePool!.replaceAll(RegExp(r'[^\d.]'), '');
      tournamentController.prizePoolController.text = prizePool;
    }
    if (widget.tournament.entryFee != null) {
      String entryFee =
          widget.tournament.entryFee!.replaceAll(RegExp(r'[^\d.]'), '');
      tournamentController.entryFeeController.text = entryFee;
    }
    if (widget.tournament.prizePoolDistribution?.first != null) {
      String firstPrize = widget.tournament.prizePoolDistribution!.first!
          .replaceAll(RegExp(r'[^\d.]'), '');
      tournamentController.firstPrizeController.text = firstPrize;
    }
    if (widget.tournament.prizePoolDistribution?.second != null) {
      String secondPrize = widget.tournament.prizePoolDistribution!.second!
          .replaceAll(RegExp(r'[^\d.]'), '');
      tournamentController.secondPrizeController.text = secondPrize;
    }
    if (widget.tournament.prizePoolDistribution?.third != null) {
      String thirdPrize = widget.tournament.prizePoolDistribution!.third!
          .replaceAll(RegExp(r'[^\d.]'), '');
      tournamentController.thirdPrizeController.text = thirdPrize;
    }

    // Set dropdown values
    tournamentController.tournamentTypeValue.value =
        widget.tournament.tournamentType;
    tournamentController.knockoutValue.value = widget.tournament.knockoutType;
    tournamentController.rankTypeValue.value = widget.tournament.rankType;

    // Set participant count
    if (widget.tournament.maxNo != null) {
      tournamentController.participantCount.value = widget.tournament.maxNo!;
      tournamentController.participantController.text =
          widget.tournament.maxNo!.toString();
    }
    // Set selected community
    if (widget.tournament.community != null) {
      tournamentController.selectedCommunity.value =
          widget.tournament.community;
      tournamentController.communitiesValue.value =
          widget.tournament.community!.name;
      tournamentController.communitiesOwnedController.text =
          widget.tournament.community!.name!;
    }

    // Set selected game
    if (widget.tournament.games != null &&
        widget.tournament.games!.isNotEmpty) {
      tournamentController.gameValue.value = widget.tournament.games!.first;
    }

    // Set form validation states
    _updateValidationStates();
  }

  void _updateValidationStates() {
    tournamentController.isTournamentName.value =
        tournamentController.tournamentNameController.text.isNotEmpty;
    tournamentController.isTournamentLink.value =
        tournamentController.tournamentLinkController.text.isNotEmpty;
    tournamentController.isTournamentSummary.value =
        tournamentController.tournamentSummaryController.text.isNotEmpty;
    tournamentController.isTournamentRequirements.value =
        tournamentController.tournamentRequirementsController.text.isNotEmpty;
    tournamentController.isTournamentStructure.value =
        tournamentController.tournamentStructureController.text.isNotEmpty;
    tournamentController.isTournamentRegulations.value =
        tournamentController.tournamentRegulationsController.text.isNotEmpty;
    tournamentController.isRegistrationDate.value =
        tournamentController.regDateController.text.isNotEmpty;
    tournamentController.isRegistrationEndDate.value =
        tournamentController.regEndDateController.text.isNotEmpty;
    tournamentController.isStartDate.value =
        tournamentController.startDateController.text.isNotEmpty;
    tournamentController.isEndDate.value =
        tournamentController.endDateController.text.isNotEmpty;
    tournamentController.isPrizePool.value =
        tournamentController.prizePoolController.text.isNotEmpty;
    tournamentController.isEntryFee.value =
        tournamentController.entryFeeController.text.isNotEmpty;
    tournamentController.isFirstPrize.value =
        tournamentController.firstPrizeController.text.isNotEmpty;
    tournamentController.isSecondPrize.value =
        tournamentController.secondPrizeController.text.isNotEmpty;
    tournamentController.isThirdPrize.value =
        tournamentController.thirdPrizeController.text.isNotEmpty;
    tournamentController.isParticipant.value =
        tournamentController.participantController.text.isNotEmpty;
    tournamentController.isTournamentType.value =
        tournamentController.tournamentTypeValue.value != null;
    tournamentController.isKnockout.value =
        tournamentController.knockoutValue.value != null;
    tournamentController.isRankType.value =
        tournamentController.rankTypeValue.value != null;
    tournamentController.isCommunities.value =
        tournamentController.selectedCommunity.value != null;
    tournamentController.isGame.value =
        tournamentController.gameValue.value != null;
  }

  Future<void> _loadCommunityGames() async {
    if (widget.tournament.community != null) {
      var community = await communityController
          .getCommunityData(widget.tournament.community!.slug!);
      if (community != null && community.gamesPlayed != null) {
        setState(() {
          _games = community.gamesPlayed!;
        });
      }
    }
  }

  Future<void> pickDate(String title) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: tournamentController.date.value ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 40),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    if (title == 'registration') {
      tournamentController.regDateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      tournamentController.date.value = newDate;
    } else if (title == 'registrationEnd') {
      tournamentController.regEndDateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      tournamentController.date.value = newDate;
    } else if (title == "startDate") {
      tournamentController.startDateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      tournamentController.date.value = newDate;
    } else {
      tournamentController.endDateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      tournamentController.date.value = newDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        leading: GoBackButton(
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          title: "Edit Tournament",
          color: AppColor().primaryWhite,
          size: 20,
          fontFamily: "InterSemibold",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Container
                _buildInfoContainer(),
                Gap(Get.height * 0.02),

                // Basic Tournament Information
                const TournamentSectionTitle(title: "Basic Information"),
                Gap(Get.height * 0.02),
                TournamentBasicInfoForm(
                  tournamentController: tournamentController,
                  tournamentNameFocusNode: _tournamentnameFocusNode,
                  tournamentHashtagFocusNode: _tournamentHashtagFocusNode,
                  tournamentLinkFocusNode: _tournamentLinkFocusNode,
                ),
                Gap(Get.height * 0.05),

                // Game Configuration
                const TournamentSectionTitle(title: "Game Configuration"),
                Gap(Get.height * 0.02),
                TournamentGameConfiguration(
                  tournamentController: tournamentController,
                  gameController: gameController,
                  games: _games,
                ),
                Gap(Get.height * 0.05),

                // Tournament Settings
                const TournamentSectionTitle(title: "Tournament Settings"),
                Gap(Get.height * 0.02),
                TournamentSettingsForm(
                  tournamentController: tournamentController,
                ),
                Gap(Get.height * 0.05),

                // Schedule
                const TournamentSectionTitle(title: "Schedule"),
                Gap(Get.height * 0.02),
                TournamentScheduleForm(
                  tournamentController: tournamentController,
                  registrationDateFocusNode: _registrationDateFocusNode,
                  registrationEndDateFocusNode: _registrationEndDateFocusNode,
                  tournamentStartDateFocusNode: _tournamentStartDateFocusNode,
                  tournamentEndDateFocusNode: _tournamentEndDateFocusNode,
                  pickDate: pickDate,
                ),
                Gap(Get.height * 0.05),

                // Prize Pool & Fees
                const TournamentSectionTitle(title: "Prize Pool & Fees"),
                Gap(Get.height * 0.02),
                TournamentPrizePoolForm(
                  tournamentController: tournamentController,
                  eventController: eventController,
                  prizePoolFocusNode: _prizePoolFocusNode,
                  entryFeeFocusNode: _entryFeeFocusNode,
                  firstPrizeFocusNode: _firstPrizeFocusNode,
                  secondPrizeFocusNode: _secondPrizeFocusNode,
                  thirdPrizeFocusNode: _thirdPrizeFocusNode,
                ),
                Gap(Get.height * 0.05),

                // Participant Settings
                TournamentParticipantSettings(
                  tournamentController: tournamentController,
                  thirdPrizeFocusNode: _thirdPrizeFocusNode,
                ),
                Gap(Get.height * 0.05),

                // Tournament Details
                const TournamentSectionTitle(title: "Tournament Details"),
                Gap(Get.height * 0.02),
                TournamentDetailsForm(
                  tournamentController: tournamentController,
                  tournamentSummaryFocusNode: _tournamentSummaryFocusNode,
                  tournamentRequirementsFocusNode:
                      _tournamentRequirementsFocusNode,
                  tournamentStructureFocusNode: _tournamentStructureFocusNode,
                  tournamentRegulationsFocusNode:
                      _tournamentRegulationsFocusNode,
                ),
                Gap(Get.height * 0.05),

                // Images Section
                const TournamentSectionTitle(title: "Tournament Images"),
                Gap(Get.height * 0.05),
                TournamentImagesSection(
                  tournamentController: tournamentController,
                ),
                Gap(Get.height * 0.04),

                // Update Button
                _buildUpdateButton(),
                Gap(Get.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer() {
    return Container(
      decoration: BoxDecoration(
          color: AppColor().primaryLightColor,
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(Get.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColor().primaryWhite,
            size: 20,
          ),
          Gap(Get.height * 0.01),
          Expanded(
            child: CustomText(
              title:
                  "Update your tournament details below. All fields marked with * are required.",
              color: AppColor().primaryWhite,
              size: 12,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return GestureDetector(
      onTap: () async {
        if (formKey.currentState!.validate()) {
          await _updateTournament();
        }
      },
      child: Container(
        height: Get.height * 0.07,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: _isLoading ? null : AppColor().primaryColor,
        ),
        child: Center(
            child: _isLoading
                ? const ButtonLoader()
                : CustomText(
                    title: 'Update Tournament',
                    color: AppColor().primaryWhite,
                    fontFamily: "InterSemiBold",
                    size: 14,
                  )),
      ),
    );
  }

  Future<void> _updateTournament() async {
    setState(() {
      _isLoading = true;
    });
    await tournamentController.updateTournament(
        widget.tournament.slug!, widget.tournament.community!.slug!);
    setState(() {
      _isLoading = false;
    });
  }
}
