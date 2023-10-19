import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChooseAlias extends StatefulWidget {
  final UserModel user;
  const ChooseAlias({super.key, required this.user});

  @override
  State<ChooseAlias> createState() => _ChooseAliasState();
}

class _ChooseAliasState extends State<ChooseAlias> {
  final authController = Get.put(AuthRepository());
  bool userCheck = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Gap(Get.height * 0.2),
          Center(
            child: Image.asset(
              'assets/images/png/done1.png',
              height: Get.height * 0.17,
              width: Get.height * 0.17,
            ),
          ),
          Gap(Get.height * 0.04),
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
            textEditingController: authController.userNameController,
            onChanged: (value) {
              setState(() {});
              if (value.isEmpty) {
                userCheck = false;
              } else {
                userCheck = true;
              }
            },
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
          Obx(() {
            return InkWell(
              onTap: () {
                widget.user.userName =
                    authController.userNameController.text.trim();
                debugPrint('User: ${widget.user.toJson()}');
                if (userCheck == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: CustomText(
                        title: 'Enter your username to continue!',
                        size: Get.height * 0.02,
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  );
                } else {
                  if (authController.signUpStatus != SignUpStatus.loading) {
                    authController.signUp(widget.user, context);
                  }
                }
              },
              child: Container(
                height: Get.height * 0.07,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: userCheck == false
                      ? AppColor().bgDark
                      : AppColor().primaryColor,
                ),
                child: (authController.signUpStatus == SignUpStatus.loading)
                    ? const LoadingWidget()
                    : Center(
                        child: CustomText(
                        title: 'Continue',
                        color: userCheck == false
                            ? AppColor().bgDark
                            : AppColor().primaryWhite,
                        weight: FontWeight.w600,
                        size: Get.height * 0.016,
                      )),
              ),
            );
          }),
        ]),
      )),
    );
  }
}
