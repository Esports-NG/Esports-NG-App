import 'dart:io';

import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthRepository());
  final FocusNode _aliasFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _fullnameFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();
  final FocusNode _bioFocusNode = FocusNode();
  final FocusNode _referralFocusNode = FocusNode();
  bool isAlias = false,
      isEmail = false,
      isPassword = false,
      isFullname = false,
      isCountry = false,
      isState = false,
      isPhone = false,
      isGender = false,
      isBio = false,
      isReferral = false;

  @override
  void initState() {
    authController.userNameController.text = authController.user!.userName!;
    authController.fullNameController.text = authController.user!.fullName!;
    authController.emailController.text = authController.user!.email!;
    authController.phoneNoController.text = authController.user!.phoneNumber!;
    authController.bioController.text = authController.user!.bio!;
    super.initState();
  }

  @override
  void dispose() {
    _aliasFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _fullnameFocusNode.dispose();
    _countryFocusNode.dispose();
    _stateFocusNode.dispose();
    _phoneFocusNode.dispose();
    _genderFocusNode.dispose();
    _bioFocusNode.dispose();
    _referralFocusNode.dispose();
    super.dispose();
  }

  void handleTap(String? title) {
    if (title == 'alias') {
      setState(() {
        isAlias = true;
      });
    } else if (title == 'email') {
      setState(() {
        isEmail = true;
      });
    } else if (title == 'password') {
      setState(() {
        isPassword = true;
      });
    } else if (title == 'fullname') {
      setState(() {
        isFullname = true;
      });
    } else if (title == 'country') {
      setState(() {
        isCountry = true;
      });
    } else if (title == 'state') {
      setState(() {
        isState = true;
      });
    } else if (title == 'phone') {
      setState(() {
        isPhone = true;
      });
    } else if (title == 'gender') {
      setState(() {
        isGender = true;
      });
    } else if (title == 'bio') {
      setState(() {
        isBio = true;
      });
    } else {
      setState(() {
        isReferral = true;
      });
    }
  }

  Future pickImageFromGallery(bool isCover) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        if (isCover) {
          authController.mCoverImage(imageTemporary);
        } else {
          authController.mUserImage(imageTemporary);
        }
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  Future pickImageFromCamera(bool isCover) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        if (isCover) {
          authController.mCoverImage(imageTemporary);
        } else {
          authController.mUserImage(imageTemporary);
        }
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      debugPrint(
          'username: ${authController.user?.userName ?? 'yourusername'}');
      return Scaffold(
        backgroundColor: AppColor().primaryBackGroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(Get.height * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                        authController.clearPhoto();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: AppColor().primaryWhite,
                      ),
                    ),
                    Gap(Get.height * 0.01),
                  ],
                ),
                Center(
                  child: GestureDetector(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        authController.userImage == null
                            ? OtherImage(
                                itemSize: Get.height * 0.13,
                                image: authController
                                    .user!.profile!.profilePicture)
                            : Container(
                                height: Get.height * 0.13,
                                width: Get.height * 0.13,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                          FileImage(authController.userImage!),
                                      fit: BoxFit.cover),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          child: InkWell(
                            onTap: () {
                              Get.defaultDialog(
                                title: "Select your image",
                                backgroundColor: AppColor().primaryLightColor,
                                titlePadding: const EdgeInsets.only(top: 30),
                                contentPadding: const EdgeInsets.only(
                                    top: 5, bottom: 30, left: 25, right: 25),
                                middleText: "Upload your profile picture",
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
                                        pickImageFromGallery(false);
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
                                        pickImageFromCamera(false);
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
                            },
                            child: authController.userImage == null
                                ? SvgPicture.asset(
                                    'assets/images/svg/camera.svg',
                                    height: Get.height * 0.05,
                                  )
                                : InkWell(
                                    onTap: () {
                                      authController.clearPhoto();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: AppColor().primaryColor,
                                          border: Border.all(
                                              width: 2,
                                              color: AppColor().primaryWhite),
                                          shape: BoxShape.circle),
                                      child: Icon(Icons.close,
                                          color: AppColor().primaryWhite),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(Get.height * 0.02),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: 'Cover Image',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          authController.coverImage == null
                              ? OtherImage(
                                  isCover: true,
                                  asset: "assets/images/png/placeholder.png",
                                  height: 200,
                                  width: double.infinity,
                                  image: authController.user!.profile!.cover)
                              : Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: FileImage(
                                              authController.coverImage!),
                                          fit: BoxFit.cover)),
                                ),
                          Positioned(
                            bottom: 0,
                            child: InkWell(
                              onTap: () {
                                Get.defaultDialog(
                                  title: "Select your image",
                                  backgroundColor: AppColor().primaryLightColor,
                                  titlePadding: const EdgeInsets.only(top: 30),
                                  contentPadding: const EdgeInsets.only(
                                      top: 5, bottom: 30, left: 25, right: 25),
                                  middleText: "Upload your cover photo",
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
                                          pickImageFromGallery(true);
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
                                          pickImageFromCamera(true);
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
                              },
                              child: authController.userImage == null
                                  ? SvgPicture.asset(
                                      'assets/images/svg/camera.svg',
                                      height: Get.height * 0.05,
                                    )
                                  : InkWell(
                                      onTap: () {
                                        authController.clearPhoto();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: AppColor().primaryColor,
                                            border: Border.all(
                                                width: 2,
                                                color: AppColor().primaryWhite),
                                            shape: BoxShape.circle),
                                        child: Icon(Icons.close,
                                            color: AppColor().primaryWhite),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Username',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        hint: "e.g realmitcha",
                        textEditingController:
                            authController.userNameController,
                        hasText: isAlias,
                        focusNode: _aliasFocusNode,
                        onTap: () => handleTap('alias'),
                        onSubmited: (_) {
                          _aliasFocusNode.unfocus();
                        },
                        onChanged: (value) {
                          setState(() {});
                          isAlias = value.isNotEmpty;
                        },
                        validate: Validator.isUsername,
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Full name',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        hint: "eg john doe",
                        textEditingController:
                            authController.fullNameController,
                        hasText: isFullname,
                        focusNode: _fullnameFocusNode,
                        onTap: () {
                          handleTap('fullname');
                        },
                        onSubmited: (_) {
                          _fullnameFocusNode.unfocus();
                        },
                        onChanged: (value) {
                          setState(() {
                            isFullname = value.isNotEmpty;
                          });
                        },
                        validate: Validator.isName,
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Phone number',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        hint: "phone",
                        textEditingController: authController.phoneNoController,
                        hasText: isPhone,
                        focusNode: _phoneFocusNode,
                        onTap: () {
                          handleTap('phone');
                        },
                        onSubmited: (_) {
                          _phoneFocusNode.unfocus();
                        },
                        onChanged: (value) {
                          setState(() {
                            isPhone = value.isNotEmpty;
                          });
                        },
                        keyType: TextInputType.phone,
                        pretext: authController.countryCodeController.text,
                        validate: Validator.isPhone,
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Bio',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'Inter',
                        size: Get.height * 0.017,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        hint: "Bio",
                        textEditingController: authController.bioController,
                        maxLines: 3,
                        hasText: isBio,
                        focusNode: _bioFocusNode,
                        onTap: () {
                          handleTap('bio');
                        },
                        onSubmited: (_) {
                          _bioFocusNode.unfocus();
                        },
                        onChanged: (value) {
                          setState(() {
                            isBio = value.isNotEmpty;
                          });
                        },
                        keyType: TextInputType.multiline,
                        validate: Validator.isName,
                      ),
                      Gap(Get.height * 0.05),
                      Obx(() {
                        return InkWell(
                          onTap: () {
                            if (authController.updateProfileStatus !=
                                UpdateProfileStatus.loading) {
                              if (authController.userImage == null &&
                                  authController.coverImage == null) {
                                debugPrint("updating user only");
                                authController.updateUser();
                              } else if (authController.userImage != null &&
                                  authController.coverImage != null) {
                                debugPrint("updating user");
                                authController.updateBothImages();
                              } else if (authController.userImage == null &&
                                  authController.coverImage != null) {
                                debugPrint("updating user");
                                authController.updateCoverImage();
                              } else if (authController.userImage != null &&
                                  authController.coverImage == null) {
                                debugPrint("updating user");
                                authController.updateProfileImage();
                              }
                            }
                          },
                          child: Container(
                            height: Get.height * 0.06,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColor().primaryColor,
                            ),
                            child: (authController.updateProfileStatus ==
                                    UpdateProfileStatus.loading)
                                ? const LoadingWidget()
                                : Center(
                                    child: CustomText(
                                    title: 'Save',
                                    color: AppColor().primaryWhite,
                                    fontFamily: "InterSemiBold",
                                    size: Get.height * 0.016,
                                  )),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
