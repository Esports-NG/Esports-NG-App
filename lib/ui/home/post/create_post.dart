import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CreatePost extends StatelessWidget {
  const CreatePost({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthRepository());
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
                    ),
                  ],
                )),
                CustomText(
                  title: 'Change Account',
                  weight: FontWeight.w400,
                  size: 15,
                  fontFamily: 'GilroyMedium',
                  color: AppColor().primaryColor,
                  underline: TextDecoration.underline,
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
              textEditingController: authController.fullNameController,
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
          ],
        ),
      ),
    );
  }
}
