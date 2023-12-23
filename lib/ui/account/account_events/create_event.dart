import 'dart:io';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/auth/choose_alias.dart';
import 'package:e_sport/ui/auth/register.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/cupertino.dart';
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
  final eventController = Get.put(EventRepository());
  final communityController = Get.put(CommunityRepository());
  String? communitiesValue,
      gameValue,
      gameModeValue,
      knockoutValue,
      rankTypeValue,
      tournamentTypeValue,
      participantValue;

  bool isTournamentLink = false,
      isGame = false,
      isTournamentName = false,
      isGameMode = false,
      isTournamentType = false,
      isKnockout = false,
      isCommunities = false,
      isRankType = false,
      isRegistrationDate = false,
      isTournamentDate = false,
      isPrizePool = false,
      isEntryFee = false,
      enableLeaderboard = false,
      dontEnableLeaderboard = false,
      isParticipant = false,
      isFirstPrize = false,
      isSecondPrize = false,
      isThirdPrize = false;

  int pageCount = 0, eventTypeCount = 0, participantCount = 1;

  final FocusNode _tournamentLinkFocusNode = FocusNode();
  final FocusNode _gameFocusNode = FocusNode();
  final FocusNode _tournamentnameFocusNode = FocusNode();
  final FocusNode _gameModeFocusNode = FocusNode();
  final FocusNode _tournamentTypeFocusNode = FocusNode();
  final FocusNode _knockoutFocusNode = FocusNode();
  final FocusNode _communitiesFocusNode = FocusNode();
  final FocusNode _rankTypeFocusNode = FocusNode();
  final FocusNode _registrationDateFocusNode = FocusNode();
  final FocusNode _tournamentDateFocusNode = FocusNode();
  final FocusNode _prizePoolFocusNode = FocusNode();
  final FocusNode _entryFeeFocusNode = FocusNode();
  final FocusNode _firstPrizeFocusNode = FocusNode();
  final FocusNode _secondPrizeFocusNode = FocusNode();
  final FocusNode _thirdPrizeFocusNode = FocusNode();

  @override
  void dispose() {
    _tournamentLinkFocusNode.dispose();
    _gameFocusNode.dispose();
    _tournamentnameFocusNode.dispose();
    _gameModeFocusNode.dispose();
    _tournamentTypeFocusNode.dispose();
    _knockoutFocusNode.dispose();
    _communitiesFocusNode.dispose();
    _rankTypeFocusNode.dispose();
    _registrationDateFocusNode.dispose();
    _tournamentDateFocusNode.dispose();
    _prizePoolFocusNode.dispose();
    _entryFeeFocusNode.dispose();
    _firstPrizeFocusNode.dispose();
    _secondPrizeFocusNode.dispose();
    _thirdPrizeFocusNode.dispose();
    super.dispose();
  }

  void handleTap(String? title) {
    if (title == 'tournamentLink') {
      setState(() {
        isTournamentLink = true;
      });
    } else if (title == 'game') {
      setState(() {
        isGame = true;
      });
    } else if (title == 'tournamentName') {
      setState(() {
        isTournamentName = true;
      });
    } else if (title == 'gameMode') {
      setState(() {
        isGameMode = true;
      });
    } else if (title == 'tournamentType') {
      setState(() {
        isTournamentType = true;
      });
    } else if (title == 'knockout') {
      setState(() {
        isKnockout = true;
      });
    } else if (title == 'communities') {
      setState(() {
        isCommunities = true;
      });
    } else if (title == 'rankType') {
      setState(() {
        isRankType = true;
      });
    } else if (title == 'regDate') {
      setState(() {
        isRegistrationDate = true;
      });
    } else if (title == 'tourDate') {
      setState(() {
        isTournamentDate = true;
      });
    } else if (title == 'prizePool') {
      setState(() {
        isPrizePool = true;
      });
    } else if (title == 'entryFee') {
      setState(() {
        isEntryFee = true;
      });
    } else if (title == 'participant') {
      setState(() {
        isParticipant = true;
      });
    } else if (title == 'first') {
      setState(() {
        isFirstPrize = true;
      });
    } else if (title == 'second') {
      setState(() {
        isSecondPrize = true;
      });
    } else if (title == 'third') {
      setState(() {
        isThirdPrize = true;
      });
    } else {
      setState(() {
        isRegistrationDate = true;
      });
    }
  }

  void displayMsg(msg) {
    debugPrint(msg);
  }

  Future pickDate(String title) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: eventController.date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 40),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      if (title == 'registration') {
        eventController.regDateController.text =
            DateFormat("yyyy-MM-dd").format(newDate).toString();
        eventController.date = newDate;
        debugPrint('Reg Date: ${eventController.regDateController.text}');
      } else {
        eventController.tournamentDateController.text =
            DateFormat("yyyy-MM-dd").format(newDate).toString();
        eventController.date = newDate;
        debugPrint(
            'Tournament Date: ${eventController.tournamentDateController.text}');
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

  DropdownMenuItem<String> buildDropDownItem(String item) => DropdownMenuItem(
      value: item,
      child: CustomText(
          title: item,
          fontFamily: 'GilroyBold',
          weight: FontWeight.w400,
          size: 13));

  CommunityModel? selectedItem;

  @override
  Widget build(BuildContext context) {
    selectedItem = communityController.allCommunity.first;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        elevation: 0,
        leading: GoBackButton(
          onPressed: () {
            if (pageCount > 0) {
              setState(() {
                --pageCount;
                debugPrint('PageCount: $pageCount');
              });
            } else {
              setState(() {});
              Get.back();
            }
          },
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
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: SingleChildScrollView(
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
                    itemCount: eventTypeCard.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = eventTypeCard[index];
                      return CustomFillButtonOption(
                        onTap: () {
                          setState(() {
                            eventTypeCount = index;
                            item.isSelected = !item.isSelected!;
                            debugPrint('Type: ${item.title}');
                            eventController.eventTypeController.text =
                                item.title!;
                          });
                        },
                        height: Get.height * 0.06,
                        buttonText: item.title,
                        textColor: AppColor().primaryWhite,
                        buttonColor: eventTypeCount == index
                            ? AppColor().primaryGreen
                            : AppColor().primaryBackGroundColor,
                        boarderColor: eventTypeCount == index
                            ? AppColor().primaryGreen
                            : AppColor().primaryWhite,
                        borderRadius: BorderRadius.circular(30),
                        fontWeight: FontWeight.w400,
                      );
                    }),
              ] else if (pageCount == 1) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor().primaryLightColor,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(Get.height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColor().primaryWhite,
                            size: 20,
                          ),
                          Gap(Get.height * 0.01),
                          Expanded(
                            child: CustomText(
                              title:
                                  'Please note: External software will be required for Bracket Management... You can still create fixtures on the platform',
                              weight: FontWeight.w500,
                              size: 14,
                              fontFamily: 'GilroyMedium',
                              textAlign: TextAlign.start,
                              color: AppColor().primaryWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title:
                          'Fill the form correctly to create a tournament page',
                      weight: FontWeight.w500,
                      size: 16,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                      title: 'Tournament name *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "The Willywonkers",
                      textEditingController:
                          eventController.tournamentNameController,
                      hasText: isTournamentName,
                      focusNode: _tournamentnameFocusNode,
                      onTap: () {
                        handleTap('tournamentName');
                      },
                      onSubmited: (_) {
                        _tournamentnameFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isTournamentName = value.isNotEmpty;
                        });
                      },
                      validate: Validator.isName,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Tournament link for brackets *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "https://",
                      textEditingController:
                          eventController.tournamentLinkController,
                      hasText: isTournamentLink,
                      focusNode: _tournamentLinkFocusNode,
                      onTap: () {
                        handleTap('tournamentLink');
                      },
                      onSubmited: (_) {
                        _tournamentLinkFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isTournamentLink = value.isNotEmpty;
                        });
                      },
                      validate: Validator.isLink,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Game to be played *',
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                          onChanged: (value) {
                            setState(() {
                              gameValue = value;
                              debugPrint(value);
                              eventController.gamePlayedController.text =
                                  value!;
                              handleTap('game');
                            });
                          },
                          hint: CustomText(
                            title: "Game",
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
                      title: 'Game Mode',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isGameMode == true
                            ? AppColor().primaryWhite
                            : AppColor().bgDark,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().lightItemsColor, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: isGameMode == true
                                  ? AppColor().primaryBackGroundColor
                                  : AppColor().lightItemsColor),
                          value: gameModeValue,
                          items: <String>[
                            'Male',
                            'Female',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: CustomText(
                                title: value,
                                color: isGameMode == true
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
                              gameModeValue = value;
                              debugPrint(value);
                              eventController.gameModeController.text = value!;
                              handleTap('gameMode');
                            });
                          },
                          hint: CustomText(
                            title: "Game Mode",
                            color: isGameMode == true
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
                      title: 'Tournament Type',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isTournamentType == true
                            ? AppColor().primaryWhite
                            : AppColor().bgDark,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().lightItemsColor, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: isTournamentType == true
                                  ? AppColor().primaryBackGroundColor
                                  : AppColor().lightItemsColor),
                          value: tournamentTypeValue,
                          items: <String>[
                            'Male',
                            'Female',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: CustomText(
                                title: value,
                                color: isTournamentType == true
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
                              tournamentTypeValue = value!;
                              debugPrint(value);
                              eventController.tournamentTypeController.text =
                                  value;
                              handleTap('tournamentType');
                            });
                          },
                          hint: CustomText(
                            title: "Tournament Type",
                            color: isTournamentType == true
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
                      title: 'Knockout Type',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isKnockout == true
                            ? AppColor().primaryWhite
                            : AppColor().bgDark,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().lightItemsColor, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: isKnockout == true
                                  ? AppColor().primaryBackGroundColor
                                  : AppColor().lightItemsColor),
                          value: knockoutValue,
                          items: <String>[
                            'Male',
                            'Female',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: CustomText(
                                title: value,
                                color: isKnockout == true
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
                              knockoutValue = value;
                              debugPrint(value);
                              eventController.knockoutTypeController.text =
                                  value!;
                              handleTap('knockout');
                            });
                          },
                          hint: CustomText(
                            title: "Knockout Type",
                            color: isKnockout == true
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
                      title: 'Rank Type',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isRankType == true
                            ? AppColor().primaryWhite
                            : AppColor().bgDark,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColor().lightItemsColor, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: isRankType == true
                                  ? AppColor().primaryBackGroundColor
                                  : AppColor().lightItemsColor),
                          value: rankTypeValue,
                          items: <String>[
                            'Ranked',
                            'Unranked',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: CustomText(
                                title: value,
                                color: isRankType == true
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
                              rankTypeValue = value;
                              eventController.rankTypeController.text = value!;
                              debugPrint(value);
                              handleTap('rank');
                            });
                          },
                          hint: CustomText(
                            title: "Rank Type",
                            color: isRankType == true
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
                        pickDate('registration');
                        handleTap('regDate');
                      },
                      child: CustomTextField(
                        hint: "DD/MM/YY",
                        enabled: false,
                        textEditingController:
                            eventController.regDateController,
                        hasText: isRegistrationDate,
                        focusNode: _registrationDateFocusNode,
                        onSubmited: (_) {
                          _registrationDateFocusNode.unfocus();
                        },
                        onChanged: (value) {
                          setState(() {
                            isRegistrationDate = value.isNotEmpty;
                          });
                        },
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
                      title: 'Tournament dates *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    InkWell(
                      onTap: () {
                        pickDate('tournament');
                        handleTap('tourDate');
                      },
                      child: CustomTextField(
                        hint: "DD/MM/YY",
                        enabled: false,
                        textEditingController:
                            eventController.tournamentDateController,
                        hasText: isTournamentDate,
                        focusNode: _tournamentDateFocusNode,
                        onSubmited: (_) {
                          _tournamentDateFocusNode.unfocus();
                        },
                        onChanged: (value) {
                          setState(() {
                            isTournamentDate = value.isNotEmpty;
                          });
                        },
                        suffixIcon: Icon(
                          CupertinoIcons.calendar,
                          color: isTournamentDate == true
                              ? AppColor().primaryBackGroundColor
                              : AppColor().lightItemsColor,
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Prize pool *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "NGN 0.00",
                      textEditingController:
                          eventController.prizePoolController,
                      hasText: isPrizePool,
                      focusNode: _prizePoolFocusNode,
                      onTap: () {
                        handleTap('prizePool');
                      },
                      onSubmited: (_) {
                        _prizePoolFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isPrizePool = value.isNotEmpty;
                        });
                      },
                      validate: Validator.isNumber,
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
                      title: 'Prize pool distribution *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.02),
                    Divider(
                      thickness: 0.4,
                      height: Get.height * 0.02,
                      color: AppColor().lightItemsColor,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'First',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "NGN 0.00",
                      textEditingController:
                          eventController.firstPrizeController,
                      hasText: isFirstPrize,
                      focusNode: _firstPrizeFocusNode,
                      onTap: () => handleTap('first'),
                      onSubmited: (_) {
                        _firstPrizeFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isFirstPrize = value.isNotEmpty;
                        });
                      },
                      validate: Validator.isNumber,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Second',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "NGN 0.00",
                      textEditingController:
                          eventController.secondPrizeController,
                      hasText: isSecondPrize,
                      focusNode: _secondPrizeFocusNode,
                      onTap: () => handleTap('second'),
                      onSubmited: (_) {
                        _secondPrizeFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isSecondPrize = value.isNotEmpty;
                        });
                      },
                      validate: Validator.isNumber,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Third',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "NGN 0.00",
                      textEditingController:
                          eventController.thirdPrizeController,
                      hasText: isThirdPrize,
                      focusNode: _thirdPrizeFocusNode,
                      onTap: () {
                        handleTap('third');
                      },
                      onSubmited: (_) {
                        _thirdPrizeFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isThirdPrize = value.isNotEmpty;
                        });
                      },
                      validate: Validator.isNumber,
                    ),
                    Gap(Get.height * 0.02),
                    Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor().primaryColor),
                            child: Icon(Icons.add,
                                size: 15,
                                color: AppColor().primaryBackGroundColor)),
                        Gap(Get.height * 0.01),
                        CustomText(
                          title: 'Add Others',
                          size: 14,
                          fontFamily: 'GilroyMeduim',
                          textAlign: TextAlign.start,
                          color: AppColor().primaryColor,
                        ),
                      ],
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Max number of participants *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.02),
                    Container(
                      height: Get.height * 0.065,
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isParticipant == true
                            ? AppColor().primaryWhite
                            : AppColor().bgDark,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            title: participantCount.toString(),
                            color: isParticipant == true
                                ? AppColor().primaryBackGroundColor
                                : AppColor().lightItemsColor,
                            fontFamily: 'GilroyBold',
                            weight: FontWeight.w400,
                            size: 13,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (participantCount >= 0) {
                                      participantCount++;
                                      eventController.participantController
                                          .text = participantCount.toString();
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.arrow_drop_up,
                                  color: isParticipant == true
                                      ? AppColor().primaryBackGroundColor
                                      : AppColor().lightItemsColor,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (participantCount >= 2) {
                                      --participantCount;
                                      eventController.participantController
                                          .text = participantCount.toString();
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: isParticipant == true
                                      ? AppColor().primaryBackGroundColor
                                      : AppColor().lightItemsColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title:
                          'Enable leaderboard *\n(Automatically enabled for ranked tournaments) ',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.left,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.02),
                    Row(
                      children: [
                        CustomText(
                          title: 'Yes',
                          color: AppColor().primaryWhite,
                          textAlign: TextAlign.left,
                          fontFamily: 'GilroyMedium',
                          size: Get.height * 0.017,
                          weight: FontWeight.w600,
                        ),
                        Gap(Get.height * 0.01),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (enableLeaderboard == false) {
                                enableLeaderboard = true;
                                dontEnableLeaderboard = false;
                                eventController.enableLeaderboardController
                                    .text = enableLeaderboard.toString();
                              } else {
                                enableLeaderboard = false;
                                dontEnableLeaderboard = true;
                                eventController.enableLeaderboardController
                                    .text = enableLeaderboard.toString();
                              }
                            });
                          },
                          child: Icon(
                              enableLeaderboard
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: enableLeaderboard
                                  ? AppColor().primaryColor
                                  : AppColor().primaryWhite),
                        ),
                        Gap(Get.height * 0.02),
                        CustomText(
                          title: 'No',
                          color: AppColor().primaryWhite,
                          textAlign: TextAlign.left,
                          fontFamily: 'GilroyMedium',
                          size: Get.height * 0.017,
                          weight: FontWeight.w600,
                        ),
                        Gap(Get.height * 0.01),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (dontEnableLeaderboard == false) {
                                dontEnableLeaderboard = true;
                                enableLeaderboard = false;
                                eventController.enableLeaderboardController
                                    .text = dontEnableLeaderboard.toString();
                              } else {
                                enableLeaderboard = true;
                                dontEnableLeaderboard = false;
                                eventController.enableLeaderboardController
                                    .text = dontEnableLeaderboard.toString();
                              }
                            });
                          },
                          child: Icon(
                              dontEnableLeaderboard
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: dontEnableLeaderboard
                                  ? AppColor().primaryColor
                                  : AppColor().primaryWhite),
                        ),
                      ],
                    )
                  ],
                ),
              ] else
                ...[],
              Gap(pageCount == 0 ? Get.height * 0.5 : Get.height * 0.02),
              CustomFillButton(
                onTap: () {
                  if (pageCount == 0) {
                    setState(() {
                      pageCount++;
                      debugPrint('PageCount: $pageCount');
                    });
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
