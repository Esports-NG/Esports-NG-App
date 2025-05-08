import 'dart:io';

import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/screens/account/privacy_policy.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/ui/widgets/utils/page_indicator.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/csc_picker.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'choose_alias.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int? current;
  List<UserPreference> selectedCategories = [];
  List<PrimaryUse> selectedUse = [];
  final authController = Get.put(AuthRepository());
  String? genderValue;

  bool? isEmail = false,
      isPassword = false,
      isFullname = false,
      isCountry = false,
      isState = false,
      isPhone = false,
      isGender = false,
      isDob = false,
      isReferral = false;
  bool isHiddenPassword = true, boolPass = false;

  int pageCount = 0;
  int? primaryUseCount;
  String state = '';
  String country = '';

  String countryValue = "";
  String statesValue = "";
  String cityValue = "";
  String address = "";

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _fullnameFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _referralFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _fullnameFocusNode.dispose();
    _countryFocusNode.dispose();
    _stateFocusNode.dispose();
    _phoneFocusNode.dispose();
    _genderFocusNode.dispose();
    _dobFocusNode.dispose();
    _referralFocusNode.dispose();
    authController.clear();
    super.dispose();
  }

  void handleTap(String? title) {
    if (title == 'email') {
      setState(() {
        isEmail = true;
      });
    } else if (title == 'password') {
      setState(() {
        isPassword = true;
      });
    } else if (title == 'fullname') {
      setState(() {
        isFullname = true;
      });
    } else if (title == 'country') {
      setState(() {
        isCountry = true;
      });
    } else if (title == 'state') {
      setState(() {
        isState = true;
      });
    } else if (title == 'phone') {
      setState(() {
        isPhone = true;
      });
    } else if (title == 'gender') {
      setState(() {
        isGender = true;
      });
    } else if (title == 'dob') {
      setState(() {
        isDob = true;
      });
    } else {
      setState(() {
        isReferral = true;
      });
    }
  }

  void displayMsg(msg) {
    debugPrint(msg);
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
      firstDate: DateTime(DateTime.now().year - 40),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      authController.dobController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      authController.date = newDate;

      debugPrint(authController.dobController.text);
    });
  }

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        authController.mUserImage(imageTemporary);
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        authController.mUserImage(imageTemporary);
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        // if (!didPop) return;
        if (pageCount > 0) {
          setState(() {
            pageCount = pageCount - 1;
          });
        } else {
          await Future.delayed(Durations.short4, () {
            Get.back();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              if (pageCount > 0) {
                setState(() {
                  --pageCount;
                  if (kDebugMode) {
                    debugPrint('PageCount: $pageCount');
                  }
                });
              } else {
                setState(() {});
                Get.back();
                authController.clear();
                selectedUse.clear();
                selectedCategories.clear();
                authController.mGetCountryCode.value = false;
                // primaryUseCount = null;
                // current = null;
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
                  fontFamily: "InterSemiBold",
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "/3",
                    style: TextStyle(
                      color: AppColor().primaryWhite.withOpacity(0.5),
                    ),
                  ),
                ],
              )),
            ),
            Gap(Get.height * 0.02),
          ],
        ),
        backgroundColor: AppColor().primaryBackGroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PageIndicator(
                    pageCount,
                    0,
                    1,
                    Get.width / 3,
                    AppColor().primaryWhite,
                  ),
                  PageIndicator(
                    pageCount,
                    1,
                    1,
                    Get.width / 3,
                    AppColor().primaryWhite,
                  ),
                  PageIndicator(
                    pageCount,
                    2,
                    1,
                    Get.width / 3,
                    AppColor().primaryWhite,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
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
                          fontFamily: 'InterBold',
                          size: Get.height * 0.035,
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
                      fontFamily: 'Inter',
                      size: 14,
                    ),
                    Gap(Get.height * 0.02),
                    pageCount == 0
                        ? Column(
                            children: [
                              Obx(() {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: Get.height * 0.15,
                                        width: Get.height * 0.15,
                                        decoration: BoxDecoration(
                                          color: AppColor().primaryWhite,
                                          shape: BoxShape.circle,
                                          image: authController.userImage ==
                                                  null
                                              ? const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/png/placeholder.png'),
                                                  fit: BoxFit.cover)
                                              : DecorationImage(
                                                  image: FileImage(
                                                      authController
                                                          .userImage!),
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: Get.width * 0.3,
                                      bottom: 0,
                                      child: InkWell(
                                        onTap: () {
                                          debugPrint('pick image');
                                          Get.defaultDialog(
                                            title: "Select your image",
                                            backgroundColor:
                                                AppColor().primaryLightColor,
                                            titlePadding:
                                                const EdgeInsets.only(top: 30),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    top: 5,
                                                    bottom: 30,
                                                    left: 25,
                                                    right: 25),
                                            middleText:
                                                "Upload your profile picture",
                                            titleStyle: TextStyle(
                                              color: AppColor().primaryWhite,
                                              fontSize: 15,
                                              fontFamily: "InterSemiBold",
                                            ),
                                            radius: 10,
                                            confirm: Column(
                                              children: [
                                                CustomFillButton(
                                                  onTap: () {
                                                    pickImageFromGallery();
                                                    Get.back();
                                                  },
                                                  height: 45,
                                                  width: Get.width * 0.5,
                                                  buttonText:
                                                      'Upload from gallery',
                                                  textColor:
                                                      AppColor().primaryWhite,
                                                  buttonColor:
                                                      AppColor().primaryColor,
                                                  boarderColor:
                                                      AppColor().primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                const Gap(10),
                                                CustomFillButton(
                                                  onTap: () {
                                                    pickImageFromCamera();
                                                    Get.back();
                                                  },
                                                  height: 45,
                                                  width: Get.width * 0.5,
                                                  buttonText:
                                                      'Upload from camera',
                                                  textColor:
                                                      AppColor().primaryWhite,
                                                  buttonColor:
                                                      AppColor().primaryColor,
                                                  boarderColor:
                                                      AppColor().primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                              ],
                                            ),
                                            middleTextStyle: TextStyle(
                                              color: AppColor().primaryWhite,
                                              fontFamily: 'Inter',
                                              fontSize: 14,
                                            ),
                                          );
                                        },
                                        child: authController.userImage == null
                                            ? SvgPicture.asset(
                                                'assets/images/svg/camera.svg',
                                                height: Get.height * 0.05,
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  authController.clearPhoto();
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                      color: AppColor()
                                                          .primaryColor,
                                                      border: Border.all(
                                                          width: 2,
                                                          color: AppColor()
                                                              .primaryWhite),
                                                      shape: BoxShape.circle),
                                                  child: Icon(Icons.close,
                                                      color: AppColor()
                                                          .primaryWhite),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              Gap(Get.height * 0.02),
                              Center(
                                child: CustomText(
                                  title: 'Max file size 1MB *',
                                  color: AppColor().primaryWhite,
                                  textAlign: TextAlign.center,
                                  fontFamily: 'Inter',
                                  size: 14,
                                ),
                              ),
                              Gap(Get.height * 0.01),
                            ],
                          )
                        : Container(),
                    if (pageCount == 0) ...[
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(Get.height * 0.02),
                            CustomText(
                              title: 'Full name',
                              color: AppColor().primaryWhite,
                              textAlign: TextAlign.center,
                              fontFamily: 'Inter',
                              size: 14,
                            ),
                            Gap(Get.height * 0.01),
                            CustomTextField(
                              hint: "eg john doe",
                              textEditingController:
                                  authController.fullNameController,
                              hasText: isFullname!,
                              focusNode: _fullnameFocusNode,
                              onTap: () {
                                handleTap('fullname');
                              },
                              onSubmited: (_) {
                                _fullnameFocusNode.unfocus();
                              },
                              onChanged: (value) {
                                setState(() {
                                  isFullname = value.isNotEmpty;
                                });
                              },
                              validate: Validator.isName,
                            ),
                            Gap(Get.height * 0.02),
                            CustomText(
                              title: 'Email Address',
                              color: AppColor().primaryWhite,
                              textAlign: TextAlign.center,
                              fontFamily: 'Inter',
                              size: 14,
                            ),
                            Gap(Get.height * 0.01),
                            CustomTextField(
                              hint: "johndoe@mail.com",
                              textEditingController:
                                  authController.emailController,
                              hasText: isEmail!,
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
                            Gap(Get.height * 0.02),
                            CustomText(
                              title: 'Password',
                              color: AppColor().primaryWhite,
                              textAlign: TextAlign.center,
                              fontFamily: 'Inter',
                              size: 14,
                            ),
                            Gap(Get.height * 0.01),
                            CustomTextField(
                              hint: "Password",
                              textEditingController:
                                  authController.passwordController,
                              obscure: isHiddenPassword,
                              hasText: isPassword!,
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
                              validate: Validator.isPassword,
                              suffixIcon: InkWell(
                                onTap: _togglePasswordView,
                                child: Icon(
                                  isHiddenPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: isHiddenPassword
                                      ? Colors.grey.withOpacity(0.5)
                                      : AppColor().primaryColor,
                                ),
                              ),
                            ),
                            Gap(Get.height * 0.02),
                            CustomText(
                              title: 'Country',
                              color: AppColor().primaryWhite,
                              textAlign: TextAlign.center,
                              fontFamily: 'Inter',
                              size: 14,
                            ),
                            Gap(Get.height * 0.01),
                            CSCPicker(
                              layout: Layout.vertical,
                              showStates: true,
                              showCities: false,
                              flagState: CountryFlag.ENABLE,
                              dropdownDecoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: isCountry == true
                                      ? AppColor().primaryWhite
                                      : AppColor().bgDark),
                              disabledDropdownDecoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: AppColor().bgDark),
                              countrySearchPlaceholder: "Select Country",
                              stateSearchPlaceholder: "Select State",
                              citySearchPlaceholder: "City",
                              countryDropdownLabel: "Country",
                              stateDropdownLabel: "State",
                              cityDropdownLabel: "City",
                              selectedItemStyle: TextStyle(
                                  color: isCountry == true
                                      ? AppColor().primaryBackGroundColor
                                      : AppColor().lightItemsColor,
                                  fontSize: 13,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'InterBold',
                                  height: 1.7),
                              dropdownHeadingStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'InterBold',
                              ),
                              dropdownItemStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'InterBold',
                              ),
                              dropdownDialogRadius: 10.0,
                              searchBarRadius: 10.0,
                              onCountryChanged: (value) {
                                setState(() {
                                  debugPrint('country: $value');
                                  countryValue = value.replaceAll(
                                      RegExp(r'[^A-Za-z\-\`\s]'), '');
                                  debugPrint('country: $countryValue');
                                  authController.countryController.text =
                                      countryValue;
                                  authController.getCountryCode();
                                });
                                handleTap('country');
                              },
                              onStateChanged: (value) {
                                setState(() {
                                  statesValue = value ?? '';
                                  authController.stateController.text =
                                      statesValue;
                                });
                              },
                              onCityChanged: (value) {
                                setState(() {
                                  cityValue = value ?? "";
                                });
                              },
                            ),
                            Gap(Get.height * 0.02),
                            CustomText(
                              title: 'Phone number (optional)',
                              color: AppColor().primaryWhite,
                              textAlign: TextAlign.center,
                              fontFamily: 'Inter',
                              size: 14,
                            ),
                            Gap(Get.height * 0.01),
                            InkWell(
                              onTap: authController.mGetCountryCode.isFalse
                                  ? () {
                                      if (authController
                                          .mGetCountryCode.isFalse) {
                                        EasyLoading.showInfo(
                                            'Select your country');
                                      }
                                    }
                                  : null,
                              child: CustomTextField(
                                maxLength: 10,
                                hint: "phone",
                                textEditingController:
                                    authController.phoneNoController,
                                enabled: authController.mGetCountryCode.isFalse
                                    ? false
                                    : true,
                                hasText: isPhone!,
                                focusNode: _phoneFocusNode,
                                onTap: () {
                                  if (authController.mGetCountryCode.isFalse) {
                                    EasyLoading.showInfo('Select your country');
                                  }
                                  handleTap('phone');
                                },
                                onSubmited: (_) {
                                  _phoneFocusNode.unfocus();
                                },
                                onChanged: (value) {
                                  setState(() {
                                    isPhone = value.isNotEmpty;
                                  });
                                },
                                keyType: TextInputType.phone,
                                pretext:
                                    '${authController.countryCodeController.text} ',
                                validate: Validator.isPhone,
                              ),
                            ),
                            Gap(Get.height * 0.02),
                            Row(mainAxisSize: MainAxisSize.max, children: [
                              Checkbox(
                                value: true,
                                onChanged: (value) {},
                                activeColor: AppColor().primaryColor,
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => PrivacyPolicy());
                                  },
                                  child: RichText(
                                      maxLines: 2,
                                      softWrap: true,
                                      // textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text:
                                              "By signing up, you agree with our ",
                                          style: TextStyle(
                                            color: AppColor().primaryWhite,
                                            fontFamily: "InterMedium",
                                          ),
                                          children: [
                                            TextSpan(
                                                text: "Privacy and User Policy",
                                                style: TextStyle(
                                                    color:
                                                        AppColor().primaryColor,
                                                    fontFamily: "InterMedium",
                                                    decoration: TextDecoration
                                                        .underline)),
                                          ])),
                                ),
                              )
                            ])
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
                                  item.isSelected = !item.isSelected!;
                                  if (item.isSelected == true) {
                                    selectedUse
                                        .add(PrimaryUse(title: item.title!));
                                  } else if (item.isSelected == false) {
                                    selectedUse.removeWhere((element) =>
                                        element.title == item.title);
                                  }
                                  if (selectedUse.isNotEmpty) {
                                    authController.purposeController.text =
                                        selectedUse.first.title!;
                                  } else {
                                    authController.purposeController.text = '';
                                  }
                                });
                              },
                              height: Get.height * 0.06,
                              buttonText: item.title,
                              textColor: AppColor().primaryWhite,
                              buttonColor: item.isSelected == true
                                  ? AppColor().primaryGreen
                                  : AppColor().primaryBackGroundColor,
                              boarderColor: item.isSelected == true
                                  ? AppColor().primaryGreen
                                  : AppColor().primaryWhite,
                              borderRadius: BorderRadius.circular(30),
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
                                      if (selectedCategories.isNotEmpty) {
                                        authController.gameTypeController.text =
                                            selectedCategories.first.title!;
                                      } else {
                                        authController.gameTypeController.text =
                                            '';
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: EdgeInsets.all(Get.height * 0.02),
                                    decoration: BoxDecoration(
                                      color: item.isSelected == true
                                          ? AppColor().primaryGreen
                                          : AppColor().primaryBackGroundColor,
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
                        UserModel user = UserModel(
                          fullName:
                              authController.fullNameController.text.trim(),
                          email: authController.emailController.text.trim(),
                          password:
                              authController.passwordController.text.trim(),
                          bio: "...",
                          password2:
                              authController.passwordController.text.trim(),
                          phoneNumber: authController.phoneNoController.text !=
                                  ""
                              ? authController.countryCodeController.text
                                      .trim() +
                                  authController.phoneNoController.text.trim()
                              : null,
                          country: authController.countryController.text.trim(),
                          state: authController.stateController.text.trim(),
                          ipurpose: selectedUse.map((e) => e.title!).toList(),
                          userName:
                              authController.userNameController.text.trim(),
                          profile: Profile(
                            igameType: selectedCategories
                                .map((e) => e.title!)
                                .toList(),
                            profilePicture: authController
                                        .pictureController.text
                                        .trim() ==
                                    ''
                                ? null
                                : authController.pictureController.text.trim(),
                          ),
                        );
                        debugPrint('User: ${user.toJson()}');

                        if (pageCount == 0) {
                          if (formKey.currentState!.validate()) {
                            if (authController.countryController.text == '' ||
                                authController.stateController.text == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: CustomText(
                                    title: 'choose your country/state!',
                                    size: Get.height * 0.02,
                                    color: AppColor().primaryWhite,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              );
                            } else {
                              setState(() {
                                pageCount++;
                                debugPrint('PageCount: $pageCount');
                              });
                            }
                          }
                        } else if (pageCount == 1) {
                          if (selectedUse.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomText(
                                  title: 'Select primary use to proceed!',
                                  size: Get.height * 0.02,
                                  color: AppColor().primaryWhite,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              pageCount++;
                              debugPrint('PageCount: $pageCount');
                            });
                          }
                        } else if (pageCount == 2) {
                          if (selectedCategories.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomText(
                                  title:
                                      'Select at least one category use to proceed!',
                                  size: Get.height * 0.02,
                                  color: AppColor().primaryWhite,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          } else {
                            Get.to(() => ChooseAlias(user: user));
                          }
                        } else {
                          Get.to(() => ChooseAlias(user: user));
                        }
                      },
                      buttonText: 'Next',
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
      ),
    );
  }
}

class PrimaryUse {
  String? title;
  bool? isSelected;

  PrimaryUse({this.title, this.isSelected});
}

class UserPreference {
  String? title;
  bool? isSelected;
  UserPreference({this.title, this.isSelected});
}

var primaryUseCard = [
  PrimaryUse(title: 'Competitions', isSelected: false),
  PrimaryUse(title: 'Gaming News', isSelected: false),
  PrimaryUse(title: 'Communities', isSelected: false),
];

var eventTypeCard = [
  PrimaryUse(title: 'Tournaments', isSelected: false),
  PrimaryUse(title: 'Social events', isSelected: false),
];

var fixtureTypeCard = [
  PrimaryUse(title: '1V1 Fixture', isSelected: false),
  PrimaryUse(title: "Leaderboard/BR Fixture", isSelected: false)
];

var categoryCard = [
  UserPreference(title: 'Puzzle', isSelected: false),
  UserPreference(title: 'Warfare', isSelected: false),
  UserPreference(title: 'RPG', isSelected: false),
  UserPreference(title: 'Sports', isSelected: false),
  UserPreference(title: 'Apocalypse', isSelected: false),
  UserPreference(title: 'Board', isSelected: false),
];
