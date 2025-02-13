import 'dart:convert';
import 'dart:developer';
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
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:dio/dio.dart' as dioClass;

final dio = dioClass.Dio();

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
  late final regEndDateController = TextEditingController();
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
  late final tournamentHashtagController = TextEditingController();

  //fixtures
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
      var tournamentLink = "https://${tournamentLinkController.text}";
      var headers = {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      };
      var request = http.MultipartRequest("POST",
          Uri.parse(ApiLink.createTournament(selectedCommunity.value!.id!)))
        ..fields["name"] = tournamentNameController.text
        ..fields["link"] = tournamentLink
        ..fields["knockout_type"] = knockoutTypeController.text
        ..fields["rank_type"] = rankTypeController.text
        ..fields["reg_start"] = regDateController.text
        ..fields["reg_end"] = regEndDateController.text
        ..fields["start_date"] = startDateController.text
        ..fields["end_date"] = endDateController.text
        ..fields["prize_pool"] =
            eventController.currency.value + prizePoolController.text
        ..fields["summary"] = tournamentSummaryController.text
        ..fields["entry_fee"] =
            eventController.currency.value + entryFeeController.text
        ..fields["requirements"] = tournamentRequirementsController.text
        ..fields["structure"] = tournamentStructureController.text
        ..fields["first"] =
            eventController.currency.value + firstPrizeController.text
        ..fields["second"] =
            eventController.currency.value + secondPrizeController.text
        ..fields["third"] =
            eventController.currency.value + thirdPrizeController.text
        ..fields["rules_regs"] = tournamentRegulationsController.text
        ..fields["event_type"] = "tournament"
        ..fields["hashtag"] = tournamentHashtagController.text
        ..fields["tournament_type"] = tournamentTypeValue.value!
        ..fields["igames"] = gameValue.value!.id.toString();

      for (int i = 0; i < gameModesController.value.selectedItems.length; i++) {
        request.fields['game_mode[$i]'] =
            '${gameModesController.value.selectedItems[i].value}';
      }

      request.files.add(await http.MultipartFile.fromPath(
          'profile', eventProfileImage!.path));
      request.files.add(
          await http.MultipartFile.fromPath('banner', eventCoverImage!.path));

      // request.fields.addAll(
      //     event.toCreateEventJson().map((key, value) => MapEntry(key, value)));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      // var res = await response.stream.bytesToString();
      // print(res);
      if (response.statusCode == 201) {
        eventController.createEventStatus(CreateEventStatus.success);
        debugPrint(await response.stream.bytesToString());
        Get.to(() => const CreateSuccessPage(title: 'Event Created'))!
            .then((value) {
          eventController.getAllEvents(false);
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

  Future registerForTournament(int id) async {
    var headers = {
      "Content-Type": "application/json",
      "Authorization": 'JWT ${authController.token}'
    };

    var response = await http.put(Uri.parse(ApiLink.registerForEvent(id)),
        headers: headers);

    print(response.body);
    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      debugPrint("success");
      Helpers().showCustomSnackbar(message: "Successfully registered");
      return true;
    } else {
      Helpers().showCustomSnackbar(message: json['error']);
      return false;
    }
  }

  Future registerForTeamTournament(int id, int teamId) async {
    var headers = {
      "Content-Type": "application/json",
      "Authorization": 'JWT ${authController.token}'
    };

    var response = await http.put(
        Uri.parse(ApiLink.registerForTeamEvent(id, teamId)),
        headers: headers);

    print(response.body);
    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      debugPrint("success");
      Helpers().showCustomSnackbar(message: json['message']);
    } else {
      Helpers().showCustomSnackbar(message: json['error']);
    }
  }

  Future getTournamentWaitlist(int id) async {
    var response = await http.get(Uri.parse(ApiLink.getEventWaitlist(id)),
        headers: {"Authorization": "JWT ${authController.token}"});
    debugPrint(response.body);

    List<WaitlistModel> waitlist = List<WaitlistModel>.from(
        json.decode(response.body).map((x) => WaitlistModel.fromJson(x)));

    return waitlist;
  }

  Future getTournamentParticipants(int id) async {
    var response =
        await http.get(Uri.parse(ApiLink.getEventParticipants(id)), headers: {
      "Content-type": "application/json",
      "Authorization": "JWT ${authController.token}"
    });

    return playerModelListFromJson(response.body);
  }

  Future getTeamTournamentParticipants(int id) async {
    var response =
        await http.get(Uri.parse(ApiLink.getEventParticipants(id)), headers: {
      "Content-type": "application/json",
      "Authorization": "JWT ${authController.token}"
    });
    return roasterModelFromJson(response.body);
  }

  Future unregisterForEvent(int eventId, String role, int roleId) async {
    try {
      var response = await http.put(
          Uri.parse(ApiLink.unregisterForEvent(eventId, role, roleId)),
          headers: {
            'Content-type': "application/json",
            "Authorization": "JWT ${authController.token}"
          });

      var json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Helpers().showCustomSnackbar(message: json['message']);
      }
    } catch (err) {}
  }

  Future getFixtures(int id) async {
    var response = await http.get(Uri.parse(ApiLink.getFixtures(id)), headers: {
      "Authorization": "JWT ${authController.token}",
      "Content-type": "application/json"
    });

    debugPrint(response.body);
    var json = jsonDecode(response.body);

    var list = List.from(json);
    var fixtures = list.map((e) => FixtureModel.fromJson(e)).toList();

    return fixtures;
  }

  Future createBRFixture(int id, List<int> participants, String type,
      int community, File? imageFile, bool hasLivestream) async {
    try {
      final formData = dioClass.FormData.fromMap(
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
          "player_ids": [
            selectedHomePlayer.value!.id.toString(),
            selectedAwayPlayer.value!.id.toString()
          ],
          "igame_mode": "1",
          "fixture_group": "player",
          "fixture_date": DateFormat('yyyy-M-dd').format(fixtureDate.value!),
          "fixture_time":
              "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
          "fixture_type": "BR",
          "title": addFixtureRoundNameController.text,
          "streaming_platform": jsonEncode(fixturePlatform.value),
          "banner": imageFile != null
              ? await dioClass.MultipartFile.fromFile(imageFile.path)
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

      var response = await dio.post(ApiLink.createFixture(id),
          data: formData,
          options: dioClass.Options(headers: {
            "Authorization": "JWT ${authController.token}",
            dioClass.Headers.contentTypeHeader:
                dioClass.Headers.multipartFormDataContentType
          }));
      print(response.data);

      if (response.statusCode == 200) {
        Get.back();
        Helpers().showCustomSnackbar(message: "Fixture added successfully");
      }
    } catch (err) {
      log("Error creating fixture: ${(err as dioClass.DioException).response?.data}");
    }
  }

  Future editBRFixture(int id, List<int> participants, String type) async {
    print(type);
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
          "time": "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
          "platform_id": fixturePlatform.value!.id!,
          "link": "https://${addFixtureStreamingLinkController.text}"
        }
      ]
    };

    try {
      var response = await http.post(Uri.parse(ApiLink.createFixture(id)),
          headers: {
            "Authorization": "JWT ${authController.token}",
            "Content-type": "application/json"
          },
          body: jsonEncode(body));
      log(response.body);

      if (response.statusCode == 200) {
        Get.back();
        Helpers().showCustomSnackbar(message: "Fixture added successfully");
      }
    } catch (err) {}
  }

  Future createFixtureForPlayer(
      int id, int community, File? imageFile, bool hasLivestream) async {
    try {
      final formData = dioClass.FormData.fromMap(
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
              ? await dioClass.MultipartFile.fromFile(imageFile.path)
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

      var response = await dio.post(ApiLink.createFixture(id),
          data: formData,
          options: dioClass.Options(headers: {
            "Authorization": "JWT ${authController.token}",
            dioClass.Headers.contentTypeHeader:
                dioClass.Headers.multipartFormDataContentType
          }));
      print(response.data);

      if (response.statusCode == 200) {
        Get.back();
        Helpers().showCustomSnackbar(message: "Fixture added successfully");
      }
    } catch (err) {
      log("Error creating fixture: ${(err as dioClass.DioException).response?.data}");
    }
  }

  Future createFixtureForTeam(
      int id, int community, File? imageFile, bool hasLivestream) async {
    try {
      final formData = dioClass.FormData.fromMap(
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
              ? await dioClass.MultipartFile.fromFile(imageFile.path)
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

      var response = await dio.post(ApiLink.createFixture(id),
          data: formData,
          options: dioClass.Options(headers: {
            "Authorization": "JWT ${authController.token}",
            dioClass.Headers.contentTypeHeader:
                dioClass.Headers.multipartFormDataContentType
          }));
      print(response.data);

      if (response.statusCode == 200) {
        Get.back();
        Helpers().showCustomSnackbar(message: "Fixture added successfully");
      }
    } catch (err) {
      log("Error creating fixture: ${(err as dioClass.DioException).response?.data}");
    }
  }

  Future getEventDetails(int id) async {
    var response = await http.get(Uri.parse(ApiLink.getEventDetails(id)),
        headers: {"Authorization": "JWT ${authController.token}"});

    var json = jsonDecode(response.body);
    var event = EventModel.fromJson(json);

    return event;
  }

  Future editFixtureForPlayer(int id) async {
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
          "time": "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
          "platform_id": fixturePlatform.value!.id!,
          "link": addFixtureStreamingLinkController.text
        }
      ]
    };
    try {
      var response = await http.put(Uri.parse(ApiLink.editFixture(id)),
          headers: {
            "Authorization": "JWT ${authController.token}",
            "Content-type": "application/json"
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        Get.back();
        Helpers().showCustomSnackbar(message: "Fixture edited successfully");
      }
    } catch (err) {}
  }

  Future editFixtureForTeam(int id) async {
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
          "time": "${fixtureTime.value!.hour}:${fixtureTime.value!.minute}:00",
          "platform_id": fixturePlatform.value!.id!,
          "link": addFixtureStreamingLinkController.text
        }
      ]
    };
    try {
      var response = await http.post(Uri.parse(ApiLink.editFixture(id)),
          headers: {
            "Authorization": "JWT ${authController.token}",
            "Content-type": "application/json"
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        Get.back();
        Helpers().showCustomSnackbar(message: "Fixture edited successfully");
      }
    } catch (err) {}
  }

  Future createLivestream(String title, String description, String link,
      int platform, File? image, DateTime date, TimeOfDay time) async {
    var headers = {
      "Authorization": "JWT ${authController.token}",
      "Content-type": "multipart/form-data"
    };
    var request =
        http.MultipartRequest("POST", Uri.parse(ApiLink.createLivestream))
          ..fields["title"] = title
          ..fields["description"] = description
          ..fields["platform_id"] = platform.toString()
          ..fields["creator"] = "user"
          ..fields["creator_id"] = authController.user!.id!.toString()
          ..fields["date"] = DateFormat('yyyy-M-dd').format(date!)
          ..fields["time"] = "${time!.hour}:${time!.minute}:00";

    request.files.add(await http.MultipartFile.fromPath('banner', image!.path));

    // request.fields.addAll(
    //     event.toCreateEventJson().map((key, value) => MapEntry(key, value)));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    // var res = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      Get.back();
      Helpers().showCustomSnackbar(message: "Livestream created successfully");
    }
  }

  Future deleteFixture(int id) async {
    var response = await http.delete(Uri.parse(ApiLink.deleteFixture(id)),
        headers: {"Authorization": "JWT ${authController.token}"});
  }

  Future takeActionOnWaitlist(
      int eventId, int applicantId, String action) async {
    var response = await http.post(
        Uri.parse(ApiLink.takeActionOnWaitlist(eventId, applicantId, action)),
        headers: {
          "Authorization": "JWT ${authController.token}",
        });
    debugPrint(response.body);
    if (response.statusCode == 200) {
      if (action == "accept") {
        Helpers()
            .showCustomSnackbar(message: "Participant accepted successfully");
      } else {
        Helpers()
            .showCustomSnackbar(message: "Participant rejected successfully");
      }
    }
  }

  Future editParticipant(int eventId, int participantId, String action) async {
    var response = await http.put(
        Uri.parse(ApiLink.editParticipant(eventId, participantId, action)),
        headers: {"Authorization": "JWT ${authController.token}"});

    if (response.statusCode == 200) {
      if (action == "remove") {
        Helpers().showCustomSnackbar(message: "Removed Participant");
      }
    }
  }

  Future getAllFixture() async {
    var response = await http.get(Uri.parse(ApiLink.getAllFixture()),
        headers: {"Authorization": "JWT ${authController.token}"});
    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var list = List.from(json['results']);
      var fixtures = list.map((e) => FixtureModel.fromJson(e)).toList();
      allFixtures.assignAll(fixtures);
    }
  }

  void handleError(dynamic error) {
    debugPrint("error $error");
    Fluttertoast.showToast(
        fontSize: Get.height * 0.015,
        msg: (error.toString().contains("api.esportsng.com") ||
                error.toString().contains("Network is unreachable"))
            ? 'Event like: No internet connection!'
            : (error.toString().contains("FormatException"))
                ? 'Event like: Internal server error, contact admin!'
                : error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
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
