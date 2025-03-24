import 'dart:io';

import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditTeamPage extends StatefulWidget {
  const EditTeamPage({super.key, required this.team});
  final TeamModel team;

  @override
  State<EditTeamPage> createState() => _EditTeamState();
}

class _EditTeamState extends State<EditTeamPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final teamController = Get.put(TeamRepository());
  bool _isEditing = false;
  String? gameTag, seePost, engagePost;
  bool enableChat = false;
  int pageCount = 0;

  void clear() {
    teamController.mTeamProfileImage.value = null;
    teamController.mTeamCoverImage.value = null;
  }

  late TextEditingController _teamNameController;
  late TextEditingController _teamAbbrevController;
  late TextEditingController _teamBioController;

  @override
  dispose() {
    clear();
    super.dispose();
  }

  @override
  initState() {
    setState(() {
      _teamNameController = TextEditingController(text: widget.team.name);
      _teamAbbrevController = TextEditingController(text: widget.team.abbrev);
      _teamBioController = TextEditingController(text: widget.team.bio);
    });
    super.initState();
  }

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
            title: 'Edit Team',
            fontFamily: "InterSemiBold",
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: CustomText(
                title: 'Edit your team',
                size: 18,
                fontFamily: 'InterSemiBold',
                color: AppColor().primaryWhite,
              ),
            ),
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
                      fontFamily: 'Inter',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "The Willywonkers",
                      textEditingController: _teamNameController,
                      validate: Validator.isName,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Team abbreviation (Max 5 characters) *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'Inter',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "ABBREV",
                      textEditingController: _teamAbbrevController,
                      validate: Validator.isName,
                      maxLength: 5,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Team bio *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'Inter',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "Type text here",
                      textEditingController: _teamBioController,
                      maxLines: 5,
                      validate: Validator.isName,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Team profile picture *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'Inter',
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
                            fontFamily: "InterSemiBold",
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
                            fontFamily: 'Inter',
                            fontSize: 14,
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
                      fontFamily: 'Inter',
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
                            fontFamily: "InterSemiBold",
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
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                        );
                      } else {
                        teamController.clearCoverPhoto();
                      }
                    }),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _isEditing = true;
                });
                var data = {
                  "name": _teamNameController.text,
                  "abbrev": _teamAbbrevController.text,
                  "bio": _teamBioController.text
                };
                await teamController.editTeam(widget.team.id!, data);
                setState(() {
                  _isEditing = false;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                height: Get.height * 0.07,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color:
                      _isEditing ? Colors.transparent : AppColor().primaryColor,
                ),
                child: _isEditing
                    ? const Center(child: ButtonLoader())
                    : Center(
                        child: CustomText(
                        title: 'Update Team',
                        color: AppColor().primaryWhite,
                        fontFamily: "InterSemiBold",
                        size: Get.height * 0.018,
                      )),
              ),
            ),
            Gap(Get.height * 0.02),
          ]),
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
          fontFamily: 'InterSemiBold',
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
          color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            teamController.teamProfileImage != null
                ? Container(
                    height: Get.height * 0.08,
                    width: Get.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: FileImage(teamController.teamProfileImage!),
                          fit: BoxFit.cover),
                    ),
                  )
                : widget.team.profilePicture != null
                    ? Container(
                        height: Get.height * 0.08,
                        width: Get.height * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(widget.team.profilePicture!),
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
                title: teamController.teamProfileImage == null
                    ? 'Click to upload'
                    : 'Cancel',
                size: 15,
                fontFamily: 'InterMedium',
                color: AppColor().primaryColor,
                underline: TextDecoration.underline,
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Max file size: 4MB',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
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
          color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            teamController.teamCoverImage != null
                ? Container(
                    height: Get.height * 0.08,
                    width: Get.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: FileImage(teamController.teamCoverImage!),
                          fit: BoxFit.cover),
                    ),
                  )
                : widget.team.cover != null
                    ? Container(
                        height: Get.height * 0.08,
                        width: Get.height * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${ApiLink.imageUrl}${widget.team.cover!}"),
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
                title: teamController.teamCoverImage == null
                    ? 'Click to upload'
                    : 'Cancel',
                size: 15,
                fontFamily: 'InterMedium',
                color: AppColor().primaryColor,
                underline: TextDecoration.underline,
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Max file size: 4MB',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: Get.height * 0.014,
            ),
          ],
        ),
      ),
    );
  }
}
