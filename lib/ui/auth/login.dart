import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'otp_screen.dart';
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
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: AppColor().primaryBgColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                      size: Get.height * 0.035,
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
                  size: Get.height * 0.016,
                ),
                Gap(Get.height * 0.05),
                CustomText(
                  title: 'Email address',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.016,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "johndoe@gmail.com",
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
                Gap(Get.height * 0.03),
                CustomText(
                  title: 'Password',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.016,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "eg 12345678",
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
                      isHiddenPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: isHiddenPassword
                          ? Colors.grey.withOpacity(0.5)
                          : AppColor().pureBlackColor,
                    ),
                  ),
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Forgot password?',
                  color: AppColor().primaryColor,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  weight: FontWeight.w600,
                  size: Get.height * 0.018,
                  underline: TextDecoration.underline,
                ),
                Gap(Get.height * 0.12),
                CustomFillButton(
                  buttonText: 'Log in',
                  fontWeight: FontWeight.w600,
                  textSize: Get.height * 0.018,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Get.to(() => const OTPScreen());
                    }
                  },
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
                      fontSize: Get.height * 0.018,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: " Sign Up",
                          style: TextStyle(
                              color: AppColor().primaryColor,
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
      ),
    );
  }
}
