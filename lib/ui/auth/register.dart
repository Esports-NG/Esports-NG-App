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
  String? genderValue;

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
                title: 'Phone number',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "+234",
                textEditingController: authController.phoneNoController,
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'phone no must not be empty';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "Please enter only digits";
                  }
                  return null;
                },
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Country',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "Country",
                // textEditingController: authController.fNameController,
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
                title: 'State',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "State",
                // textEditingController: authController.fNameController,
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
                title: 'Gender',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.01),
              InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor().lightBlack,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: genderValue,
                    items: <String>[
                      'Male',
                      'Female',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: CustomText(
                          title: value,
                          color: AppColor().pureBlackColor,
                          fontFamily: 'GilroyMedium',
                          weight: FontWeight.w600,
                          size: 13,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        genderValue = value;
                        authController.genderController.text = value!;
                        if (kDebugMode) {
                          print(value);
                        }
                      });
                    },
                    hint: CustomText(
                      title: "Gender",
                      color: AppColor().hintTextColor,
                      weight: FontWeight.w400,
                      size: 13,
                    ),
                  ),
                ),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Date of birth',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.018,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "Date of birth",
                // textEditingController: authController.fNameController,
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Fullname must not be empty';
                  } else if (!RegExp(r'[A-Za-z]+$').hasMatch(value)) {
                    return "Please enter only letters";
                  }
                  return null;
                },
              ),
              Gap(Get.height * 0.05),
              CustomFillButton(
                buttonText: 'Sign up',
                fontWeight: FontWeight.w600,
                textSize: 16,
                onTap: () {},
                isLoading: false,
              ),
              Gap(Get.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
