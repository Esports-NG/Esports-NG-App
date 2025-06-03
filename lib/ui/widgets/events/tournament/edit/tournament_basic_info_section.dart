import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentBasicInfoSection extends StatelessWidget {
  final TournamentRepository tournamentController;
  final FocusNode tournamentNameFocusNode;
  final FocusNode tournamentHashtagFocusNode;
  final FocusNode tournamentLinkFocusNode;

  const TournamentBasicInfoSection({
    super.key,
    required this.tournamentController,
    required this.tournamentNameFocusNode,
    required this.tournamentHashtagFocusNode,
    required this.tournamentLinkFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tournament Name
            CustomText(
              title: 'Tournament name *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: 14,
            ),
            Gap(Get.height * 0.01),
            CustomTextField(
              hint: "The Willywonkers",
              textEditingController:
                  tournamentController.tournamentNameController,
              hasText: tournamentController.isTournamentName.value,
              focusNode: tournamentNameFocusNode,
              onTap: () => tournamentController.handleTap('tournamentName'),
              onSubmited: (_) => tournamentNameFocusNode.unfocus(),
              onChanged: (value) {
                tournamentController.isTournamentName.value = value.isNotEmpty;
              },
              validate: Validator.isName,
            ),
            Gap(Get.height * 0.02),

            // Tournament Hashtag
            CustomText(
              title: 'Tournament hashtag *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: 14,
            ),
            Gap(Get.height * 0.01),
            CustomTextField(
              prefixIcon: Icon(
                Icons.tag,
                color: AppColor().primaryWhite,
              ),
              hint: "Hashtag",
              textEditingController:
                  tournamentController.tournamentHashtagController,
              focusNode: tournamentHashtagFocusNode,
              onSubmited: (_) => tournamentHashtagFocusNode.unfocus(),
            ),
            Gap(Get.height * 0.02),

            // Tournament Link
            CustomText(
              title: 'Tournament link for brackets *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: 14,
            ),
            Gap(Get.height * 0.01),
            CustomTextField(
              prefixIcon: const IntrinsicWidth(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text(
                      "https://",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              textEditingController:
                  tournamentController.tournamentLinkController,
              hasText: tournamentController.isTournamentLink.value,
              focusNode: tournamentLinkFocusNode,
              onTap: () => tournamentController.handleTap('tournamentLink'),
              onSubmited: (_) => tournamentLinkFocusNode.unfocus(),
              onChanged: (value) {
                tournamentController.isTournamentLink.value = value.isNotEmpty;
              },
              validate: Validator.isLink,
            ),
          ],
        ));
  }
}
