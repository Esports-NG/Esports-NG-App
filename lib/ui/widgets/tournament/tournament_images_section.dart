import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/util/colors.dart';

class TournamentImagesSection extends StatelessWidget {
  final TournamentRepository tournamentController;

  const TournamentImagesSection({
    super.key,
    required this.tournamentController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tournament image
            CustomText(
              title: 'Tournament image',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: 14,
            ),
            Gap(Get.height * 0.01),
            tournamentController.pickProfileImage(onTap: () {
              if (tournamentController.eventProfileImage == null) {
                _showImagePickerDialog(
                    context, 'image', 'tournament profile picture');
              } else {
                tournamentController.clearProfilePhoto();
              }
            }),
            Gap(Get.height * 0.02),

            // Tournament banner
            CustomText(
              title: 'Tournament banner',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: 14,
            ),
            Gap(Get.height * 0.01),
            tournamentController.pickCoverImage(onTap: () {
              if (tournamentController.eventCoverImage == null) {
                _showImagePickerDialog(context, 'banner', 'tournament banner');
              } else {
                tournamentController.clearCoverPhoto();
              }
            }),
          ],
        ));
  }

  void _showImagePickerDialog(
      BuildContext context, String imageType, String description) {
    Get.defaultDialog(
      title: "Select your image",
      backgroundColor: AppColor().primaryLightColor,
      titlePadding: const EdgeInsets.only(top: 30),
      contentPadding:
          const EdgeInsets.only(top: 5, bottom: 30, left: 25, right: 25),
      middleText: "Upload your $description",
      titleStyle: TextStyle(
        color: AppColor().primaryWhite,
        fontSize: 15,
        fontFamily: "InterSemiBold",
      ),
      radius: 10,
      confirm: Column(
        children: [
          CustomFillButton(
            onTap: () {
              tournamentController.pickImageFromGallery(imageType);
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
              tournamentController.pickImageFromCamera(imageType);
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
          color: AppColor().primaryWhite, fontSize: 14, fontFamily: "Inter"),
    );
  }
}
