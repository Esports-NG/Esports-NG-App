// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/utils/create_success_page.dart';
import 'package:e_sport/util/api_helpers.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as Get;

enum CommunityStatus {
  loading,
  success,
  error,
  empty,
  available,
}

enum CreateCommunityStatus {
  loading,
  success,
  error,
  empty,
}

// Response model to handle API responses
class ApiResponse<T> {
  final String? message;
  final bool success;
  final T? data;

  ApiResponse({
    this.message,
    required this.success,
    this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJson) {
    return ApiResponse(
      message: json['message'],
      success: json['success'] ?? false,
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : null,
    );
  }
}

class CommunityRepository extends Get.GetxController {
  final authController = Get.Get.put(AuthRepository());

  // Text controllers
  late final communityNameController = TextEditingController();
  late final communityAbbrController = TextEditingController();
  late final communityBioController = TextEditingController();
  late final communityGameController = TextEditingController();
  late final communityChatController = TextEditingController();
  late final searchController = TextEditingController();

  // Status Observables
  final _communityStatus = CommunityStatus.empty.obs;
  final _createCommunityStatus = CreateCommunityStatus.empty.obs;

  CommunityStatus get communityStatus => _communityStatus.value;
  CreateCommunityStatus get createCommunityStatus =>
      _createCommunityStatus.value;

  // Community data observables
  final Get.Rx<List<CommunityModel>> _allCommunity = Get.Rx([]);
  final Get.Rx<List<CommunityModel>> _myCommunity = Get.Rx([]);
  List<CommunityModel> get allCommunity => _allCommunity.value;
  List<CommunityModel> get myCommunity => _myCommunity.value;

  final Get.RxList<CommunityModel> searchedCommunities = <CommunityModel>[].obs;
  Get.RxList<UserModel> suggestedProfiles = Get.RxList([]);

  // Image files
  Get.Rx<File?> mCommunityProfileImage = Get.Rx(null);
  Get.Rx<File?> mCommunityCoverImage = Get.Rx(null);
  File? get communityProfileImage => mCommunityProfileImage.value;
  File? get communityCoverImage => mCommunityCoverImage.value;

  // UI related
  final Get.RxList<OverlayPortalController> currentOverlay =
      <OverlayPortalController>[].obs;
  Get.Rx<String> typeFilter = Get.RxString("All");
  Get.Rx<GamePlayed?> addToGamesPlayedValue = Get.Rx(null);
  Get.RxBool isLoading = false.obs;

  // Dio instance
  late Dio _dio;

  // Initialize Dio with auth interceptor
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

  @override
  void onInit() {
    super.onInit();
    _initDio();

    authController.mToken.listen((p0) async {
      if (p0 != '0') {
        getAllCommunity(true);
        getSuggestedProfiles();
      } else {
        getAllCommunity(false);
        getSuggestedProfiles();
      }
    });
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  // Handle error responses consistently
  void _handleApiError(dynamic error) {
    ApiHelpers.handleApiError(error);
  }

  // Safe API call helper
  Future<T?> _safeApiCall<T>(Future<Response> Function() apiCall,
      {T Function(Map<String, dynamic>)? fromJson,
      Function(bool)? setStatus,
      Function(T?)? onSuccess}) async {
    return ApiHelpers.safeApiCall(
      apiCall,
      fromJson: fromJson,
      setStatus: setStatus,
      onSuccess: onSuccess,
    );
  }

  // Hide all overlays
  void hideAllOverlays() {
    if (currentOverlay.isNotEmpty) {
      for (var element in currentOverlay) {
        element.hide();
      }
      currentOverlay.clear();
    }
  }

  // Create community
  Future createCommunity(Map<String, dynamic> community) async {
    try {
      _createCommunityStatus(CreateCommunityStatus.loading);

      // Create form data
      final formData = FormData.fromMap({
        "name": communityNameController.text,
        "bio": communityBioController.text,
        "abbrev": communityAbbrController.text,
      });

      // Add images if they exist
      if (communityProfileImage != null) {
        formData.files.add(MapEntry(
            'logo', await MultipartFile.fromFile(communityProfileImage!.path)));
      }

      if (communityCoverImage != null) {
        formData.files.add(MapEntry(
            'cover', await MultipartFile.fromFile(communityCoverImage!.path)));
      }

      final response = await _dio.post(ApiLink.createCommunity, data: formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true) {
          _createCommunityStatus(CreateCommunityStatus.success);
          debugPrint('Community created: ${apiResponse['data']}');
          Get.Get.to(() => const CreateSuccessPage(title: 'Community Created'))!
              .then((value) {
            getAllCommunity(false);
            clear();
          });

          if (apiResponse['message'] != null) {
            Helpers().showCustomSnackbar(message: apiResponse['message']);
          }

          return apiResponse['data'];
        } else {
          _createCommunityStatus(CreateCommunityStatus.error);
          throw apiResponse['message'] ?? 'Failed to create community';
        }
      } else {
        _createCommunityStatus(CreateCommunityStatus.error);
        throw 'Failed to create community';
      }
    } catch (error) {
      _createCommunityStatus(CreateCommunityStatus.error);
      _handleApiError(error);
      return null;
    }
  }

  // Get all communities
  Future getAllCommunity(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        _communityStatus(CommunityStatus.loading);
      }

      debugPrint('getting all community...');
      final response = await _dio.get(ApiLink.getAllCommunity);

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          var list = List.from(apiResponse['data']['results']);
          var communities =
              list.map((e) => CommunityModel.fromJson(e)).toList();
          debugPrint("${communities.length} communities found");
          _allCommunity(communities);
          communities.isNotEmpty
              ? _communityStatus(CommunityStatus.available)
              : _communityStatus(CommunityStatus.empty);

          if (apiResponse['message'] != null) {
            Helpers().showCustomSnackbar(message: apiResponse['message']);
          }
        } else {
          throw apiResponse['message'] ?? 'Failed to get communities';
        }
      } else {
        throw 'Failed to get communities';
      }

      return response.data;
    } catch (error) {
      _communityStatus(CommunityStatus.error);
      debugPrint("getting all community: ${error.toString()}");
      return null;
    }
  }

  // Get community data with followers
  Future<CommunityModel?> getCommunityData(String slug) async {
    try {
      final response = await _dio
          .get(ApiLink.getDataWithFollowers(slug: slug, type: "community"));

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return CommunityModel.fromJson(apiResponse['data']);
        } else {
          throw apiResponse['message'] ?? 'Failed to get community data';
        }
      } else {
        throw 'Failed to get community data';
      }
    } catch (error) {
      _handleApiError(error);
      return null;
    }
  }

  // Get community followers
  Future<List<Map<String, dynamic>>> getCommunityFollowers(String slug) async {
    try {
      final response = await _dio.get(ApiLink.getCommunityFollowers(slug));

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          List<dynamic> data = apiResponse['data'];
          return data.map((e) => e as Map<String, dynamic>).toList();
        } else {
          throw apiResponse['message'] ?? 'Failed to get community followers';
        }
      } else {
        throw 'Failed to get community followers';
      }
    } catch (error) {
      _handleApiError(error);
      return [];
    }
  }

  // Get suggested profiles
  Future getSuggestedProfiles() async {
    try {
      final response = await _dio.get(ApiLink.getSuggestedUsers);

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          var list = List.from(apiResponse['data']);
          suggestedProfiles
              .assignAll(list.map((e) => UserModel.fromJson(e)).toList());

          if (apiResponse['message'] != null) {
            Helpers().showCustomSnackbar(message: apiResponse['message']);
          }
        } else {
          throw apiResponse['message'] ?? 'Failed to get suggested profiles';
        }
      } else {
        throw 'Failed to get suggested profiles';
      }
    } catch (error) {
      debugPrint("getting suggested profiles: ${error.toString()}");
    }
  }

  // Add game to community
  Future addGameToCommunity(String slug) async {
    try {
      if (addToGamesPlayedValue.value == null ||
          addToGamesPlayedValue.value!.id == null) {
        Helpers().showCustomSnackbar(message: "No game selected");
        return;
      }

      final response = await _dio.post(
          ApiLink.addGameToCommunity(slug, addToGamesPlayedValue.value!.id!));

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true) {
          Helpers().showCustomSnackbar(
              message: apiResponse['message'] ?? "Game added to community");
          getAllCommunity(false);
        } else {
          throw apiResponse['message'] ?? 'Failed to add game to community';
        }
      } else {
        throw 'Failed to add game to community';
      }
    } catch (err) {
      debugPrint('adding game to community error: $err');
      _handleApiError(err);
    }
  }

  // Block community
  Future blockCommunity(String slug) async {
    try {
      final response = await _dio.post(ApiLink.blockCommunity(slug));

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true) {
          Helpers().showCustomSnackbar(
              message: apiResponse['message'] ?? "Community blocked");
        } else {
          throw apiResponse['message'] ?? 'Failed to block community';
        }
      } else {
        throw 'Failed to block community';
      }
    } catch (error) {
      _handleApiError(error);
    }
  }

  // Edit community
  Future editCommunity(String slug, Map<String, dynamic> data) async {
    try {
      // Create form data
      final formData = FormData.fromMap(
          {"name": data["name"], "bio": data["bio"], "abbrev": data["abbrev"]});

      // Add images if they exist
      if (communityProfileImage != null) {
        formData.files.add(MapEntry('profile_picture',
            await MultipartFile.fromFile(communityProfileImage!.path)));
      }

      if (communityCoverImage != null) {
        formData.files.add(MapEntry(
            'cover', await MultipartFile.fromFile(communityCoverImage!.path)));
      }

      final response =
          await _dio.put(ApiLink.editCommunity(slug), data: formData);

      if (response.statusCode == 200) {
        final apiResponse = response.data;
        if (apiResponse['success'] == true) {
          Get.Get.back();
          Helpers().showCustomSnackbar(
              message:
                  apiResponse['message'] ?? "Community edited successfully");
        } else {
          throw apiResponse['message'] ?? 'Failed to edit community';
        }
      } else {
        throw 'Failed to edit community';
      }
    } catch (err) {
      _handleApiError(err);
      debugPrint('Edit community error: $err');
    }
  }

  void clearProfilePhoto() {
    debugPrint('profile image cleared');
    mCommunityProfileImage.value = null;
  }

  void clearCoverPhoto() {
    debugPrint('cover image cleared');
    mCommunityCoverImage.value = null;
  }

  void clear() {
    communityNameController.clear();
    communityAbbrController.clear();
    communityBioController.clear();
    communityGameController.clear();
    communityChatController.clear();
  }
}
