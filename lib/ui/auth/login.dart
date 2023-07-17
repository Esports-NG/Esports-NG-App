import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthRepository());
  bool isHiddenPassword = true;
  bool? isChecked = false;

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
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
              Row(
                children: [
                  CustomText(
                    title: 'Hello again',
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.center,
                    fontFamily: 'GilroyBold',
                    size: Get.height * 0.04,
                  ),
                  Gap(Get.height * 0.01),
                  Image.asset(
                    'assets/images/png/hello.png',
                  ),
                ],
              ),
              CustomText(
                title: 'Welcome back, you’ve been missed',
                color: AppColor().primaryWhite.withOpacity(0.8),
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.08),
              CustomText(
                title: 'Email address',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "Email address",
                textEditingController: authController.emailController,
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Email address must not be empty';
                  } else if (!RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                      .hasMatch(value)) {
                    return "enter a valid email address";
                  }
                  return null;
                },
              ),
              Gap(Get.height * 0.05),
              CustomText(
                title: 'Password',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "Password",
                textEditingController: authController.passwordController,
                obscure: isHiddenPassword,
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'password must not be empty';
                  } else if (value.length < 4) {
                    return 'password must not be less than 8 character';
                  }
                  return null;
                },
                suffixIcon: InkWell(
                  onTap: _togglePasswordView,
                  child: Icon(
                    isHiddenPassword ? Icons.visibility : Icons.visibility_off,
                    color: isHiddenPassword
                        ? Colors.grey.withOpacity(0.5)
                        : AppColor().pureBlackColor,
                  ),
                ),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Forgot password?',
                color: AppColor().primaryGreen,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                weight: FontWeight.w600,
                size: Get.height * 0.02,
                underline: TextDecoration.underline,
              ),
              Gap(Get.height * 0.15),
              CustomFillButton(
                buttonText: 'Log in',
                fontWeight: FontWeight.w600,
                textSize: 16,
                onTap: () {},
                isLoading: false,
              ),
              Gap(Get.height * 0.05),
              Center(
                child: Text.rich(TextSpan(
                  text: "Don’t have an account?",
                  style: TextStyle(
                    color: AppColor().primaryWhite,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'GilroyRegular',
                    fontSize: Get.height * 0.019,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: " Sign Up",
                        style: TextStyle(
                            color: AppColor().primaryGreen,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => const RegisterScreen());
                          }),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
