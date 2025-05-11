import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/screens/auth/activate_account.dart';
import 'package:e_sport/ui/screens/auth/forgot_password.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
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
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool isHiddenPassword = true;
  bool isEmail = false, isPassword = false;

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void handleTap(String? title) {
    if (title == 'email') {
      setState(() {
        isEmail = true;
      });
    } else {
      setState(() {
        isPassword = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.height * 0.02, vertical: Get.height * 0.03),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    title: 'Hello again',
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.center,
                    size: 32,
                    fontFamily: "InterSemiBold",
                  ),
                  Gap(Get.height * 0.01),
                  Image.asset(
                    'assets/images/png/hello.png',
                  ),
                ],
              ),
              const Gap(5),
              CustomText(
                title: "Welcome back, you've been missed",
                color: AppColor().primaryWhite.withOpacity(0.8),
                textAlign: TextAlign.center,
                fontFamily: "Inter",
                size: 14,
              ),
              Gap(Get.height * 0.05),
              CustomText(
                title: 'Email address',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                size: Get.height * 0.016,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "johndoe@mail.com",
                textEditingController: authController.emailController,
                hasText: isEmail,
                focusNode: _emailFocusNode,
                onTap: () {
                  handleTap('email');
                },
                onSubmited: (_) {
                  _emailFocusNode.unfocus();
                },
                onChanged: (value) {
                  setState(() {
                    isEmail = value.isNotEmpty;
                  });
                },
                validate: Validator.isEmail,
              ),
              Gap(Get.height * 0.03),
              CustomText(
                title: 'Password',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                size: Get.height * 0.016,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "eg 12345678",
                textEditingController: authController.passwordController,
                obscure: isHiddenPassword,
                hasText: isPassword,
                focusNode: _passwordFocusNode,
                onTap: () {
                  handleTap('password');
                },
                onSubmited: (_) {
                  _passwordFocusNode.unfocus();
                },
                onChanged: (value) {
                  setState(() {
                    isPassword = value.isNotEmpty;
                  });
                },
                validate: Validator.isName,
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
              Gap(Get.height * 0.03),
              GestureDetector(
                onTap: () => Get.to(() => const ForgotPassword()),
                child: CustomText(
                  title: 'Forgot password?',
                  color: AppColor().primaryColor,
                  textAlign: TextAlign.center,
                  size: 14,
                  underline: TextDecoration.underline,
                ),
              ),
              Gap(Get.height * 0.05),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate() &&
                        authController.signInStatus != SignInStatus.loading) {
                      authController.login(context);
                    }
                  },
                  child: Container(
                    height: Get.height * 0.06,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColor().primaryColor,
                    ),
                    child: (authController.signInStatus == SignInStatus.loading)
                        ? Center(
                            child: ButtonLoader(
                              color: AppColor().primaryWhite,
                            ),
                          )
                        : Center(
                            child: CustomText(
                            title: 'Log in',
                            color: AppColor().primaryWhite,
                            fontFamily: "InterSemiBold",
                            size: 14,
                          )),
                  ),
                );
              }),
              Gap(Get.height * 0.01),
              Center(
                child: Text.rich(TextSpan(
                  text: "Can't login?",
                  style: TextStyle(
                    color: AppColor().primaryWhite,
                    fontFamily: 'Inter',
                    fontSize: Get.height * 0.018,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: " Request Activation Link",
                        style: TextStyle(
                            color: AppColor().primaryColor,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => const ActivateAccount());
                          }),
                  ],
                )),
              ),
              const Spacer(),
              Center(
                child: Text.rich(TextSpan(
                  text: "Don’t have an account?",
                  style: TextStyle(
                    color: AppColor().primaryWhite,
                    fontFamily: 'Inter',
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
    );
  }
}
