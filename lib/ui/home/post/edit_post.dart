import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/account/account_teams/game_selection_chip.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/small_circle.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'create_post_item.dart';

class EditPost extends StatefulWidget {
  final PostModel item;
  const EditPost({super.key, required this.item});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final postController = Get.put(PostRepository());
  final gamesController = Get.put(GamesRepository());
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
  void initState() {
    postController.postBodyController.text =
        utf8.decode(widget.item.body!.runes.toList(), allowMalformed: true);
    final gamesTagList = gamesController.allGames
        .where((e) =>
            widget.item.tags!.where((i) => i.title! == e.abbrev!).isNotEmpty)
        .toList();
    postController.gameTags.assignAll(gamesTagList);
    super.initState();
  }

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
            title: 'Edit Post',
            fontFamily: "InterSemiBold",
            size: 18,
            color: AppColor().primaryWhite,
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete Post",
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
                          postController.deletePost(widget.item.id!);
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
        body: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text.rich(TextSpan(
                  //       text: "Post as: ",
                  //       style: TextStyle(
                  //         color: AppColor().primaryWhite,
                  //         fontFamily: 'InterMedium',
                  //         fontSize: 15,
                  //       ),
                  //       children: [
                  //         TextSpan(
                  //           text: postController.accountTypeController.text ==
                  //                   ''
                  //               ? "“Your User Profile”"
                  //               : "“${postController.accountTypeController.text}”",
                  //           style: const TextStyle( fontFamily: "InterSemiBold"),
                  //         ),
                  //       ],
                  //     )),
                  //     InkWell(
                  //       onTap: () {
                  //         _showAccountListDialog(context);
                  //       },
                  //       child: CustomText(
                  //         title: 'Change Account',
                  //
                  //         size: 15,
                  //         fontFamily: 'InterMedium',
                  //         color: AppColor().primaryColor,
                  //         underline: TextDecoration.underline,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Gap(Get.height * 0.03),
                  // CustomText(
                  //   title: 'Edit the form correctly to create a new post',
                  //
                  //   size: 15,
                  //   fontFamily: 'InterMedium',
                  //   color: AppColor().primaryWhite,
                  // ),
                  // Gap(Get.height * 0.03),
                  CustomText(
                    title: 'Post body *',
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.center,
                    fontFamily: 'Inter',
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
                    title: 'Game tags *',
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.center,
                    fontFamily: 'Inter',
                    size: Get.height * 0.017,
                  ),
                  Gap(Get.height * 0.01),
                  const GameSelectionChip(
                    postCreation: true,
                  ),
                  Gap(Get.height * 0.02),
                  if (widget.item.image != null)
                    Column(
                      children: [
                        CustomText(
                          title: 'Post image',
                          color: AppColor().primaryWhite,
                          textAlign: TextAlign.center,
                          fontFamily: 'Inter',
                          size: Get.height * 0.017,
                        ),
                        Gap(Get.height * 0.01),
                        CachedNetworkImage(
                          height: Get.height * 0.25,
                          width: double.infinity,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: SizedBox(
                              height: Get.height * 0.05,
                              width: Get.height * 0.05,
                              child: CircularProgressIndicator(
                                  color: AppColor().primaryWhite,
                                  value: progress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, color: AppColor().primaryWhite),
                          imageUrl:
                              'http://res.cloudinary.com/dkykwpryb/${widget.item.image!}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'http://res.cloudinary.com/dkykwpryb/${widget.item.image!}'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Gap(Get.height * 0.05),
                      ],
                    ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate() &&
                          postController.createPostStatus !=
                              CreatePostStatus.loading) {
                        postController.editPost(widget.item.id!);
                      }
                    },
                    child: Container(
                      height: Get.height * 0.07,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: postController.createPostStatus ==
                                CreatePostStatus.loading
                            ? Colors.transparent
                            : AppColor().primaryColor,
                      ),
                      child: (postController.createPostStatus ==
                              CreatePostStatus.loading)
                          ? const Center(child: ButtonLoader())
                          : Center(
                              child: CustomText(
                              title: 'Update Post',
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
                    fontFamily: 'InterSemiBold',
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

  void deletePostDialog(BuildContext context) {
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
                    title: 'Are you sure you want to delete post?',
                    size: Get.height * 0.018,
                    fontFamily: 'InterSemiBold',
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
                height: Get.height * 0.2,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => postController.deletePost(widget.item.id!),
                      child: Container(
                        padding: EdgeInsets.all(Get.height * 0.025),
                        decoration: BoxDecoration(
                          color: AppColor().primaryColor,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: AppColor().primaryColor, width: 1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              title: 'Yes',
                              size: Get.height * 0.016,
                              fontFamily: 'InterMedium',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                            const Spacer(),
                            SmallCircle(
                              size: Get.height * 0.015,
                              color: AppColor().primaryWhite,
                              bColor: AppColor().primaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(Get.height * 0.025),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: AppColor().lightItemsColor, width: 1),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              title: 'No',
                              size: Get.height * 0.016,
                              fontFamily: 'InterMedium',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                            const Spacer(),
                            SmallCircle(
                              size: Get.height * 0.015,
                              color: AppColor().primaryWhite,
                              bColor: AppColor().primaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
      },
    );
  }
}
