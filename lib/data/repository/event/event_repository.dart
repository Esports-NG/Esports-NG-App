// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/social_event_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

class EventRepository extends GetxController
    with GetSingleTickerProviderStateMixin {
  final authController = Get.put(AuthRepository());

  final RxList<OverlayPortalController> currentOverlay =
      <OverlayPortalController>[].obs;

  late final eventTypeController = TextEditingController();
  late final searchController = TextEditingController();

  late TabController tabController;

  final Rx<List<EventModel>> _allEvent = Rx([]);
  final Rx<List<EventModel>> _myEvent = Rx([]);
  final Rx<List<SocialEventModel>> _allSocialEvent = Rx([]);
  final Rx<List<SocialEventModel>> _mySocialEvent = Rx([]);

  final Rx<String?> typeFilter = Rx(null);
  final Rx<String?> gameFilter = Rx(null);
  final Rx<String?> statusFilter = Rx(null);

  final RxList<String> typeFilterList =
      ["All", "Tournament", "Social Event"].obs;
  final RxList<String> statusFilterList = ["All", "Ongoing", "Concluded"].obs;
  final RxList<String> gameFilterList =
      ["All", "CODM", "MLBB", "Brawl Stars"].obs;

  var maxTabs = 3.obs, eventTypeCount = 0.obs, participantCount = 0.obs;

  List<EventModel> get allEvent => _allEvent.value;
  List<EventModel> get myEvent => _myEvent.value;
  List<SocialEventModel> get allSocialEvent => _allSocialEvent.value;
  List<SocialEventModel> get mySocialEvent => _mySocialEvent.value;

  final eventStatus = EventStatus.empty.obs;
  final createEventStatus = CreateEventStatus.empty.obs;

  // EventStatus get eventStatus => eventStatus.value;
  // CreateEventStatus get createEventStatus => createEventStatus.value;

  Rx<File?> mEventProfileImage = Rx(null);
  Rx<File?> mEventCoverImage = Rx(null);
  File? get eventProfileImage => mEventProfileImage.value;
  File? get eventCoverImage => mEventCoverImage.value;

  DateTime? date;

  void hideAllOverlays() {
    if (currentOverlay.isNotEmpty) {
      currentOverlay.forEach((element) {
        element.hide();
      });
      currentOverlay.clear();
    }
  }

  void handleFilterChange({required String title, required String value}) {
    if (title == "Status") {
      statusFilter.value = value;
    } else if (title == "Game") {
      gameFilter.value = value;
    } else {
      typeFilter.value = value;
    }
  }

  String renderFilter({required String title}) {
    if (title == "Type") {
      return typeFilter.value != null ? typeFilter.value! : title;
    } else if (title == "Status") {
      return statusFilter.value != null ? statusFilter.value! : title;
    } else {
      return gameFilter.value != null ? gameFilter.value! : title;
    }
  }

  void changeEventType({required int index, required PrimaryUse item}) {
    eventTypeCount.value = index;
    if (index == 0) {
      maxTabs.value = 3;
    } else {
      maxTabs.value = 2;
    }
    // item.isSelected = !item.isSelected!;
    debugPrint('Type: ${item.title}');
    eventTypeController.text = item.title!;
  }

  void clear() {
    searchController.clear();
    eventTypeController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);

    tabController.addListener(() {
      typeFilter.value = null;
      gameFilter.value = null;
      statusFilter.value = null;

      if (tabController.index == 2) {
        statusFilterList.value = [
          "All",
          "Ongoing Registration",
          "Registration Ended"
        ];
      } else {
        statusFilterList.value = ["All", "Ongoing", "Concluded"];
      }
    });

    authController.mToken.listen((p0) async {
      if (p0 != '0') {
        getAllTournaments(true);
        getAllSocialEvents(true);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future getAllTournaments(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        eventStatus(EventStatus.loading);
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
        eventStatus(EventStatus.success);
        events.isNotEmpty
            ? eventStatus(EventStatus.available)
            : eventStatus(EventStatus.empty);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        eventStatus(EventStatus.error);
      }
      return response.body;
    } catch (error) {
      eventStatus(EventStatus.error);
      debugPrint("getting all event: ${error.toString()}");
    }
  }

  Future getAllSocialEvents(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        eventStatus(EventStatus.loading);
      }

      debugPrint('getting all social event...');
      var response =
          await http.get(Uri.parse(ApiLink.getAllSocialEvents), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });

      print(response.body);
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (json['detail']);
      }

      if (response.statusCode == 200) {
        var list = List.from(json);
        var events = list.map((e) => SocialEventModel.fromJson(e)).toList();
        debugPrint("${events.length} events found");
        _allSocialEvent(events);
        eventStatus(EventStatus.success);
        events.isNotEmpty
            ? eventStatus(EventStatus.available)
            : eventStatus(EventStatus.empty);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        eventStatus(EventStatus.error);
      }
      return response.body;
    } catch (error) {
      eventStatus(EventStatus.error);
      debugPrint("getting all event: ${error.toString()}");
    }
  }
}
