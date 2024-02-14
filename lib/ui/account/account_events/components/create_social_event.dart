import 'dart:io';
import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/home/post/create_post_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateSocialEvent extends StatefulWidget {
  const CreateSocialEvent({super.key});

  @override
  State<CreateSocialEvent> createState() => _CreateSocialEventState();
}

class _CreateSocialEventState extends State<CreateSocialEvent> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthRepository());
  final postController = Get.put(PostRepository());
  final eventController = Get.put(EventRepository());
  final communityController = Get.put(CommunityRepository());
  CommunityModel? selectedItem;
  int selectedMenu = 0;
  String? communitiesValue, gameValue, partnerValue;

  bool isEventDesc = false,
      isGame = false,
      isEventName = false,
      isRegistrationDate = false,
      isEntryFee = false,
      isEventLink = false,
      isEventVenue = false,
      isPartner = false,
      isCommunities = false,
      isStartTime = false,
      isEndTime = false;

  final FocusNode _eventDescFocusNode = FocusNode();
  final FocusNode _eventVenueFocusNode = FocusNode();
  final FocusNode _eventNameFocusNode = FocusNode();
  final FocusNode _gameModeFocusNode = FocusNode();
  final FocusNode _registrationDateFocusNode = FocusNode();
  final FocusNode _entryFeeFocusNode = FocusNode();
  final FocusNode _eventLinkFocusNode = FocusNode();

  @override
  void dispose() {
    _eventDescFocusNode.dispose();
    _eventVenueFocusNode.dispose();
    _eventNameFocusNode.dispose();
    _gameModeFocusNode.dispose();
    _registrationDateFocusNode.dispose();
    _entryFeeFocusNode.dispose();
    _eventLinkFocusNode.dispose();
    super.dispose();
  }

  void handleTap(String? title) {
    if (title == 'description') {
      setState(() {
        isEventDesc = true;
      });
    } else if (title == 'game') {
      setState(() {
        isGame = true;
      });
    } else if (title == 'eventName') {
      setState(() {
        isEventName = true;
      });
    } else if (title == 'regDate') {
      setState(() {
        isRegistrationDate = true;
      });
    } else if (title == 'eventVenue') {
      setState(() {
        isEventVenue = true;
      });
    } else if (title == 'entryFee') {
      setState(() {
        isEntryFee = true;
      });
    } else if (title == 'eventLink') {
      setState(() {
        isEventLink = true;
      });
    } else if (title == 'partner') {
      setState(() {
        isPartner = true;
      });
    } else if (title == 'start') {
      setState(() {
        isStartTime = true;
      });
    } else if (title == 'end') {
      setState(() {
        isEndTime = true;
      });
    } else {
      setState(() {
        isCommunities = true;
      });
    }
  }

  Future pickTime(String title) async {
    TimeOfDay initialTime = TimeOfDay.now();
    final timeOfDay =
        await showTimePicker(context: context, initialTime: initialTime);
    if (timeOfDay == null) return;
    setState(() {
      initialTime = timeOfDay;
      if (title == 'start') {
        eventController.startTimeController.text = initialTime.format(context);
      } else {
        eventController.endTimeController.text = initialTime.format(context);
      }
    });
  }

  Future pickDate() async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: eventController.date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 40),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      eventController.regDateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      eventController.date = newDate;
      debugPrint('Reg Date: ${eventController.regDateController.text}');
    });
  }

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        eventController.mEventCoverImage(imageTemporary);
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
        eventController.mEventCoverImage(imageTemporary);
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  pickProfileImage({VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.04),
      decoration: BoxDecoration(
          color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            eventController.eventProfileImage == null
                ? SvgPicture.asset(
                    'assets/images/svg/photo.svg',
                    height: Get.height * 0.08,
                  )
                : Container(
                    height: Get.height * 0.08,
                    width: Get.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: FileImage(eventController.eventProfileImage!),
                          fit: BoxFit.cover),
                    ),
                  ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: onTap,
              child: CustomText(
                title: eventController.eventProfileImage == null
                    ? 'Click to upload'
                    : 'Cancel',
                weight: FontWeight.w400,
                size: 15,
                fontFamily: 'GilroyMedium',
                color: AppColor().primaryColor,
                underline: TextDecoration.underline,
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Max file size: 4MB',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'GilroyRegular',
              size: Get.height * 0.014,
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, myState) {
          return AlertDialog(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: AppColor().primaryWhite,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomText(
                    title: 'Select an account for\nyour post',
                    size: Get.height * 0.018,
                    fontFamily: 'GilroySemiBold',
                    textAlign: TextAlign.center,
                    color: AppColor().primaryWhite,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColor().primaryLightColor,
            content: Container(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                width: Get.width * 0.5,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: selectAccountItem.length,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.03),
                  itemBuilder: (context, index) {
                    var item = selectAccountItem[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          postController.accountTypeController.text =
                              item.title;
                        });
                        myState(() {
                          selectedMenu = index;
                        });
                        Get.back();
                      },
                      child: CreateMenu(
                        item: item,
                        selectedItem: selectedMenu,
                        index: index,
                      ),
                    );
                  },
                )),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        elevation: 0,
        leading: GoBackButton(onPressed: () => Get.back()),
        centerTitle: true,
        title: CustomText(
          title: 'Create a social event',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
        actions: [
          Center(
            child: Text.rich(TextSpan(
              text: '2',
              style: TextStyle(
                color: AppColor().primaryWhite,
                fontWeight: FontWeight.w600,
                fontFamily: 'GilroyBold',
                fontSize: Get.height * 0.017,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "/2",
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
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(TextSpan(
                      text: "Post as: ",
                      style: TextStyle(
                        color: AppColor().primaryWhite,
                        fontFamily: 'GilroyMedium',
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: postController.accountTypeController.text == ''
                              ? "“Your User Profile”"
                              : "“${postController.accountTypeController.text}”",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                    InkWell(
                      onTap: _showAccountListDialog,
                      child: CustomText(
                        title: 'Change Account',
                        weight: FontWeight.w400,
                        size: 15,
                        fontFamily: 'GilroyMedium',
                        color: AppColor().primaryColor,
                        underline: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                Gap(Get.height * 0.03),
                CustomText(
                  title:
                      'Fill the form correctly to create a social event page',
                  weight: FontWeight.w400,
                  size: 15,
                  fontFamily: 'GilroyMedium',
                  color: AppColor().primaryWhite,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Organising community *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isCommunities == true
                        ? AppColor().primaryWhite
                        : AppColor().bgDark,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().lightItemsColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CommunityModel>(
                      value: selectedItem,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: isCommunities == true
                            ? AppColor().primaryBackGroundColor
                            : AppColor().lightItemsColor,
                      ),
                      items: communityController.allCommunity.map((value) {
                        return DropdownMenuItem<CommunityModel>(
                          value: value,
                          child: CustomText(
                            title: value.name,
                            color: isCommunities == true
                                ? AppColor().primaryBackGroundColor
                                : AppColor().lightItemsColor,
                            fontFamily: 'GilroyBold',
                            weight: FontWeight.w400,
                            size: 13,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          communitiesValue = value!.name;
                          eventController.communitiesOwnedController.text =
                              value.name!;
                          debugPrint(communitiesValue);
                          handleTap('communities');
                        });
                      },
                      hint: CustomText(
                        title: "Communities Owned",
                        color: isCommunities == true
                            ? AppColor().primaryBackGroundColor
                            : AppColor().lightItemsColor,
                        fontFamily: 'GilroyBold',
                        weight: FontWeight.w400,
                        size: 13,
                      ),
                    ),
                  ),
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Event name *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "The Willywonkers",
                  textEditingController: eventController.eventNameController,
                  hasText: isEventName,
                  focusNode: _eventNameFocusNode,
                  onTap: () => handleTap('eventName'),
                  onSubmited: (_) => _eventNameFocusNode.unfocus(),
                  onChanged: (value) => setState(() {
                    isEventName = value.isNotEmpty;
                  }),
                  validate: Validator.isName,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Event description *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "type text here",
                  textEditingController: eventController.eventDescController,
                  maxLines: 4,
                  hasText: isEventDesc,
                  focusNode: _eventDescFocusNode,
                  onTap: () => handleTap('description'),
                  onSubmited: (_) => _eventDescFocusNode.unfocus(),
                  onChanged: (value) => setState(() {
                    isEventDesc = value.isNotEmpty;
                  }),
                  validate: Validator.isName,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Entry fee *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "NGN 0.00",
                  textEditingController: eventController.entryFeeController,
                  hasText: isEntryFee,
                  focusNode: _entryFeeFocusNode,
                  onTap: () => handleTap('entryFee'),
                  onSubmited: (_) {
                    _entryFeeFocusNode.unfocus();
                  },
                  onChanged: (value) {
                    setState(() {
                      isEntryFee = value.isNotEmpty;
                    });
                  },
                  validate: Validator.isNumber,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Games covered *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isGame == true
                        ? AppColor().primaryWhite
                        : AppColor().bgDark,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().lightItemsColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: isGame == true
                              ? AppColor().primaryBackGroundColor
                              : AppColor().lightItemsColor),
                      value: gameValue,
                      items: <String>[
                        '1',
                        '2',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: CustomText(
                            title: value,
                            color: isGame == true
                                ? AppColor().primaryBackGroundColor
                                : AppColor().lightItemsColor,
                            fontFamily: 'GilroyBold',
                            weight: FontWeight.w400,
                            size: 13,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() {
                        gameValue = value;
                        debugPrint(value);
                        eventController.gameCoveredController.text = value!;
                        handleTap('game');
                      }),
                      hint: CustomText(
                        title: "Game covered",
                        color: isGame == true
                            ? AppColor().primaryBackGroundColor
                            : AppColor().lightItemsColor,
                        fontFamily: 'GilroyBold',
                        weight: FontWeight.w400,
                        size: 13,
                      ),
                    ),
                  ),
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Registration dates *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                InkWell(
                  onTap: () {
                    pickDate();
                    handleTap('regDate');
                  },
                  child: CustomTextField(
                    hint: "DD/MM/YY",
                    enabled: false,
                    textEditingController: eventController.regDateController,
                    hasText: isRegistrationDate,
                    focusNode: _registrationDateFocusNode,
                    onSubmited: (_) => _registrationDateFocusNode.unfocus(),
                    onChanged: (value) => setState(() {
                      isRegistrationDate = value.isNotEmpty;
                    }),
                    suffixIcon: Icon(
                      CupertinoIcons.calendar,
                      color: isRegistrationDate == true
                          ? AppColor().primaryBackGroundColor
                          : AppColor().lightItemsColor,
                    ),
                  ),
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Event time *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          pickTime('start');
                          handleTap('start');
                        },
                        child: Container(
                          height: Get.height * 0.065,
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isStartTime == true
                                ? AppColor().primaryWhite
                                : AppColor().bgDark,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.time,
                                color: isStartTime == true
                                    ? AppColor().primaryBackGroundColor
                                    : AppColor().lightItemsColor,
                              ),
                              Gap(Get.height * 0.01),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: 'Starts',
                                    color: isStartTime == true
                                        ? AppColor().primaryBackGroundColor
                                        : AppColor().lightItemsColor,
                                    fontFamily: 'GilroyBold',
                                    weight: FontWeight.w400,
                                    size: 13,
                                  ),
                                  Gap(Get.height * 0.005),
                                  CustomText(
                                    title: eventController
                                                .startTimeController.text ==
                                            ''
                                        ? '00:00 AM'
                                        : eventController
                                            .startTimeController.text,
                                    color: isStartTime == true
                                        ? AppColor().primaryBackGroundColor
                                        : AppColor().lightItemsColor,
                                    fontFamily: 'GilroyBold',
                                    weight: FontWeight.w400,
                                    size: 13,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: isStartTime == true
                                    ? AppColor().primaryBackGroundColor
                                    : AppColor().lightItemsColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          pickTime('end');
                          handleTap('end');
                        },
                        child: Container(
                          height: Get.height * 0.065,
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isEndTime == true
                                ? AppColor().primaryWhite
                                : AppColor().bgDark,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.time,
                                color: isEndTime == true
                                    ? AppColor().primaryBackGroundColor
                                    : AppColor().lightItemsColor,
                              ),
                              Gap(Get.height * 0.01),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title: 'Ends',
                                    color: isEndTime == true
                                        ? AppColor().primaryBackGroundColor
                                        : AppColor().lightItemsColor,
                                    fontFamily: 'GilroyBold',
                                    weight: FontWeight.w400,
                                    size: 13,
                                  ),
                                  Gap(Get.height * 0.005),
                                  CustomText(
                                    title: eventController
                                                .endTimeController.text ==
                                            ''
                                        ? '00:00 AM'
                                        : eventController
                                            .endTimeController.text,
                                    color: isEndTime == true
                                        ? AppColor().primaryBackGroundColor
                                        : AppColor().lightItemsColor,
                                    fontFamily: 'GilroyBold',
                                    weight: FontWeight.w400,
                                    size: 13,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: isEndTime == true
                                    ? AppColor().primaryBackGroundColor
                                    : AppColor().lightItemsColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Event image *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                pickProfileImage(onTap: () {
                  if (eventController.eventProfileImage == null) {
                    debugPrint('pick image');
                    Get.defaultDialog(
                      title: "Select your image",
                      backgroundColor: AppColor().primaryLightColor,
                      titlePadding: const EdgeInsets.only(top: 30),
                      contentPadding: const EdgeInsets.only(
                          top: 5, bottom: 30, left: 25, right: 25),
                      middleText: "Upload your event image",
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
                            buttonText: 'Upload from gallery',
                            textColor: AppColor().primaryWhite,
                            buttonColor: AppColor().primaryColor,
                            boarderColor: AppColor().primaryColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          const Gap(10),
                          CustomFillButton(
                            onTap: () {
                              pickImageFromCamera();
                              Get.back();
                            },
                            height: 45,
                            width: Get.width * 0.5,
                            buttonText: 'Upload from camera',
                            textColor: AppColor().primaryWhite,
                            buttonColor: AppColor().primaryColor,
                            boarderColor: AppColor().primaryColor,
                            borderRadius: BorderRadius.circular(25),
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
                  } else {
                    eventController.clearProfilePhoto();
                  }
                }),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Event venue *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Type text here",
                  textEditingController: eventController.eventVenueController,
                  hasText: isEventVenue,
                  focusNode: _eventVenueFocusNode,
                  onTap: () => handleTap('eventVenue'),
                  maxLines: 4,
                  onSubmited: (_) => _eventVenueFocusNode.unfocus(),
                  onChanged: (value) => setState(() {
                    isEventVenue = value.isNotEmpty;
                  }),
                  validate: Validator.isName,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Event link *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "https://",
                  textEditingController: eventController.eventLinkController,
                  hasText: isEventLink,
                  focusNode: _eventLinkFocusNode,
                  onTap: () => handleTap('eventLink'),
                  onSubmited: (_) => _eventLinkFocusNode.unfocus(),
                  onChanged: (value) => setState(() {
                    isEventLink = value.isNotEmpty;
                  }),
                  validate: Validator.isLink,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Event partners *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'GilroyRegular',
                  size: Get.height * 0.017,
                ),
                Gap(Get.height * 0.01),
                InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isPartner == true
                        ? AppColor().primaryWhite
                        : AppColor().bgDark,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().lightItemsColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: isPartner == true
                              ? AppColor().primaryBackGroundColor
                              : AppColor().lightItemsColor),
                      value: partnerValue,
                      items: <String>[
                        'EASPORTS',
                        'ESportsNG',
                        'Others',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: CustomText(
                            title: value,
                            color: isPartner == true
                                ? AppColor().primaryBackGroundColor
                                : AppColor().lightItemsColor,
                            fontFamily: 'GilroyBold',
                            weight: FontWeight.w400,
                            size: 13,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() {
                        partnerValue = value;
                        debugPrint(value);
                        eventController.partnersController.text = value!;
                        handleTap('partner');
                      }),
                      hint: CustomText(
                        title: "Partners",
                        color: isPartner == true
                            ? AppColor().primaryBackGroundColor
                            : AppColor().lightItemsColor,
                        fontFamily: 'GilroyBold',
                        weight: FontWeight.w400,
                        size: 13,
                      ),
                    ),
                  ),
                ),
                Gap(Get.height * 0.02),
                CustomFillButton(
                  onTap: () {},
                  buttonText: 'Create Event',
                  fontWeight: FontWeight.w600,
                  textSize: Get.height * 0.016,
                  isLoading: false,
                ),
                Gap(Get.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
