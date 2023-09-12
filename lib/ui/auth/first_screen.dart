import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'login.dart';
import 'register.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBgColor,
      body: Stack(
        children: [
          SizedBox(
            width: Get.width,
            child: Center(
                child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/png/bg.png',
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(Get.height * 0.2),
                  SvgPicture.asset(
                    'assets/images/svg/splashTest.svg',
                    height: Get.height * 0.17,
                  ),
                  Gap(Get.height * 0.02),
                  Center(
                    child: CustomText(
                      title:
                          'Esports NG is your all in one social\nnetworking platform for Gaming',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyLight',
                      size: Get.height * 0.018,
                    ),
                  ),
                  Gap(Get.height * 0.1),
                  CustomFillButton(
                    buttonText: 'Sign up',
                    fontWeight: FontWeight.w600,
                    textSize: Get.height * 0.018,
                    onTap: () {
                      Get.to(() => const RegisterScreen());
                    },
                    isLoading: false,
                  ),
                  Gap(Get.height * 0.02),
                  CustomFillButton(
                    buttonText: 'Log in',
                    textColor: AppColor().primaryColor,
                    fontWeight: FontWeight.w600,
                    buttonColor: AppColor().primaryBgColor,
                    textSize: Get.height * 0.018,
                    onTap: () {
                      Get.to(() => const LoginScreen());
                    },
                    isLoading: false,
                  ),
                  Gap(Get.height * 0.05),
                  Center(
                    child: CustomText(
                      title: 'OR',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyLight',
                      size: Get.height * 0.018,
                    ),
                  ),
                  Gap(Get.height * 0.05),
                  CustomFillButton(
                    onTap: () {},
                    buttonText: '',
                    textColor: AppColor().primaryColor,
                    boarderColor: AppColor().primaryWhite,
                    fontWeight: FontWeight.w600,
                    buttonColor: AppColor().primaryBgColor,
                    textSize: Get.height * 0.021,
                    isLoading: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/png/google.png',
                        ),
                        Gap(Get.height * 0.01),
                        CustomText(
                          title: 'Continue with Google',
                          color: AppColor().primaryWhite,
                          textAlign: TextAlign.center,
                          fontFamily: 'GilroyLight',
                          weight: FontWeight.w600,
                          size: Get.height * 0.018,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
