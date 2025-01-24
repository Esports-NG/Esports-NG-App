import 'dart:io';

import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/account_teams/game_selection_chip.dart';
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

class CreatePost extends StatefulWidget {
  const CreatePost({super.key, this.postId, this.postAs, this.postName});
  final int? postId;
  final String? postAs;
  final String? postName;

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final postController = Get.put(PostRepository());
  final teamController = Get.put(TeamRepository());
  final communityController = Get.put(CommunityRepository());
  final authController = Get.put(AuthRepository());
  final gameController = Get.put(GamesRepository());

  String? gameTag, seePost, engagePost;
  int? selectedMenu = 0;
  bool? isPostTitle = false,
      isPostBody = false,
      isGameTag = false,
      isSeePost = false,
      isEngagePost = false;

  final FocusNode postBodyFocusNode = FocusNode();
  final FocusNode gameTagFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.postId != null) {
      postController.postId.value = widget.postId!;
      postController.postAs.value = widget.postAs!;
      postController.postName.value = widget.postName!;
    } else {
      postController.postId.value = authController.user!.id!;
      postController.postAs.value = "user";
      postController.postName.value = authController.user!.fullName!;
    }
  }

  @override
  void dispose() {
    postBodyFocusNode.dispose();
    gameTagFocusNode.dispose();
    super.dispose();
  }

  void handleTap(String? title) {
    if (title == 'postBody') {
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
            fontFamily: "InterSemiBold",
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
                          fontFamily: 'InterMedium',
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: postController.postName.value,
                            style: const TextStyle(fontFamily: "InterSemiBold"),
                          ),
                        ],
                      )),
                      GestureDetector(
                        onTap: _showAccountListDialog,
                        child: CustomText(
                          title: 'Change Account',
                          size: 15,
                          fontFamily: 'InterMedium',
                          color: AppColor().primaryColor,
                          underline: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  Gap(Get.height * 0.03),
                  CustomText(
                    title: 'Fill the form correctly to create a new post',
                    size: 15,
                    fontFamily: 'InterMedium',
                    color: AppColor().primaryWhite,
                  ),
                  Gap(Get.height * 0.03),
                  CustomText(
                    title: 'Post text *',
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
                    title: 'Upload an image (Optional)',
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
                              postController.clearPhoto();
                            }
                          },
                          child: CustomText(
                            title: postController.postImage == null
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
                  Gap(Get.height * 0.02),
                  CustomText(
                    title: 'Add game tags',
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.center,
                    fontFamily: 'Inter',
                    size: Get.height * 0.017,
                  ),
                  Gap(Get.height * 0.01),
                  GameSelectionChip(
                    postCreation: true,
                    controller: postController.gameTagsController,
                    gameList: gameController.allGames,
                  ),
                  Gap(Get.height * 0.05),
                  InkWell(
                    onTap: () {
                      PostModel post = PostModel(
                          body: postController.postBodyController.text.trim(),
                          iTags: [
                            '#${postController.gameTagController.text}'
                          ],
                          iViewers: [
                            postController.seeController.text,
                          ]);
                      debugPrint('post: ${post.toCreatePostJson()}');
                      if (_formKey.currentState!.validate() &&
                          postController.createPostStatus !=
                              CreatePostStatus.loading) {
                        postController.createPost(post);
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

  void _showAccountListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final List<bool> _isOpen = [false, false];
        return StatefulBuilder(builder: (context, myState) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  padding: const EdgeInsets.only(top: 0),
                  child: CustomText(
                    title: 'Post as:',
                    size: Get.height * 0.018,
                    fontFamily: 'InterSemiBold',
                    textAlign: TextAlign.center,
                    color: AppColor().primaryWhite,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColor().primaryLightColor,
            content: SizedBox(
                width: Get.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        postController.postAs.value = "user";
                        postController.postId.value = authController.user!.id!;
                        postController.postName.value =
                            authController.user!.fullName!;
                        Get.back();
                      },
                      child: Row(
                        children: [
                          OtherImage(
                            image: authController.user!.profile!.profilePicture ?? DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/png/placeholder.png')),
                            width: 40,
                            height: 40,
                          ),
                          const Gap(10),
                          CustomText(
                              title: authController.user!.fullName,
                              color: AppColor().primaryWhite,
                              size: 16)
                        ],
                      ),
                    ),
                    const Gap(10),
                    ExpansionPanelList(
                        expandedHeaderPadding: const EdgeInsets.all(0),
                        dividerColor: Colors.transparent,
                        expansionCallback: (panelIndex, isExpanded) =>
                            myState(() {
                              _isOpen[panelIndex] = isExpanded;
                            }),
                        expandIconColor: AppColor().primaryWhite,
                        elevation: 0,
                        children: [
                          ExpansionPanel(
                              backgroundColor: Colors.transparent,
                              isExpanded: _isOpen[0],
                              headerBuilder: (context, isExpanded) => Row(
                                    children: [
                                      CustomText(
                                          title: "Teams",
                                          color: AppColor().primaryWhite),
                                    ],
                                  ),
                              body: ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: teamController.myTeam.length,
                                separatorBuilder: (context, index) => Gap(20),
                                itemBuilder: (context, index) {
                                  var item = teamController.myTeam[index];
                                  return GestureDetector(
                                    onTap: () {
                                      postController.postAs.value = "team";
                                      postController.postId.value = item.id!;
                                      postController.postName.value =
                                          item.name!;
                                      Get.back();
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              image: item.profilePicture == null
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/png/placeholder.png'))
                                                  : DecorationImage(
                                                      image: NetworkImage(
                                                          item.profilePicture!),
                                                      fit: BoxFit.cover)),
                                          width: 40,
                                          height: 40,
                                        ),
                                        const Gap(10),
                                        CustomText(
                                            title: item.name,
                                            color: AppColor().primaryWhite,
                                            size: 16)
                                      ],
                                    ),
                                  );
                                },
                              )),
                          ExpansionPanel(
                              backgroundColor: Colors.transparent,
                              isExpanded: _isOpen[1],
                              headerBuilder: (context, isExpanded) => Row(
                                    children: [
                                      CustomText(
                                          title: "Communities",
                                          color: AppColor().primaryWhite),
                                    ],
                                  ),
                              body: ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: communityController.allCommunity
                                    .where((e) =>
                                        e.owner!.id == authController.user!.id)
                                    .toList()
                                    .length,
                                separatorBuilder: (context, index) => Gap(20),
                                itemBuilder: (context, index) {
                                  var item = communityController.allCommunity
                                      .where((e) =>
                                          e.owner!.id ==
                                          authController.user!.id)
                                      .toList()[index];
                                  return GestureDetector(
                                    onTap: () {
                                      postController.postAs.value = "community";
                                      postController.postId.value = item.id!;
                                      postController.postName.value =
                                          item.name!;
                                      Get.back();
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              image: item.logo == null
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/png/placeholder.png'))
                                                  : DecorationImage(
                                                  image:
                                                      NetworkImage(item.logo!),
                                                  fit: BoxFit.cover)),
                                          width: 40,
                                          height: 40,
                                        ),
                                        const Gap(10),
                                        CustomText(
                                            title: item.name,
                                            color: AppColor().primaryWhite,
                                            size: 16)
                                      ],
                                    ),
                                  );
                                },
                              )),
                        ]),
                  ],
                )),
          );
        });
      },
    );
  }
}
