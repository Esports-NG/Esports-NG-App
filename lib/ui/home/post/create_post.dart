import 'dart:io';
import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  final postController = Get.put(PostRepository());
  String? gameTag, seePost, engagePost;
  int? selectedMenu = 0;
  bool? isPostTitle = false,
      isPostBody = false,
      isGameTag = false,
      isSeePost = false,
      isEngagePost = false;

  final FocusNode postTitleFocusNode = FocusNode();
  final FocusNode postBodyFocusNode = FocusNode();
  final FocusNode gameTagFocusNode = FocusNode();

  @override
  void dispose() {
    postTitleFocusNode.dispose();
    postBodyFocusNode.dispose();
    gameTagFocusNode.dispose();
    super.dispose();
  }

  void handleTap(String? title) {
    if (title == 'postTitle') {
      setState(() {
        isPostTitle = true;
      });
    } else if (title == 'postBody') {
      setState(() {
        isPostBody = true;
      });
    } else if (title == 'gameTag') {
      setState(() {
        isGameTag = true;
      });
    } else if (title == 'seePost') {
      setState(() {
        isSeePost = true;
      });
    } else {
      setState(() {
        isEngagePost = true;
      });
    }
  }

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        postController.mPostImage(imageTemporary);
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
        postController.mPostImage(imageTemporary);
      });
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
            title: 'Create a Post',
            weight: FontWeight.w600,
            size: 18,
            color: AppColor().primaryWhite,
          ),
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Get.back();
              postController.clear();
            },
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
                        children: [
                          TextSpan(
                            text: postController.accountTypeController.text ==
                                    ''
                                ? "“Your User Profile”"
                                : "“${postController.accountTypeController.text}”",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                      InkWell(
                        onTap: () {
                          _showAccountListDialog(context);
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
                    title: 'Post title *',
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.center,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.017,
                  ),
                  Gap(Get.height * 0.01),
                  CustomTextField(
                    hint: "Type text here",
                    textEditingController: postController.postTitleController,
                    hasText: isPostTitle!,
                    focusNode: postTitleFocusNode,
                    onTap: () {
                      handleTap('postTitle');
                    },
                    onSubmited: (_) {
                      postTitleFocusNode.unfocus();
                    },
                    onChanged: (value) {
                      setState(() {
                        isPostTitle = value.isNotEmpty;
                      });
                    },
                    maxLines: 2,
                    validate: Validator.isName,
                  ),
                  Gap(Get.height * 0.02),
                  CustomText(
                    title: 'Post body *',
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.center,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.017,
                  ),
                  Gap(Get.height * 0.01),
                  CustomTextField(
                    hint: "Type text here",
                    textEditingController: postController.postBodyController,
                    hasText: isPostBody!,
                    focusNode: postBodyFocusNode,
                    onTap: () {
                      handleTap('postBody');
                    },
                    onSubmited: (_) {
                      postBodyFocusNode.unfocus();
                    },
                    onChanged: (value) {
                      setState(() {
                        isPostBody = value.isNotEmpty;
                      });
                    },
                    maxLines: 5,
                    validate: Validator.isName,
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
                      fillColor: isGameTag == true
                          ? AppColor().primaryWhite
                          : AppColor().bgDark,
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
                              color: isGameTag == true
                                  ? AppColor().primaryBackGroundColor
                                  : AppColor().lightItemsColor,
                              fontFamily: 'GilroyBold',
                              weight: FontWeight.w400,
                              size: 13,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            gameTag = value;
                            postController.gameTagController.text = gameTag!;
                            handleTap('gameTag');
                          });
                        },
                        hint: CustomText(
                          title: "Game Tag",
                          color: isGameTag == true
                              ? AppColor().primaryBackGroundColor
                              : AppColor().lightItemsColor,
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
                        postController.postImage == null
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
                                          FileImage(postController.postImage!),
                                      fit: BoxFit.cover),
                                ),
                              ),
                        Gap(Get.height * 0.01),
                        InkWell(
                          onTap: () {
                            if (postController.postImage == null) {
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
                              postController.clearPhoto();
                            }
                          },
                          child: CustomText(
                            title: postController.postImage == null
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
                      fillColor: isSeePost == true
                          ? AppColor().primaryWhite
                          : AppColor().bgDark,
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
                        items: <String>['Everyone', 'My Followers', 'Just Me']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: CustomText(
                              title: value,
                              color: isSeePost == true
                                  ? AppColor().primaryBackGroundColor
                                  : AppColor().lightItemsColor,
                              fontFamily: 'GilroyBold',
                              weight: FontWeight.w400,
                              size: 13,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            seePost = value;
                            postController.seeController.text = seePost!;
                            handleTap('seePost');
                          });
                        },
                        hint: CustomText(
                          title: "Everyone",
                          color: isSeePost == true
                              ? AppColor().primaryBackGroundColor
                              : AppColor().lightItemsColor,
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
                      fillColor: isEngagePost == true
                          ? AppColor().primaryWhite
                          : AppColor().bgDark,
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
                              color: isEngagePost == true
                                  ? AppColor().primaryBackGroundColor
                                  : AppColor().lightItemsColor,
                              fontFamily: 'GilroyBold',
                              weight: FontWeight.w400,
                              size: 13,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            engagePost = value;
                            postController.engageController.text = engagePost!;
                            handleTap('engagePost');
                          });
                        },
                        hint: CustomText(
                          title: "Everyone",
                          color: isEngagePost == true
                              ? AppColor().primaryBackGroundColor
                              : AppColor().lightItemsColor,
                          fontFamily: 'GilroyBold',
                          weight: FontWeight.w400,
                          size: 13,
                        ),
                      ),
                    ),
                  ),
                  Gap(Get.height * 0.05),
                  InkWell(
                    onTap: () {
                      PostModel post = PostModel(
                        title: postController.postTitleController.text.trim(),
                        body: postController.postBodyController.text.trim(),
                        iTags: '#${postController.gameTagController.text}',
                        iViewers: postController.seeController.text,
                      );
                      debugPrint('post: ${post.toCreatePostJson()}');
                      if (_formKey.currentState!.validate() &&
                          postController.createPostStatus !=
                              CreatePostStatus.loading) {
                        if (postController.postImage == null) {
                          EasyLoading.showInfo('Select post image!');
                        } else if (postController.gameTagController.text ==
                            '') {
                          EasyLoading.showInfo('Select game tag!');
                        } else if (postController.seeController.text == '') {
                          EasyLoading.showInfo('Select who can see post!');
                        } else if (postController.engageController.text == '') {
                          EasyLoading.showInfo('Select who can engage post!');
                        } else {
                          postController.createPost(post, context);
                        }
                      }
                    },
                    child: Container(
                      height: Get.height * 0.07,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColor().primaryColor,
                      ),
                      child: (postController.createPostStatus ==
                              CreatePostStatus.loading)
                          ? const LoadingWidget()
                          : Center(
                              child: CustomText(
                              title: 'Create Post',
                              color: AppColor().primaryWhite,
                              weight: FontWeight.w600,
                              size: Get.height * 0.018,
                            )),
                    ),
                  ),
                  Gap(Get.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showAccountListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, myState) {
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
                          postController.accountTypeController.text =
                              item.title;
                        });
                        myState(() {
                          selectedMenu = index;
                        });
                        Get.back();
                      },
                      child: CreateMenu(
                        item: item,
                        selectedItem: selectedMenu,
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
