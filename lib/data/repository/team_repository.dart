// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/roaster_model.dart';
import 'package:e_sport/data/model/team/team_inbox_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/utils/create_success_page.dart';
import 'package:e_sport/util/api_helpers.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

// Simple API client to handle form data requests
class ApiClient {
  final _dio = dio.Dio();

  Future<ApiResponse> postFormData(String url,
      {required dio.FormData formData}) async {
    try {
      final authRepo = Get.find<AuthRepository>();
      final response = await _dio.post(
        url,
        data: formData,
        options: dio.Options(
          headers: {"Authorization": "JWT ${authRepo.token}"},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        return ApiResponse(
          success: responseData['success'] ?? false,
          message: responseData['message'] ?? 'Request completed',
          data: responseData['data'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });
}

enum TeamStatus {
  loading,
  success,
  error,
  empty,
  available,
}

enum TeamInboxStatus {
  loading,
  success,
  error,
  empty,
  available,
}

enum MyTeamStatus {
  loading,
  success,
  error,
  empty,
  available,
}

enum CreateTeamStatus {
  loading,
  success,
  error,
  empty,
}

class TeamRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  late final teamNameController = TextEditingController();
  late final teamBioController = TextEditingController();
  final teamAbbrevController = TextEditingController();
  late final seeController = TextEditingController();
  late final engageController = TextEditingController();
  late final gameTagController = TextEditingController();
  late final accountTypeController = TextEditingController();

  final Rx<List<TeamModel>> _allTeam = Rx([]);
  final Rx<List<TeamModel>?> _myTeam = Rx([]);
  final Rx<TeamInboxModel?> _teamInbox = Rx(null);

  final RxList<TeamModel> searchedTeams = <TeamModel>[].obs;

  List<TeamModel> get allTeam => _allTeam.value;
  List<TeamModel> get myTeam => _myTeam.value!;
  TeamInboxModel? get teamInbox => _teamInbox.value;

  // apply to team controller
  TextEditingController teamRole = TextEditingController();
  TextEditingController teamJoinReason = TextEditingController();
  RxBool includeGamerProfile = true.obs;
  RxBool shareTeamHistory = false.obs;
  Rx<GamePlayed?> addToRosterGame = null.obs;
  RxList<GamePlayed> gamesPlayed = <GamePlayed>[].obs;

  MultiSelectController<GamePlayed> gamesPlayedController =
      MultiSelectController<GamePlayed>();

  OverlayPortalController gameChipOverlayController = OverlayPortalController();
  TextEditingController gameSearchController = TextEditingController();
  Rx<GamePlayed?> addToGamesPlayedValue = Rx(null);

  void hideGameChip() {
    gameChipOverlayController.hide();
  }

  void addToGamesPlayed(GamePlayed game) {
    if (gamesPlayed.contains(game)) {
      gamesPlayed.remove(game);
    } else {
      gamesPlayed.add(game);
    }
  }

  final _teamStatus = TeamStatus.empty.obs;
  final _teamInboxStatus = TeamInboxStatus.empty.obs;
  final _myTeamStatus = MyTeamStatus.empty.obs;
  final _createTeamStatus = CreateTeamStatus.empty.obs;

  TeamStatus get teamStatus => _teamStatus.value;
  TeamInboxStatus get teamInboxStatus => _teamInboxStatus.value;
  MyTeamStatus get myTeamStatus => _myTeamStatus.value;
  CreateTeamStatus get createTeamStatus => _createTeamStatus.value;

  Rx<File?> mTeamProfileImage = Rx(null);
  Rx<File?> mTeamCoverImage = Rx(null);
  File? get teamProfileImage => mTeamProfileImage.value;
  File? get teamCoverImage => mTeamCoverImage.value;

  // Single Dio instance for all API calls
  final _dio = dio.Dio();

  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    // Configure Dio with default headers
    _dio.options.headers = {"Content-Type": "application/json"};
    _dio.options.receiveTimeout = Duration(seconds: 40);

    // Update auth token when it changes
    authController.mToken.listen((token) async {
      if (token != '0') {
        _dio.options.headers["Authorization"] = "JWT $token";
        getAllTeam(true);
        getMyTeam(true);
      }
    });
  }

  Future<void> createTeam() async {
    try {
      _createTeamStatus(CreateTeamStatus.loading);

      final formData = dio.FormData.fromMap({
        "name": teamNameController.text,
        "bio": teamBioController.text,
        "abbrev": teamAbbrevController.text,
      });

      if (teamProfileImage != null) {
        formData.files.add(MapEntry(
          'profile_picture',
          await dio.MultipartFile.fromFile(teamProfileImage!.path),
        ));
      }

      if (teamCoverImage != null) {
        formData.files.add(MapEntry(
          'cover',
          await dio.MultipartFile.fromFile(teamCoverImage!.path),
        ));
      }

      final response =
          await _apiClient.postFormData(ApiLink.createTeam, formData: formData);

      if (response.success) {
        _createTeamStatus(CreateTeamStatus.success);
        debugPrint("Team created successfully: ${response.message}");
        Get.to(() => const CreateSuccessPage(title: 'Team Created'))!
            .then((value) {
          getAllTeam(false);
          clear();
        });
      } else {
        _createTeamStatus(CreateTeamStatus.error);
        handleError(response.message);
      }
    } catch (error) {
      _createTeamStatus(CreateTeamStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      handleError(error);
    }
  }

  Future getAllTeam(bool isFirstTime) async {
    try {
      _teamStatus(TeamStatus.loading);
      debugPrint('getting all team...');

      final response = await _dio.get(
        ApiLink.getAllTeam,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;
        print(response.data);

        if (success) {
          final data = responseData['data']['results'] ?? [];
          var teams = (data as List).map((e) => TeamModel.fromJson(e)).toList();
          debugPrint("${teams.length} teams found");
          _allTeam(teams);
          teams.isNotEmpty
              ? _teamStatus(TeamStatus.available)
              : _teamStatus(TeamStatus.empty);
        } else {
          _teamStatus(TeamStatus.error);
          handleError(responseData['message'] ?? 'Unknown error occurred');
        }
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _teamStatus(TeamStatus.error);
      } else {
        _teamStatus(TeamStatus.error);
        handleError(response.statusMessage);
      }
      return response.data;
    } on dio.DioException catch (error) {
      _teamStatus(TeamStatus.error);
      if (error.response?.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
      } else {
        debugPrint("Error occurred ${error.message}");
        handleError(error.message);
      }
    } catch (error) {
      _teamStatus(TeamStatus.error);
      debugPrint("getting all team: ${error.toString()}");
      handleError(error);
    }
    return null;
  }

  Future getMyTeam(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        _myTeamStatus(MyTeamStatus.loading);
      }

      final response = await _dio.get(
        ApiLink.getMyTeam,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          final data = responseData['data'] ?? [];
          var teams = (data as List).map((e) => TeamModel.fromJson(e)).toList();
          debugPrint("${teams.length} teams found");
          _myTeam(teams);
          teams.isNotEmpty
              ? _myTeamStatus(MyTeamStatus.available)
              : _myTeamStatus(MyTeamStatus.empty);
        } else {
          _myTeamStatus(MyTeamStatus.error);
          handleError(responseData['message'] ?? 'Unknown error occurred');
        }
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _myTeamStatus(MyTeamStatus.error);
      }
      return response.data;
    } on dio.DioException catch (error) {
      _myTeamStatus(MyTeamStatus.error);
      if (error.response?.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
      } else {
        debugPrint("Getting my team error: ${error.message}");
        handleError(error.message);
      }
    } catch (error) {
      debugPrint("Getting my team error: ${error.toString()}");
      _myTeamStatus(MyTeamStatus.error);
      handleError(error);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getTeamFollowers(String slug) async {
    try {
      final response = await _dio.get(
        ApiLink.getTeamFollowers(slug),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          final data = responseData['data'] ?? [];
          return (data as List).map((e) => e as Map<String, dynamic>).toList();
        } else {
          handleError(responseData['message'] ?? 'Unknown error occurred');
        }
      }
    } on dio.DioException catch (error) {
      print(error.response?.data);
      if (error.response?.statusCode == 401) {
        authController
            .refreshToken()
            .then((_) => EasyLoading.showInfo('try again!'));
      } else {
        handleError(error.message);
      }
    } catch (error) {
      handleError(error);
    }
    return [];
  }

  Future getTeamInbox(bool isFirstTime, int teamId) async {
    try {
      if (isFirstTime == true) {
        _teamInboxStatus(TeamInboxStatus.loading);
      }

      debugPrint('getting team inbox...');
      final response = await _dio.get(
        '${ApiLink.team}$teamId/inbox',
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          final data = responseData['data'];
          var teamInboxItem = TeamInboxModel.fromJson(data);
          _teamInbox(teamInboxItem);
          _teamInboxStatus(TeamInboxStatus.success);
        } else {
          _teamInboxStatus(TeamInboxStatus.error);
          handleError(responseData['message'] ?? 'Unknown error occurred');
        }
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _teamInboxStatus(TeamInboxStatus.error);
      }
      return response.data;
    } on dio.DioException catch (error) {
      _teamInboxStatus(TeamInboxStatus.error);
      if (error.response?.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
      } else {
        debugPrint("Getting team inbox error: ${error.message}");
        handleError(error.message);
      }
    } catch (error) {
      debugPrint("getting team inbox: ${error.toString()}");
      _teamInboxStatus(TeamInboxStatus.error);
      handleError(error);
    }
    return null;
  }

  Future addGameToTeam(int teamId) async {
    try {
      final response = await _dio.post(
        ApiLink.addGameToTeam(teamId, addToGamesPlayedValue.value!.id!),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          final body = {"game_id": addToGamesPlayedValue.value!.id};

          final rosterResponse = await _dio.post(
            ApiLink.createRosterForGame(teamId),
            data: body,
          );

          if (rosterResponse.statusCode == 200) {
            final rosterData = rosterResponse.data;
            final rosterSuccess = rosterData['success'] ?? false;

            if (rosterSuccess) {
              Helpers().showCustomSnackbar(
                  message: "Successfully added game to team");
              getMyTeam(true);
            } else {
              handleError(rosterData['message'] ?? 'Failed to create roster');
            }
          }
        } else {
          handleError(responseData['message'] ?? 'Failed to add game to team');
        }
      }
    } on dio.DioException catch (error) {
      debugPrint("Adding game to team error: ${error.message}");
      handleError(error.message);
    } catch (err) {
      debugPrint("Adding game to team error: ${err.toString()}");
      handleError(err);
    }
  }

  Future applyAsPlayer(int teamId) async {
    try {
      final body = {
        "iteam": teamId,
        "igames": gamesPlayedController.selectedItems
            .map((e) => e.value.id!)
            .toList(),
        "message": teamJoinReason.text,
        "role": teamRole.text
      };

      final response = await _dio.post(
        ApiLink.sendTeamApplication,
        data: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          Helpers().showCustomSnackbar(message: "Application sent");
        } else {
          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? 'Unknown error occurred');
        }
      }
    } on dio.DioException catch (error) {
      debugPrint("Team application error: ${error.message}");
      handleError(error.message);
    } catch (error) {
      debugPrint("Team application error: $error");
      handleError(error);
    }
  }

  Future<List<TeamApplicationModel>?> getTeamApplications(int id) async {
    try {
      final response = await _dio.get(
        ApiLink.getTeamApplications(id),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          final data = responseData['data'] ?? [];
          return teamApplicationModelFromJson(jsonEncode(data));
        }
      }
    } on dio.DioException catch (error) {
      debugPrint("Get team applications error: ${error.message}");
      handleError(error.message);
    } catch (error) {
      debugPrint("Get team applications error: $error");
      handleError(error);
    }
    return null;
  }

  Future takeActionOnApplication(int id, String action, int teamId) async {
    try {
      final response = await _dio.put(
        ApiLink.respondToApplication(id, teamId, action),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? 'Action taken successfully');
        } else {
          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? 'Failed to take action');
        }
      }
    } on dio.DioException catch (error) {
      debugPrint("Action on application error: ${error.message}");
      handleError(error.message);
    } catch (error) {
      debugPrint("Action on application error: $error");
      handleError(error);
    }
  }

  Future<List<RoasterModel>> getTeamRoster(int teamId) async {
    try {
      final response = await _dio.get(
        ApiLink.getRosters(teamId),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          final data = responseData['data'] ?? [];
          return roasterModelFromJson(jsonEncode(data));
        }
      }
    } on dio.DioException catch (error) {
      debugPrint("Get team roster error: ${error.message}");
      handleError(error.message);
    } catch (error) {
      debugPrint("Get team roster error: $error");
      handleError(error);
    }
    return [];
  }

  Future addPlayerToRoster(teamId, playerId, rosterId) async {
    try {
      final response = await _dio.put(
        ApiLink.addToRoster(teamId, playerId, rosterId),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? 'Player added to roster');
        } else {
          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? 'Failed to add player');
        }
      }
    } on dio.DioException catch (error) {
      debugPrint("Add player to roster error: ${error.message}");
      handleError(error.message);
    } catch (error) {
      debugPrint("Add player to roster error: $error");
      handleError(error);
    }
  }

  Future blockTeam(int id) async {
    try {
      final response = await _dio.post(
        ApiLink.blockTeam(id),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? 'Team blocked');
        } else {
          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? 'Failed to block team');
        }
      }
    } on dio.DioException catch (error) {
      debugPrint("Block team error: ${error.message}");
      handleError(error.message);
    } catch (error) {
      debugPrint("Block team error: $error");
      handleError(error);
    }
  }

  Future editTeam(int id, Map<String, dynamic> data) async {
    try {
      final formData = dio.FormData.fromMap({
        "name": data["name"],
        "bio": data["bio"],
        "abbrev": data["abbrev"],
      });

      if (teamProfileImage != null) {
        formData.files.add(MapEntry(
          'profile_picture',
          await dio.MultipartFile.fromFile(teamProfileImage!.path),
        ));
      }

      if (teamCoverImage != null) {
        formData.files.add(MapEntry(
          'cover',
          await dio.MultipartFile.fromFile(teamCoverImage!.path),
        ));
      }

      final response = await _dio.put(
        ApiLink.editTeam(id),
        data: formData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final success = responseData['success'] ?? false;

        if (success) {
          getMyTeam(false);
          Get.back();
          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? "Team edited successfully");
        } else {
          Helpers().showCustomSnackbar(
              message: responseData['message'] ??
                  "An error occurred. Please try again.");
        }
      } else {
        Helpers().showCustomSnackbar(
            message: "An error occurred. Please try again.");
      }
    } on dio.DioException catch (error) {
      debugPrint("Edit team error: ${error.message}");
      Helpers()
          .showCustomSnackbar(message: "An error occurred. Please try again.");
    } catch (err) {
      debugPrint("Edit team error: $err");
      Helpers()
          .showCustomSnackbar(message: "An error occurred. Please try again.");
    }
  }

  // Updating error handler to use the centralized API helper
  void handleError(dynamic error) {
    ApiHelpers.handleApiError(error);
  }

  void clearProfilePhoto() {
    debugPrint('image cleared');
    mTeamProfileImage.value = null;
  }

  void clearCoverPhoto() {
    debugPrint('image cleared');
    mTeamCoverImage.value = null;
  }

  void clear() {
    teamNameController.clear();
    teamAbbrevController.clear();
    teamBioController.clear();
    gameTagController.clear();
    seeController.clear();
  }
}
