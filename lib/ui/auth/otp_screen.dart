import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/keypad.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
// import 'package:numpad_layout/numpad.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final authController = Get.put(AuthRepository());
  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  String? otpText, otp;
  bool hasError = false;
  bool isLoading = false;
  String? errorMessage;
  String number = "";

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppColor().pureBlackColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(Get.height * 0.03),
            CustomText(
              title: 'OTP Verification',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'GilroyBold',
              size: Get.height * 0.032,
            ),
            CustomText(
              title:
                  'We’ve sent you a one time code to your phone\nnumber **** *** 8328',
              color: AppColor().primaryWhite.withOpacity(0.8),
              textAlign: TextAlign.start,
              fontFamily: 'GilroyRegular',
              size: Get.height * 0.016,
            ),
            Gap(Get.height * 0.1),
            Center(
              child: PinCodeTextField(
                pinBoxRadius: 8,
                autofocus: true,
                controller: controller,
                pinBoxOuterPadding: const EdgeInsets.symmetric(horizontal: 10),
                // hideCharacter:
                //      false,
                highlight: true,
                highlightAnimation: true,
                highlightColor: AppColor().lightBlack,
                defaultBorderColor: AppColor().primaryColor,
                hasTextBorderColor: AppColor().primaryColor,
                highlightPinBoxColor: AppColor().lightBlack,
                hasError: hasError,
                // maskCharacter:
                //     widget.title == 'withdrawal' ? "*" : thisText,
                onTextChanged: (text) {
                  setState(() {
                    otp = text;
                    hasError = false;
                  });
                },
                onDone: (text) {
                  otpText = text;
                  authController.otpPin.text = text;
                  if (kDebugMode) {
                    print("DONE $otpText");
                  }
                },
                pinBoxWidth: Get.height * 0.07,
                pinBoxHeight: Get.height * 0.07,
                hasUnderline: false,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                pinTextStyle: const TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'GilroyRegular',
                  fontWeight: FontWeight.w700,
                ),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration:
                    const Duration(milliseconds: 300),
                highlightAnimationBeginColor: Colors.black,
                highlightAnimationEndColor: Colors.white12,
                keyboardType: TextInputType.number,
              ),
            ),
            Gap(Get.height * 0.05),
            Center(
              child: CustomText(
                title: '00:59',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyBold',
                size: Get.height * 0.028,
              ),
            ),
            Gap(Get.height * 0.02),
            Center(
              child: Text.rich(TextSpan(
                text: "Didn`t receive code?",
                style: TextStyle(
                  color: AppColor().primaryWhite.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'GilroyRegular',
                  fontSize: Get.height * 0.018,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: " Resend",
                      style: TextStyle(
                          color: AppColor().primaryColor,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Add Resend Code Logic
                        }),
                ],
              )),
            ),

            Gap(Get.height * 0.12),
            CustomFillButton(
              buttonText: 'Continue',
              fontWeight: FontWeight.w600,
              textSize: Get.height * 0.016,
              onTap: () {
                if (otp == null || otp == '') {
                  Get.snackbar(
                    'Alert',
                    'Enter your OTP to continue!',
                    titleText: CustomText(
                      title: 'Alert',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyBold',
                      size: Get.height * 0.015,
                    ),
                    messageText: CustomText(
                      title: 'Enter your OTP to continue!',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.015,
                    ),
                  );
                } else if (otp!.length < 4 || otp!.length > 4) {
                  Get.snackbar(
                    'Alert',
                    'Invalid OTP!',
                    titleText: CustomText(
                      title: 'Alert',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyBold',
                      size: Get.height * 0.015,
                    ),
                    messageText: CustomText(
                      title: 'Invalid OTP!',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.015,
                    ),
                  );
                } else {}
              },
              isLoading: false,
            ),
            // NumPad(
            //   highlightColor: AppColor().primaryWhite,
            //   runSpace: Get.height * 0.03,
            //   onType: (value) {
            //     setState(() {
            //       otpText += value;
            //     });
            //     if (kDebugMode) {
            //       print("OTP: $otpText");
            //     }
            //   },
            //   rightWidget: IconButton(
            //     icon: Icon(
            //       Icons.backspace,
            //       color: AppColor().primaryWhite,
            //     ),
            //     onPressed: () {
            //       if (otpText.isNotEmpty) {
            //         setState(() {
            //           otpText = otpText.substring(0, otpText.length - 1);
            //         });
            //         if (kDebugMode) {
            //           print("OTP: $otpText");
            //         }
            //       }
            //     },
            //   ),
            // )
          ],
        )),
      ),
    );
  }
}
