import 'dart:io';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/page_indicator.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditCommunityPage extends StatefulWidget {
  const EditCommunityPage({super.key});

  @override
  State<EditCommunityPage> createState() => _EditCommunityState();
}

class _EditCommunityState extends State<EditCommunityPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final communityController = Get.put(CommunityRepository());
  String? gameTag, seePost, engagePost;
  bool enableChat = true;
  int pageCount = 0;

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
                    fontWeight: FontWeight.w600,
                    fontFamily: 'GilroyRegular',
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
                    fontFamily: 'GilroyRegular',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PageIndicator(
                    pageCount,
                    0,
                    0.5,
                    Get.width / 2,
                    AppColor().primaryColor,
                  ),
                  PageIndicator(
                    pageCount,
                    1,
                    0.5,
                    Get.width / 2,
                    AppColor().primaryColor,
                  ),
                ],
              ),
              Gap(Get.height * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: CustomText(
                  title: 'Edit your Community',
                  weight: FontWeight.w400,
                  size: 15,
                  fontFamily: 'GilroyMedium',
                  color: AppColor().primaryWhite,
                ),
              ),
              Gap(Get.height * 0.02),
              if (pageCount == 0) ...[
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
                          fontFamily: 'GilroyRegular',
                          size: Get.height * 0.017,
                        ),
                        Gap(Get.height * 0.01),
                        CustomTextField(
                          hint: "The Willywonkers",
                          textEditingController:
                              communityController.communityNameController,
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
                          fontFamily: 'GilroyRegular',
                          size: Get.height * 0.017,
                        ),
                        Gap(Get.height * 0.01),
                        CustomTextField(
                          hint: "The Willywonkers",
                          textEditingController:
                              communityController.communityAbbrController,
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
                          fontFamily: 'GilroyRegular',
                          size: Get.height * 0.017,
                        ),
                        Gap(Get.height * 0.01),
                        CustomTextField(
                          hint: "Type text here",
                          textEditingController:
                              communityController.communityBioController,
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
                          fontFamily: 'GilroyRegular',
                          size: Get.height * 0.017,
                        ),
                        Gap(Get.height * 0.01),
                        pickProfileImage(onTap: () {
                          if (communityController.communityProfileImage ==
                              null) {
                            debugPrint('pick image');
                            Get.defaultDialog(
                              title: "Select your image",
                              backgroundColor: AppColor().primaryLightColor,
                              titlePadding: const EdgeInsets.only(top: 30),
                              contentPadding: const EdgeInsets.only(
                                  top: 5, bottom: 30, left: 25, right: 25),
                              middleText:
                                  "Upload your community profile picture",
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
                            communityController.clearProfilePhoto();
                          }
                        }),
                        Gap(Get.height * 0.02),
                        CustomText(
                          title: 'Community cover photo *',
                          color: AppColor().primaryWhite,
                          textAlign: TextAlign.center,
                          fontFamily: 'GilroyRegular',
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
                            communityController.clearCoverPhoto();
                          }
                        }),
                        Gap(Get.height * 0.02),
                        CustomText(
                          title: 'Games Covered *',
                          color: AppColor().primaryWhite,
                          textAlign: TextAlign.center,
                          fontFamily: 'GilroyRegular',
                          size: Get.height * 0.017,
                        ),
                        Gap(Get.height * 0.01),
                        InputDecorator(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor().bgDark,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColor().lightItemsColor,
                                    width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: seePost,
                              icon: Icon(
                                Icons.expand_more,
                                color: AppColor().primaryWhite,
                              ),
                              items:
                                  <String>['COD', 'Others'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: CustomText(
                                    title: value,
                                    color: AppColor().lightItemsColor,
                                    fontFamily: 'GilroyBold',
                                    weight: FontWeight.w400,
                                    size: 13,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  seePost = value;
                                });
                              },
                              hint: CustomText(
                                title: "Games Covered",
                                color: AppColor().lightItemsColor,
                                fontFamily: 'GilroyBold',
                                weight: FontWeight.w400,
                                size: 13,
                              ),
                            ),
                          ),
                        ),
                        Gap(Get.height * 0.02),
                        CustomText(
                          title: 'Enable team chat *',
                          color: AppColor().primaryWhite,
                          textAlign: TextAlign.center,
                          fontFamily: 'GilroyRegular',
                          size: Get.height * 0.017,
                        ),
                        Gap(Get.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              title: 'Yes',
                              color: AppColor().primaryWhite,
                              textAlign: TextAlign.center,
                              fontFamily: 'GilroySemiBold',
                              size: Get.height * 0.016,
                            ),
                            Gap(Get.height * 0.01),
                            InkWell(
                                onTap: () => setState(() {
                                      enableChat = true;
                                    }),
                                child: Icon(
                                  enableChat
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: enableChat
                                      ? AppColor().primaryColor
                                      : AppColor().primaryWhite,
                                  size: 20,
                                )),
                            Gap(Get.height * 0.02),
                            CustomText(
                              title: 'No',
                              color: AppColor().primaryWhite,
                              textAlign: TextAlign.center,
                              fontFamily: 'GilroySemiBold',
                              size: Get.height * 0.016,
                            ),
                            Gap(Get.height * 0.01),
                            InkWell(
                                onTap: () => setState(() {
                                      enableChat = false;
                                    }),
                                child: Icon(
                                  !enableChat
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: !enableChat
                                      ? AppColor().primaryColor
                                      : AppColor().primaryWhite,
                                  size: 20,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding: EdgeInsets.all(Get.height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: 'Add staff to your community *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'GilroyRegular',
                        size: Get.height * 0.017,
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: seePost,
                            icon: Icon(
                              Icons.expand_more,
                              color: AppColor().primaryWhite,
                            ),
                            items:
                                <String>['COD', 'Others'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: CustomText(
                                  title: value,
                                  color: AppColor().lightItemsColor,
                                  fontFamily: 'GilroyBold',
                                  weight: FontWeight.w400,
                                  size: 13,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                seePost = value;
                              });
                            },
                            hint: CustomText(
                              title: "COD",
                              color: AppColor().lightItemsColor,
                              fontFamily: 'GilroyBold',
                              weight: FontWeight.w400,
                              size: 13,
                            ),
                          ),
                        ),
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: 'Add secondary community manager *',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'GilroyRegular',
                        size: Get.height * 0.017,
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: seePost,
                            icon: Icon(
                              Icons.expand_more,
                              color: AppColor().primaryWhite,
                            ),
                            items:
                                <String>['COD', 'Others'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: CustomText(
                                  title: value,
                                  color: AppColor().lightItemsColor,
                                  fontFamily: 'GilroyBold',
                                  weight: FontWeight.w400,
                                  size: 13,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                seePost = value;
                              });
                            },
                            hint: CustomText(
                              title: "COD",
                              color: AppColor().lightItemsColor,
                              fontFamily: 'GilroyBold',
                              weight: FontWeight.w400,
                              size: 13,
                            ),
                          ),
                        ),
                      ),
                      Gap(Get.height * 0.02),
                    ],
                  ),
                ),
              ],
              Gap(Get.height * 0.05),
              Obx(() {
                return InkWell(
                  onTap: () {
                    Map<String, dynamic> body = {
                      'name': communityController.communityNameController.text
                          .trim(),
                      'bio': communityController.communityBioController.text
                          .trim(),
                      'enable_teamchat': enableChat.toString(),
                      'games_played': '',
                      // "isocials[0]['title']": 'X',
                      // "isocials[0]['link']": 'https://x.com',
                      // "isocials[1]['title']": 'Discord',
                      // "isocials[1]['link']": 'https://discord.com',
                    };

                    if (pageCount == 0) {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          pageCount = 1;
                        });
                      }
                    } else if (communityController.createCommunityStatus !=
                        CreateCommunityStatus.loading) {
                      communityController.createCommunity(body);
                      // Get.to(() =>
                      //     const CreateSuccessPage(title: 'Community Created'));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    height: Get.height * 0.07,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColor().primaryColor,
                    ),
                    child: (communityController.createCommunityStatus ==
                            CreateCommunityStatus.loading)
                        ? const LoadingWidget()
                        : Center(
                            child: CustomText(
                            title: pageCount == 0 ? 'Next' : 'Update',
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
          color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            communityController.communityProfileImage == null
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
                          image: FileImage(
                              communityController.communityProfileImage!),
                          fit: BoxFit.cover),
                    ),
                  ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: onTap,
              child: CustomText(
                title: communityController.communityProfileImage == null
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
          color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            communityController.communityCoverImage == null
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
                          image: FileImage(
                              communityController.communityCoverImage!),
                          fit: BoxFit.cover),
                    ),
                  ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: onTap,
              child: CustomText(
                title: communityController.communityCoverImage == null
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