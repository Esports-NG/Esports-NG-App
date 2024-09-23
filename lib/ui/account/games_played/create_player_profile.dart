import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/game_list_dropdown.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CreatePlayerProfile extends StatefulWidget {
  const CreatePlayerProfile({super.key});

  @override
  State<CreatePlayerProfile> createState() => _CreatePlayerProfileState();
}

class _CreatePlayerProfileState extends State<CreatePlayerProfile> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var playerController = Get.put(PlayerRepository());
  var gamesController = Get.put(GamesRepository());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: CustomText(
            title: "Add Game Profile",
            fontFamily: 'InterSemiBold',
            size: 18,
            color: AppColor().primaryWhite,
          ),
          leading: GoBackButton(onPressed: () => Get.back()),
        ),
        backgroundColor: AppColor().primaryBackGroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: Get.height * 0.02, vertical: Get.height * 0.04),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "Select Game",
                  size: 16,
                  color: AppColor().greyFour,
                ),
                Gap(Get.height * 0.01),
                GameDropdown(gameValue: gamesController.selectedGame),
                Gap(Get.height * 0.03),
                CustomText(
                  title: "IGN",
                  size: 16,
                  color: AppColor().greyFour,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Type text here",
                  textEditingController: playerController.gameNameController,
                  validate: Validator.isName,
                ),
                Gap(Get.height * 0.03),
                CustomText(
                  title: "Game ID (Optional)",
                  size: 16,
                  color: AppColor().greyFour,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Type text here",
                  textEditingController: playerController.gameIdController,
                ),
                Gap(Get.height * 0.03),
                CustomText(
                  title: "Player Profile Picture (Optional)",
                  size: 16,
                  color: AppColor().greyFour,
                ),
                Gap(Get.height * 0.01),
                playerController.pickProfileImage(onTap: () {
                  if (playerController.playerProfileImage == null) {
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
                        fontFamily: "InterSemiBold",
                      ),
                      radius: 10,
                      confirm: Column(
                        children: [
                          CustomFillButton(
                            onTap: () {
                              playerController.pickImageFromGallery('image');
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
                              playerController.pickImageFromCamera('image');
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
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                    );
                  } else {
                    playerController.clearProfilePhoto();
                  }
                }),
                Gap(Get.height * 0.03),
                CustomFillButton(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      playerController.createPlayer(PlayerModel(
                          inGameName: playerController.gameNameController.text,
                          inGameId: playerController.gameIdController.text,
                          gamePlayed: gamesController.selectedGame.value));
                    }
                  },
                  buttonText: "Add Game Profile",
                  isLoading: playerController.createPlayerStatus ==
                      CreatePlayerStatus.loading,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
