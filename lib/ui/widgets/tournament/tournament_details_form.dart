import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';

class TournamentDetailsForm extends StatelessWidget {
  final TournamentRepository tournamentController;
  final FocusNode tournamentSummaryFocusNode;
  final FocusNode tournamentRequirementsFocusNode;
  final FocusNode tournamentStructureFocusNode;
  final FocusNode tournamentRegulationsFocusNode;

  const TournamentDetailsForm({
    super.key,
    required this.tournamentController,
    required this.tournamentSummaryFocusNode,
    required this.tournamentRequirementsFocusNode,
    required this.tournamentStructureFocusNode,
    required this.tournamentRegulationsFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tournament summary
            _buildTextAreaField(
              title: 'Tournament summary *',
              controller: tournamentController.tournamentSummaryController,
              hasText: tournamentController.isTournamentSummary.value,
              focusNode: tournamentSummaryFocusNode,
              maxLines: 4,
              onTap: () => tournamentController.handleTap('tournamentSummary'),
              onChanged: (value) {
                tournamentController.isTournamentSummary.value =
                    value.isNotEmpty;
              },
            ),
            Gap(Get.height * 0.02),

            // Requirements for entry
            _buildTextAreaField(
              title: 'Requirements for entry *',
              controller: tournamentController.tournamentRequirementsController,
              hasText: tournamentController.isTournamentRequirements.value,
              focusNode: tournamentRequirementsFocusNode,
              maxLines: 4,
              onTap: () =>
                  tournamentController.handleTap('tournamentRequirements'),
              onChanged: (value) {
                tournamentController.isTournamentRequirements.value =
                    value.isNotEmpty;
              },
            ),
            Gap(Get.height * 0.02),

            // Tournament structure
            _buildTextAreaField(
              title: 'Tournament structure *',
              controller: tournamentController.tournamentStructureController,
              hasText: tournamentController.isTournamentStructure.value,
              focusNode: tournamentStructureFocusNode,
              maxLines: 3,
              onTap: () =>
                  tournamentController.handleTap('tournamentStructure'),
              onChanged: (value) {
                tournamentController.isTournamentStructure.value =
                    value.isNotEmpty;
              },
            ),
            Gap(Get.height * 0.02),

            // Tournament rules & regulations
            _buildTextAreaField(
              title: 'Tournament rules & regulations *',
              controller: tournamentController.tournamentRegulationsController,
              hasText: tournamentController.isTournamentRegulations.value,
              focusNode: tournamentRegulationsFocusNode,
              maxLines: 3,
              onTap: () =>
                  tournamentController.handleTap('tournamentRegulations'),
              onChanged: (value) {
                tournamentController.isTournamentRegulations.value =
                    value.isNotEmpty;
              },
            ),
          ],
        ));
  }

  Widget _buildTextAreaField({
    required String title,
    required TextEditingController controller,
    required bool hasText,
    required FocusNode focusNode,
    required int maxLines,
    required VoidCallback onTap,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: title,
          color: AppColor().primaryWhite,
          textAlign: TextAlign.center,
          fontFamily: 'Inter',
          size: 14,
        ),
        Gap(Get.height * 0.01),
        CustomTextField(
          hint: "Type text here",
          textEditingController: controller,
          hasText: hasText,
          focusNode: focusNode,
          onTap: onTap,
          maxLines: maxLines,
          onSubmited: (_) => focusNode.unfocus(),
          onChanged: onChanged,
          validate: Validator.isName,
        ),
      ],
    );
  }
}
