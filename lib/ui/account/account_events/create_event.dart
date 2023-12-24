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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'components/create_social_event.dart';
import 'components/create_tournament.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int? current;
  final authController = Get.put(AuthRepository());
  final eventController = Get.put(EventRepository());
  final communityController = Get.put(CommunityRepository());
  String? communitiesValue,
      gameValue,
      gameModeValue,
      knockoutValue,
      rankTypeValue,
      tournamentTypeValue,
      participantValue,
      partnerValue,
      staffValue;

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
      isThirdPrize = false,
      isPartner = false,
      isStaff = false;

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
    } else if (title == 'partner') {
      setState(() {
        isPartner = true;
      });
    } else if (title == 'staff') {
      setState(() {
        isStaff = true;
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

  Future pickImageFromGallery(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        if (title == 'image') {
          eventController.mEventProfileImage(imageTemporary);
        } else {
          eventController.mEventCoverImage(imageTemporary);
        }
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  Future pickImageFromCamera(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      if (title == 'image') {
        eventController.mEventProfileImage(imageTemporary);
      } else {
        eventController.mEventCoverImage(imageTemporary);
      }
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
              text: '1',
              style: TextStyle(
                color: AppColor().primaryWhite,
                fontWeight: FontWeight.w600,
                fontFamily: 'GilroyBold',
                fontSize: Get.height * 0.017,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: eventTypeCount == 0 ? "/3" : "/2",
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
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
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
                                height: 1.5,
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
                            items:
                                communityController.allCommunity.map((value) {
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
                                eventController.communitiesOwnedController
                                    .text = value.name!;
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
                              '1',
                              '2',
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
                                eventController.gameModeController.text =
                                    value!;
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
                              'Single Player',
                              'Teams',
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
                              'Group Stage',
                              'Knockout Stage',
                              'Group and Knockout Stage',
                              'Battle Royale',
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
                                eventController.rankTypeController.text =
                                    value!;
                                debugPrint(value);
                                handleTap('rankType');
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
                        textEditingController:
                            eventController.entryFeeController,
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
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: 'Tournament group stage settings',
                      weight: FontWeight.w500,
                      size: 14,
                      fontFamily: 'GilroyMedium',
                      textAlign: TextAlign.start,
                      color: AppColor().primaryWhite,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Tournament summary *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "Type text here",
                      textEditingController:
                          eventController.tournamentNameController,
                      // hasText: isTournamentName,
                      // focusNode: _tournamentnameFocusNode,
                      onTap: () => handleTap('tournamentSummary'),
                      maxLines: 4,
                      onSubmited: (_) {
                        // _tournamentnameFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          // isTournamentName = value.isNotEmpty;
                        });
                      },
                      validate: Validator.isName,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Requirements for entry *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "Type text here",
                      textEditingController:
                          eventController.tournamentLinkController,
                      hasText: isTournamentLink,
                      focusNode: _tournamentLinkFocusNode,
                      onTap: () => handleTap('tournamentLink'),
                      maxLines: 4,
                      onSubmited: (_) {
                        _tournamentLinkFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isTournamentLink = value.isNotEmpty;
                        });
                      },
                      validate: Validator.isName,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Tournament structure *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "Type text here",
                      textEditingController:
                          eventController.tournamentLinkController,
                      hasText: isTournamentLink,
                      focusNode: _tournamentLinkFocusNode,
                      onTap: () => handleTap('tournamentLink'),
                      maxLines: 3,
                      onSubmited: (_) {
                        _tournamentLinkFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isTournamentLink = value.isNotEmpty;
                        });
                      },
                      validate: Validator.isName,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Tournament rules & regulations *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      hint: "Type text here",
                      textEditingController:
                          eventController.tournamentLinkController,
                      hasText: isTournamentLink,
                      focusNode: _tournamentLinkFocusNode,
                      onTap: () => handleTap('tournamentLink'),
                      maxLines: 3,
                      onSubmited: (_) {
                        _tournamentLinkFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        setState(() {
                          isTournamentLink = value.isNotEmpty;
                        });
                      },
                      validate: Validator.isName,
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Tournament partners *',
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
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
                          onChanged: (value) {
                            setState(() {
                              partnerValue = value;
                              debugPrint(value);
                              eventController.partnersController.text = value!;
                              handleTap('partner');
                            });
                          },
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
                    CustomText(
                      title: 'Tournament image *',
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
                          middleText: "Upload your tournament profile picture",
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
                                  pickImageFromGallery('image');
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
                                  pickImageFromCamera('image');
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
                      title: 'Tournament banner *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    pickCoverImage(onTap: () {
                      if (eventController.eventCoverImage == null) {
                        debugPrint('pick image');
                        Get.defaultDialog(
                          title: "Select your image",
                          backgroundColor: AppColor().primaryLightColor,
                          titlePadding: const EdgeInsets.only(top: 30),
                          contentPadding: const EdgeInsets.only(
                              top: 5, bottom: 30, left: 25, right: 25),
                          middleText: "Upload your tournament banner",
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
                                  pickImageFromGallery('banner');
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
                                  pickImageFromCamera('banner');
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
                        eventController.clearCoverPhoto();
                      }
                    }),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Add tournament staff *',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'GilroyRegular',
                      size: Get.height * 0.017,
                    ),
                    Gap(Get.height * 0.01),
                    InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isStaff == true
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
                              color: isStaff == true
                                  ? AppColor().primaryBackGroundColor
                                  : AppColor().lightItemsColor),
                          value: staffValue,
                          items: <String>[
                            'EASPORTS',
                            'ESportsNG',
                            'Others',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: CustomText(
                                title: value,
                                color: isStaff == true
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
                              staffValue = value;
                              debugPrint(value);
                              eventController.staffController.text = value!;
                              handleTap('staff');
                            });
                          },
                          hint: CustomText(
                            title: "Staff",
                            color: isStaff == true
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
                  ],
                ),
              ],
              Gap(pageCount == 0 ? Get.height * 0.5 : Get.height * 0.02),
              CustomFillButton(
                onTap: () {
                  if (eventTypeCount == 0) {
                    Get.to(() => const CreateTournamentEvent());
                  } else {
                    Get.to(() => const CreateSocialEvent());
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

  Container pickProfileImage({VoidCallback? onTap}) {
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

  Container pickCoverImage({VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.all(Get.height * 0.04),
      decoration: BoxDecoration(
          color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            eventController.eventCoverImage == null
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
                          image: FileImage(eventController.eventCoverImage!),
                          fit: BoxFit.cover),
                    ),
                  ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: onTap,
              child: CustomText(
                title: eventController.eventCoverImage == null
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
}
