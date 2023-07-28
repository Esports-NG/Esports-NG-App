import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/page_indicator.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
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
  int? primaryUseCount;
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
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            if (pageCount > 0) {
              setState(() {
                --pageCount;
                if (kDebugMode) {
                  print('PageCount: $pageCount');
                }
              });
            } else {
              Get.back();
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColor().primaryWhite,
          ),
        ),
        actions: [
          Center(
            child: Text.rich(TextSpan(
              text: '${pageCount + 1}',
              style: TextStyle(
                color: AppColor().primaryWhite,
                fontWeight: FontWeight.w600,
                fontFamily: 'GilroyBold',
                fontSize: Get.height * 0.014,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: "/3",
                    style: TextStyle(
                      color: AppColor().primaryWhite.withOpacity(0.5),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(() => const RegisterScreen());
                      }),
              ],
            )),
          ),
        ],
      ),
      backgroundColor: AppColor().pureBlackColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PageIndicator(pageCount, 0, 1, Get.width / 3),
                PageIndicator(pageCount, 1, 1, Get.width / 3),
                PageIndicator(pageCount, 2, 1, Get.width / 3),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(Get.height * 0.02),
                  Row(
                    children: [
                      CustomText(
                        title: pageCount == 0
                            ? 'Hey there'
                            : pageCount == 1
                                ? 'Almost there'
                                : 'All done',
                        color: AppColor().primaryWhite,
                        textAlign: TextAlign.center,
                        fontFamily: 'GilroyBold',
                        size: Get.height * 0.032,
                      ),
                      Gap(Get.height * 0.01),
                      Image.asset(
                        pageCount == 0
                            ? 'assets/images/png/hello.png'
                            : pageCount == 1
                                ? 'assets/images/png/smile.png'
                                : 'assets/images/png/done.png',
                      ),
                    ],
                  ),
                  CustomText(
                    title: pageCount == 0
                        ? 'Welcome to Esport NG, please sign up to get\nexclusive access our services.'
                        : pageCount == 1
                            ? 'Let’s know about you, to improve your experience,\nwhat would you be primarily using the Esport NG for?'
                            : 'Please select as many categories as you like, to\nimprove your feed experience',
                    color: AppColor().primaryWhite.withOpacity(0.8),
                    textAlign: TextAlign.start,
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.016,
                  ),
                  Gap(Get.height * 0.02),
                  pageCount == 0
                      ? Stack(
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
                                child: SvgPicture.asset(
                                    'assets/images/svg/camera.svg')),
                          ],
                        )
                      : Container(),
                  if (pageCount == 0) ...[
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'Username',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.014,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "@johndoe",
                            textEditingController:
                                authController.uNameController,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Username must not be empty';
                              } else if (!RegExp(r'[A-Za-z]+$')
                                  .hasMatch(value)) {
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
                            size: Get.height * 0.014,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "+234",
                            textEditingController:
                                authController.phoneNoController,
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
                            size: Get.height * 0.014,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "Country",
                            // textEditingController: authController.fNameController,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Fullname must not be empty';
                              } else if (!RegExp(r'[A-Za-z]+$')
                                  .hasMatch(value)) {
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
                            size: Get.height * 0.014,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "State",
                            // textEditingController: authController.fNameController,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Fullname must not be empty';
                              } else if (!RegExp(r'[A-Za-z]+$')
                                  .hasMatch(value)) {
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
                            size: Get.height * 0.014,
                          ),
                          Gap(Get.height * 0.01),
                          InputDecorator(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor().pureBlackColor,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColor().lightItemsColor,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColor().lightItemsColor,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColor().lightItemsColor,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
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
                                      color: AppColor().lightItemsColor,
                                      fontFamily: 'GilroyBold',
                                      weight: FontWeight.w400,
                                      size: 13,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    genderValue = value;
                                    authController.genderController.text =
                                        value!;
                                    if (kDebugMode) {
                                      print(value);
                                    }
                                  });
                                },
                                hint: CustomText(
                                  title: "Gender",
                                  color: AppColor().lightItemsColor,
                                  fontFamily: 'GilroyBold',
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
                            size: Get.height * 0.014,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "DD/MM/YY",
                            textEditingController: authController.dobController,
                            suffixIcon: IconButton(
                              icon: Icon(
                                CupertinoIcons.calendar,
                                color: AppColor().lightItemsColor,
                              ),
                              onPressed: () {},
                            ),
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Fullname must not be empty';
                              } else if (!RegExp(r'[A-Za-z]+$')
                                  .hasMatch(value)) {
                                return "Please enter only letters";
                              }
                              return null;
                            },
                          ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'Referral code (Optional)',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.014,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "DJKNDFD7786S",
                            textEditingController: authController.dobController,
                          ),
                        ],
                      ),
                    ),
                  ] else if (pageCount == 1) ...[
                    Gap(Get.height * 0.02),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        separatorBuilder: (context, index) => const Gap(20),
                        itemCount: primaryUseCard.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = primaryUseCard[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: CustomFillButtonOption(
                              onTap: () {
                                setState(() {
                                  primaryUseCount = index;
                                });
                              },
                              height: 50,
                              buttonText: item.title,
                              textColor: AppColor().primaryDark,
                              buttonColor: primaryUseCount == index
                                  ? AppColor().primaryGreen
                                  : AppColor().primaryWhite,
                              boarderColor: primaryUseCount == index
                                  ? AppColor().primaryGreen
                                  : AppColor().primaryColor,
                              borderRadius: BorderRadius.circular(30),
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }),
                  ],
                  Gap(Get.height * 0.05),
                  CustomFillButton(
                    onTap: () {
                      if (pageCount < 2
                          // && _formKey.currentState!.validate()
                          ) {
                        setState(() {
                          pageCount++;
                          if (kDebugMode) {
                            print('PageCount: $pageCount');
                          }
                        });
                      } else {
                        if (pageCount < 2) {
                          if (kDebugMode) {
                            print('PageCount: $pageCount');
                          }
                        }
                        // else if (isChecked != true) {
                        //   Get.snackbar('Alert',
                        //       'Agree to the terms and condition to continue!');
                        // }
                        else {
                          // if (authController.signUpStatus !=
                          //         SignUpStatus.loading &&
                          //     _businessFormKey.currentState!.validate()) {
                          //   authController.signUp(user);
                          // }
                        }
                      }
                    },
                    buttonText: 'Next',
                    fontWeight: FontWeight.w600,
                    textSize: Get.height * 0.016,
                    isLoading: false,
                  ),
                  Gap(Get.height * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryUse {
  final String? title;

  PrimaryUse({this.title});
}

var primaryUseCard = [
  PrimaryUse(title: 'Competitions'),
  PrimaryUse(title: 'Gaming news'),
  PrimaryUse(title: 'Communities'),
];
