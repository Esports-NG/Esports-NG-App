import 'dart:io';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TournamentRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  final eventController = Get.put(EventRepository());

  late final communitiesOwnedController = TextEditingController();
  late final tournamentNameController = TextEditingController();
  late final eventNameController = TextEditingController();
  late final eventVenueController = TextEditingController();
  late final eventDescController = TextEditingController();
  late final tournamentLinkController = TextEditingController();
  late final tournamentSummaryController = TextEditingController();
  late final tournamentRequirementsController = TextEditingController();
  late final tournamentRegulationsController = TextEditingController();
  late final tournamentStructureController = TextEditingController();
  late final eventLinkController = TextEditingController();
  late final regDateController = TextEditingController();
  late final startDateController = TextEditingController();
  late final endDateController = TextEditingController();
  // late final tournamentDateController = TextEditingController();
  late final prizePoolController = TextEditingController();
  late final entryFeeController = TextEditingController();
  late final firstPrizeController = TextEditingController();
  late final secondPrizeController = TextEditingController();
  late final thirdPrizeController = TextEditingController();
  late final participantController = TextEditingController();
  late final enableLeaderboardController = TextEditingController();
  late final rankTypeController = TextEditingController();
  late final gamePlayedController = TextEditingController();
  late final gameCoveredController = TextEditingController();
  late final gameModeController = TextEditingController();
  late final knockoutTypeController = TextEditingController();
  late final tournamentTypeController = TextEditingController();
  late final partnersController = TextEditingController();
  late final staffController = TextEditingController();

  Rx<String?> communitiesValue = Rx(null);
  Rx<String?> gameValue = Rx(null);
  Rx<String?> gameModeValue = Rx(null);
  Rx<String?> knockoutValue = Rx(null);
  Rx<String?> rankTypeValue = Rx(null);
  Rx<String?> tournamentTypeValue = Rx(null);
  Rx<String?> participantValue = Rx(null);
  Rx<String?> partnerValue = Rx(null);
  Rx<String?> staffValue = Rx(null);

  Rx<CommunityModel?> selectedCommunity = Rx(null);
  Rx<int> pageCount = 0.obs, eventTypeCount = 0.obs, participantCount = 1.obs;

  Rx<DateTime?> date = Rx(null);

  var isTournamentLink = false.obs;
  var isTournamentStructure = false.obs;
  var isTournamentRegulations = false.obs;
  var isTournamentSummary = false.obs;
  var isTournamentRequirements = false.obs;
  var isGame = false.obs;
  var isTournamentName = false.obs;
  var isGameMode = false.obs;
  var isTournamentType = false.obs;
  var isKnockout = false.obs;
  var isCommunities = false.obs;
  var isRankType = false.obs;
  var isRegistrationDate = false.obs;
  var isStartDate = false.obs;
  var isEndDate = false.obs;
  var isPrizePool = false.obs;
  var isEntryFee = false.obs;
  var enableLeaderboard = false.obs;
  var dontEnableLeaderboard = false.obs;
  var isParticipant = false.obs;
  var isFirstPrize = false.obs;
  var isSecondPrize = false.obs;
  var isThirdPrize = false.obs;
  var isPartner = false.obs;
  var isStaff = false.obs;

  void handleTap(String? title) {
    if (title == 'tournamentLink') {
      isTournamentLink.value = true;
    } else if (title == 'game') {
      isGame.value = true;
    } else if (title == 'tournamentName') {
      isTournamentName.value = true;
    } else if (title == 'gameMode') {
      isGameMode.value = true;
    } else if (title == 'tournamentType') {
      isTournamentType.value = true;
    } else if (title == 'knockout') {
      isKnockout.value = true;
    } else if (title == 'communities') {
      isCommunities.value = true;
    } else if (title == 'rankType') {
      isRankType.value = true;
    } else if (title == 'regDate') {
      isRegistrationDate.value = true;
    } else if (title == 'endDate') {
      isEndDate.value = true;
    } else if (title == 'startDate') {
      isStartDate.value = true;
    } else if (title == 'prizePool') {
      isPrizePool.value = true;
    } else if (title == 'entryFee') {
      isEntryFee.value = true;
    } else if (title == 'participant') {
      isParticipant.value = true;
    } else if (title == 'first') {
      isFirstPrize.value = true;
    } else if (title == 'second') {
      isSecondPrize.value = true;
    } else if (title == 'third') {
      isThirdPrize.value = true;
    } else if (title == 'partner') {
      isPartner.value = true;
    } else if (title == 'staff') {
      isStaff.value = true;
    } else {
      isRegistrationDate.value = true;
    }
  }

  Rx<File?> mEventProfileImage = Rx(null);
  Rx<File?> mEventCoverImage = Rx(null);
  File? get eventProfileImage => mEventProfileImage.value;
  File? get eventCoverImage => mEventCoverImage.value;

  Future pickImageFromGallery(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);

      if (title == 'image') {
        mEventProfileImage(imageTemporary);
      } else {
        mEventCoverImage(imageTemporary);
      }
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
        mEventProfileImage(imageTemporary);
      } else {
        mEventCoverImage(imageTemporary);
      }
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  Widget pickProfileImage({VoidCallback? onTap}) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(Get.height * 0.04),
        decoration: BoxDecoration(
            color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              eventProfileImage == null
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
                            image: FileImage(eventProfileImage!),
                            fit: BoxFit.cover),
                      ),
                    ),
              Gap(Get.height * 0.01),
              InkWell(
                onTap: onTap,
                child: CustomText(
                  title:
                      eventProfileImage == null ? 'Click to upload' : 'Cancel',
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
            eventCoverImage == null
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
                          image: FileImage(eventCoverImage!),
                          fit: BoxFit.cover),
                    ),
                  ),
            Gap(Get.height * 0.01),
            InkWell(
              onTap: onTap,
              child: CustomText(
                title: eventCoverImage == null ? 'Click to upload' : 'Cancel',
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

  Future createTournament() async {
    try {
      eventController.createEventStatus(CreateEventStatus.loading);
      var headers = {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      };
      var request =
          http.MultipartRequest("POST", Uri.parse(ApiLink.createTournament))
            ..fields["name"] = tournamentNameController.text
            ..fields["link_for_bracket"] = tournamentLinkController.text
            ..fields["game_mode"] = gameModeController.text
            ..fields["knockout_type"] = knockoutTypeController.text
            ..fields["rank_type"] = rankTypeController.text
            ..fields["reg_start"] = regDateController.text
            ..fields["start_date"] = startDateController.text
            ..fields["end_date"] = endDateController.text
            ..fields["prize_pool"] = prizePoolController.text
            ..fields["summary"] = tournamentSummaryController.text
            ..fields["entry_fee"] = entryFeeController.text
            ..fields["requirements"] = tournamentRequirementsController.text
            ..fields["structure"] = tournamentStructureController.text
            ..fields["first"] = firstPrizeController.text
            ..fields["second"] = secondPrizeController.text
            ..fields["third"] = thirdPrizeController.text
            ..fields["rules_regs"] = tournamentRegulationsController.text;

      request.files.add(await http.MultipartFile.fromPath(
          'profile', eventProfileImage!.path));
      request.files.add(
          await http.MultipartFile.fromPath('banner', eventCoverImage!.path));

      // request.fields.addAll(
      //     event.toCreateEventJson().map((key, value) => MapEntry(key, value)));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var res = await http.Response.fromStream(response);
      print(res.body);
      if (response.statusCode == 201) {
        eventController.createEventStatus(CreateEventStatus.success);
        debugPrint(await response.stream.bytesToString());
        Get.to(() => const CreateSuccessPage(title: 'Event Created'))!
            .then((value) {
          eventController.getAllTournaments(false);
          clear();
        });
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        eventController.createEventStatus(CreateEventStatus.error);
      } else {
        eventController.createEventStatus(CreateEventStatus.error);
        debugPrint(response.reasonPhrase);
        handleError(response.reasonPhrase);
      }
    } catch (error) {
      eventController.createEventStatus(CreateEventStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      handleError(error);
    }
  }

  void handleError(dynamic error) {
    debugPrint("error $error");
    Fluttertoast.showToast(
        fontSize: Get.height * 0.015,
        msg: (error.toString().contains("esports-ng.vercel.app") ||
                error.toString().contains("Network is unreachable"))
            ? 'Event like: No internet connection!'
            : (error.toString().contains("FormatException"))
                ? 'Event like: Internal server error, contact admin!'
                : error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  void clearProfilePhoto() {
    debugPrint('image cleared');
    mEventProfileImage.value = null;
  }

  void clearCoverPhoto() {
    debugPrint('image cleared');
    mEventCoverImage.value = null;
  }

  void clear() {
    tournamentNameController.clear();
    tournamentLinkController.clear();
    regDateController.clear();
    endDateController.clear();
    startDateController.clear();
    prizePoolController.clear();
    entryFeeController.clear();
    enableLeaderboardController.clear();
    rankTypeController.clear();
    gamePlayedController.clear();
    partnersController.clear();
    staffController.clear();
    eventNameController.clear();
  }
}
