import 'dart:io';

import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'create_post_item.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthRepository());
  String? gameTag, seePost, engagePost;
  int? _selectedMenu;

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        authController.mUserImage(imageTemporary);
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
        authController.mUserImage(imageTemporary);
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          title: 'Create a Post',
          weight: FontWeight.w600,
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: AppColor().primaryWhite,
          ),
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(TextSpan(
                      text: "Post as: ",
                      style: TextStyle(
                        color: AppColor().primaryWhite,
                        fontFamily: 'GilroyMedium',
                        fontSize: 15,
                      ),
                      children: const [
                        TextSpan(
                          text: "“Your User Profile”",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                    InkWell(
                      onTap: () {
                        _showItemListDialog(context);
                      },
                      child: CustomText(
                        title: 'Change Account',
                        weight: FontWeight.w400,
                        size: 15,
                        fontFamily: 'GilroyMedium',
                        color: AppColor().primaryColor,
                        underline: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                Gap(Get.height * 0.03),
                CustomText(
                  title: 'Fill the form correctly to create a new post',
                  weight: FontWeight.w400,
                  size: 15,
                  fontFamily: 'GilroyMedium',
                  color: AppColor().primaryWhite,
                ),
                Gap(Get.height * 0.03),
                CustomText(
                  title: 'Post an update *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Type text here",
                  // textEditingController: authController.fullNameController,
                  maxLines: 5,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Full Name must not be empty';
                    }
                    return null;
                  },
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Add game tags *',
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: gameTag,
                      icon: Icon(
                        Icons.expand_more,
                        color: AppColor().primaryWhite,
                      ),
                      items: <String>[
                        'COD',
                        'Others',
                      ].map((String value) {
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
                          gameTag = value;
                        });
                      },
                      hint: CustomText(
                        title: "Game Tag",
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
                  title: 'Upload an image (Optional)',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                Obx(() {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Get.height * 0.04),
                    decoration: BoxDecoration(
                        color: AppColor().bgDark,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        authController.userImage == null
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
                                      image:
                                          FileImage(authController.userImage!),
                                      fit: BoxFit.cover),
                                ),
                              ),
                        Gap(Get.height * 0.01),
                        InkWell(
                          onTap: () {
                            if (authController.userImage == null) {
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
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'GilroyRegular',
                                ),
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
                                  fontFamily: 'GilroyRegular',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            } else {
                              authController.clearPhoto();
                            }
                          },
                          child: CustomText(
                            title: authController.userImage == null
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
                  );
                }),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Who can see this post *',
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: seePost,
                      icon: Icon(
                        Icons.expand_more,
                        color: AppColor().primaryWhite,
                      ),
                      items: <String>['Everyone', 'My Followers', 'Just Me']
                          .map((String value) {
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
                        title: "Everyone",
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
                  title: 'Who can engage with this post *',
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: engagePost,
                      icon: Icon(
                        Icons.expand_more,
                        color: AppColor().primaryWhite,
                      ),
                      items: <String>['Everyone', 'My Followers', 'Just Me']
                          .map((String value) {
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
                          engagePost = value;
                        });
                      },
                      hint: CustomText(
                        title: "Everyone",
                        color: AppColor().lightItemsColor,
                        fontFamily: 'GilroyBold',
                        weight: FontWeight.w400,
                        size: 13,
                      ),
                    ),
                  ),
                ),
                Gap(Get.height * 0.05),
                Obx(() {
                  return InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Get.back();
                      }
                    },
                    child: Container(
                      height: Get.height * 0.07,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColor().primaryColor,
                      ),
                      child:
                          (authController.signInStatus == SignInStatus.loading)
                              ? const LoadingWidget()
                              : Center(
                                  child: CustomText(
                                  title: 'Create Post',
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
        ),
      ),
    );
  }

  void _showItemListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: AppColor().primaryWhite,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomText(
                    title: 'Select an account for\nyour post',
                    size: Get.height * 0.018,
                    fontFamily: 'GilroySemiBold',
                    textAlign: TextAlign.center,
                    color: AppColor().primaryWhite,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColor().primaryLightColor,
            content: Container(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                width: Get.width * 0.5,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: selectAccountItem.length,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.03),
                  itemBuilder: (context, index) {
                    var item = selectAccountItem[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMenu = index;
                        });
                        Get.back();
                      },
                      child: CreateMenu(
                        item: item,
                        selectedItem: _selectedMenu,
                        index: index,
                      ),
                    );
                  },
                )),
          );
        });
      },
    );
  }
}
