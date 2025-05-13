// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/screens/auth/register.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as Get;

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

// Response model to handle the new backend structure
class EventApiResponse<T> {
  final String? message;
  final bool success;
  final T? data;

  EventApiResponse({
    this.message,
    required this.success,
    this.data,
  });

  factory EventApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJson) {
    return EventApiResponse(
      message: json['message'],
      success: json['success'] ?? false,
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : null,
    );
  }
}

class EventRepository extends Get.GetxController
    with Get.GetSingleTickerProviderStateMixin {
  final authController = Get.Get.put(AuthRepository());

  // Dio instance for HTTP requests
  late Dio _dio;

  final Get.RxList<OverlayPortalController> currentOverlay =
      <OverlayPortalController>[].obs;

  late final eventTypeController = TextEditingController();
  late final searchController = TextEditingController();

  late TabController tabController;

  Get.Rx<bool> fetchingCreatedEvents = Get.Rx(false);

  final Get.Rx<List<EventModel>> _allEvent = Get.Rx([]);
  final Get.Rx<List<EventModel>> _filteredEvent = Get.Rx([]);
  final Get.Rx<List<EventModel>> _myEvent = Get.Rx([]);
  final Get.Rx<List<EventModel>> _allTournaments = Get.Rx([]);
  final Get.Rx<List<EventModel>> _myTournaments = Get.Rx([]);
  final Get.Rx<List<EventModel>> _allSocialEvent = Get.Rx([]);
  final Get.Rx<List<EventModel>> _mySocialEvent = Get.Rx([]);
  final Get.RxList<EventModel> createdEvents = <EventModel>[].obs;

  final Get.Rx<String> currency = "".obs;
  final Get.RxString nextLink = "".obs;

  final Get.RxList<EventModel> searchedEvents = <EventModel>[].obs;

  Map<String, String> currencies = {
    "NGN": "₦", // Nigerian Naira
    "USD": "\$",
    "EUR": "€",
    "JPY": "¥",
    "GBP": "£",
    "AUD": "A\$",
    "CAD": "C\$",
    "CHF": "CHF",
    "CNY": "¥",
    "INR": "₹",
    "RUB": "₽",
    "BRL": "R\$",
    "ZAR": "R",
    "MXN": "\$",
    "SGD": "S\$",
    "HKD": "HK\$",
    "KRW": "₩",
    "TRY": "₺",
    "SEK": "kr",
    "NOK": "kr",
    "DKK": "kr",
    "EGP": "£", // Egyptian Pound
    "KES": "KSh", // Kenyan Shilling
    "GHS": "₵", // Ghanaian Cedi
    "ZMW": "ZK", // Zambian Kwacha
    "TZS": "TSh", // Tanzanian Shilling
    "UGX": "USh", // Ugandan Shilling
    "MAD": "MAD", // Moroccan Dirham
    "DZD": "دج", // Algerian Dinar
    "TND": "د.ت", // Tunisian Dinar
    "XOF": "CFA", // West African CFA Franc
    "XAF": "CFA", // Central African CFA Franc
    "BWP": "P", // Botswana Pula
    "MUR": "₨", // Mauritian Rupee
    "SCR": "₨", // Seychellois Rupee
    "MZN": "MT", // Mozambican Metical
    "AOA": "Kz", // Angolan Kwanza
    "ETB": "Br", // Ethiopian Birr
    "NAD": "\$", // Namibian Dollar
    "LSL": "L", // Lesotho Loti
    "SZL": "E", // Eswatini Lilangeni
  };

  Get.RxBool isFiltering = true.obs;

  List<EventModel> get allEvent => _allEvent.value;
  List<EventModel> get filteredEvent => _filteredEvent.value;
  List<EventModel> get myEvent => _myEvent.value;
  List<EventModel> get allSocialEvent => _allSocialEvent.value;
  List<EventModel> get mySocialEvent => _mySocialEvent.value;
  List<EventModel> get allTournaments => _allTournaments.value;
  List<EventModel> get myTournaments => _myTournaments.value;

  final Get.Rx<String?> typeFilter = Get.Rx("All");
  final Get.Rx<String?> gameFilter = Get.Rx("All");
  final Get.Rx<String?> statusFilter = Get.Rx("All");

  final Get.RxList<String> typeFilterList =
      ["All", "Tournament", "Social Event"].obs;
  final Get.RxList<String> statusFilterList =
      ["All", "Ongoing", "Concluded"].obs;
  final Get.RxList<String> gameFilterList =
      ["All", "CODM", "MLBB", "Brawl Stars"].obs;

  var maxTabs = 3.obs, eventTypeCount = 0.obs, participantCount = 0.obs;

  var fixtureTypeCount = 0.obs;

  final eventStatus = EventStatus.empty.obs;
  final myEventStatus = EventStatus.empty.obs;
  final createEventStatus = CreateEventStatus.empty.obs;
  final updateEventStatus = UpdateEventStatus.empty.obs;
  final deleteEventStatus = DeleteEventStatus.empty.obs;

  Get.RxMap<dynamic, dynamic> eventFilter = {}.obs;

  Get.Rx<File?> mEventProfileImage = Get.Rx(null);
  Get.Rx<File?> mEventCoverImage = Get.Rx(null);
  File? get eventProfileImage => mEventProfileImage.value;
  File? get eventCoverImage => mEventCoverImage.value;

  DateTime? date;

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiLink.baseurl,
      contentType: 'application/json',
      responseType: ResponseType.json,
    ));

    // Add an interceptor to handle authentication
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token to header if it exists
        if (authController.token.isNotEmpty && authController.token != "0") {
          options.headers['Authorization'] = 'JWT ${authController.token}';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Handle token refresh if 401 error occurs
        if (error.response?.statusCode == 401) {
          try {
            await authController.refreshToken();
            // Retry the request with updated token
            final opts = Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers
                ..['Authorization'] = 'JWT ${authController.token}',
            );
            final response = await _dio.request(
              error.requestOptions.path,
              options: opts,
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
            );
            return handler.resolve(response);
          } catch (e) {
            // If refresh token fails, proceed with original error
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

  // Handle error responses consistently
  void _handleApiError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      if (response != null) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['message'] != null) {
          Helpers().showCustomSnackbar(message: data['message']);
          return;
        }
      }
      // Handle network errors
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        Helpers().showCustomSnackbar(
            message: 'Network error! Please check your connection.');
        return;
      }
    }
    // Fallback error message
    Helpers().showCustomSnackbar(
        message: (error.toString().contains("esports-ng.vercel.app") ||
                error.toString().contains("Network is unreachable"))
            ? 'No internet connection!'
            : (error.toString().contains("FormatException"))
                ? 'Internal server error, contact admin!'
                : error.toString().replaceAll('(', '').replaceAll(')', ''));
  }

  // Safe API call method
  Future<T?> _safeApiCall<T>(Future<Response> Function() apiCall,
      {T Function(Map<String, dynamic>)? fromJson,
      Function(bool)? setStatus,
      Function(T?)? onSuccess}) async {
    try {
      if (setStatus != null) setStatus(true);
      final response = await apiCall();

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        print(response.data);
        final apiResponse = EventApiResponse.fromJson(
            response.data is Map<String, dynamic>
                ? response.data
                : {'success': true, 'data': response.data['data']},
            fromJson);
        if (apiResponse.message != null) {
          Helpers().showCustomSnackbar(message: apiResponse.message!);
        }

        if (onSuccess != null) {
          onSuccess(apiResponse.data);
        }

        return apiResponse.data;
      } else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Unexpected status code: ${response.statusCode}');
      }
    } catch (error) {
      _handleApiError(error);
      return null;
    } finally {
      if (setStatus != null) setStatus(false);
    }
  }

  void hideAllOverlays() {
    if (currentOverlay.isNotEmpty) {
      for (var element in currentOverlay) {
        element.hide();
      }
      currentOverlay.clear();
    }
  }

  void handleFilterChange({required String title, required String value}) {
    if (title == "Status") {
      statusFilter.value = value;
    } else if (title == "Game") {
      gameFilter.value = value;
      if (value == "All") {
        eventFilter.remove("games_name");
      } else {
        eventFilter.update("games_name", (val) => value, ifAbsent: () => value);
      }
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
    eventTypeController.text = item.title!;
  }

  void changeFixtureType({required int index, required PrimaryUse item}) {
    fixtureTypeCount.value = index;
    eventTypeController.text = item.title!;
  }

  void clear() {
    searchController.clear();
    eventTypeController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    _initDio();
    tabController = TabController(length: 3, vsync: this);

    tabController.addListener(() {
      typeFilter.value = "All";
      gameFilter.value = "All";
      statusFilter.value = "All";

      if (tabController.index == 2) {
        statusFilterList.value = ["All", "Ongoing", "Concluded"];
      } else {
        statusFilterList.value = [
          "All",
          "Ongoing Registration",
          "Registration Ended"
        ];
      }
    });

    eventFilter.listen((p0) async {
      await filterEvents();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<List<EventModel>?> getAllEvents(bool? firstTime) async {
    debugPrint("Getting all events");

    return _safeApiCall(() => _dio.get(ApiLink.getAllEvent), fromJson: (data) {
      final results = data['results'] as List<dynamic>;
      nextLink.value = data['next'] ?? "";
      print(results);
      return results.map((e) => EventModel.fromJson(e)).toList();
    }, setStatus: (loading) {
      if (firstTime == true) {
        eventStatus(loading ? EventStatus.loading : EventStatus.empty);
      }
    }, onSuccess: (events) {
      if (events != null) {
        _allEvent(events);

        eventStatus(
            events.isNotEmpty ? EventStatus.available : EventStatus.empty);
      }
    });
  }

  Future<List<EventModel>?> getNextEvents() async {
    if (nextLink.value.isEmpty) return null;

    return _safeApiCall(() => _dio.get(nextLink.value), fromJson: (data) {
      final results = data['results'] as List<dynamic>;
      nextLink.value = data['next'] ?? "";
      return results.map((e) => EventModel.fromJson(e)).toList();
    }, onSuccess: (events) {
      if (events != null) {
        _allEvent.value.addAll(events);
        _allEvent.refresh();
      }
    });
  }

  Future<List<EventModel>?> getMyEvents(bool? firstTime) async {
    return _safeApiCall(() => _dio.get(ApiLink.getMyEvents), fromJson: (data) {
      print(data);
      return (data['results'] as List<dynamic>)
          .map((e) => EventModel.fromJson(e))
          .toList();
    }, setStatus: (loading) {
      myEventStatus(loading ? EventStatus.loading : EventStatus.empty);
    }, onSuccess: (events) {
      if (events != null) {
        _myEvent(events);
        myEventStatus(
            events.isNotEmpty ? EventStatus.available : EventStatus.empty);
      }
    });
  }

  Future<List<EventModel>?> getAllTournaments(bool isFirstTime) async {
    return _safeApiCall(() => _dio.get(ApiLink.getAllTournaments),
        fromJson: (data) {
      return (data as List<dynamic>)
          .map((e) => EventModel.fromJson(e))
          .toList();
    }, setStatus: (loading) {
      if (isFirstTime) {
        eventStatus(loading ? EventStatus.loading : EventStatus.empty);
      }
    }, onSuccess: (events) {
      if (events != null) {
        _allTournaments(events);
        debugPrint("${events.length} events found");
        eventStatus(
            events.isNotEmpty ? EventStatus.available : EventStatus.empty);
      }
    });
  }

  Future<List<EventModel>?> getAllSocialEvents(bool isFirstTime) async {
    return _safeApiCall(() => _dio.get(ApiLink.getAllSocialEvents),
        fromJson: (data) {
      return (data as List<dynamic>)
          .map((e) => EventModel.fromJson(e))
          .toList();
    }, setStatus: (loading) {
      if (isFirstTime) {
        eventStatus(loading ? EventStatus.loading : EventStatus.empty);
      }
    }, onSuccess: (events) {
      if (events != null) {
        _allSocialEvent(events);
        debugPrint("${events.length} events found");
        eventStatus(
            events.isNotEmpty ? EventStatus.available : EventStatus.empty);
      }
    });
  }

  Future<List<EventModel>?> getCreatedEvents() async {
    return _safeApiCall(() => _dio.get(ApiLink.getCreatedEvents),
        fromJson: (data) {
      return (data as List<dynamic>)
          .map((e) => EventModel.fromJson(e))
          .toList();
    }, setStatus: (loading) {
      fetchingCreatedEvents.value = loading;
    }, onSuccess: (events) {
      if (events != null) {
        createdEvents.assignAll(events);
      }
    });
  }

  Future<List<EventModel>?> filterEvents() async {
    return _safeApiCall(
        () => _dio.get('/event/search/',
            queryParameters: eventFilter.cast<String, dynamic>()),
        fromJson: (data) {
      return (data as List<dynamic>)
          .map((e) => EventModel.fromJson(e))
          .toList();
    }, setStatus: (loading) {
      isFiltering(loading);
    }, onSuccess: (events) {
      if (events != null) {
        _filteredEvent(events);
      }
    });
  }
}
