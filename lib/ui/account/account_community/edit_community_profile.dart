import 'dart:io';

import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditCommunityPage extends StatefulWidget {
  const EditCommunityPage({super.key, required this.community});

  final CommunityModel community;

  @override
  State<EditCommunityPage> createState() => _EditCommunityState();
}

class _EditCommunityState extends State<EditCommunityPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final communityController = Get.put(CommunityRepository());
  String? gameTag, seePost, engagePost;
  bool enableChat = true;
  int pageCount = 0;

  bool _isEditing = false;

  late TextEditingController _communityNameController;
  late TextEditingController _communityBioController;
  late TextEditingController _communityAbbrevController;

  void clear() async {
    communityController.clearCoverPhoto();
    communityController.clearProfilePhoto();
  }

  @override
  dispose() {
    clear();
    super.dispose();
  }

  @override
  initState() {
    _communityNameController =
        TextEditingController(text: widget.community.name);
    _communityBioController = TextEditingController(text: widget.community.bio);
    _communityAbbrevController =
        TextEditingController(text: widget.community.abbrev);
    super.initState();
  }

  Future pickImageFromGallery(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        if (title == 'profile') {
          communityController.mCommunityProfileImage(imageTemporary);
        } else {
          communityController.mCommunityCoverImage(imageTemporary);
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
        communityController.mCommunityProfileImage(imageTemporary);
      } else {
        communityController.mCommunityCoverImage(imageTemporary);
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
            title: 'Edit Community Page',
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
                communityController.clearCoverPhoto();
                communityController.clearProfilePhoto();
                Get.back();
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor().primaryWhite,
            ),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete Community",
                  backgroundColor: AppColor().primaryLightColor,
                  titlePadding: const EdgeInsets.only(top: 30),
                  contentPadding: const EdgeInsets.only(
                      top: 5, bottom: 30, left: 25, right: 25),
                  middleText: "Are you sure?",
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
                          //teamController.deleteTeam(widget.item.id!);
                          Get.back();
                        },
                        height: 45,
                        width: Get.width * 0.5,
                        buttonText: 'Yes',
                        textColor: AppColor().primaryWhite,
                        buttonColor: AppColor().primaryColor,
                        boarderColor: AppColor().primaryColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      const Gap(10),
                      CustomFillButton(
                        onTap: () {
                          Get.back();
                        },
                        height: 45,
                        width: Get.width * 0.5,
                        buttonText: 'No',
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
              },
              icon: Icon(
                Icons.delete_outline,
                color: AppColor().primaryWhite,
              ),
            ),
            Gap(Get.height * 0.02),
          ],
        ),
        backgroundColor: AppColor().primaryBackGroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: CustomText(
                  title: 'Edit your Community',
                  size: 15,
                  fontFamily: 'InterMedium',
                  color: AppColor().primaryWhite,
                ),
              ),
              Gap(Get.height * 0.02),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(Get.height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: 'Community name *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        hint: "The Willywonkers",
                        textEditingController: _communityNameController,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'community name must not be empty';
                          }
                          return null;
                        },
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Community abbreviation (Max 5 characters) *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        hint: "The Willywonkers",
                        textEditingController: _communityAbbrevController,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'abbreviation must not be empty';
                          }
                          return null;
                        },
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Community bio *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        hint: "Type text here",
                        textEditingController: _communityBioController,
                        maxLines: 5,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'bio must not be empty';
                          }
                          return null;
                        },
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Community profile picture *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      pickProfileImage(onTap: () {
                        if (communityController.communityProfileImage == null) {
                          debugPrint('pick image');
                          Get.defaultDialog(
                            title: "Select your image",
                            backgroundColor: AppColor().primaryLightColor,
                            titlePadding: const EdgeInsets.only(top: 30),
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 30, left: 25, right: 25),
                            middleText: "Upload your community profile picture",
                            titleStyle: TextStyle(
                                color: AppColor().primaryWhite,
                                fontSize: 15,
                                fontFamily: "InterSemiBold"),
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
                          communityController.clearProfilePhoto();
                        }
                      }),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Community cover photo *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      pickCoverImage(onTap: () {
                        if (communityController.communityCoverImage == null) {
                          debugPrint('pick image');
                          Get.defaultDialog(
                            title: "Select your image",
                            backgroundColor: AppColor().primaryLightColor,
                            titlePadding: const EdgeInsets.only(top: 30),
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 30, left: 25, right: 25),
                            middleText: "Upload your community cover picture",
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
                          communityController.clearCoverPhoto();
                        }
                      }),
                      Gap(Get.height * 0.02),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Map<String, dynamic> body = {
                    'name': _communityNameController.text.trim(),
                    'bio': _communityBioController.text.trim(),
                    'enable_teamchat': enableChat.toString(),
                    'games_played': '',
                    'abbrev': _communityAbbrevController.text
                  };
                  setState(() {
                    _isEditing = true;
                  });
                  await communityController.editCommunity(
                      widget.community.id!, body);
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
                    color: _isEditing
                        ? Colors.transparent
                        : AppColor().primaryColor,
                  ),
                  child: _isEditing
                      ? const Center(child: ButtonLoader())
                      : Center(
                          child: CustomText(
                          title: 'Update Community',
                          color: AppColor().primaryWhite,
                          fontFamily: "InterSemiBold",
                          size: Get.height * 0.018,
                        )),
                ),
              ),
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
            communityController.communityProfileImage != null
                ? Container(
                    height: Get.height * 0.08,
                    width: Get.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: FileImage(
                              communityController.communityProfileImage!),
                          fit: BoxFit.cover),
                    ),
                  )
                : widget.community.logo != null
                    ? Container(
                        height: Get.height * 0.08,
                        width: Get.height * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(widget.community.logo),
                              fit: BoxFit.cover),
                        ))
                    : SvgPicture.asset(
                        'assets/images/svg/photo.svg',
                        height: Get.height * 0.08,
                      ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: onTap,
              child: CustomText(
                title: communityController.communityProfileImage == null
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
            communityController.communityCoverImage != null
                ? Container(
                    height: Get.height * 0.08,
                    width: Get.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: FileImage(
                              communityController.communityCoverImage!),
                          fit: BoxFit.cover),
                    ),
                  )
                : widget.community.cover != null
                    ? Container(
                        height: Get.height * 0.08,
                        width: Get.height * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage("${widget.community.cover}"),
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
                title: communityController.communityCoverImage == null
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
