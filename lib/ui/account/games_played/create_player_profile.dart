import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
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
            fontFamily: 'GilroySemiBold',
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
                InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor().bgDark,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().lightItemsColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<GamePlayed>(
                      value: gamesController.selectedGame.value,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor().lightItemsColor,
                      ),
                      items: gamesController.allGames.map((value) {
                        return DropdownMenuItem<GamePlayed>(
                          value: value,
                          child: CustomText(
                            title: value.name,
                            color: AppColor().lightItemsColor,
                            fontFamily: 'GilroyBold',
                            weight: FontWeight.w400,
                            size: 13,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        gamesController.selectedGame.value = value;
                        gamesController.selectedGameName.value = value!.name!;
                        // debugPrint(gamesController.communitiesValue.value);
                        // gamesController.handleTap('commu');
                      },
                      hint: CustomText(
                        title: "Select a Game",
                        color: AppColor().lightItemsColor,
                        fontFamily: 'GilroyBold',
                        weight: FontWeight.w400,
                        size: 13,
                      ),
                    ),
                  ),
                ),
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
                        fontWeight: FontWeight.w600,
                        fontFamily: 'GilroyRegular',
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
                        fontFamily: 'GilroyRegular',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
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
                            inGameName:
                                playerController.gameNameController.text,
                            inGameId: playerController.gameIdController.text,
                            gamePlayed: gamesController.selectedGame.value));
                      }
                    },
                    buttonText: "Add Game Profile")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
