import 'dart:io';

import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/ui/auth/choose_alias.dart';
import 'package:e_sport/ui/auth/register.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
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
  bool isHiddenPassword = true, isChecked = false, boolPass = false;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        elevation: 0,
        leading: GoBackButton(
          onPressed: () {},
        ),
        centerTitle: true,
        title: CustomText(
          title: 'Create an Event',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
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
                ),
              ],
            )),
          ),
          Gap(Get.height * 0.02),
        ],
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (pageCount == 0) ...[
                CustomText(
                  title: 'Select your event type',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyBold',
                  size: Get.height * 0.024,
                ),
                Gap(Get.height * 0.1),
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
                              selectedUse.add(PrimaryUse(title: item.title!));
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
              ] else if (pageCount == 1)
                ...[]
              else
                ...[],
              CustomFillButton(
                onTap: () {
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
                      } else if (authController.genderController.text == '') {
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
      ),
    );
  }
}
