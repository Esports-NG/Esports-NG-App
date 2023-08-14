import 'package:country_state_picker/country_state_picker.dart';
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
import 'package:intl/intl.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';

import 'choose_alias.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? current;
  List<UserPreference> selectedCategories = [];
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
  String state = '';
  String country = '';

  void displayMsg(msg) {
    print(msg);
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: authController.date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      authController.dobController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      authController.date = newDate;
      if (kDebugMode) {
        print(authController.dobController.text);
      }
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
                fontSize: Get.height * 0.015,
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
                      ? Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/images/png/photo.png',
                                    height: Get.height * 0.15,
                                  ),
                                ),
                                Positioned(
                                    right: Get.width * 0.3,
                                    bottom: 0,
                                    child: SvgPicture.asset(
                                      'assets/images/svg/camera.svg',
                                      height: Get.height * 0.05,
                                    )),
                              ],
                            ),
                            Gap(Get.height * 0.02),
                            Center(
                              child: CustomText(
                                title: 'Max file size 1MB *',
                                color: AppColor().primaryWhite,
                                textAlign: TextAlign.center,
                                fontFamily: 'GilroyRegular',
                                size: Get.height * 0.015,
                              ),
                            ),
                            Gap(Get.height * 0.01),
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
                            title: 'Full name',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.015,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "eg john doe",
                            textEditingController:
                                authController.fNameController,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Full Name must not be empty';
                              } else if (!RegExp(r'[A-Za-z]+$')
                                  .hasMatch(value)) {
                                return "Please enter only letters";
                              }
                              return null;
                            },
                          ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'Email Address',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.015,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "johndoe@mail.com",
                            textEditingController:
                                authController.emailController,
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
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'Username',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.015,
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
                            title: 'Password',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.015,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "Password",
                            textEditingController:
                                authController.passwordController,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'password must not be empty';
                              } else if (value.length < 8) {
                                return 'password must not be less than 8 character';
                              }
                              return null;
                            },
                            suffixIcon: InkWell(
                              onTap: _togglePasswordView,
                              child: Icon(
                                isHiddenPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: isHiddenPassword
                                    ? Colors.grey.withOpacity(0.5)
                                    : AppColor().primaryColor,
                              ),
                            ),
                          ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'Phone number',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.015,
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
                          // CustomText(
                          //   title: 'Country',
                          //   color: AppColor().primaryWhite,
                          //   textAlign: TextAlign.center,
                          //   fontFamily: 'GilroyRegular',
                          //   size: Get.height * 0.015,
                          // ),
                          // Gap(Get.height * 0.01),
                          CountryStatePicker(
                            dropdownColor: Colors.black,
                            countryLabel: Padding(
                              padding:
                                  EdgeInsets.only(bottom: Get.height * 0.01),
                              child: CustomText(
                                title: 'Country',
                                color: AppColor().primaryWhite,
                                textAlign: TextAlign.left,
                                fontFamily: 'GilroyRegular',
                                size: Get.height * 0.015,
                              ),
                            ),
                            stateLabel: Padding(
                              padding:
                                  EdgeInsets.only(bottom: Get.height * 0.01),
                              child: CustomText(
                                title: 'State',
                                color: AppColor().primaryWhite,
                                textAlign: TextAlign.left,
                                fontFamily: 'GilroyRegular',
                                size: Get.height * 0.015,
                              ),
                            ),
                            hintTextStyle: TextStyle(
                              color: AppColor().lightItemsColor,
                              fontSize: 13,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'GilroyBold',
                              fontWeight: FontWeight.w400,
                              height: 1.7,
                            ),
                            itemTextStyle: TextStyle(
                              color: AppColor().lightItemsColor,
                              fontSize: 13,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'GilroyBold',
                              fontWeight: FontWeight.w400,
                              height: 1.7,
                            ),
                            inputDecoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              fillColor: AppColor().bgDark,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColor().lightItemsColor,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onCountryChanged: (ct) => setState(() {
                              country = ct;
                              state = '';

                              // List<String> statesForCountry =
                              //     countryToStates[country];
                              // if (statesForCountry != null &&
                              //     statesForCountry.isNotEmpty) {
                              //   state = statesForCountry[0];
                              //   // Set the first state as default
                              // }
                              if (kDebugMode) {
                                print(country);
                                print(state);
                              }
                            }),
                            onStateChanged: (st) => setState(() {
                              state = st;
                              if (kDebugMode) {
                                print(country);
                                print(state);
                              }
                            }),
                            countryHintText: "Country",
                            stateHintText: "State",
                            noStateFoundText: "No State Found",
                          ),
                          // Gap(Get.height * 0.02),
                          // CustomTextField(
                          //   hint: "Country",
                          //   // textEditingController: authController.fNameController,
                          //   validate: (value) {
                          //     if (value!.isEmpty) {
                          //       return 'country must not be empty';
                          //     } else if (!RegExp(r'[A-Za-z]+$')
                          //         .hasMatch(value)) {
                          //       return "Please enter only letters";
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // Gap(Get.height * 0.02),
                          // CustomText(
                          //   title: 'State',
                          //   color: AppColor().primaryWhite,
                          //   textAlign: TextAlign.center,
                          //   fontFamily: 'GilroyRegular',
                          //   size: Get.height * 0.015,
                          // ),
                          // Gap(Get.height * 0.01),
                          // CustomTextField(
                          //   hint: "State",
                          //   // textEditingController: authController.fNameController,
                          //   validate: (value) {
                          //     if (value!.isEmpty) {
                          //       return 'state must not be empty';
                          //     } else if (!RegExp(r'[A-Za-z]+$')
                          //         .hasMatch(value)) {
                          //       return "Please enter only letters";
                          //     }
                          //     return null;
                          //   },
                          // ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'Gender',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.015,
                          ),
                          Gap(Get.height * 0.01),
                          InputDecorator(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor().bgDark,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColor().lightItemsColor,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
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
                            size: Get.height * 0.015,
                          ),
                          Gap(Get.height * 0.01),
                          InkWell(
                            onTap: () {
                              pickDate(context);
                            },
                            child: CustomTextField(
                              hint: "DD/MM/YY",
                              enabled: false,
                              textEditingController:
                                  authController.dobController,
                              suffixIcon: Icon(
                                CupertinoIcons.calendar,
                                color: AppColor().lightItemsColor,
                              ),
                            ),
                          ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'Referral code (Optional)',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.015,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "DJKNDFD7786S",
                            textEditingController:
                                authController.referralController,
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
                          return CustomFillButtonOption(
                            onTap: () {
                              setState(() {
                                primaryUseCount = index;
                              });
                            },
                            height: Get.height * 0.06,
                            buttonText: item.title,
                            textColor: AppColor().primaryWhite,
                            buttonColor: primaryUseCount == index
                                ? AppColor().primaryGreen
                                : AppColor().pureBlackColor,
                            boarderColor: primaryUseCount == index
                                ? AppColor().primaryGreen
                                : AppColor().primaryWhite,
                            borderRadius: BorderRadius.circular(30),
                            fontWeight: FontWeight.w400,
                          );
                        }),
                  ] else ...[
                    Gap(Get.height * 0.02),
                    GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3 / 1,
                        ),
                        itemCount: categoryCard.length,
                        itemBuilder: (context, index) {
                          var item = categoryCard[index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    current = index;
                                    item.isSelected = !item.isSelected!;
                                    if (item.isSelected == true) {
                                      selectedCategories.add(
                                          UserPreference(title: item.title!));
                                    } else if (item.isSelected == false) {
                                      selectedCategories.removeWhere(
                                          (element) =>
                                              element.title == item.title);
                                    }
                                    // userPreferences[index].isSelected = !userPreferences[index].isSelected!
                                  });
                                  if (kDebugMode) {
                                    print('item $current');
                                    print(
                                        'Selected Category: ${selectedCategories.length}');
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: EdgeInsets.all(Get.height * 0.02),
                                  decoration: BoxDecoration(
                                    color: item.isSelected == true
                                        ? AppColor().primaryGreen
                                        : AppColor().pureBlackColor,
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: item.isSelected == true
                                          ? AppColor().primaryGreen
                                          : AppColor().primaryWhite,
                                    ),
                                  ),
                                  child: Center(
                                    child: CustomText(
                                      title: item.title,
                                      size: 12,
                                      color: AppColor().primaryWhite,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                  ],
                  Gap(pageCount == 0
                      ? Get.height * 0.05
                      : pageCount == 1
                          ? Get.height * 0.35
                          : Get.height * 0.1),
                  CustomFillButton(
                    onTap: () {
                      if (pageCount < 2
                          //  && _formKey.currentState!.validate()
                          ) {
                        setState(() {
                          pageCount++;
                          if (kDebugMode) {
                            print('PageCount: $pageCount');
                          }
                        });
                        // if(pageCount)
                      } else {
                        if (primaryUseCount == null) {
                          Get.snackbar('Alert',
                              'Agree to the terms and condition to continue!');
                        } else {
                          // if (authController.signUpStatus !=
                          //         SignUpStatus.loading &&
                          //     _businessFormKey.currentState!.validate()) {
                          //   authController.signUp(user);
                          // }
                          Get.to(() => const ChooseAlias());
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

class UserPreference {
  String? title;
  bool? isSelected;
  UserPreference({this.title, this.isSelected});
}

var primaryUseCard = [
  PrimaryUse(title: 'Competitions'),
  PrimaryUse(title: 'Gaming news'),
  PrimaryUse(title: 'Communities'),
];

var categoryCard = [
  UserPreference(title: 'Puzzle', isSelected: false),
  UserPreference(title: 'Warfare', isSelected: false),
  UserPreference(title: 'RPG', isSelected: false),
  UserPreference(title: 'Sports', isSelected: false),
  UserPreference(title: 'Apocalypse', isSelected: false),
  UserPreference(title: 'Board', isSelected: false),
  UserPreference(title: 'Puzzle', isSelected: false),
  UserPreference(title: 'Warfare', isSelected: false),
  UserPreference(title: 'RPG', isSelected: false),
  UserPreference(title: 'Sports', isSelected: false),
  UserPreference(title: 'Apocalypse', isSelected: false),
  UserPreference(title: 'Board', isSelected: false),
];
