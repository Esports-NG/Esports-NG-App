import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/event/social_event_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/ui/widgets/posts/create_post_item.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/ui/widgets/game/game_list_dropdown.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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
  final socialEventController = Get.put(SocialEventRepository());
  final eventController = Get.put(EventRepository());
  final communityController = Get.put(CommunityRepository());
  int selectedMenu = 0;
  String? communitiesValue, gameValue, partnerValue;

  bool isEventDesc = false,
      isGame = false,
      isEventName = false,
      isRegistrationStartDate = false,
      isRegistrationEndDate = false,
      isEntryFee = false,
      isEventLink = false,
      isEventVenue = false,
      isPartner = false,
      isCommunities = false,
      isStartTime = false,
      isEndTime = false,
      isEventDate = false;

  final FocusNode _eventDescFocusNode = FocusNode();
  final FocusNode _eventVenueFocusNode = FocusNode();
  final FocusNode _eventNameFocusNode = FocusNode();
  final FocusNode _gameModeFocusNode = FocusNode();
  final FocusNode _registrationStartDateFocusNode = FocusNode();
  final FocusNode _registrationEndDateFocusNode = FocusNode();
  final FocusNode _entryFeeFocusNode = FocusNode();
  final FocusNode _eventLinkFocusNode = FocusNode();
  final FocusNode _eventDateFocusNode = FocusNode();
  final FocusNode _eventHashtagFocusNode = FocusNode();

  @override
  void dispose() {
    _eventDescFocusNode.dispose();
    _eventVenueFocusNode.dispose();
    _eventNameFocusNode.dispose();
    _gameModeFocusNode.dispose();
    _registrationStartDateFocusNode.dispose();
    _registrationEndDateFocusNode.dispose();
    _entryFeeFocusNode.dispose();
    _eventLinkFocusNode.dispose();
    _eventHashtagFocusNode.dispose();
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
    } else if (title == 'regStartDate') {
      setState(() {
        isRegistrationStartDate = true;
      });
    } else if (title == 'regEndDate') {
      setState(() {
        isRegistrationEndDate = true;
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
    } else if (title == 'eventDate') {
      setState(() {
        isEventDate = true;
      });
    } else {
      setState(() {
        isCommunities = true;
      });
    }
  }

  Future pickTime(String title) async {
    TimeOfDay initialTime = TimeOfDay.now();
    final timeOfDay = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });
    if (timeOfDay == null) return;

    setState(() {
      initialTime = timeOfDay;
      if (title == 'start') {
        socialEventController.startTimeController.text =
            initialTime.format(context);
      } else {
        socialEventController.endTimeController.text =
            initialTime.format(context);
      }
    });
  }

  Future pickDate(String title) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: socialEventController.date.value ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 40),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      if (title == "start") {
        socialEventController.regStartDateController.text =
            DateFormat("yyyy-MM-dd").format(newDate).toString();
      } else if (title == "eventDate") {
        socialEventController.eventDateController.text =
            DateFormat("yyyy-MM-dd").format(newDate).toString();
      } else {
        socialEventController.regEndDateController.text =
            DateFormat("yyyy-MM-dd").format(newDate).toString();
      }
      socialEventController.date.value = newDate;
      debugPrint(
          'Reg Date: ${socialEventController.regStartDateController.text}');
      debugPrint(
          'Reg Date: ${socialEventController.regEndDateController.text}');
    });
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
                    size: 14,
                    fontFamily: 'InterSemiBold',
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

  List<GamePlayed> _games = [];
  bool _fetchingGames = false;

  @override
  void initState() {
    socialEventController.organizingCommunity.listen((value) async {
      setState(() {
        _fetchingGames = true;
      });
      if (value != null) {
        var community = await communityController.getCommunityData(value.slug!);
        if (community != null) {
          setState(() {
            _games = community.gamesPlayed!;
          });
        }
      }
      setState(() {
        _fetchingGames = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: 'Fill the form correctly to create a social event page',
                size: 15,
                fontFamily: 'InterMedium',
                color: AppColor().primaryWhite,
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Organising community *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 16,
              ),
              Gap(Get.height * 0.01),
              InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor().primaryDark,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: AppColor().lightItemsColor, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CommunityModel>(
                    dropdownColor: AppColor().primaryDark,
                    borderRadius: BorderRadius.circular(10),
                    value: socialEventController.organizingCommunity.value,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor().lightItemsColor,
                    ),
                    items: communityController.myCommunity.map((value) {
                      return DropdownMenuItem<CommunityModel>(
                        value: value,
                        child: CustomText(
                          title: value.name,
                          fontFamily: 'InterMedium',
                          size: 14,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      socialEventController.organizingCommunity.value = value;
                      socialEventController.communitiesOwnedController.text =
                          value!.name!;
                      debugPrint(communitiesValue);
                      handleTap('communities');
                    },
                    hint: CustomText(
                      title: "Communities Owned",
                      color: isCommunities == true
                          ? AppColor().primaryBackGroundColor
                          : AppColor().lightItemsColor,
                      fontFamily: 'InterMedium',
                      size: 14,
                    ),
                  ),
                ),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Event name *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "The Willywonkers",
                textEditingController:
                    socialEventController.eventNameController,
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
                title: 'Event hashtag *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                prefixIcon: Icon(
                  Icons.tag,
                  color: AppColor().primaryWhite,
                ),
                hint: "Hashtag",
                textEditingController:
                    socialEventController.eventHashtagController,
                focusNode: _eventHashtagFocusNode,
                onSubmited: (_) {
                  _eventHashtagFocusNode.unfocus();
                },
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Event description *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "Type text here",
                textEditingController:
                    socialEventController.eventDescController,
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
                title: 'Currency *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              Theme(
                data: ThemeData.dark(),
                child: DropdownSearch<MapEntry<String, String>>(
                  onChanged: (value) {
                    eventController.currency.value = value!.value;
                  },
                  items: (filter, infiniteScrollProps) =>
                      eventController.currencies.entries.toList(),
                  itemAsString: (item) => item.key,
                  compareFn: (item1, item2) => true,
                  decoratorProps: DropDownDecoratorProps(
                    baseStyle: TextStyle(fontFamily: "Inter"),
                    decoration: InputDecoration(
                      fillColor: AppColor().primaryDark,
                      filled: true,
                      isDense: true,
                      prefixStyle: TextStyle(
                        color: AppColor().lightItemsColor,
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'InterMedium',
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      focusColor: AppColor().primaryWhite,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor().lightItemsColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'InterMedium',
                      ),
                      hintStyle: TextStyle(
                        color: AppColor().lightItemsColor,
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'InterMedium',
                      ),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                      showSearchBox: true,
                      itemBuilder: (context, item, isDisabled, isSelected) =>
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: CustomText(
                              title: item.key,
                              color: AppColor().primaryWhite,
                              size: 16,
                            ),
                          ),
                      searchFieldProps: TextFieldProps(
                          style: TextStyle(fontFamily: "Inter"),
                          decoration: InputDecoration(
                            hintText: "Select a currency",
                            prefixIcon: Icon(
                              CupertinoIcons.search,
                              color: AppColor().greyFour,
                            ),
                            hintStyle: TextStyle(
                                color: AppColor().greyFour,
                                fontFamily: "InterMedium"),
                            filled: true,
                            fillColor:
                                AppColor().primaryWhite.withOpacity(0.05),
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
                          )),
                      menuProps: MenuProps(
                          backgroundColor: AppColor().primaryDark,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                ),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Entry fee *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                prefixIcon: IntrinsicWidth(
                  child: Center(
                    child: Text(
                      eventController.currency.value,
                      style: TextStyle(
                          color: AppColor().greyFour,
                          fontFamily: "dfe",
                          fontSize: 16),
                    ),
                  ),
                ),
                hint: "0.00",
                textEditingController: socialEventController.entryFeeController,
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
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              socialEventController.organizingCommunity.value == null
                  ? CustomText(
                      title: "Please select a community",
                      color: AppColor().primaryRed)
                  : _fetchingGames
                      ? ButtonLoader()
                      : GameDropdown(
                          gameValue: socialEventController.gameValue,
                          gameList: _games,
                        ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Registration Start date *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              InkWell(
                onTap: () {
                  pickDate("start");
                  handleTap('regStartDate');
                },
                child: CustomTextField(
                  hint: "DD/MM/YY",
                  enabled: false,
                  textEditingController:
                      socialEventController.regStartDateController,
                  hasText: isRegistrationStartDate,
                  focusNode: _registrationStartDateFocusNode,
                  onSubmited: (_) => _registrationStartDateFocusNode.unfocus(),
                  onChanged: (value) => setState(() {
                    isRegistrationStartDate = value.isNotEmpty;
                  }),
                  suffixIcon: Icon(
                    CupertinoIcons.calendar,
                    color: isRegistrationStartDate == true
                        ? AppColor().primaryBackGroundColor
                        : AppColor().lightItemsColor,
                  ),
                ),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Registration End date *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              InkWell(
                onTap: () {
                  pickDate("end");
                  handleTap('regEndDate');
                },
                child: CustomTextField(
                  hint: "DD/MM/YY",
                  enabled: false,
                  textEditingController:
                      socialEventController.regEndDateController,
                  hasText: isRegistrationEndDate,
                  focusNode: _registrationEndDateFocusNode,
                  onSubmited: (_) => _registrationEndDateFocusNode.unfocus(),
                  onChanged: (value) => setState(() {
                    isRegistrationEndDate = value.isNotEmpty;
                  }),
                  suffixIcon: Icon(
                    CupertinoIcons.calendar,
                    color: isRegistrationEndDate == true
                        ? AppColor().primaryBackGroundColor
                        : AppColor().lightItemsColor,
                  ),
                ),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Event date *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              InkWell(
                onTap: () {
                  pickDate("eventDate");
                  handleTap('eventDate');
                },
                child: CustomTextField(
                  hint: "DD/MM/YY",
                  enabled: false,
                  textEditingController:
                      socialEventController.eventDateController,
                  hasText: isEventDate,
                  focusNode: _eventDateFocusNode,
                  onSubmited: (_) => _eventDateFocusNode.unfocus(),
                  onChanged: (value) => setState(() {
                    isEventDate = value.isNotEmpty;
                  }),
                  suffixIcon: Icon(
                    CupertinoIcons.calendar,
                    color: isEventDate == true
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
                fontFamily: 'Inter',
                size: 14,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isStartTime == true
                              ? AppColor().primaryWhite
                              : AppColor().primaryDark,
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
                                  fontFamily: 'InterBold',
                                  size: 13,
                                ),
                                Gap(Get.height * 0.005),
                                CustomText(
                                  title: socialEventController
                                              .startTimeController.text ==
                                          ''
                                      ? '00:00 AM'
                                      : socialEventController
                                          .startTimeController.text,
                                  color: isStartTime == true
                                      ? AppColor().primaryBackGroundColor
                                      : AppColor().lightItemsColor,
                                  fontFamily: 'InterBold',
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
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isEndTime == true
                              ? AppColor().primaryWhite
                              : AppColor().primaryDark,
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
                                  fontFamily: 'InterBold',
                                  size: 13,
                                ),
                                Gap(Get.height * 0.005),
                                CustomText(
                                  title: socialEventController
                                              .endTimeController.text ==
                                          ''
                                      ? '00:00 AM'
                                      : socialEventController
                                          .endTimeController.text,
                                  color: isEndTime == true
                                      ? AppColor().primaryBackGroundColor
                                      : AppColor().lightItemsColor,
                                  fontFamily: 'InterBold',
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
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              socialEventController.pickCoverImage(onTap: () {
                if (socialEventController.eventCoverImage == null) {
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
                      fontFamily: "InterSemiBold",
                    ),
                    radius: 10,
                    confirm: Column(
                      children: [
                        CustomFillButton(
                          onTap: () {
                            socialEventController.pickImageFromGallery("image");
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
                            socialEventController.pickImageFromCamera("image");
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
                      fontFamily: 'InterMedium',
                      fontSize: 14,
                    ),
                  );
                } else {
                  socialEventController.clearPhoto();
                }
              }),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Event venue *',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "Type text here",
                textEditingController:
                    socialEventController.eventVenueController,
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
                fontFamily: 'Inter',
                size: 14,
              ),
              Gap(Get.height * 0.01),
              CustomTextField(
                hint: "https://",
                textEditingController:
                    socialEventController.eventLinkController,
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
              CustomFillButton(
                onTap: () {
                  socialEventController.createSocialEvent();
                },
                buttonText: 'Create Event',
                textSize: Get.height * 0.016,
                isLoading: eventController.createEventStatus.value ==
                    CreateEventStatus.loading,
              ),
              Gap(Get.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
