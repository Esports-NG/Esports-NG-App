import 'dart:io';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/games_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/ui/widget/page_indicator.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateTournamentEvent extends StatefulWidget {
  const CreateTournamentEvent({super.key});

  @override
  State<CreateTournamentEvent> createState() => _CreateTournamentEventState();
}

class _CreateTournamentEventState extends State<CreateTournamentEvent> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final GlobalKey<FormState> form2Key = GlobalKey<FormState>();
  final authController = Get.put(AuthRepository());
  final eventController = Get.put(EventRepository());
  final communityController = Get.put(CommunityRepository());
  CommunityModel? selectedItem;
  GamesModel? selectedGame;
  GameMode? selectedGameMode;
  List<GameMode>? selectedGameModeList = [];
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
      isTournamentEndDate = false,
      isPrizePool = false,
      isEntryFee = false,
      enableLeaderboard = false,
      isParticipant = false,
      isFirstPrize = false,
      isSecondPrize = false,
      isThirdPrize = false,
      isPartner = false,
      isStaff = false,
      isSummary = false,
      isRequirement = false,
      isStructure = false,
      isRules = false;

  int pageCount = 1, participantCount = 1;

  final FocusNode _tournamentLinkFocusNode = FocusNode();
  final FocusNode _gameFocusNode = FocusNode();
  final FocusNode _tournamentNameFocusNode = FocusNode();
  final FocusNode _gameModeFocusNode = FocusNode();
  final FocusNode _tournamentTypeFocusNode = FocusNode();
  final FocusNode _knockoutFocusNode = FocusNode();
  final FocusNode _communitiesFocusNode = FocusNode();
  final FocusNode _rankTypeFocusNode = FocusNode();
  final FocusNode _registrationDateFocusNode = FocusNode();
  final FocusNode _tournamentDateFocusNode = FocusNode();
  final FocusNode _tournamentEndDateFocusNode = FocusNode();
  final FocusNode _prizePoolFocusNode = FocusNode();
  final FocusNode _entryFeeFocusNode = FocusNode();
  final FocusNode _firstPrizeFocusNode = FocusNode();
  final FocusNode _secondPrizeFocusNode = FocusNode();
  final FocusNode _thirdPrizeFocusNode = FocusNode();
  final FocusNode _summaryFocusNode = FocusNode();
  final FocusNode _requirementFocusNode = FocusNode();
  final FocusNode _structureFocusNode = FocusNode();
  final FocusNode _rulesFocusNode = FocusNode();

  @override
  void dispose() {
    _tournamentLinkFocusNode.dispose();
    _gameFocusNode.dispose();
    _tournamentNameFocusNode.dispose();
    _gameModeFocusNode.dispose();
    _tournamentTypeFocusNode.dispose();
    _knockoutFocusNode.dispose();
    _communitiesFocusNode.dispose();
    _rankTypeFocusNode.dispose();
    _registrationDateFocusNode.dispose();
    _tournamentDateFocusNode.dispose();
    _tournamentEndDateFocusNode.dispose();
    _prizePoolFocusNode.dispose();
    _entryFeeFocusNode.dispose();
    _firstPrizeFocusNode.dispose();
    _secondPrizeFocusNode.dispose();
    _thirdPrizeFocusNode.dispose();
    _summaryFocusNode.dispose();
    _requirementFocusNode.dispose();
    _structureFocusNode.dispose();
    _rulesFocusNode.dispose();
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
    } else if (title == 'tourEndDate') {
      setState(() {
        isTournamentEndDate = true;
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
    } else if (title == 'summary') {
      setState(() {
        isSummary = true;
      });
    } else if (title == 'requirement') {
      setState(() {
        isRequirement = true;
      });
    } else if (title == 'structure') {
      setState(() {
        isStructure = true;
      });
    } else if (title == 'rules') {
      setState(() {
        isRules = true;
      });
    } else {
      setState(() {
        isRegistrationDate = true;
      });
    }
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
      } else if (title == 'start date') {
        eventController.tournamentDateController.text =
            DateFormat("yyyy-MM-dd").format(newDate).toString();
        eventController.date = newDate;
        debugPrint(
            'Tournament Date: ${eventController.tournamentDateController.text}');
      } else if (title == 'end date') {
        eventController.tournamentEndDateController.text =
            DateFormat("yyyy-MM-dd").format(newDate).toString();
        eventController.date = newDate;
        debugPrint(
            'Tournament End Date: ${eventController.tournamentEndDateController.text}');
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

  pickCoverImage({VoidCallback? onTap}) {
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

  DropdownMenuItem<String> buildDropDownItem(String item) => DropdownMenuItem(
      value: item,
      child: CustomText(
          title: item,
          fontFamily: 'GilroyBold',
          weight: FontWeight.w400,
          size: 13));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        elevation: 0,
        leading: GoBackButton(
          onPressed: () {
            if (pageCount > 1) {
              setState(() {
                --pageCount;
                debugPrint('PageCount: $pageCount');
              });
            } else {
              setState(() {
                eventController.clear();
                eventController.clearCoverPhoto();
                eventController.clearProfilePhoto();
              });
              Get.back();
            }
          },
        ),
        centerTitle: true,
        title: CustomText(
          title: 'Create a tournament',
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PageIndicator(
                  pageCount,
                  0,
                  0.5,
                  Get.width / 3,
                  AppColor().primaryColor,
                ),
                PageIndicator(
                  pageCount,
                  1,
                  0.5,
                  Get.width / 3,
                  AppColor().primaryColor,
                ),
                PageIndicator(
                  pageCount,
                  2,
                  0.5,
                  Get.width / 3,
                  AppColor().primaryColor,
                ),
              ],
            ),
            Gap(Get.height * 0.03),
            Padding(
              padding: EdgeInsets.all(Get.height * 0.02),
              child: Column(
                children: [
                  if (pageCount == 1) ...[
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
                            title: 'Organizing community *',
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
                              child: DropdownButton<CommunityModel>(
                                value: selectedItem,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: isCommunities == true
                                      ? AppColor().primaryBackGroundColor
                                      : AppColor().lightItemsColor,
                                ),
                                items: communityController.allCommunity
                                    .map((value) {
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
                                  title:
                                      communitiesValue ?? "Communities Owned",
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
                            focusNode: _tournamentNameFocusNode,
                            onTap: () {
                              handleTap('tournamentName');
                            },
                            onSubmited: (_) {
                              _tournamentNameFocusNode.unfocus();
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
                              child: DropdownButton<GamesModel>(
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: isGame == true
                                        ? AppColor().primaryBackGroundColor
                                        : AppColor().lightItemsColor),
                                value: selectedGame,
                                items: authController.allGames.map((value) {
                                  return DropdownMenuItem<GamesModel>(
                                    value: value,
                                    child: CustomText(
                                      title: value.name,
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
                                    gameValue = value!.name;
                                    debugPrint(gameValue);
                                    selectedGameModeList = value.gameModes;
                                    eventController.gamePlayedController.text =
                                        value.id.toString();
                                    handleTap('game');
                                  });
                                },
                                hint: CustomText(
                                  title: gameValue ?? "Game",
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
                              child: DropdownButton<GameMode>(
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: isGameMode == true
                                        ? AppColor().primaryBackGroundColor
                                        : AppColor().lightItemsColor),
                                value: selectedGameMode,
                                items: selectedGameModeList!.map((value) {
                                  return DropdownMenuItem<GameMode>(
                                    value: value,
                                    child: CustomText(
                                      title: value.name,
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
                                    gameModeValue = value!.name;
                                    eventController.gameModeController.text =
                                        value.name!;
                                    handleTap('gameMode');
                                  });
                                },
                                hint: CustomText(
                                  title: gameModeValue ?? "Game Mode",
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
                                    eventController
                                        .tournamentTypeController.text = value;
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
                                    eventController
                                        .knockoutTypeController.text = value!;
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
                            title: 'Registration start date *',
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
                            title: 'Tournament start date *',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.017,
                          ),
                          Gap(Get.height * 0.01),
                          InkWell(
                            onTap: () {
                              pickDate('start date');
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
                            title: 'Tournament end date *',
                            color: AppColor().primaryWhite,
                            textAlign: TextAlign.center,
                            fontFamily: 'GilroyRegular',
                            size: Get.height * 0.017,
                          ),
                          Gap(Get.height * 0.01),
                          InkWell(
                            onTap: () {
                              pickDate('end date');
                              handleTap('tourEndDate');
                            },
                            child: CustomTextField(
                              hint: "DD/MM/YY",
                              enabled: false,
                              textEditingController:
                                  eventController.tournamentEndDateController,
                              hasText: isTournamentEndDate,
                              focusNode: _tournamentEndDateFocusNode,
                              onSubmited: (_) {
                                _tournamentEndDateFocusNode.unfocus();
                              },
                              onChanged: (value) {
                                setState(() {
                                  isTournamentEndDate = value.isNotEmpty;
                                });
                              },
                              suffixIcon: Icon(
                                CupertinoIcons.calendar,
                                color: isTournamentEndDate == true
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
                            keyType: TextInputType.phone,
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
                            keyType: TextInputType.phone,
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
                            keyType: TextInputType.phone,
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
                            keyType: TextInputType.phone,
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
                            keyType: TextInputType.phone,
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
                                      color:
                                          AppColor().primaryBackGroundColor)),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.height * 0.02),
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
                                            eventController
                                                    .participantController
                                                    .text =
                                                participantCount.toString();
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
                                            eventController
                                                    .participantController
                                                    .text =
                                                participantCount.toString();
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
                        ],
                      ),
                    ),
                  ] else ...[
                    Form(
                      key: form2Key,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
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
                                eventController.summaryController,
                            hasText: isSummary,
                            focusNode: _summaryFocusNode,
                            onTap: () => handleTap('summary'),
                            maxLines: 3,
                            onSubmited: (_) {
                              _summaryFocusNode.unfocus();
                            },
                            onChanged: (value) {
                              setState(() {
                                isSummary = value.isNotEmpty;
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
                                eventController.requirementController,
                            hasText: isRequirement,
                            focusNode: _requirementFocusNode,
                            onTap: () => handleTap('requirement'),
                            maxLines: 3,
                            onSubmited: (_) {
                              _requirementFocusNode.unfocus();
                            },
                            onChanged: (value) {
                              setState(() {
                                isRequirement = value.isNotEmpty;
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
                                eventController.structureController,
                            hasText: isStructure,
                            focusNode: _structureFocusNode,
                            onTap: () => handleTap('structure'),
                            maxLines: 3,
                            onSubmited: (_) {
                              _structureFocusNode.unfocus();
                            },
                            onChanged: (value) {
                              setState(() {
                                isStructure = value.isNotEmpty;
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
                                eventController.rulesAndRegulationController,
                            hasText: isRules,
                            focusNode: _rulesFocusNode,
                            onTap: () => handleTap('rules'),
                            maxLines: 3,
                            onSubmited: (_) {
                              _rulesFocusNode.unfocus();
                            },
                            onChanged: (value) {
                              setState(() {
                                isRules = value.isNotEmpty;
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
                                    eventController.partnersController.text =
                                        value!;
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
                                middleText:
                                    "Upload your tournament profile picture",
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
                              setState(() {
                                eventController.clearProfilePhoto();
                              });
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
                              setState(() {
                                eventController.clearCoverPhoto();
                              });
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
                                    eventController.staffController.text =
                                        value!;
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
                    ),
                  ],
                  Gap(Get.height * 0.02),
                  Obx(() {
                    return InkWell(
                      onTap: () {
                        EventModel event = EventModel(
                          name: eventController.tournamentNameController.text
                              .trim(),
                          linkForBracket: eventController
                              .tournamentLinkController.text
                              .trim(),
                          gameMode:
                              eventController.gameModeController.text.trim(),
                          knockoutType: eventController
                              .knockoutTypeController.text
                              .trim(),
                          rankType:
                              eventController.rankTypeController.text.trim(),
                          iRegStart:
                              eventController.regDateController.text.trim(),
                          iStartDate: eventController
                              .tournamentDateController.text
                              .trim(),
                          iEndDate: eventController
                              .tournamentEndDateController.text
                              .trim(),
                          prizePool:
                              eventController.prizePoolController.text.trim(),
                          entryFee:
                              eventController.entryFeeController.text.trim(),
                          iMaxNo:
                              eventController.participantController.text.trim(),
                          prizePoolDistribution: PrizePoolDistribution(
                            first: eventController.firstPrizeController.text
                                .trim(),
                            second: eventController.secondPrizeController.text
                                .trim(),
                            third: eventController.thirdPrizeController.text
                                .trim(),
                          ),
                          description: 'no description',
                          summary:
                              eventController.summaryController.text.trim(),
                          structure:
                              eventController.structureController.text.trim(),
                          requirements:
                              eventController.requirementController.text.trim(),
                          rulesRegs: eventController
                              .rulesAndRegulationController.text
                              .trim(),
                        );

                        if (pageCount == 1) {
                          setState(() {
                            pageCount++;
                            debugPrint('PageCount: $pageCount');
                          });
                        } else {
                          if (eventController.eventProfileImage == null) {
                            eventController
                                .handleError('Select tournament image!');
                          } else if (eventController.eventCoverImage == null) {
                            eventController
                                .handleError('Select tournament banner!');
                          } else if (eventController.createEventStatus !=
                              CreateEventStatus.loading) {
                            eventController.createEvent(event, 'tournament');
                          }
                        }
                      },
                      child: Container(
                        height: Get.height * 0.065,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColor().primaryColor,
                        ),
                        child: (eventController.createEventStatus ==
                                CreateEventStatus.loading)
                            ? const LoadingWidget()
                            : Center(
                                child: CustomText(
                                title: pageCount == 1 ? 'Next' : 'Create Event',
                                color: AppColor().primaryWhite,
                                weight: FontWeight.w600,
                                size: Get.height * 0.018,
                              )),
                      ),
                    );
                  }),
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
