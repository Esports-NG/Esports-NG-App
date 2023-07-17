import 'dart:io';

import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthRepository());
  String stateValue = NigerianStatesAndLGA.allStates[0];
  String lgaValue = 'Select a Local Government Area';
  String selectedLGAFromAllLGAs = NigerianStatesAndLGA.getAllNigerianLGAs()[0];
  List<String> statesLga = [];

  bool isHiddenPassword = true;
  bool? isChecked = false;
  bool boolPass = false;
  int pageCount = 0;
  var number = "";
  var bizNo = "";

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
              Container(
                color: AppColor().primaryWhite,
                height: 1,
                width: Get.width,
              ),
              Gap(Get.height * 0.04),
              Row(
                children: [
                  CustomText(
                    title: 'Hey there',
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
                title:
                    'Welcome to Esport NG, please sign up to get\nexclusive access our services.',
                color: AppColor().primaryWhite.withOpacity(0.8),
                textAlign: TextAlign.start,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.02),
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/png/photo.png',
                    ),
                  ),
                  Positioned(
                      right: Get.width * 0.3,
                      bottom: 0,
                      child: SvgPicture.asset('assets/images/svg/camera.svg')),
                ],
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Fullname',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "Johnny Doe",
                textEditingController: authController.fNameController,
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Fullname must not be empty';
                  } else if (!RegExp(r'[A-Za-z]+$').hasMatch(value)) {
                    return "Please enter only letters";
                  }
                  return null;
                },
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Password',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.01),
              IntlPhoneField(
                  disableLengthCheck: true,
                  keyboardType: Platform.isIOS
                      ? const TextInputType.numberWithOptions(
                          signed: true, decimal: false)
                      : TextInputType.phone,
                  flagsButtonMargin: const EdgeInsets.only(left: 8),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'GilroyMedium',
                      fontWeight: FontWeight.w600,
                      height: 1.7),
                  decoration: InputDecoration(
                    fillColor: AppColor().lightBlack,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor().textFieldColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().textFieldColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().textFieldColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Phone Number',
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'GilroyMedium',
                        fontWeight: FontWeight.w600,
                        height: 1.7),
                  ),
                  controller: authController.phoneNoController,
                  initialCountryCode: "NG",
                  validator: (data) {
                    number = data!.number;
                    if (number.length < 10 || number.length > 10) {
                      return "Invalid phone number";
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(number)) {
                      return "Please enter only digits";
                    }
                    return null;
                  },
                  onChanged: (data) {
                    number = data.countryCode;
                    if (kDebugMode) {
                      print("number is ${data.countryCode}");
                    }
                  }),
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
                            // Get.to(() => const AccountOption());
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
