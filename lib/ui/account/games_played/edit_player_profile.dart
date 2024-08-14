import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditPlayerProfile extends StatefulWidget {
  const EditPlayerProfile({super.key, required this.player});
  final PlayerModel player;

  @override
  State<EditPlayerProfile> createState() => _EditPlayerProfileState();
}

class _EditPlayerProfileState extends State<EditPlayerProfile> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var playerController = Get.put(PlayerRepository());
  var gamesController = Get.put(GamesRepository());
  final appColors = AppColor();

  bool _isEditing = false;
  bool _isDeleting = false;

  late TextEditingController _gameNameController;
  late TextEditingController _gameIdController;

  @override
  void initState() {
    _gameNameController = TextEditingController(text: widget.player.inGameName);
    _gameIdController = TextEditingController(text: widget.player.inGameId);
    gamesController.selectedGame.value = gamesController.allGames
        .firstWhereOrNull((e) => e.id == widget.player.gamePlayed!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: CustomText(
            title: "Edit Game Profile",
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
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: AppColor().primaryDark,
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
                  textEditingController: _gameNameController,
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
                  textEditingController: _gameIdController,
                ),
                Gap(Get.height * 0.03),
                CustomText(
                  title: "Player Profile Picture (Optional)",
                  size: 16,
                  color: AppColor().greyFour,
                ),
                Gap(Get.height * 0.01),
                pickProfileImage(onTap: () {
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
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: GestureDetector(
                            onTap: () async {
                              var data = {
                                "in_game_name": _gameNameController.text,
                                "in_game_id": _gameIdController.text,
                              };
                              setState(() {
                                _isEditing = true;
                              });
                              await playerController.editPlayerProfile(
                                  widget.player.id!, data);
                              setState(() {
                                _isEditing = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                  color: _isEditing
                                      ? Colors.transparent
                                      : AppColor().primaryColor,
                                  borderRadius: BorderRadius.circular(90)),
                              child: Center(
                                  child: _isEditing
                                      ? const ButtonLoader()
                                      : CustomText(
                                          title: "Update Game Profile",
                                          fontFamily: "GilroyMedium",
                                          color: AppColor().primaryWhite,
                                        )),
                            ))),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 5,
                      child: CustomFillButton(
                        buttonColor: appColors.primaryRed,
                        boarderColor: appColors.primaryColor.withOpacity(0),
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            playerController.createPlayer(PlayerModel(
                                inGameName:
                                    playerController.gameNameController.text,
                                inGameId:
                                    playerController.gameIdController.text,
                                gamePlayed:
                                    gamesController.selectedGame.value));
                          }
                        },
                        buttonText: "Delete Game Profile",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pickProfileImage({VoidCallback? onTap}) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(Get.height * 0.04),
        decoration: BoxDecoration(
            color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              playerController.playerProfileImage != null
                  ? Container(
                      height: Get.height * 0.08,
                      width: Get.height * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image:
                                FileImage(playerController.playerProfileImage!),
                            fit: BoxFit.cover),
                      ),
                    )
                  : widget.player.profile != null
                      ? Container(
                          height: Get.height * 0.08,
                          width: Get.height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(widget.player.profile),
                                fit: BoxFit.cover),
                          ),
                        )
                      : SvgPicture.asset(
                          'assets/images/svg/photo.svg',
                          height: Get.height * 0.08,
                        ),
              Gap(Get.height * 0.01),
              InkWell(
                onTap: onTap,
                child: CustomText(
                  title: playerController.playerProfileImage == null
                      ? 'Click to upload'
                      : 'Cancel',
                  weight: FontWeight.w400,
                  size: 15,
                  fontFamily: 'GilroyMedium',
                  color: AppColor().primaryColor,
                  underline: TextDecoration.underline,
                ),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Max file size: 4MB',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.014,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
