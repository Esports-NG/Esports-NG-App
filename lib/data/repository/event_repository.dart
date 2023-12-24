// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

enum EventStatus {
  empty,
  available,
  loading,
  error,
  success,
}

enum UpdateEventStatus {
  empty,
  loading,
  error,
  success,
}

enum CreateEventStatus {
  empty,
  loading,
  error,
  success,
}

enum DeleteEventStatus {
  empty,
  loading,
  error,
  success,
}

class EventRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  late final eventTypeController = TextEditingController();
  late final communitiesOwnedController = TextEditingController();
  late final searchController = TextEditingController();
  late final tournamentNameController = TextEditingController();
  late final eventNameController = TextEditingController();
  late final eventVenueController = TextEditingController();
  late final eventDescController = TextEditingController();
  late final tournamentLinkController = TextEditingController();
  late final eventLinkController = TextEditingController();
  late final regDateController = TextEditingController();
  late final startTimeController = TextEditingController();
  late final endTimeController = TextEditingController();
  late final tournamentDateController = TextEditingController();
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

  final Rx<List<EventModel>> _allEvent = Rx([]);
  final Rx<List<EventModel>> _myEvent = Rx([]);
  List<EventModel> get allEvent => _allEvent.value;
  List<EventModel> get myEvent => _myEvent.value;

  final _eventStatus = EventStatus.empty.obs;
  final _createEventStatus = CreateEventStatus.empty.obs;

  EventStatus get eventStatus => _eventStatus.value;
  CreateEventStatus get createEventStatus => _createEventStatus.value;

  Rx<File?> mEventProfileImage = Rx(null);
  Rx<File?> mEventCoverImage = Rx(null);
  File? get eventProfileImage => mEventProfileImage.value;
  File? get eventCoverImage => mEventCoverImage.value;

  DateTime? date;

  @override
  void onInit() {
    super.onInit();
    authController.mToken.listen((p0) async {
      if (p0 != '0') {
        getAllEvent(true);
      }
    });
  }

  Future createEvent(EventModel event) async {
    try {
      _createEventStatus(CreateEventStatus.loading);
      var headers = {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      };
      var request =
          http.MultipartRequest("POST", Uri.parse(ApiLink.createEvent));

      request.files.add(await http.MultipartFile.fromPath(
          'profile_picture', eventProfileImage!.path));
      request.files.add(
          await http.MultipartFile.fromPath('cover', eventCoverImage!.path));

      request.fields.addAll(
          event.toCreateEventJson().map((key, value) => MapEntry(key, value)));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        _createEventStatus(CreateEventStatus.success);
        debugPrint(await response.stream.bytesToString());
        Get.to(() => const CreateSuccessPage(title: 'Event Created'))!
            .then((value) {
          getAllEvent(false);
          clear();
        });
      } else {
        _createEventStatus(CreateEventStatus.error);
        debugPrint(response.reasonPhrase);
        handleError(response.reasonPhrase);
      }
    } catch (error) {
      _createEventStatus(CreateEventStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      handleError(error);
    }
  }

  Future getAllEvent(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        _eventStatus(EventStatus.loading);
      }

      debugPrint('getting all event...');
      var response = await http.get(Uri.parse(ApiLink.getAllEvent), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (json['detail']);
      }

      if (response.statusCode == 200) {
        var list = List.from(json);
        var events = list.map((e) => EventModel.fromJson(e)).toList();
        debugPrint("${events.length} events found");
        _allEvent(events);
        _eventStatus(EventStatus.success);
        events.isNotEmpty
            ? _eventStatus(EventStatus.available)
            : _eventStatus(EventStatus.empty);
      }
      return response.body;
    } catch (error) {
      _eventStatus(EventStatus.error);
      debugPrint("getting all event: ${error.toString()}");
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
    searchController.clear();
    tournamentNameController.clear();
    tournamentLinkController.clear();
    regDateController.clear();
    tournamentDateController.clear();
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
