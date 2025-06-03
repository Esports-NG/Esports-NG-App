import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';

class TournamentParticipantSettings extends StatelessWidget {
  final TournamentRepository tournamentController;
  final FocusNode thirdPrizeFocusNode;

  const TournamentParticipantSettings({
    super.key,
    required this.tournamentController,
    required this.thirdPrizeFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Participants
            CustomText(
              title: 'Max number of participants *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: 14,
            ),
            Gap(Get.height * 0.02),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomTextField(
                      keyType: TextInputType.number,
                      initialValue: tournamentController.participantCount.value
                          .toString(),
                      onSubmited: (_) => thirdPrizeFocusNode.unfocus(),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          tournamentController.participantCount.value =
                              int.parse(value);
                        }
                      },
                      validate: Validator.isNumber,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            tournamentController.participantCount.value++;
                            tournamentController.participantController.text =
                                tournamentController.participantCount.value
                                    .toString();
                          },
                          child: Icon(
                            Icons.arrow_drop_up,
                            color:
                                tournamentController.isParticipant.value == true
                                    ? AppColor().primaryBackGroundColor
                                    : AppColor().lightItemsColor,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (tournamentController.participantCount.value >=
                                2) {
                              --tournamentController.participantCount.value;
                              tournamentController.participantController.text =
                                  tournamentController.participantCount.value
                                      .toString();
                            }
                          },
                          child: Icon(
                            Icons.arrow_drop_down,
                            color:
                                tournamentController.isParticipant.value == true
                                    ? AppColor().primaryBackGroundColor
                                    : AppColor().lightItemsColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Gap(Get.height * 0.02),

            // Enable leaderboard
            CustomText(
              title:
                  'Enable leaderboard *\n(Automatically enabled for ranked tournaments) ',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.left,
              fontFamily: 'Inter',
              size: 14,
            ),
            Gap(Get.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: 'Yes',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.left,
                        fontFamily: 'InterMedium',
                        size: 14,
                      ),
                      Gap(Get.height * 0.01),
                      InkWell(
                        onTap: () {
                          tournamentController.enableLeaderboard.value = true;
                          tournamentController.dontEnableLeaderboard.value =
                              false;
                          tournamentController
                                  .enableLeaderboardController.text =
                              tournamentController.enableLeaderboard.value
                                  .toString();
                        },
                        child: Icon(
                          tournamentController.enableLeaderboard.value
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: tournamentController.enableLeaderboard.value
                              ? AppColor().primaryColor
                              : AppColor().primaryWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(Get.height * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: 'No',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.left,
                        fontFamily: 'InterMedium',
                        size: 14,
                      ),
                      Gap(Get.height * 0.01),
                      InkWell(
                        onTap: () {
                          tournamentController.dontEnableLeaderboard.value =
                              true;
                          tournamentController.enableLeaderboard.value = false;
                          tournamentController
                                  .enableLeaderboardController.text =
                              tournamentController.enableLeaderboard.value
                                  .toString();
                        },
                        child: Icon(
                          tournamentController.dontEnableLeaderboard.value
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color:
                              tournamentController.dontEnableLeaderboard.value
                                  ? AppColor().primaryColor
                                  : AppColor().primaryWhite,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
