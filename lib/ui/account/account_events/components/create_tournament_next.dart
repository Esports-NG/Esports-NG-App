// import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CreateTournamentNext extends StatefulWidget {
  const CreateTournamentNext({super.key});

  @override
  State<CreateTournamentNext> createState() => _CreateTournamentNextState();
}

class _CreateTournamentNextState extends State<CreateTournamentNext> {
  final tournamentController = Get.put(TournamentRepository());

  final _tournamentSummaryFocusNode = FocusNode();
  final _tournamentRequirementsFocusNode = FocusNode();
  final _tournamentStructureFocusNode = FocusNode();
  final _tournamentRegulationsFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: 'Tournament group stage settings',
            weight: FontWeight.w500,
            size: 14,
            fontFamily: 'GilroyMedium',
            textAlign: TextAlign.start,
            color: AppColor().primaryWhite,
          ),
          Gap(Get.height * 0.02),
          CustomText(
            title: 'Tournament summary *',
            color: AppColor().primaryWhite,
            textAlign: TextAlign.center,
            fontFamily: 'GilroyRegular',
            size: Get.height * 0.017,
          ),
          Gap(Get.height * 0.01),
          CustomTextField(
            hint: "Type text here",
            textEditingController:
                tournamentController.tournamentSummaryController,
            // hasText: isTournamentName,
            focusNode: _tournamentSummaryFocusNode,
            onTap: () => tournamentController.handleTap('tournamentSummary'),
            maxLines: 4,
            onSubmited: (_) {
              _tournamentSummaryFocusNode.unfocus();
            },
            onChanged: (value) {
              tournamentController.isTournamentSummary.value = value.isNotEmpty;
            },
            validate: Validator.isName,
          ),
          Gap(Get.height * 0.02),
          CustomText(
            title: 'Requirements for entry *',
            color: AppColor().primaryWhite,
            textAlign: TextAlign.center,
            fontFamily: 'GilroyRegular',
            size: Get.height * 0.017,
          ),
          Gap(Get.height * 0.01),
          CustomTextField(
            hint: "Type text here",
            textEditingController:
                tournamentController.tournamentRequirementsController,
            hasText: tournamentController.isTournamentRequirements.value,
            focusNode: _tournamentRequirementsFocusNode,
            onTap: () =>
                tournamentController.handleTap('tournamentRequirements'),
            maxLines: 4,
            onSubmited: (_) {
              _tournamentRequirementsFocusNode.unfocus();
            },
            onChanged: (value) {
              tournamentController.isTournamentLink.value = value.isNotEmpty;
            },
            validate: Validator.isName,
          ),
          Gap(Get.height * 0.02),
          CustomText(
            title: 'Tournament structure *',
            color: AppColor().primaryWhite,
            textAlign: TextAlign.center,
            fontFamily: 'GilroyRegular',
            size: Get.height * 0.017,
          ),
          Gap(Get.height * 0.01),
          CustomTextField(
            hint: "Type text here",
            textEditingController:
                tournamentController.tournamentStructureController,
            hasText: tournamentController.isTournamentStructure.value,
            focusNode: _tournamentStructureFocusNode,
            onTap: () => tournamentController.handleTap('tournamentStructure'),
            maxLines: 3,
            onSubmited: (_) {
              _tournamentStructureFocusNode.unfocus();
            },
            onChanged: (value) {
              tournamentController.isTournamentLink.value = value.isNotEmpty;
            },
            validate: Validator.isName,
          ),
          Gap(Get.height * 0.02),
          CustomText(
            title: 'Tournament rules & regulations *',
            color: AppColor().primaryWhite,
            textAlign: TextAlign.center,
            fontFamily: 'GilroyRegular',
            size: Get.height * 0.017,
          ),
          Gap(Get.height * 0.01),
          CustomTextField(
            hint: "Type text here",
            textEditingController:
                tournamentController.tournamentRegulationsController,
            hasText: tournamentController.isTournamentRegulations.value,
            focusNode: _tournamentRegulationsFocusNode,
            onTap: () =>
                tournamentController.handleTap('tournamentRegulations'),
            maxLines: 3,
            onSubmited: (_) {
              _tournamentRegulationsFocusNode.unfocus();
            },
            onChanged: (value) {
              tournamentController.isTournamentLink.value = value.isNotEmpty;
            },
            validate: Validator.isName,
          ),
          Gap(Get.height * 0.02),
          CustomText(
            title: 'Tournament image *',
            color: AppColor().primaryWhite,
            textAlign: TextAlign.center,
            fontFamily: 'GilroyRegular',
            size: Get.height * 0.017,
          ),
          Gap(Get.height * 0.01),
          tournamentController.pickProfileImage(onTap: () {
            if (tournamentController.eventProfileImage == null) {
              debugPrint('pick image');
              Get.defaultDialog(
                title: "Select your image",
                backgroundColor: AppColor().primaryLightColor,
                titlePadding: const EdgeInsets.only(top: 30),
                contentPadding: const EdgeInsets.only(
                    top: 5, bottom: 30, left: 25, right: 25),
                middleText: "Upload your tournament profile picture",
                titleStyle: TextStyle(
                  color: AppColor().primaryWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'GilroyRegular',
                ),
                radius: 10,
                confirm: Column(
                  children: [
                    CustomFillButton(
                      onTap: () {
                        tournamentController.pickImageFromGallery('image');
                        Get.back();
                      },
                      height: 45,
                      width: Get.width * 0.5,
                      buttonText: 'Upload from gallery',
                      textColor: AppColor().primaryWhite,
                      buttonColor: AppColor().primaryColor,
                      boarderColor: AppColor().primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    const Gap(10),
                    CustomFillButton(
                      onTap: () {
                        tournamentController.pickImageFromCamera('image');
                        Get.back();
                      },
                      height: 45,
                      width: Get.width * 0.5,
                      buttonText: 'Upload from camera',
                      textColor: AppColor().primaryWhite,
                      buttonColor: AppColor().primaryColor,
                      boarderColor: AppColor().primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ],
                ),
                middleTextStyle: TextStyle(
                  color: AppColor().primaryWhite,
                  fontFamily: 'GilroyRegular',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );
            } else {
              tournamentController.clearProfilePhoto();
            }
          }),
          Gap(Get.height * 0.02),
          CustomText(
            title: 'Tournament banner *',
            color: AppColor().primaryWhite,
            textAlign: TextAlign.center,
            fontFamily: 'GilroyRegular',
            size: Get.height * 0.017,
          ),
          Gap(Get.height * 0.01),
          tournamentController.pickCoverImage(onTap: () {
            if (tournamentController.eventCoverImage == null) {
              debugPrint('pick image');
              Get.defaultDialog(
                title: "Select your image",
                backgroundColor: AppColor().primaryLightColor,
                titlePadding: const EdgeInsets.only(top: 30),
                contentPadding: const EdgeInsets.only(
                    top: 5, bottom: 30, left: 25, right: 25),
                middleText: "Upload your tournament banner",
                titleStyle: TextStyle(
                  color: AppColor().primaryWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'GilroyRegular',
                ),
                radius: 10,
                confirm: Column(
                  children: [
                    CustomFillButton(
                      onTap: () {
                        tournamentController.pickImageFromGallery('banner');
                        Get.back();
                      },
                      height: 45,
                      width: Get.width * 0.5,
                      buttonText: 'Upload from gallery',
                      textColor: AppColor().primaryWhite,
                      buttonColor: AppColor().primaryColor,
                      boarderColor: AppColor().primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    const Gap(10),
                    CustomFillButton(
                      onTap: () {
                        tournamentController.pickImageFromCamera('banner');
                        Get.back();
                      },
                      height: 45,
                      width: Get.width * 0.5,
                      buttonText: 'Upload from camera',
                      textColor: AppColor().primaryWhite,
                      buttonColor: AppColor().primaryColor,
                      boarderColor: AppColor().primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ],
                ),
                middleTextStyle: TextStyle(
                  color: AppColor().primaryWhite,
                  fontFamily: 'GilroyRegular',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );
            } else {
              tournamentController.clearCoverPhoto();
            }
          }),
          Gap(Get.height * 0.02),
        ],
      ),
    );
  }
}
