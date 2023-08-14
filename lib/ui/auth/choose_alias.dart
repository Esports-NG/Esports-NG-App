import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/home/dashboard.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChooseAlias extends StatelessWidget {
  const ChooseAlias({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthRepository());
    return Scaffold(
      backgroundColor: AppColor().pureBlackColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Gap(Get.height * 0.2),
          Center(
            child: Image.asset(
              'assets/images/png/done1.png',
              // height: Get.height * 0.2,
              // width: Get.height * 0.2,
            ),
          ),
          Gap(Get.height * 0.05),
          CustomText(
            title: 'Choose an awesome\nalias for your profile ',
            color: AppColor().primaryWhite,
            textAlign: TextAlign.center,
            fontFamily: 'GilroyBold',
            size: Get.height * 0.04,
          ),
          Gap(Get.height * 0.03),
          CustomTextField(
            hint: "e.g realmitcha",
            textEditingController: authController.uNameController,
            validate: (value) {
              if (value!.isEmpty) {
                return 'Username must not be empty';
              } else if (!RegExp(r'[A-Za-z]+$').hasMatch(value)) {
                return "Please enter only letters";
              }
              return null;
            },
          ),
          Gap(Get.height * 0.25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomFillButton(
                onTap: () {
                  Get.off(() => const Dashboard());
                },
                width: Get.width / 2 - Get.height * 0.04,
                height: Get.height * 0.07,
                buttonText: 'Skip',
                fontWeight: FontWeight.w600,
                textSize: Get.height * 0.016,
                isLoading: false,
                buttonColor: AppColor().pureBlackColor,
                boarderColor: AppColor().primaryColor,
                textColor: AppColor().primaryColor,
              ),
              CustomFillButton(
                onTap: () {
                  Get.off(() => const Dashboard());
                },
                width: Get.width / 2 - Get.height * 0.04,
                height: Get.height * 0.07,
                buttonText: 'Next',
                fontWeight: FontWeight.w600,
                textSize: Get.height * 0.016,
                isLoading: false,
              ),
            ],
          )
        ]),
      )),
    );
  }
}
