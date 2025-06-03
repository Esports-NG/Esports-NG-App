import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';

class TournamentPrizePoolForm extends StatelessWidget {
  final TournamentRepository tournamentController;
  final EventRepository eventController;
  final FocusNode prizePoolFocusNode;
  final FocusNode entryFeeFocusNode;
  final FocusNode firstPrizeFocusNode;
  final FocusNode secondPrizeFocusNode;
  final FocusNode thirdPrizeFocusNode;

  const TournamentPrizePoolForm({
    super.key,
    required this.tournamentController,
    required this.eventController,
    required this.prizePoolFocusNode,
    required this.entryFeeFocusNode,
    required this.firstPrizeFocusNode,
    required this.secondPrizeFocusNode,
    required this.thirdPrizeFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Currency
            CustomText(
              title: 'Currency *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: 14,
            ),
            Gap(Get.height * 0.01),
            Theme(
              data: ThemeData.dark(),
              child: DropdownSearch<MapEntry<String, String>>(
                compareFn: (item1, item2) => true,
                onChanged: (value) {
                  eventController.currency.value = value!.value;
                },
                selectedItem: eventController.currencies.entries.firstWhere(
                    (entry) => entry.value == eventController.currency.value,
                    orElse: () => eventController.currencies.entries.first),
                items: (filter, infiniteScrollProps) =>
                    eventController.currencies.entries.toList(),
                itemAsString: (item) => "${item.value} ${item.key}",
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: "Select Currency",
                    hintStyle: TextStyle(color: AppColor().lightItemsColor),
                    filled: true,
                    fillColor: AppColor().primaryDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  menuProps: MenuProps(
                    backgroundColor: AppColor().primaryDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Gap(Get.height * 0.02),

            // Prize Pool
            _buildPrizeField(
              title: 'Prize pool *',
              controller: tournamentController.prizePoolController,
              hasText: tournamentController.isPrizePool.value,
              focusNode: prizePoolFocusNode,
              onTap: () => tournamentController.handleTap('prizePool'),
              onChanged: (value) {
                tournamentController.isPrizePool.value = value.isNotEmpty;
              },
            ),
            Gap(Get.height * 0.02),

            // Entry Fee
            _buildPrizeField(
              title: 'Entry fee *',
              controller: tournamentController.entryFeeController,
              hasText: tournamentController.isEntryFee.value,
              focusNode: entryFeeFocusNode,
              onTap: () => tournamentController.handleTap('entryFee'),
              onChanged: (value) {
                tournamentController.isEntryFee.value = value.isNotEmpty;
              },
            ),
            Gap(Get.height * 0.02),

            // First Prize
            _buildPrizeField(
              title: 'First prize *',
              controller: tournamentController.firstPrizeController,
              hasText: tournamentController.isFirstPrize.value,
              focusNode: firstPrizeFocusNode,
              onTap: () => tournamentController.handleTap('first'),
              onChanged: (value) {
                tournamentController.isFirstPrize.value = value.isNotEmpty;
              },
            ),
            Gap(Get.height * 0.02),

            // Second Prize
            _buildPrizeField(
              title: 'Second prize *',
              controller: tournamentController.secondPrizeController,
              hasText: tournamentController.isSecondPrize.value,
              focusNode: secondPrizeFocusNode,
              onTap: () => tournamentController.handleTap('second'),
              onChanged: (value) {
                tournamentController.isSecondPrize.value = value.isNotEmpty;
              },
            ),
            Gap(Get.height * 0.02),

            // Third Prize
            _buildPrizeField(
              title: 'Third prize *',
              controller: tournamentController.thirdPrizeController,
              hasText: tournamentController.isThirdPrize.value,
              focusNode: thirdPrizeFocusNode,
              onTap: () => tournamentController.handleTap('third'),
              onChanged: (value) {
                tournamentController.isThirdPrize.value = value.isNotEmpty;
              },
            ),
          ],
        ));
  }

  Widget _buildPrizeField({
    required String title,
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
        CustomTextField(
          prefixIcon: Container(
            width: 50,
            alignment: Alignment.center,
            child: CustomText(
              title: eventController.currency.value,
            ),
          ),
          hint: "0.00",
          keyType: TextInputType.number,
          textEditingController: controller,
          hasText: hasText,
          focusNode: focusNode,
          onTap: onTap,
          onSubmited: (_) => focusNode.unfocus(),
          onChanged: onChanged,
          validate: Validator.isNumber,
        ),
      ],
    );
  }
}
