import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with SingleTickerProviderStateMixin {
  final PageController _pageViewController = PageController();
  final authController = Get.put(AuthRepository());
  int _currentPage = 0;
  bool _isHiddenPassword = true;
  bool _isLoading = false;

  void _togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  Future handleButton() async {
    setState(() {
      _isLoading = true;
    });
    if (_currentPage == 0) {
      if (authController.resetPasswordEmailController.text != "") {
        var success = await authController.requestPasswordOtp();
        if (success) {
          _pageViewController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear);
        }
      } else {}
    } else if (_currentPage == 1) {
      if (authController.resetPasswordOtpController.text != "") {
        var success = await authController.verifyPasswordOtp();
        if (success) {
          _pageViewController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear);
        }
      } else {}
    } else {
      var success = await authController.resetPassword();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void clear() {
    authController.resetPasswordIdController.clear();
    authController.resetPasswordEmailController.clear();
    authController.resetPasswordConfirmController.clear();
    authController.resetPasswordOtpController.clear();
    authController.resetPasswordController.clear();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: GoBackButton(onPressed: () => Get.back()),
      ),
      body: Column(
        children: [
          Expanded(
              child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageViewController,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            children: [
              Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Forgot Password",
                      color: AppColor().primaryWhite,
                      fontFamily: "InterBold",
                      size: 28,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title:
                          "Please enter your email address to get verification OTP to reset your password",
                      color: AppColor().lightItemsColor,
                      size: 16,
                      fontFamily: "Inter",
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: "Email",
                      color: AppColor().primaryWhite,
                      size: 14,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      textEditingController:
                          authController.resetPasswordEmailController,
                      hint: "Enter your email",
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Enter 6-Digit Code",
                      color: AppColor().primaryWhite,
                      fontFamily: "InterBold",
                      size: 28,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: "Please enter the 6-digit OTP sent to your email",
                      color: AppColor().lightItemsColor,
                      size: 16,
                      fontFamily: "Inter",
                    ),
                    Gap(Get.height * 0.02),
                    Pinput(
                      length: 6,
                      keyboardType: TextInputType.number,
                      controller: authController.resetPasswordOtpController,
                      defaultPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontFamily: "InterSemiBold",
                            color: AppColor().primaryWhite),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColor().primaryColor),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Reset Password",
                      color: AppColor().primaryWhite,
                      fontFamily: "InterBold",
                      size: 28,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title:
                          "Set a new password for your account so you can login and access all the features",
                      color: AppColor().lightItemsColor,
                      size: 16,
                      fontFamily: "Inter",
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: "New Password",
                      color: AppColor().primaryWhite,
                      size: 14,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                        obscure: _isHiddenPassword,
                        textEditingController:
                            authController.resetPasswordController,
                        hint: "Enter your new password",
                        suffixIcon: GestureDetector(
                          onTap: _togglePasswordView,
                          child: Icon(
                              _isHiddenPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColor().lightItemsColor),
                        )),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: "Confirm New Password",
                      color: AppColor().primaryWhite,
                      size: 14,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                        obscure: _isHiddenPassword,
                        textEditingController:
                            authController.resetPasswordConfirmController,
                        hint: "Confirm your new password",
                        suffixIcon: GestureDetector(
                          onTap: _togglePasswordView,
                          child: Icon(
                              _isHiddenPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColor().lightItemsColor),
                        )),
                  ],
                ),
              ),
            ],
          )),
          Padding(
              padding: EdgeInsets.all(Get.height * 0.02),
              child: CustomFillButton(
                buttonText: _currentPage == 0
                    ? "Send OTP"
                    : _currentPage == 1
                        ? "Verify OTP"
                        : "Reset Password",
                onTap: handleButton,
                isLoading: _isLoading,
              ))
        ],
      ),
    );
  }
}
