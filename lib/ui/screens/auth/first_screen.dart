import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/screens/activities/activities.dart';
import 'package:e_sport/ui/screens/news/news.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'login.dart';
import 'register.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final authController = Get.put(AuthRepository());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
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
                          'ENGY Africa is your all in one social\nnetworking platform for Gaming',
                      color: AppColor().primaryWhite.withOpacity(0.9),
                      textAlign: TextAlign.center,
                      fontFamily: 'InterMedium',
                      size: 16,
                    ),
                  ),
                  Gap(Get.height * 0.1),
                  CustomFillButton(
                    buttonText: 'Sign up',
                    textSize: 16,
                    onTap: () {
                      authController.pref!.setFirstTimeOpen(false);
                      Get.to(() => const RegisterScreen());
                    },
                    isLoading: false,
                  ),
                  Gap(Get.height * 0.02),
                  CustomFillButton(
                    buttonText: 'Log in',
                    textColor: AppColor().primaryColor,
                    buttonColor:
                        AppColor().primaryBackGroundColor.withOpacity(0.7),
                    textSize: 16,
                    onTap: () {
                      authController.pref!.setFirstTimeOpen(false);
                      Get.to(() => const LoginScreen());
                    },
                    isLoading: false,
                  ),
                  Gap(10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomFillButton(
                        onTap: () => Get.to(() => NewsScreen()),
                        buttonText: "See News",
                        buttonColor: Colors.transparent,
                        boarderColor: Colors.transparent,
                        width: Get.width * 0.4,
                        child: Row(
                          spacing: 8.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              title: "See News",
                              size: 14,
                              fontFamily: "InterSemiBold",
                            ),
                            Icon(
                              IconsaxPlusLinear.arrow_right,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      CustomFillButton(
                        onTap: () => Get.to(() => ActivitiesScreen()),
                        buttonText: "View activities",
                        buttonColor: Colors.transparent,
                        boarderColor: Colors.transparent,
                        width: Get.width * 0.4,
                        child: Row(
                          spacing: 8.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              title: "View Activities",
                              size: 14,
                              fontFamily: "InterSemiBold",
                            ),
                            Icon(
                              IconsaxPlusLinear.arrow_right,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Gap(Get.height * 0.05),
                  // Center(
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //           child: Divider(
                  //         color: AppColor().primaryWhite.withOpacity(0.7),
                  //       )),
                  //       Padding(
                  //         padding: EdgeInsets.symmetric(
                  //             horizontal: Get.height * 0.01),
                  //         child: CustomText(
                  //           title: 'OR',
                  //           color: AppColor().primaryWhite.withOpacity(0.7),
                  //           textAlign: TextAlign.center,
                  //           fontFamily: 'InterMedium',
                  //           size: 14,
                  //         ),
                  //       ),
                  //       Expanded(
                  //           child: Divider(
                  //         color: AppColor().primaryWhite.withOpacity(0.7),
                  //       )),
                  //     ],
                  //   ),
                  // ),
                  // Gap(Get.height * 0.05),
                  // CustomFillButton(
                  //   onTap: () {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(
                  //         content: CustomText(
                  //           title: 'Coming soon!',
                  //           size: Get.height * 0.02,
                  //           color: AppColor().primaryWhite,
                  //           textAlign: TextAlign.start,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   buttonText: '',
                  //   textColor: AppColor().primaryColor,
                  //   boarderColor: AppColor().primaryWhite,
                  //    fontFamily: "InterSemiBold",
                  //   buttonColor:
                  //       AppColor().primaryBackGroundColor.withOpacity(0.7),
                  //   textSize: Get.height * 0.021,
                  //   isLoading: false,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Image.asset(
                  //         'assets/images/png/google.png',
                  //       ),
                  //       Gap(Get.height * 0.01),
                  //       CustomText(
                  //         title: 'Continue with Google',
                  //         color: AppColor().primaryWhite,
                  //         textAlign: TextAlign.center,
                  //         fontFamily: 'InterMedium',
                  //         size: 14,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
