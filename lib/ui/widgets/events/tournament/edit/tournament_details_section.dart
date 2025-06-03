import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentDetailsSection extends StatelessWidget {
  final TournamentRepository tournamentController;
  final FocusNode tournamentSummaryFocusNode;
  final FocusNode tournamentRequirementsFocusNode;
  final FocusNode tournamentStructureFocusNode;
  final FocusNode tournamentRegulationsFocusNode;

  const TournamentDetailsSection({
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
              hint: 'Type text here',
              controller: tournamentController.tournamentSummaryController,
              hasText: tournamentController.isTournamentSummary.value,
              focusNode: tournamentSummaryFocusNode,
              onTap: () => tournamentController.handleTap('tournamentSummary'),
              onChanged: (value) {
                tournamentController.isTournamentSummary.value =
                    value.isNotEmpty;
              },
              maxLines: 4,
            ),
            Gap(Get.height * 0.02),

            // Requirements for entry
            _buildTextAreaField(
              title: 'Requirements for entry *',
              hint: 'Type text here',
              controller: tournamentController.tournamentRequirementsController,
              hasText: tournamentController.isTournamentRequirements.value,
              focusNode: tournamentRequirementsFocusNode,
              onTap: () =>
                  tournamentController.handleTap('tournamentRequirements'),
              onChanged: (value) {
                tournamentController.isTournamentRequirements.value =
                    value.isNotEmpty;
              },
              maxLines: 4,
            ),
            Gap(Get.height * 0.02),

            // Tournament structure
            _buildTextAreaField(
              title: 'Tournament structure *',
              hint: 'Type text here',
              controller: tournamentController.tournamentStructureController,
              hasText: tournamentController.isTournamentStructure.value,
              focusNode: tournamentStructureFocusNode,
              onTap: () =>
                  tournamentController.handleTap('tournamentStructure'),
              onChanged: (value) {
                tournamentController.isTournamentStructure.value =
                    value.isNotEmpty;
              },
              maxLines: 3,
            ),
            Gap(Get.height * 0.02),

            // Tournament rules & regulations
            _buildTextAreaField(
              title: 'Tournament rules & regulations *',
              hint: 'Type text here',
              controller: tournamentController.tournamentRegulationsController,
              hasText: tournamentController.isTournamentRegulations.value,
              focusNode: tournamentRegulationsFocusNode,
              onTap: () =>
                  tournamentController.handleTap('tournamentRegulations'),
              onChanged: (value) {
                tournamentController.isTournamentRegulations.value =
                    value.isNotEmpty;
              },
              maxLines: 3,
            ),
          ],
        ));
  }

  Widget _buildTextAreaField({
    required String title,
    required String hint,
    required TextEditingController controller,
    required bool hasText,
    required FocusNode focusNode,
    required VoidCallback onTap,
    required Function(String) onChanged,
    required int maxLines,
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
          hint: hint,
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
