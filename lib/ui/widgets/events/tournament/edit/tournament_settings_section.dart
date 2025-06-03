import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/events/tournament/edit/tournament_dropdown_field.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentSettingsSection extends StatelessWidget {
  final TournamentRepository tournamentController;

  const TournamentSettingsSection({
    super.key,
    required this.tournamentController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tournament Type
            TournamentDropdownField(
              title: 'Tournament Type',
              hint: 'Tournament Type',
              value: tournamentController.tournamentTypeValue.value,
              enableFill: tournamentController.isTournamentType.value,
              items: ['Single Player', 'Teams'],
              valueMap: {
                'Single Player': 'solo',
                'Teams': 'team',
              },
              onChanged: (value) {
                tournamentController.tournamentTypeValue.value = value!;
                tournamentController.tournamentTypeController.text = value;
                tournamentController.handleTap('tournamentType');
              },
            ),
            Gap(Get.height * 0.02),

            // Knockout Type
            TournamentDropdownField(
              title: 'Knockout Type',
              hint: 'Knockout Type',
              value: tournamentController.knockoutValue.value,
              enableFill: tournamentController.isKnockout.value,
              items: [
                'Group Stage',
                'Knockout Stage',
                'Group and Knockout Stage',
                'Battle Royale',
              ],
              onChanged: (value) {
                tournamentController.knockoutValue.value = value;
                tournamentController.knockoutTypeController.text = value!;
                tournamentController.handleTap('knockout');
              },
            ),
            Gap(Get.height * 0.02),

            // Rank Type
            TournamentDropdownField(
              title: 'Rank Type',
              hint: 'Rank Type',
              value: tournamentController.rankTypeValue.value,
              enableFill: tournamentController.isRankType.value,
              items: ['Ranked', 'Unranked'],
              onChanged: (value) {
                tournamentController.rankTypeValue.value = value;
                tournamentController.rankTypeController.text = value!;
                tournamentController.handleTap('rankType');
              },
            ),
          ],
        ));
  }
}
