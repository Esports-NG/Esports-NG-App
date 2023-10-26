import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'create_post_item.dart';

class CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({super.key});

  @override
  State<CreateCommunityPage> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreateCommunityPage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthRepository());
  String? gameTag, seePost, engagePost;
  int? _selectedMenu;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        title: CustomText(
          title: 'Create Community Page',
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
                CustomText(
                  title: 'Fill the form correctly to create a community page',
                  weight: FontWeight.w400,
                  size: 15,
                  fontFamily: 'GilroyMedium',
                  color: AppColor().primaryWhite,
                ),
                Gap(Get.height * 0.03),
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
                  // textEditingController: authController.fullNameController,
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
                  // textEditingController: authController.fullNameController,
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
                  // textEditingController: authController.fullNameController,
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
                pickImage(onTap: () {}),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Community cover photo *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                pickImage(onTap: () {}),
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
                      items: <String>['COD', 'Others'].map((String value) {
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
                                  title: 'Next',
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

  Container pickImage({VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.04),
      decoration: BoxDecoration(
          color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/svg/photo.svg',
              height: Get.height * 0.08,
            ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: onTap,
              child: CustomText(
                title: 'Click to upload ',
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
