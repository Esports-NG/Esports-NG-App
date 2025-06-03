import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/util/colors.dart';

class TournamentScheduleForm extends StatelessWidget {
  final TournamentRepository tournamentController;
  final FocusNode registrationDateFocusNode;
  final FocusNode registrationEndDateFocusNode;
  final FocusNode tournamentStartDateFocusNode;
  final FocusNode tournamentEndDateFocusNode;
  final Function(String) pickDate;

  const TournamentScheduleForm({
    super.key,
    required this.tournamentController,
    required this.registrationDateFocusNode,
    required this.registrationEndDateFocusNode,
    required this.tournamentStartDateFocusNode,
    required this.tournamentEndDateFocusNode,
    required this.pickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Registration start date
            _buildDateField(
              title: 'Registration start date *',
              hint: 'DD/MM/YY',
              controller: tournamentController.regDateController,
              hasText: tournamentController.isRegistrationDate.value,
              focusNode: registrationDateFocusNode,
              onTap: () {
                pickDate('registration');
                tournamentController.handleTap('regDate');
              },
              onChanged: (value) {
                tournamentController.isRegistrationDate.value =
                    value.isNotEmpty;
              },
            ),
            Gap(Get.height * 0.02),

            // Registration end date
            _buildDateField(
              title: 'Registration end date *',
              hint: 'DD/MM/YY',
              controller: tournamentController.regEndDateController,
              hasText: tournamentController.isRegistrationEndDate.value,
              focusNode: registrationEndDateFocusNode,
              onTap: () {
                pickDate('registrationEnd');
                tournamentController.handleTap('regEndDate');
              },
              onChanged: (value) {
                tournamentController.isRegistrationEndDate.value =
                    value.isNotEmpty;
              },
            ),
            Gap(Get.height * 0.02),

            // Tournament Start date
            _buildDateField(
              title: 'Tournament Start date *',
              hint: 'DD/MM/YY',
              controller: tournamentController.startDateController,
              hasText: tournamentController.isStartDate.value,
              focusNode: tournamentStartDateFocusNode,
              onTap: () {
                pickDate('startDate');
                tournamentController.handleTap('startDate');
              },
              onChanged: (value) {
                tournamentController.isStartDate.value = value.isNotEmpty;
              },
            ),
            Gap(Get.height * 0.02),

            // Tournament End date
            _buildDateField(
              title: 'Tournament End date *',
              hint: 'DD/MM/YY',
              controller: tournamentController.endDateController,
              hasText: tournamentController.isEndDate.value,
              focusNode: tournamentEndDateFocusNode,
              onTap: () {
                pickDate('endDate');
                tournamentController.handleTap('endDate');
              },
              onChanged: (value) {
                tournamentController.isEndDate.value = value.isNotEmpty;
              },
            ),
          ],
        ));
  }

  Widget _buildDateField({
    required String title,
    required String hint,
    required TextEditingController controller,
    required bool hasText,
    required FocusNode focusNode,
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
        InkWell(
          onTap: onTap,
          child: CustomTextField(
            hint: hint,
            enabled: false,
            textEditingController: controller,
            hasText: hasText,
            focusNode: focusNode,
            onSubmited: (_) => focusNode.unfocus(),
            onChanged: onChanged,
            suffixIcon: Icon(
              CupertinoIcons.calendar,
              color: hasText
                  ? AppColor().primaryBackGroundColor
                  : AppColor().lightItemsColor,
            ),
          ),
        ),
      ],
    );
  }
}
