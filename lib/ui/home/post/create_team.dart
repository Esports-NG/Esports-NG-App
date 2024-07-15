import 'dart:io';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/game_list_dropdown.dart';
import 'package:e_sport/ui/widget/page_indicator.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({super.key});

  @override
  State<CreateTeamPage> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeamPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final teamController = Get.put(TeamRepository());
  bool _isCreating = false;
  String? gameTag, seePost, engagePost;
  bool enableChat = false;
  int pageCount = 0;

  Future pickImageFromGallery(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        if (title == 'profile') {
          teamController.mTeamProfileImage(imageTemporary);
        } else {
          teamController.mTeamCoverImage(imageTemporary);
        }
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  Future pickImageFromCamera(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      if (title == 'profile') {
        teamController.mTeamProfileImage(imageTemporary);
      } else {
        teamController.mTeamCoverImage(imageTemporary);
      }
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor().primaryBackGroundColor,
          centerTitle: true,
          title: CustomText(
            title: 'Create Team',
            weight: FontWeight.w600,
            size: 18,
            color: AppColor().primaryWhite,
          ),
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              if (pageCount > 0) {
                setState(() {
                  --pageCount;
                  debugPrint('PageCount: $pageCount');
                });
              } else {
                setState(() {});
                teamController.clearCoverPhoto();
                teamController.clearProfilePhoto();
                Get.back();
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor().primaryWhite,
            ),
          ),
        ),
        backgroundColor: AppColor().primaryBackGroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(Get.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: CustomText(
                  title: 'Fill the form correctly to create a team page',
                  weight: FontWeight.w400,
                  size: 15,
                  fontFamily: 'GilroyMedium',
                  color: AppColor().primaryWhite,
                ),
              ),
              Gap(Get.height * 0.01),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: EdgeInsets.all(Get.height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: 'Team name *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'GilroyRegular',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        hint: "The Willywonkers",
                        textEditingController:
                            teamController.teamNameController,
                        validate: Validator.isName,
                      ),
                      Gap(Get.height * 0.02),
                      // CustomText(
                      //   title: 'Team abbreviation (Max 5 characters) *',
                      //   color: AppColor().primaryWhite,
                      //   textAlign: TextAlign.center,
                      //   fontFamily: 'GilroyRegular',
                      //   size: Get.height * 0.017,
                      // ),
                      // Gap(Get.height * 0.01),
                      // const CustomTextField(
                      //   hint: "The Willywonkers",
                      //   // textEditingController:
                      //   //     teamController.teamBioController,
                      //   validate: Validator.isName,
                      // ),
                      // Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Team bio *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'GilroyRegular',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        hint: "Type text here",
                        textEditingController: teamController.teamBioController,
                        maxLines: 5,
                        validate: Validator.isName,
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Team profile picture *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'GilroyRegular',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      pickProfileImage(onTap: () {
                        if (teamController.teamProfileImage == null) {
                          debugPrint('pick image');
                          Get.defaultDialog(
                            title: "Select your image",
                            backgroundColor: AppColor().primaryLightColor,
                            titlePadding: const EdgeInsets.only(top: 30),
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 30, left: 25, right: 25),
                            middleText: "Upload your team profile picture",
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
                                    pickImageFromGallery('profile');
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
                                    pickImageFromCamera('profile');
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
                          teamController.clearProfilePhoto();
                        }
                      }),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Team cover photo *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'GilroyRegular',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      pickCoverImage(onTap: () {
                        if (teamController.teamCoverImage == null) {
                          debugPrint('pick image');
                          Get.defaultDialog(
                            title: "Select your image",
                            backgroundColor: AppColor().primaryLightColor,
                            titlePadding: const EdgeInsets.only(top: 30),
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 30, left: 25, right: 25),
                            middleText: "Upload your team cover picture",
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
                                    pickImageFromGallery('cover');
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
                                    pickImageFromCamera('cover');
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
                          teamController.clearCoverPhoto();
                        }
                      }),
                      // Gap(Get.height * 0.02),
                      // CustomText(
                      //   title: 'Games Covered *',
                      //   color: AppColor().primaryWhite,
                      //   textAlign: TextAlign.center,
                      //   fontFamily: 'GilroyRegular',
                      //   size: Get.height * 0.017,
                      // ),
                      // Gap(Get.height * 0.01),
                      // GameDropdown(gameValue: gameValue)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: Get.height * 0.02,
                    left: Get.height * 0.02,
                    right: Get.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: 'Add team manager (Optional)',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    const CustomTextField(
                      hint: "The Willywonkers",
                      // textEditingController: authController.fullNameController,
                    ),
                  ],
                ),
              ),
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    await teamController.createTeam();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    height: Get.height * 0.07,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: teamController.createTeamStatus ==
                              CreateTeamStatus.loading
                          ? null
                          : AppColor().primaryColor,
                    ),
                    child: Center(
                        child: teamController.createTeamStatus ==
                                CreateTeamStatus.loading
                            ? const ButtonLoader()
                            : CustomText(
                                title: 'Submit',
                                color: AppColor().primaryWhite,
                                weight: FontWeight.w600,
                                size: Get.height * 0.018,
                              )),
                  ),
                );
              }),
              Gap(Get.height * 0.02),
            ],
          ),
        ),
      );
    });
  }

  Row enableChatOption({String? title, VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomText(
          title: title,
          color: AppColor().primaryWhite,
          textAlign: TextAlign.center,
          fontFamily: 'GilroySemiBold',
          size: Get.height * 0.016,
        ),
        Gap(Get.height * 0.01),
        IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onTap,
            icon: Icon(
              enableChat == true
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: AppColor().primaryWhite,
              size: 20,
            ))
      ],
    );
  }

  Container pickProfileImage({VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.04),
      decoration: BoxDecoration(
          color: AppColor().primaryDark,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            teamController.teamProfileImage == null
                ? SvgPicture.asset(
                    'assets/images/svg/photo.svg',
                    height: Get.height * 0.08,
                  )
                : Container(
                    height: Get.height * 0.08,
                    width: Get.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: FileImage(teamController.teamProfileImage!),
                          fit: BoxFit.cover),
                    ),
                  ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: onTap,
              child: CustomText(
                title: teamController.teamProfileImage == null
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
    );
  }

  Container pickCoverImage({VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.04),
      decoration: BoxDecoration(
          color: AppColor().primaryDark,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            teamController.teamCoverImage == null
                ? SvgPicture.asset(
                    'assets/images/svg/photo.svg',
                    height: Get.height * 0.08,
                  )
                : Container(
                    height: Get.height * 0.08,
                    width: Get.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: FileImage(teamController.teamCoverImage!),
                          fit: BoxFit.cover),
                    ),
                  ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: onTap,
              child: CustomText(
                title: teamController.teamCoverImage == null
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
    );
  }
}
