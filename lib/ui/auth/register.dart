import 'dart:io';

import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/page_indicator.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
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
  List<PrimaryUse> selectedUse = [];
  final authController = Get.put(AuthRepository());
  String? genderValue;

  bool isHiddenPassword = true;
  bool? isChecked = false;
  bool boolPass = false;
  int pageCount = 0;
  int? primaryUseCount;
  String state = '';
  String country = '';

  String countryValue = "";
  String statesValue = "";
  String cityValue = "";
  String address = "";

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
      if (kDebugMode) {
        debugPrint(authController.dobController.text);
      }
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
                  debugPrint('PageCount: $pageCount');
                }
              });
            } else {
              setState(() {});
              Get.back();
              authController.clear();
              selectedUse.clear();
              selectedCategories.clear();
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
                fontWeight: FontWeight.w600,
                fontFamily: 'GilroyBold',
                fontSize: Get.height * 0.017,
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
                        fontFamily: 'GilroyBold',
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
                    fontFamily: 'GilroyRegular',
                    size: Get.height * 0.018,
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
                                        image: authController.userImage == null
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/png/photo.png'),
                                                fit: BoxFit.contain)
                                            : DecorationImage(
                                                image: FileImage(
                                                    authController.userImage!),
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
                                          contentPadding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 30,
                                              left: 25,
                                              right: 25),
                                          middleText:
                                              "Upload your profile picture",
                                          titleStyle: TextStyle(
                                            color: AppColor().primaryWhite,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'GilroyRegular',
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
                                            fontFamily: 'GilroyRegular',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
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
                                                    color:
                                                        AppColor().primaryColor,
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
                                fontFamily: 'GilroyRegular',
                                size: Get.height * 0.017,
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
                            size: Get.height * 0.017,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "eg john doe",
                            textEditingController:
                                authController.fullNameController,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Full Name must not be empty';
                              } else if (!RegExp(r'^[A-Za-z\- ]+$')
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
                            size: Get.height * 0.017,
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
                                return "Enter a valid email address";
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
                            size: Get.height * 0.017,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "Password",
                            textEditingController:
                                authController.passwordController,
                            obscure: isHiddenPassword,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Password must not be empty';
                              } else if (value.length < 8) {
                                return 'Password must not be less than 8 character';
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
                                    : AppColor().primaryColor,
                              ),
                            ),
                          ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: 'Country',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.017,
                          ),
                          Gap(Get.height * 0.01),
                          CSCPicker(
                            layout: Layout.vertical,
                            showStates: true,
                            showCities: false,
                            flagState: CountryFlag.ENABLE,
                            dropdownDecoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: AppColor().bgDark),
                            disabledDropdownDecoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: AppColor().bgDark),
                            countrySearchPlaceholder: "Select Country",
                            stateSearchPlaceholder: "Select State",
                            citySearchPlaceholder: "City",
                            countryDropdownLabel: "Country",
                            stateDropdownLabel: "State",
                            cityDropdownLabel: "City",
                            selectedItemStyle: TextStyle(
                                color: AppColor().lightItemsColor,
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'GilroyBold',
                                fontWeight: FontWeight.w400,
                                height: 1.7),
                            dropdownHeadingStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'GilroyBold',
                              fontWeight: FontWeight.w400,
                            ),
                            dropdownItemStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'GilroyBold',
                              fontWeight: FontWeight.w400,
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
                            title: 'Phone number',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.017,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            hint: "phone",
                            textEditingController:
                                authController.phoneNoController,
                            keyType: TextInputType.phone,
                            pretext: authController.countryCodeController.text,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Phone no must not be empty';
                              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return "Please enter only digits";
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
                            size: Get.height * 0.017,
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
                                    if (genderValue == "Male") {
                                      authController.genderController.text =
                                          'M';
                                    } else {
                                      authController.genderController.text =
                                          'F';
                                    }

                                    if (kDebugMode) {
                                      debugPrint(value);
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
                            size: Get.height * 0.017,
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
                            size: Get.height * 0.017,
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
                                item.isSelected = !item.isSelected!;
                                if (item.isSelected == true) {
                                  selectedUse
                                      .add(PrimaryUse(title: item.title!));
                                } else if (item.isSelected == false) {
                                  selectedUse.removeWhere(
                                      (element) => element.title == item.title);
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
                        fullName: authController.fullNameController.text.trim(),
                        email: authController.emailController.text.trim(),
                        password: authController.passwordController.text.trim(),
                        password2:
                            authController.passwordController.text.trim(),
                        phoneNumber:
                            authController.countryCodeController.text.trim() +
                                authController.phoneNoController.text.trim(),
                        country: authController.countryController.text.trim(),
                        state: authController.stateController.text.trim(),
                        gender: authController.genderController.text.trim(),
                        dOB: authController.dobController.text.trim(),
                        iPurpose: selectedUse.map((e) => e.title!).toList(),
                        userName: authController.userNameController.text.trim(),
                        iProfile: SignUpProfile(
                          iGameType:
                              selectedCategories.map((e) => e.title!).toList(),
                          profilePicture:
                              authController.pictureController.text.trim() == ''
                                  ? null
                                  : authController.pictureController.text
                                      .trim(),
                        ),
                      );
                      debugPrint('User: ${user.toJson()}');

                      if (pageCount == 0) {
                        if (_formKey.currentState!.validate()) {
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
                          } else if (authController.genderController.text ==
                              '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomText(
                                  title: 'choose your gender!',
                                  size: Get.height * 0.02,
                                  color: AppColor().primaryWhite,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          } else if (authController.dobController.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomText(
                                  title: 'pick your date of birth!',
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
