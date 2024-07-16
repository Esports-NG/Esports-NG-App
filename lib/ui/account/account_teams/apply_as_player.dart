import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/account_teams/game_selection_chip.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ApplyAsPlayer extends StatefulWidget {
  const ApplyAsPlayer({super.key, required this.item});

  final TeamModel item;

  @override
  State<ApplyAsPlayer> createState() => _ApplyAsPlayerState();
}

class _ApplyAsPlayerState extends State<ApplyAsPlayer> {
  final _formKey = GlobalKey<FormState>();
  final teamController = Get.put(TeamRepository());
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: GoBackButton(onPressed: () => Get.back()),
          title: CustomText(
            title: "Apply as Player",
            color: AppColor().primaryWhite,
            size: 18,
            weight: FontWeight.w600,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.height * 0.02, vertical: Get.height * 0.02),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title:
                          "Fill the form below with your correct player information.",
                      color: AppColor().primaryWhite,
                      fontFamily: "GilroyMedium",
                      size: 16,
                    ),
                    Gap(Get.height * 0.03),
                    formControl(
                      "Which games would you like to play?*",
                      const GameSelectionChip(
                        teamApplication: true,
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    formControl(
                        "What role would you play in our team?*",
                        CustomTextField(
                          textEditingController: teamController.teamRole,
                          hint: "Eg. Marksman",
                        )),
                    Gap(Get.height * 0.02),
                    formControl(
                        "Why do you want to join our team?*",
                        CustomTextField(
                          minLines: 7,
                          maxLines: 7,
                          textEditingController: teamController.teamJoinReason,
                          hint: "Type here...",
                        )),
                    Gap(Get.height * 0.02),
                    formControl(
                      "Would you like to include your gamer profile?*",
                      checkRadio(teamController.includeGamerProfile),
                    ),
                    Gap(Get.height * 0.02),
                    formControl("Would you like to share your team history?*",
                        checkRadio(teamController.shareTeamHistory)),
                    Gap(Get.height * 0.02),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          _isSubmitting = true;
                        });
                        await teamController.applyAsPlayer(widget.item.id!);
                        setState(() {
                          _isSubmitting = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: _isSubmitting
                                ? Colors.transparent
                                : AppColor().primaryColor,
                            borderRadius: BorderRadius.circular(99),
                            border: _isSubmitting
                                ? Border.all(color: AppColor().primaryColor)
                                : null),
                        child: Center(
                          child: _isSubmitting
                              ? const ButtonLoader()
                              : CustomText(
                                  title: "Submit",
                                  color: AppColor().primaryWhite,
                                  weight: FontWeight.w600,
                                ),
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget formControl(String label, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: label,
          color: AppColor().primaryWhite.withOpacity(0.6),
          fontFamily: "GilroyMedium",
        ),
        Gap(Get.height * 0.01),
        widget
      ],
    );
  }

  Widget checkRadio(RxBool state) {
    return Row(
      children: [
        CustomText(
          title: "Yes",
          color: AppColor().primaryWhite,
          size: 12,
        ),
        Gap(Get.height * 0.005),
        GestureDetector(
          onTap: () => state.value = true,
          child: Icon(
            state.value
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: AppColor().primaryColor,
          ),
        ),
        Gap(Get.height * 0.02),
        CustomText(
          title: "No",
          color: AppColor().primaryWhite,
          size: 12,
        ),
        Gap(Get.height * 0.005),
        GestureDetector(
          onTap: () => state.value = false,
          child: Icon(
            !state.value
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: AppColor().primaryColor,
          ),
        )
      ],
    );
  }
}
