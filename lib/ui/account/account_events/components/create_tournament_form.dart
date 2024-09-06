import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
// import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/ui/widget/game_list_dropdown.dart';
import 'package:e_sport/ui/widget/game_mode_dropdown.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateTournamentForm extends StatefulWidget {
  const CreateTournamentForm({super.key});

  @override
  State<CreateTournamentForm> createState() => _CreateTournamentFormState();
}

class _CreateTournamentFormState extends State<CreateTournamentForm> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final communityController = Get.put(CommunityRepository());
  final tournamentController = Get.put(TournamentRepository());
  final eventController = Get.put(EventRepository());
  final authController = Get.put(AuthRepository());

  Future pickDate(String title) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: tournamentController.date.value ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 40),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    if (title == 'registration') {
      tournamentController.regDateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      tournamentController.date.value = newDate;
      debugPrint('Reg Date: ${tournamentController.regDateController.text}');
    } else if (title == 'registrationEnd') {
      tournamentController.regEndDateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      tournamentController.date.value = newDate;
      debugPrint('Reg Date: ${tournamentController.regEndDateController.text}');
    } else if (title == "startDate") {
      tournamentController.startDateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      tournamentController.date.value = newDate;
      debugPrint(
          'Start Date: ${tournamentController.startDateController.text}');
    } else {
      tournamentController.endDateController.text =
          DateFormat("yyyy-MM-dd").format(newDate).toString();
      tournamentController.date.value = newDate;
      debugPrint('End Date: ${tournamentController.endDateController.text}');
    }
  }

  final FocusNode _tournamentLinkFocusNode = FocusNode();
  final FocusNode _gameFocusNode = FocusNode();
  final FocusNode _tournamentnameFocusNode = FocusNode();
  final FocusNode _gameModeFocusNode = FocusNode();
  final FocusNode _tournamentTypeFocusNode = FocusNode();
  final FocusNode _knockoutFocusNode = FocusNode();
  final FocusNode _communitiesFocusNode = FocusNode();
  final FocusNode _rankTypeFocusNode = FocusNode();
  final FocusNode _registrationDateFocusNode = FocusNode();
  final FocusNode _registrationEndDateFocusNode = FocusNode();
  final FocusNode _tournamentDateFocusNode = FocusNode();
  final FocusNode _prizePoolFocusNode = FocusNode();
  final FocusNode _entryFeeFocusNode = FocusNode();
  final FocusNode _firstPrizeFocusNode = FocusNode();
  final FocusNode _secondPrizeFocusNode = FocusNode();
  final FocusNode _thirdPrizeFocusNode = FocusNode();
  final FocusNode _tournamentHashtagFocusNode = FocusNode();

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
    _tournamentHashtagFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
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
              title: 'Fill the form correctly to create a tournament page',
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
                fillColor: tournamentController.isCommunities.value == true
                    ? AppColor().primaryWhite
                    : AppColor().primaryDark,
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor().lightItemsColor, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CommunityModel>(
                  dropdownColor: AppColor().primaryDark,
                  borderRadius: BorderRadius.circular(10),
                  value: tournamentController.selectedCommunity.value,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: tournamentController.isCommunities.value == true
                        ? AppColor().primaryBackGroundColor
                        : AppColor().lightItemsColor,
                  ),
                  items: communityController.allCommunity
                      .where((e) => e.owner!.id! == authController.user!.id!)
                      .toList()
                      .map((value) {
                    return DropdownMenuItem<CommunityModel>(
                      value: value,
                      child: CustomText(
                        title: value.name,
                        color: tournamentController.isCommunities.value == true
                            ? AppColor().primaryBackGroundColor
                            : AppColor().lightItemsColor,
                        fontFamily: 'GilroyMedium',
                        weight: FontWeight.w400,
                        size: 15,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    tournamentController.selectedCommunity.value = value;
                    tournamentController.communitiesValue.value = value!.name;
                    tournamentController.communitiesOwnedController.text =
                        value.name!;
                    debugPrint(tournamentController.communitiesValue.value);
                    tournamentController.handleTap('commu');
                  },
                  hint: CustomText(
                    title: "Communities Owned",
                    color: tournamentController.isCommunities.value == true
                        ? AppColor().primaryBackGroundColor
                        : AppColor().lightItemsColor,
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.w400,
                    size: 15,
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
                  tournamentController.tournamentNameController,
              hasText: tournamentController.isTournamentName.value,
              focusNode: _tournamentnameFocusNode,
              onTap: () {
                tournamentController.handleTap('tournamentName');
              },
              onSubmited: (_) {
                _tournamentnameFocusNode.unfocus();
              },
              onChanged: (value) {
                tournamentController.isTournamentName.value = value.isNotEmpty;
              },
              validate: Validator.isName,
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Tournament hashtag *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'GilroyRegular',
              size: Get.height * 0.017,
            ),
            Gap(Get.height * 0.01),
            CustomTextField(
              prefixIcon: Icon(
                Icons.tag,
                color: AppColor().primaryWhite,
              ),
              hint: "Hashtag",
              textEditingController:
                  tournamentController.tournamentHashtagController,
              focusNode: _tournamentHashtagFocusNode,
              onSubmited: (_) {
                _tournamentHashtagFocusNode.unfocus();
              },
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
                  tournamentController.tournamentLinkController,
              hasText: tournamentController.isTournamentLink.value,
              focusNode: _tournamentLinkFocusNode,
              onTap: () {
                tournamentController.handleTap('tournamentLink');
              },
              onSubmited: (_) {
                _tournamentLinkFocusNode.unfocus();
              },
              onChanged: (value) {
                tournamentController.isTournamentLink.value = value.isNotEmpty;
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
            GameDropdown(
                enableFill: tournamentController.isGame.value,
                gameValue: tournamentController.gameValue,
                handleTap: () => tournamentController.handleTap('game')),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Game Mode',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'GilroyRegular',
              size: Get.height * 0.017,
            ),
            Gap(Get.height * 0.01),
            GameModeDropDown(
                gameModeController: tournamentController.gameModeController,
                gameValue: tournamentController.gameValue,
                gameModeValue: tournamentController.gameModeValue,
                enableFill: tournamentController.isGameMode.value,
                handleTap: () => tournamentController.handleTap('gameMode')),
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
                fillColor: tournamentController.isTournamentType.value == true
                    ? AppColor().primaryWhite
                    : AppColor().primaryDark,
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor().lightItemsColor, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: AppColor().primaryDark,
                  borderRadius: BorderRadius.circular(10),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: tournamentController.isTournamentType.value == true
                          ? AppColor().primaryBackGroundColor
                          : AppColor().lightItemsColor),
                  value: tournamentController.tournamentTypeValue.value,
                  items: <String>[
                    'Single Player',
                    'Teams',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value == "Single Player" ? "solo" : "team",
                      child: CustomText(
                        title: value,
                        color:
                            tournamentController.isTournamentType.value == true
                                ? AppColor().primaryBackGroundColor
                                : AppColor().lightItemsColor,
                        fontFamily: 'GilroyMedium',
                        weight: FontWeight.w400,
                        size: 15,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    tournamentController.tournamentTypeValue.value = value!;
                    debugPrint(value);
                    tournamentController.tournamentTypeController.text = value;
                    tournamentController.handleTap('tournamentType');
                  },
                  hint: CustomText(
                    title: "Tournament Type",
                    color: AppColor().lightItemsColor,
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.w400,
                    size: 15,
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
                fillColor: tournamentController.isKnockout.value == true
                    ? AppColor().primaryWhite
                    : AppColor().primaryDark,
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor().lightItemsColor, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: AppColor().primaryDark,
                  borderRadius: BorderRadius.circular(10),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: tournamentController.isKnockout.value == true
                          ? AppColor().primaryBackGroundColor
                          : AppColor().lightItemsColor),
                  value: tournamentController.knockoutValue.value,
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
                        color: tournamentController.isKnockout.value == true
                            ? AppColor().primaryBackGroundColor
                            : AppColor().lightItemsColor,
                        fontFamily: 'GilroyMedium',
                        weight: FontWeight.w400,
                        size: 15,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    tournamentController.knockoutValue.value = value;
                    debugPrint(value);
                    tournamentController.knockoutTypeController.text = value!;
                    tournamentController.handleTap('knockout');
                  },
                  hint: CustomText(
                    title: "Knockout Type",
                    color: tournamentController.isKnockout.value == true
                        ? AppColor().primaryBackGroundColor
                        : AppColor().lightItemsColor,
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.w400,
                    size: 15,
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
                fillColor: tournamentController.isRankType.value == true
                    ? AppColor().primaryWhite
                    : AppColor().primaryDark,
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor().lightItemsColor, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: AppColor().primaryDark,
                  borderRadius: BorderRadius.circular(10),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: tournamentController.isRankType.value == true
                          ? AppColor().primaryBackGroundColor
                          : AppColor().lightItemsColor),
                  value: tournamentController.rankTypeValue.value,
                  items: <String>[
                    'Ranked',
                    'Unranked',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: CustomText(
                        title: value,
                        color: tournamentController.isRankType.value == true
                            ? AppColor().primaryBackGroundColor
                            : AppColor().lightItemsColor,
                        fontFamily: 'GilroyMedium',
                        weight: FontWeight.w400,
                        size: 15,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    tournamentController.rankTypeValue.value = value;
                    tournamentController.rankTypeController.text = value!;
                    debugPrint(value);
                    tournamentController.handleTap('rankType');
                  },
                  hint: CustomText(
                    title: "Rank Type",
                    color: tournamentController.isRankType.value == true
                        ? AppColor().primaryBackGroundColor
                        : AppColor().lightItemsColor,
                    fontFamily: 'GilroyMedium',
                    weight: FontWeight.w400,
                    size: 15,
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
                tournamentController.handleTap('regDate');
              },
              child: CustomTextField(
                hint: "DD/MM/YY",
                enabled: false,
                textEditingController: tournamentController.regDateController,
                hasText: tournamentController.isRegistrationDate.value,
                focusNode: _registrationDateFocusNode,
                onSubmited: (_) {
                  _registrationDateFocusNode.unfocus();
                },
                onChanged: (value) {
                  tournamentController.isRegistrationDate.value =
                      value.isNotEmpty;
                },
                suffixIcon: Icon(
                  CupertinoIcons.calendar,
                  color: tournamentController.isRegistrationDate.value == true
                      ? AppColor().primaryBackGroundColor
                      : AppColor().lightItemsColor,
                ),
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Registration end date *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'GilroyRegular',
              size: Get.height * 0.017,
            ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: () {
                pickDate('registrationEnd');
                tournamentController.handleTap('regEndDate');
              },
              child: CustomTextField(
                hint: "DD/MM/YY",
                enabled: false,
                textEditingController:
                    tournamentController.regEndDateController,
                hasText: tournamentController.isRegistrationEndDate.value,
                focusNode: _registrationEndDateFocusNode,
                onSubmited: (_) {
                  _registrationEndDateFocusNode.unfocus();
                },
                onChanged: (value) {
                  tournamentController.isRegistrationDate.value =
                      value.isNotEmpty;
                },
                suffixIcon: Icon(
                  CupertinoIcons.calendar,
                  color:
                      tournamentController.isRegistrationEndDate.value == true
                          ? AppColor().primaryBackGroundColor
                          : AppColor().lightItemsColor,
                ),
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Tournament Start date *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'GilroyRegular',
              size: Get.height * 0.017,
            ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: () {
                pickDate('startDate');
                tournamentController.handleTap('startDate');
              },
              child: CustomTextField(
                hint: "DD/MM/YY",
                enabled: false,
                textEditingController: tournamentController.startDateController,
                hasText: tournamentController.isStartDate.value,
                focusNode: _tournamentDateFocusNode,
                onSubmited: (_) {
                  _tournamentDateFocusNode.unfocus();
                },
                onChanged: (value) {
                  tournamentController.isStartDate.value = value.isNotEmpty;
                },
                suffixIcon: Icon(
                  CupertinoIcons.calendar,
                  color: tournamentController.isStartDate.value == true
                      ? AppColor().primaryBackGroundColor
                      : AppColor().lightItemsColor,
                ),
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Tournament End date *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'GilroyRegular',
              size: Get.height * 0.017,
            ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: () {
                pickDate('endDate');
                tournamentController.handleTap('endDate');
              },
              child: CustomTextField(
                hint: "DD/MM/YY",
                enabled: false,
                textEditingController: tournamentController.endDateController,
                hasText: tournamentController.isEndDate.value,
                focusNode: _tournamentDateFocusNode,
                onSubmited: (_) {
                  _tournamentDateFocusNode.unfocus();
                },
                onChanged: (value) {
                  tournamentController.isEndDate.value = value.isNotEmpty;
                },
                suffixIcon: Icon(
                  CupertinoIcons.calendar,
                  color: tournamentController.isEndDate.value == true
                      ? AppColor().primaryBackGroundColor
                      : AppColor().lightItemsColor,
                ),
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Currency *',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'GilroyRegular',
              size: Get.height * 0.017,
            ),
            Gap(Get.height * 0.01),
            Theme(
              data: ThemeData.dark(),
              child: DropdownSearch<MapEntry<String, String>>(
                onChanged: (value) {
                  eventController.currency.value = value!.value;
                },
                items: eventController.currencies.entries.toList(),
                itemAsString: (item) => item.key,
                popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                      hintText: "Select a currency",
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: AppColor().greyFour,
                      ),
                      hintStyle: TextStyle(
                          color: AppColor().greyFour,
                          fontFamily: "GilroyMedium"),
                      filled: true,
                      fillColor: AppColor().primaryWhite.withOpacity(0.05),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().lightItemsColor, width: 1),
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
                dropdownButtonProps: DropdownButtonProps(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    color: AppColor().greyFour),
                dropdownDecoratorProps: DropDownDecoratorProps(
                    baseStyle: TextStyle(
                        color: AppColor().primaryWhite,
                        fontFamily: "GilroyMedium"),
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Select a currency",
                      hintStyle: TextStyle(
                          color: AppColor().greyFour,
                          fontFamily: "GilroyMedium"),
                      filled: true,
                      fillColor: AppColor().primaryDark,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().lightItemsColor, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    )),
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
              keyType: TextInputType.number,
              textEditingController: tournamentController.prizePoolController,
              hasText: tournamentController.isPrizePool.value,
              focusNode: _prizePoolFocusNode,
              onTap: () {
                tournamentController.handleTap('prizePool');
              },
              onSubmited: (_) {
                _prizePoolFocusNode.unfocus();
              },
              onChanged: (value) {
                tournamentController.isPrizePool.value = value.isNotEmpty;
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
              keyType: TextInputType.number,
              textEditingController: tournamentController.entryFeeController,
              hasText: tournamentController.isEntryFee.value,
              focusNode: _entryFeeFocusNode,
              onTap: () => tournamentController.handleTap('entryFee'),
              onSubmited: (_) {
                _entryFeeFocusNode.unfocus();
              },
              onChanged: (value) {
                tournamentController.isEntryFee.value = value.isNotEmpty;
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
              keyType: TextInputType.number,
              textEditingController: tournamentController.firstPrizeController,
              hasText: tournamentController.isFirstPrize.value,
              focusNode: _firstPrizeFocusNode,
              onTap: () => tournamentController.handleTap('first'),
              onSubmited: (_) {
                _firstPrizeFocusNode.unfocus();
              },
              onChanged: (value) {
                tournamentController.isFirstPrize.value = value.isNotEmpty;
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
              keyType: TextInputType.number,
              textEditingController: tournamentController.secondPrizeController,
              hasText: tournamentController.isSecondPrize.value,
              focusNode: _secondPrizeFocusNode,
              onTap: () => tournamentController.handleTap('second'),
              onSubmited: (_) {
                _secondPrizeFocusNode.unfocus();
              },
              onChanged: (value) {
                tournamentController.isSecondPrize.value = value.isNotEmpty;
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
              keyType: TextInputType.number,
              textEditingController: tournamentController.thirdPrizeController,
              hasText: tournamentController.isThirdPrize.value,
              focusNode: _thirdPrizeFocusNode,
              onTap: () {
                tournamentController.handleTap('third');
              },
              onSubmited: (_) {
                _thirdPrizeFocusNode.unfocus();
              },
              onChanged: (value) {
                tournamentController.isThirdPrize.value = value.isNotEmpty;
              },
              validate: Validator.isNumber,
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: tournamentController.isParticipant.value == true
                    ? AppColor().primaryWhite
                    : AppColor().primaryDark,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomTextField(
                      keyType: TextInputType.number,
                      initialValue: tournamentController.participantCount.value
                          .toString(),
                      onSubmited: (_) {
                        _thirdPrizeFocusNode.unfocus();
                      },
                      onChanged: (value) {
                        tournamentController.participantCount.value =
                            int.parse(value);
                      },
                      validate: Validator.isNumber,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (tournamentController.participantCount.value >=
                                0) {
                              tournamentController.participantCount.value++;
                              tournamentController.participantController.text =
                                  tournamentController.participantCount.value
                                      .toString();
                            }
                          },
                          child: Icon(
                            Icons.arrow_drop_up,
                            color:
                                tournamentController.isParticipant.value == true
                                    ? AppColor().primaryBackGroundColor
                                    : AppColor().lightItemsColor,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (tournamentController.participantCount.value >=
                                2) {
                              --tournamentController.participantCount.value;
                              tournamentController.participantController.text =
                                  tournamentController.participantCount.value
                                      .toString();
                            }
                          },
                          child: Icon(
                            Icons.arrow_drop_down,
                            color:
                                tournamentController.isParticipant.value == true
                                    ? AppColor().primaryBackGroundColor
                                    : AppColor().lightItemsColor,
                          ),
                        ),
                      ],
                    ),
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
                    if (tournamentController.enableLeaderboard.value == false) {
                      tournamentController.enableLeaderboard.value = true;
                      tournamentController.dontEnableLeaderboard.value = false;
                      tournamentController.enableLeaderboardController.text =
                          tournamentController.enableLeaderboard.value
                              .toString();
                    } else {
                      tournamentController.enableLeaderboard.value = false;
                      tournamentController.dontEnableLeaderboard.value = true;
                      tournamentController.enableLeaderboardController.text =
                          tournamentController.enableLeaderboard.value
                              .toString();
                    }
                  },
                  child: Icon(
                      tournamentController.enableLeaderboard.value
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: tournamentController.enableLeaderboard.value
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
                    if (tournamentController.dontEnableLeaderboard.value ==
                        false) {
                      tournamentController.dontEnableLeaderboard.value = true;
                      tournamentController.enableLeaderboard.value = false;
                      tournamentController.enableLeaderboardController.text =
                          tournamentController.dontEnableLeaderboard.value
                              .toString();
                    } else {
                      tournamentController.enableLeaderboard.value = true;
                      tournamentController.dontEnableLeaderboard.value = false;
                      tournamentController.enableLeaderboardController.text =
                          tournamentController.dontEnableLeaderboard.value
                              .toString();
                    }
                  },
                  child: Icon(
                      tournamentController.dontEnableLeaderboard.value
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: tournamentController.dontEnableLeaderboard.value
                          ? AppColor().primaryColor
                          : AppColor().primaryWhite),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
