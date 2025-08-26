import 'dart:convert';
import 'dart:io';

import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/fixture_model.dart';
import 'package:e_sport/data/model/platform_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/roaster_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/model/waitlist_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/di/dependency_injection.dart';
import 'package:e_sport/ui/widgets/utils/create_success_page.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:dio/dio.dart';

class TournamentRepository extends GetxController {
  late Dio dio;

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    try {
      // Try to get the shared Dio instance from ApiService
      dio = Get.find<ApiService>().dio;
    } catch (e) {
      // Fallback to creating a new Dio instance if ApiService is not available
      debugPrint('Error getting Dio from ApiService: $e');
      dio = Dio();
    }
  }

  final authController = Get.put(AuthRepository());
  final eventController = Get.put(EventRepository());

  // Headers setup method to avoid repetition
  Map<String, String> _getAuthHeaders() => {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      };

  // Response handler to streamline error handling and data extraction
  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = response.data;

      // Handle the new API response format
      if (responseData is Map && responseData.containsKey('success')) {
        if (responseData['success'] == true) {
          return responseData['data'];
        } else {
          throw responseData['message'] ?? 'Unknown error occurred';
        }
      }

      return responseData;
    } else {
      throw 'Error: ${response.statusCode} - ${response.statusMessage}';
    }
  }

  // Error handler
  void _handleError(dynamic error) {
    debugPrint("Error: $error");
    String errorMessage = 'An unknown error occurred';

    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Connection timed out';
      } else if (error.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection!';
      } else if (error.response != null) {
        // Try to extract error message from response
        try {
          final responseData = error.response?.data;
          if (responseData is Map && responseData.containsKey('message')) {
            errorMessage = responseData['message'];
          } else if (responseData is String) {
            errorMessage = responseData;
          } else {
            errorMessage = 'Server error: ${error.response?.statusCode}';
          }
        } catch (e) {
          errorMessage = 'Server error: ${error.response?.statusCode}';
        }
      }
    } else {
      errorMessage = error.toString();
    }

    Fluttertoast.showToast(
        fontSize: Get.height * 0.015,
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  // Controllers
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
  late final regEndDateController = TextEditingController();
  late final startDateController = TextEditingController();
  late final endDateController = TextEditingController();
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
  late final tournamentHashtagController = TextEditingController();

  // Fixtures
  late final addFixtureRoundNameController = TextEditingController();
  late final addFixtureStreamingLinkController = TextEditingController();
  late final addFixturesHomeTeamScoreController = TextEditingController();
  late final addFixturesAwayTeamScoreController = TextEditingController();
  late final addFixturesAwayPlayerScoreController = TextEditingController();
  late final addFixturesHomePlayerScoreController = TextEditingController();
  late final brWinnerController = TextEditingController();
  late final brSecondController = TextEditingController();
  late final brThirdController = TextEditingController();
  Rx<PlayerModel?> brWinnerPlayer = Rx(null);
  Rx<PlayerModel?> brSecondPlayer = Rx(null);
  Rx<PlayerModel?> brThirdPlayer = Rx(null);

  Rx<TeamModel?> brWinnerTeam = Rx(null);
  Rx<TeamModel?> brSecondTeam = Rx(null);
  Rx<TeamModel?> brThirdTeam = Rx(null);
  RxList<FixtureModel> allFixtures = RxList([]);

  Rx<PlayerModel?> selectedAwayPlayer = Rx(null);
  Rx<PlayerModel?> selectedHomePlayer = Rx(null);
  Rx<TeamModel?> selectedHomeTeam = Rx(null);
  Rx<TeamModel?> selectedAwayTeam = Rx(null);
  Rx<DateTime?> fixtureDate = Rx(null);
  Rx<TimeOfDay?> fixtureTime = Rx(null);
  Rx<PlatformModel?> fixturePlatform = Rx(null);
  Rx<GameMode?> fixtureGameMode = Rx(null);

  Rx<String?> communitiesValue = Rx(null);
  Rx<GamePlayed?> gameValue = Rx(null);
  Rx<String?> gameModeValue = Rx(null);
  Rx<String?> knockoutValue = Rx(null);
  Rx<String?> rankTypeValue = Rx(null);
  Rx<String?> tournamentTypeValue = Rx(null);
  Rx<String?> participantValue = Rx(null);
  Rx<String?> partnerValue = Rx(null);
  Rx<String?> staffValue = Rx(null);

  final gameValueController = MultiSelectController<int>();
  final Rx<MultiSelectController<int>> gameModesController =
      Rx(MultiSelectController<int>());
  RxBool selectingCommunity = false.obs;
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
  var isRegistrationEndDate = false.obs;
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
    } else if (title == 'regEndDate') {
      isRegistrationEndDate.value = true;
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
                  size: 15,
                  fontFamily: 'InterMedium',
                  color: AppColor().primaryColor,
                  underline: TextDecoration.underline,
                ),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Max file size: 4MB',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'Inter',
                size: 12,
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
                size: 15,
                fontFamily: 'InterMedium',
                color: AppColor().primaryColor,
                underline: TextDecoration.underline,
              ),
            ),
            Gap(Get.height * 0.02),
            CustomText(
              title: 'Max file size: 4MB',
              color: AppColor().primaryWhite,
              textAlign: TextAlign.center,
              fontFamily: 'Inter',
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  Future createTournament() async {
    try {
      eventController.createEventStatus(CreateEventStatus.loading);
      var httpSplit = tournamentLinkController.text.replaceAll("https://", "");
      var tournamentLink = "https://$httpSplit";

      // Create FormData for multipart request
      final formData = FormData.fromMap({
        "name": tournamentNameController.text,
        "link": tournamentLink,
        "knockout_type": knockoutTypeController.text,
        "rank_type": rankTypeController.text,
        "reg_start": regDateController.text,
        "reg_end": regEndDateController.text,
        "start_date": startDateController.text,
        "end_date": endDateController.text,
        "prize_pool": eventController.currency.value + prizePoolController.text,
        "summary": tournamentSummaryController.text,
        "entry_fee": eventController.currency.value + entryFeeController.text,
        "requirements": tournamentRequirementsController.text,
        "structure": tournamentStructureController.text,
        "first": eventController.currency.value + firstPrizeController.text,
        "second": eventController.currency.value + secondPrizeController.text,
        "third": eventController.currency.value + thirdPrizeController.text,
        "rules_regs": tournamentRegulationsController.text,
        "event_type": "tournament",
        "hashtag": tournamentHashtagController.text,
        "tournament_type": tournamentTypeValue.value!,
        "igames": gameValue.value!.id.toString(),
        "profile": await MultipartFile.fromFile(eventProfileImage!.path),
        "banner": await MultipartFile.fromFile(eventCoverImage!.path),
      });

      // Add game modes
      for (int i = 0; i < gameModesController.value.selectedItems.length; i++) {
        formData.fields.add(MapEntry('game_mode[$i]',
            '${gameModesController.value.selectedItems[i].value}'));
      }

      // Send the request
      var response = await dio.post(
        ApiLink.createTournament(selectedCommunity.value!.slug!),
        data: formData,
        options: Options(headers: _getAuthHeaders()),
      );

      if (response.statusCode == 201) {
        eventController.createEventStatus(CreateEventStatus.success);
        Get.off(() => const CreateSuccessPage(title: 'Event Created'))!
            .then((value) {
          // Refresh the events list
          eventController.getAllEvents(false);
          clear();
        });
      } else {
        eventController.createEventStatus(CreateEventStatus.error);
        debugPrint("Unexpected status code: ${response.statusCode}");
        _handleError("Unexpected error occurred");
      }
    } on DioException catch (err) {
      if (err.response?.data != null) {
        print(err.response?.data);
      }
    } catch (error) {
      eventController.createEventStatus(CreateEventStatus.error);
      debugPrint("Error occurred: ${error.toString()}");

      if (error is DioException && error.response?.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('Please try again!'));
      } else {
        _handleError(error);
      }
    }
  }

  Future updateTournament(
    String eventSlug,
    String communitySlug,
  ) async {
    try {
      eventController.createEventStatus(CreateEventStatus.loading);
      var httpSplit = tournamentLinkController.text.replaceAll("https://", "");
      var tournamentLink = "https://$httpSplit";

      // Create FormData for multipart request
      final formData = FormData.fromMap({
        "name": tournamentNameController.text,
        "link": tournamentLink,
        "knockout_type": knockoutTypeController.text,
        "rank_type": rankTypeController.text,
        "reg_start": regDateController.text,
        "reg_end": regEndDateController.text,
        "start_date": startDateController.text,
        "end_date": endDateController.text,
        "prize_pool": eventController.currency.value + prizePoolController.text,
        "summary": tournamentSummaryController.text,
        "entry_fee": eventController.currency.value + entryFeeController.text,
        "requirements": tournamentRequirementsController.text,
        "structure": tournamentStructureController.text,
        "first": eventController.currency.value + firstPrizeController.text,
        "second": eventController.currency.value + secondPrizeController.text,
        "third": eventController.currency.value + thirdPrizeController.text,
        "rules_regs": tournamentRegulationsController.text,
        "event_type": "tournament",
        "hashtag": tournamentHashtagController.text,
        "tournament_type": tournamentTypeValue.value!,
        "igames": gameValue.value!.id.toString(),
        "team_size": participantController.text,
        "enable_leaderboard": enableLeaderboardController.text,
      });

      // Add images if they are updated
      if (eventProfileImage != null) {
        formData.files.add(MapEntry(
            "profile", await MultipartFile.fromFile(eventProfileImage!.path)));
      }
      if (eventCoverImage != null) {
        formData.files.add(MapEntry(
            "banner", await MultipartFile.fromFile(eventCoverImage!.path)));
      }

      // Add game modes
      for (int i = 0; i < gameModesController.value.selectedItems.length; i++) {
        formData.fields.add(MapEntry('game_mode[$i]',
            '${gameModesController.value.selectedItems[i].value}'));
      }

      // Send the request
      var response = await dio.put(
        ApiLink.editTournament(eventSlug, communitySlug),
        data: formData,
        options: Options(headers: _getAuthHeaders()),
      );
      Get.back(); // Navigate back to tournament details
      Helpers().showCustomSnackbar(message: "Tournament updated successfully");
      // Refresh the events list
      eventController.getMyEvents(false);
    } on DioException catch (err) {
      print("edit tournament error: ${err.response?.data}");
      eventController.createEventStatus(CreateEventStatus.error);
      if (err.response?.data != null) {
        print(err.response?.data);
        _handleError(err.response?.data);
      } else {
        _handleError("Failed to update tournament");
      }
    } catch (error) {
      eventController.createEventStatus(CreateEventStatus.error);
      debugPrint("Error occurred: ${error.toString()}");

      if (error is DioException && error.response?.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('Please try again!'));
      } else {
        _handleError(error);
      }
    }
  }

  Future registerForTournament(String slug) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.put(ApiLink.registerForEvent(slug),
          options: Options(headers: headers));

      _handleResponse(response);
      Helpers().showCustomSnackbar(message: "Successfully registered");
      return true;
    } catch (error) {
      _handleError(error);
      return false;
    }
  }

  Future registerForTeamTournament(String slug, String teamSlug) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.put(ApiLink.registerForTeamEvent(slug, teamSlug),
          options: Options(headers: headers));

      _handleResponse(response);
      Helpers().showCustomSnackbar(message: "Successfully registered");
    } on DioException catch (error) {
      print(error.response?.data);
      _handleError(error);
    }
  }

  Future getTournamentWaitlist(String slug) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.get(ApiLink.getEventWaitlist(slug),
          options: Options(headers: headers));

      var responseData = _handleResponse(response);
      return List<WaitlistModel>.from(
          responseData.map((x) => WaitlistModel.fromJson(x)));
    } catch (error) {
      _handleError(error);
      return [];
    }
  }

  Future getTournamentParticipants(String slug) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.get(ApiLink.getEventParticipants(slug),
          options: Options(headers: headers));

      var responseData = _handleResponse(response);
      print(responseData);
      return responseData;
    } catch (error) {
      print(error);
      _handleError(error);
      return [];
    }
  }

  Future getTeamTournamentParticipants(String slug) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.get(ApiLink.getEventParticipants(slug),
          options: Options(headers: headers));
      print(response.data);

      var responseData = _handleResponse(response);

      return List<RoasterModel>.from(
          responseData.map((x) => RoasterModel.fromJson(x)));
    } catch (error) {
      _handleError(error);
      return [];
    }
  }

  Future<bool> unregisterForEvent(
      String slug, String role, String roleSlug) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.put(
          ApiLink.unregisterForEvent(slug, role, roleSlug),
          options: Options(headers: headers));

      _handleResponse(response);
      Helpers().showCustomSnackbar(message: "Successfully unregistered");
      return true;
    } catch (error) {
      _handleError(error);
    }
    return false;
  }

  Future getFixtures(String slug) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.get(ApiLink.getFixtures(slug),
          options: Options(headers: headers));

      var responseData = _handleResponse(response);
      return List<FixtureModel>.from(
          responseData.map((x) => FixtureModel.fromJson(x)));
    } catch (error) {
      _handleError(error);
      return [];
    }
  }

  Future createBRFixture(String slug, List<int> participants, String type,
      int community, File? imageFile, bool hasLivestream) async {
    try {
      final formData = FormData.fromMap(
        {
          "ifirst": (type == "solo"
                      ? brWinnerPlayer.value?.id
                      : brWinnerTeam.value?.id)
                  ?.toString() ??
              "",
          "isecond": (type == "solo"
                      ? brSecondPlayer.value?.id
                      : brSecondTeam.value?.id)
                  ?.toString() ??
              "",
          "ithird":
              (type == "solo" ? brThirdPlayer.value?.id : brThirdTeam.value?.id)
                      ?.toString() ??
                  "",
          "player_ids": type == "solo" ? participants : [],
          "team_ids": type == "team" ? participants : [],
          "igame_mode": "1",
          "fixture_group": "player",
          "fixture_date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
          "fixture_time":
              "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
          "fixture_type": "BR",
          "title": addFixtureRoundNameController.text,
          "streaming_platform": jsonEncode(fixturePlatform.value),
          "banner": imageFile != null
              ? await MultipartFile.fromFile(imageFile.path)
              : null,
        },
      );

      if (hasLivestream) {
        var livestreams = [
          {
            "title": addFixtureRoundNameController.text,
            "description": "fixture",
            "date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
            "creator": "community",
            "creator_id": community,
            "time":
                "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
            "platform_id": fixturePlatform.value!.id,
            "link": "https://${addFixtureStreamingLinkController.text}",
          }
        ];

        for (var key in livestreams[0].keys) {
          formData.fields.add(
              MapEntry("ilivestreams[0].$key", livestreams[0][key].toString()));
        }
      }

      var response = await dio.post(
        ApiLink.createFixture(slug),
        data: formData,
        options: Options(headers: _getAuthHeaders()),
      );

      _handleResponse(response);
      Get.back();
      Helpers().showCustomSnackbar(message: "Fixture added successfully");
    } catch (error) {
      _handleError(error);
    }
  }

  Future editBRFixture(String slug, List<int> participants, String type) async {
    try {
      Map<String, dynamic> body = {
        "player_ids": type == "solo" ? participants : [],
        "team_ids": type == "team" ? participants : [],
        "igame_mode": 1,
        "fixture_group": "player",
        "fixture_date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
        "fixture_time":
            "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
        "fixture_type": "BR",
        "title": addFixtureRoundNameController.text,
        "streaming_platform": fixturePlatform.value,
        "livestreams": [
          {
            "title": addFixtureRoundNameController.text,
            "description": "fixture",
            "date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
            "time":
                "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
            "platform_id": fixturePlatform.value!.id!,
            "link": "https://${addFixtureStreamingLinkController.text}"
          }
        ]
      };

      var headers = _getAuthHeaders();
      var response = await dio.post(ApiLink.createFixture(slug),
          data: body, options: Options(headers: headers));

      _handleResponse(response);
      Get.back();
      Helpers().showCustomSnackbar(message: "Fixture added successfully");
    } catch (error) {
      _handleError(error);
    }
  }

  Future createFixtureForPlayer(
      String slug, int community, File? imageFile, bool hasLivestream) async {
    try {
      final formData = FormData.fromMap(
        {
          "away_player_id": selectedAwayPlayer.value!.id.toString(),
          "away_score": addFixturesAwayPlayerScoreController.text.isEmpty
              ? ""
              : addFixturesAwayPlayerScoreController.text,
          "home_player_id": selectedHomePlayer.value!.id.toString(),
          "home_score": addFixturesHomePlayerScoreController.text.isEmpty
              ? ""
              : addFixturesHomePlayerScoreController.text,
          "player_ids": [
            selectedHomePlayer.value!.id.toString(),
            selectedAwayPlayer.value!.id.toString()
          ],
          "igame_mode": "1",
          "fixture_group": "player",
          "fixture_date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
          "fixture_time":
              "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
          "fixture_type": "1v1",
          "title": addFixtureRoundNameController.text,
          "streaming_platform": jsonEncode(fixturePlatform.value),
          "banner": imageFile != null
              ? await MultipartFile.fromFile(imageFile.path)
              : null,
        },
      );

      if (hasLivestream) {
        var livestreams = [
          {
            "title": addFixtureRoundNameController.text,
            "description": "fixture",
            "date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
            "creator": "community",
            "creator_id": community,
            "time":
                "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
            "platform_id": fixturePlatform.value!.id,
            "link": "https://${addFixtureStreamingLinkController.text}",
          }
        ];

        for (var key in livestreams[0].keys) {
          formData.fields.add(
              MapEntry("ilivestreams[0].$key", livestreams[0][key].toString()));
        }
      }

      var headers = _getAuthHeaders();
      var response = await dio.post(ApiLink.createFixture(slug),
          data: formData, options: Options(headers: headers));

      _handleResponse(response);
      Get.back();
      Helpers().showCustomSnackbar(message: "Fixture added successfully");
    } catch (error) {
      _handleError(error);
    }
  }

  Future createFixtureForTeam(
      String slug, int community, File? imageFile, bool hasLivestream) async {
    try {
      final formData = FormData.fromMap(
        {
          "away_team_id": selectedAwayTeam.value!.id.toString(),
          "away_score": addFixturesAwayTeamScoreController.text.isEmpty
              ? ""
              : addFixturesAwayTeamScoreController.text,
          "home_team_id": selectedHomeTeam.value!.id.toString(),
          "home_score": addFixturesHomeTeamScoreController.text.isEmpty
              ? ""
              : addFixturesHomeTeamScoreController.text,
          "team_ids": [
            selectedHomeTeam.value!.id.toString(),
            selectedAwayTeam.value!.id.toString()
          ],
          "igame_mode": "1",
          "fixture_group": "team",
          "fixture_date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
          "fixture_time":
              "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
          "fixture_type": "1v1",
          "title": addFixtureRoundNameController.text,
          "streaming_platform": jsonEncode(fixturePlatform.value),
          "banner": imageFile != null
              ? await MultipartFile.fromFile(imageFile.path)
              : null,
        },
      );

      if (hasLivestream) {
        var livestreams = [
          {
            "title": addFixtureRoundNameController.text,
            "description": "fixture",
            "date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
            "creator": "community",
            "creator_id": community,
            "time":
                "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
            "platform_id": fixturePlatform.value!.id,
            "link": "https://${addFixtureStreamingLinkController.text}",
          }
        ];

        for (var key in livestreams[0].keys) {
          formData.fields.add(
              MapEntry("ilivestreams[0].$key", livestreams[0][key].toString()));
        }
      }

      var headers = _getAuthHeaders();
      var response = await dio.post(ApiLink.createFixture(slug),
          data: formData, options: Options(headers: headers));

      _handleResponse(response);
      Get.back();
      Helpers().showCustomSnackbar(message: "Fixture added successfully");
    } catch (error) {
      _handleError(error);
    }
  }

  Future<EventModel?> getEventDetails(String slug) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.get(ApiLink.getEventDetails(slug),
          options: Options(headers: headers));

      var responseData = _handleResponse(response);
      return EventModel.fromJson(responseData);
    } catch (error) {
      _handleError(error);
    }
    return null;
  }

  Future editFixtureForPlayer(String slug) async {
    try {
      Map<String, dynamic> body = {
        "away_player_id": selectedAwayPlayer.value!.id,
        "away_score": addFixturesAwayPlayerScoreController.text == ""
            ? null
            : addFixturesAwayPlayerScoreController.text,
        "home_player_id": selectedHomePlayer.value!.id,
        "home_score": addFixturesHomePlayerScoreController.text == ""
            ? null
            : addFixturesHomePlayerScoreController.text,
        "player_ids": [
          selectedHomePlayer.value!.id,
          selectedAwayPlayer.value!.id
        ],
        "igame_mode": 1,
        "fixture_group": "player",
        "fixture_date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
        "fixture_time":
            "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
        "fixture_type": "1v1",
        "title": addFixtureRoundNameController.text,
        "streaming_platform": fixturePlatform.value,
        "livestreams": [
          {
            "title": addFixtureRoundNameController.text,
            "description": "fixture",
            "date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
            "time":
                "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
            "platform_id": fixturePlatform.value!.id!,
            "link": addFixtureStreamingLinkController.text
          }
        ]
      };

      var headers = _getAuthHeaders();
      var response = await dio.put(ApiLink.editFixture(slug),
          data: body, options: Options(headers: headers));

      _handleResponse(response);
      Get.back();
      Helpers().showCustomSnackbar(message: "Fixture edited successfully");
    } catch (error) {
      _handleError(error);
    }
  }

  Future editFixtureForTeam(String slug) async {
    try {
      Map<String, dynamic> body = {
        "away_team_id": selectedAwayTeam.value!.id,
        "away_score": addFixturesAwayTeamScoreController.text,
        "home_team_id": selectedHomeTeam.value!.id,
        "home_score": addFixturesHomeTeamScoreController.text,
        "team_ids": [selectedHomeTeam.value!.id, selectedAwayTeam.value!.id],
        "igame_mode": 1,
        "fixture_group": "team",
        "fixture_date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
        "fixture_time":
            "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
        "fixture_type": "1v1",
        "title": addFixtureRoundNameController.text,
        "streaming_link": "addFixtureStreamingLinkController.text",
        "streaming_platform": fixturePlatform.value,
        "livestreams": [
          {
            "title": "",
            "description": "",
            "date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
            "time":
                "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
            "platform_id": fixturePlatform.value!.id!,
            "link": addFixtureStreamingLinkController.text
          }
        ]
      };

      var headers = _getAuthHeaders();
      var response = await dio.post(ApiLink.editFixture(slug),
          data: body, options: Options(headers: headers));

      _handleResponse(response);
      Get.back();
      Helpers().showCustomSnackbar(message: "Fixture edited successfully");
    } catch (error) {
      _handleError(error);
    }
  }

  Future createLivestream(String title, String description, String link,
      int platform, File? image, DateTime date, TimeOfDay time) async {
    try {
      final formData = FormData.fromMap(
        {
          "title": title,
          "description": description,
          "platform_id": platform.toString(),
          "creator": "user",
          "creator_id": authController.user!.id!.toString(),
          "date": DateFormat('yyyy-M-dd').format(date),
          "time": "${time.hour}:${time.minute}:00",
          "banner":
              image != null ? await MultipartFile.fromFile(image.path) : null,
        },
      );

      var headers = _getAuthHeaders();
      print(ApiLink.createLivestream);
      var response = await dio.post(ApiLink.createLivestream,
          data: formData, options: Options(headers: headers));

      _handleResponse(response);
      Get.back();
      Helpers().showCustomSnackbar(message: "Livestream created successfully");
    } on DioException catch (error) {
      print(error.response?.data);
      _handleError(error);
    }
  }

  Future deleteFixture(String slug) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.delete(ApiLink.deleteFixture(slug),
          options: Options(headers: headers));

      _handleResponse(response);
    } catch (error) {
      _handleError(error);
    }
  }

  Future takeActionOnWaitlist(
      String eventSlug, String applicantSlug, String action) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.post(
          ApiLink.takeActionOnWaitlist(eventSlug, applicantSlug, action),
          options: Options(headers: headers));

      _handleResponse(response);
      if (action == "accept") {
        Helpers()
            .showCustomSnackbar(message: "Participant accepted successfully");
      } else {
        Helpers()
            .showCustomSnackbar(message: "Participant rejected successfully");
      }
    } catch (error) {
      _handleError(error);
    }
  }

  Future editParticipant(
      String eventSlug, String participantSlug, String action) async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.put(
          ApiLink.editParticipant(eventSlug, participantSlug, action),
          options: Options(headers: headers));

      _handleResponse(response);
      if (action == "remove") {
        Helpers().showCustomSnackbar(message: "Removed Participant");
      }
    } catch (error) {
      _handleError(error);
    }
  }

  Future getAllFixture() async {
    try {
      var headers = _getAuthHeaders();
      var response = await dio.get(ApiLink.getAllFixture(),
          options: Options(headers: headers));

      var responseData = _handleResponse(response);
      var fixtures = List<FixtureModel>.from(
          responseData['results'].map((x) => FixtureModel.fromJson(x)));
      allFixtures.assignAll(fixtures);
    } catch (error) {
      _handleError(error);
    }
  }

  void clearFixturesData() {
    fixtureTime.value = null;
    fixtureDate.value = null;
    addFixturesAwayPlayerScoreController.clear();
    addFixturesHomePlayerScoreController.clear();
    addFixturesAwayTeamScoreController.clear();
    addFixturesHomeTeamScoreController.clear();
    selectedAwayPlayer.value = null;
    selectedHomePlayer.value = null;
    selectedHomeTeam.value = null;
    selectedAwayTeam.value = null;
    addFixtureRoundNameController.clear();
    addFixtureStreamingLinkController.clear();
    fixturePlatform.value = null;
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
