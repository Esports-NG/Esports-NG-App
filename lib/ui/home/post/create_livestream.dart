import 'dart:io';

import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class CreateLivestream extends StatefulWidget {
  const CreateLivestream({super.key});

  @override
  State<CreateLivestream> createState() => _CreateLivestreamState();
}

class _CreateLivestreamState extends State<CreateLivestream> {
  TextEditingController streamTitleController = TextEditingController();
  TextEditingController streamImageController = TextEditingController();
  TextEditingController streamDateController = TextEditingController();
  TextEditingController streamTimeController = TextEditingController();
  TextEditingController gameCoveredController = TextEditingController();
  TextEditingController streamingPlatformController = TextEditingController();
  TextEditingController streamLinkController = TextEditingController();
  File? imageFile = null;

  bool _loading = false;

  Future<void> createLivestream() async {
    setState(() {
      _loading = true;
    });
    try {} catch (err) {
      print(err);
    }
    setState(() {
      _loading = false;
    });
  }

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  void clearPhoto() {
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          title: 'Create Livestream',
          fontFamily: "InterSemiBold",
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: GoBackButton(onPressed: () => Get.back()),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: 'Stream Title *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Enter stream title",
                  textEditingController: streamTitleController,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Stream Image *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Get.height * 0.04),
                  decoration: BoxDecoration(
                      color: AppColor().bgDark,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      imageFile == null
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
                                    image: FileImage(imageFile!),
                                    fit: BoxFit.cover),
                              ),
                            ),
                      Gap(Get.height * 0.01),
                      InkWell(
                        onTap: () {
                          if (imageFile == null) {
                            debugPrint('pick image');
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
                                  fontFamily: "InterSemiBold"),
                              radius: 10,
                              confirm: Column(
                                children: [
                                  CustomFillButton(
                                    onTap: () {
                                      pickImageFromGallery();
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
                                      pickImageFromCamera();
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
                            clearPhoto();
                          }
                        },
                        child: CustomText(
                          title:
                              imageFile == null ? 'Click to upload' : 'Cancel',
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
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Stream Date *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Enter stream date",
                  textEditingController: streamDateController,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Stream Time *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Enter stream time",
                  textEditingController: streamTimeController,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Game Covered *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Enter game covered",
                  textEditingController: gameCoveredController,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Streaming Platform (Platforms) *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Enter streaming platform(s)",
                  textEditingController: streamingPlatformController,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Stream Link *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Enter stream link",
                  textEditingController: streamLinkController,
                ),
                Gap(Get.height * 0.02),
                CustomFillButton(buttonText: "Create Livestream")
              ],
            ),
          )),
    );
  }
}
