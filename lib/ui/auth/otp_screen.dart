import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/home/dashboard.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/keypad.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final authController = Get.put(AuthRepository());
  TextEditingController controller = TextEditingController(text: "");
  final CountdownController _controller = CountdownController(autoStart: true);
  String thisText = "";
  String? otpText, otp;
  bool hasError = false;
  bool isLoading = false;
  String? errorMessage;
  String number = "";
  bool resend = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.020),
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
              size: Get.height * 0.04,
            ),
            CustomText(
              title:
                  'We’ve sent you a one time code to your phone\nnumber **** *** 8328',
              color: AppColor().primaryWhite.withOpacity(0.8),
              textAlign: TextAlign.start,
              fontFamily: 'GilroyMedium',
              size: Get.height * 0.018,
            ),
            Gap(Get.height * 0.05),
            Center(
              child: PinCodeTextField(
                pinBoxRadius: 8,
                maxLength: 6,
                autofocus: false,
                controller: authController.otpPin,
                pinBoxOuterPadding: const EdgeInsets.symmetric(horizontal: 4),
                highlight: true,
                highlightAnimation: true,
                highlightColor: AppColor().lightBlack,
                defaultBorderColor: AppColor().primaryColor,
                hasTextBorderColor: AppColor().primaryColor,
                highlightPinBoxColor: AppColor().lightBlack,
                hasError: hasError,
                onTextChanged: (text) {
                  setState(() {
                    number = text;
                    hasError = false;
                  });
                },
                onDone: (text) {
                  number = text;

                  if (kDebugMode) {
                    print("DONE $number");
                  }
                },
                pinBoxWidth: Get.width / 6 - Get.height * 0.02,
                pinBoxHeight: Get.height * 0.07,
                hasUnderline: false,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                pinTextStyle: const TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'GilroyMedium',
                  fontWeight: FontWeight.w700,
                ),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration:
                    const Duration(milliseconds: 300),
                highlightAnimationBeginColor: Colors.black,
                highlightAnimationEndColor: Colors.white12,
                keyboardType: TextInputType.none,
              ),
            ),
            Gap(Get.height * 0.05),
            Countdown(
                seconds: 60,
                onFinished: () {
                  debugPrint('Timer is done!');
                  setState(() {
                    resend = false;
                  });
                },
                build: (context, time) {
                  return Center(
                    child: CustomText(
                      title: '00:${time.toString().replaceAll('.0', '')}',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyBlack',
                      size: Get.height * 0.03,
                    ),
                  );
                }),
            Gap(Get.height * 0.02),
            Center(
              child: Text.rich(TextSpan(
                text: "Didn`t receive code?",
                style: TextStyle(
                  color: AppColor().primaryWhite.withOpacity(0.8),
                  fontFamily: 'GilroyMedium',
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
                          if (resend == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomText(
                                  title:
                                      'Password reset link sent successfully',
                                  size: Get.height * 0.02,
                                  color: AppColor().primaryWhite,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                            _controller.restart();
                            setState(() {
                              resend = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomText(
                                  title: 'Please wait...',
                                  size: Get.height * 0.02,
                                  color: AppColor().primaryWhite,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          }
                        }),
                ],
              )),
            ),
            Gap(Get.height * 0.06),
            SizedBox(
              height: Get.height * 0.35,
              child: NumPad(
                highlightColor: AppColor().primaryWhite,
                runSpace: Get.height * 0.03,
                onType: (value) {
                  setState(() {
                    if (number.length < 6) {
                      number += value;
                      authController.otpPin.text += value;
                    } else if (number.length == 6) {
                      Get.offAll(() => const Dashboard());
                    }
                  });
                },
                rightWidget: IconButton(
                  icon: Icon(
                    Icons.backspace,
                    color: AppColor().primaryWhite,
                  ),
                  onPressed: () {
                    if (number.isNotEmpty) {
                      setState(() {
                        authController.otpPin.text =
                            number.substring(0, number.length - 1);
                      });
                    }
                  },
                ),
                leftWidget: IconButton(
                  icon: Icon(
                    Icons.done,
                    color: AppColor().primaryColor,
                    size: 30,
                  ),
                  onPressed: () {
                    if (authController.otpPin.text.length == 6) {
                      Get.offAll(() => const Dashboard());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: CustomText(
                            title: 'Incomplete pin!',
                            size: Get.height * 0.02,
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
