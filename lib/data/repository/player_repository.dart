// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/utils/create_success_page.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/api_helpers.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

enum PlayerStatus {
  loading,
  success,
  error,
  empty,
  available,
}

enum CreatePlayerStatus {
  loading,
  success,
  error,
  empty,
}

class PlayerRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  final gamesController = Get.put(GamesRepository());
  late final gameIdController = TextEditingController();
  late final gameNameController = TextEditingController();
  late final searchController = TextEditingController();
  final _dio = dio.Dio(); // Create a Dio instance

  final Rx<List<PlayerModel>> _allPlayer = Rx([]);
  final RxList<PlayerModel> myPlayer = RxList([]);
  List<PlayerModel> get allPlayer => _allPlayer.value;

  final _playerStatus = PlayerStatus.empty.obs;
  final _createPlayerStatus = CreatePlayerStatus.empty.obs;

  PlayerStatus get playerStatus => _playerStatus.value;
  CreatePlayerStatus get createPlayerStatus => _createPlayerStatus.value;

  Rx<File?> mPlayerProfileImage = Rx(null);
  File? get playerProfileImage => mPlayerProfileImage.value;

  @override
  void onInit() {
    super.onInit();
    // Configure Dio defaults
    _dio.options.validateStatus = (status) => true; // Accept all status codes
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    authController.mToken.listen((p0) async {
      if (p0 != '0') {
        getAllPlayer(true);
      }
    });
  }

  Future createPlayer(PlayerModel player) async {
    try {
      _createPlayerStatus(CreatePlayerStatus.loading);

      final formData = dio.FormData.fromMap({
        ...player.toCreatePlayerJson(),
        'igames': player.gamePlayed!.id.toString(),
        if (playerProfileImage != null)
          'profile': await dio.MultipartFile.fromFile(playerProfileImage!.path),
      });

      final options = dio.Options(
          headers: {"Authorization": 'JWT ${authController.token}'});

      final response = await _dio.post(
        ApiLink.createPlayer,
        data: formData,
        options: options,
      );

      final responseData = response.data;

      if (response.statusCode == 201) {
        _createPlayerStatus(CreatePlayerStatus.success);
        debugPrint(responseData.toString());

        Get.off(() => const CreateSuccessPage(title: 'Player Created'))!
            .then((value) {
          getAllPlayer(false);
          getMyPlayer();
          clear();
        });
      } else if (response.statusCode == 401) {
        authController.refreshToken();
        _createPlayerStatus(CreatePlayerStatus.error);
      } else {
        _createPlayerStatus(CreatePlayerStatus.error);
        debugPrint(responseData['message'] ?? response.statusMessage);
        handleError(responseData['message'] ?? response.statusMessage);
      }
    } catch (error) {
      _createPlayerStatus(CreatePlayerStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      handleError(error);
    }
  }

  Future getMyPlayer() async {
    try {
      final options = dio.Options(headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });

      final response = await _dio.get(
        "${ApiLink.getAllPlayer}?q=profiles",
        options: options,
      );
      print(response.data);
      var responseData = response.data["data"];
      var players = List<PlayerModel>.from(
          responseData.map((x) => PlayerModel.fromJson(x)));
      myPlayer.assignAll(players);
    } on dio.DioException catch (err) {
      if (err.response?.data) {
        print(err.response?.data);
      }
    } catch (err) {
      print(err);
    }
  }

  Future<PlayerModel?> getProfile(String slug) async {
    try {
      final options = dio.Options(headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });

      final response = await _dio.get(
        "${ApiLink.getAllPlayer}?p_s=$slug",
        options: options,
      );
      var responseData = response.data['data'];
      return PlayerModel.fromJson(responseData);
    } on dio.DioException catch (err) {
      if (err.response?.data) {
        print(err.response?.data);
      }
    }
    return null;
  }

  Future getAllPlayer(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        _playerStatus(PlayerStatus.loading);
      }

      debugPrint('getting all player...');

      final options = dio.Options(headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });

      final response = await _dio.get(
        ApiLink.getAllPlayer,
        options: options,
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          var list = List.from(responseData['data']);
          var players = list.map((e) => PlayerModel.fromJson(e)).toList();
          debugPrint("${players.length} players found");
          _allPlayer(players);

          players.isNotEmpty
              ? _playerStatus(PlayerStatus.available)
              : _playerStatus(PlayerStatus.empty);
        } else {
          _playerStatus(PlayerStatus.error);
          handleError(responseData['message'] ?? 'Failed to load players');
        }
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _playerStatus(PlayerStatus.error);
      } else {
        _playerStatus(PlayerStatus.error);
        handleError(responseData['message'] ?? response.statusMessage);
      }
      return responseData;
    } catch (error) {
      _playerStatus(PlayerStatus.error);
      debugPrint("getting all player: ${error.toString()}");
      handleError(error);
      return null;
    }
  }

  Future editPlayerProfile(String slug, Map<String, dynamic> data) async {
    try {
      final formData = dio.FormData.fromMap({
        "in_game_id": data["in_game_id"],
        "in_game_name": data["in_game_name"],
        if (playerProfileImage != null)
          'profile': await dio.MultipartFile.fromFile(playerProfileImage!.path),
      });

      final options = dio.Options(
          headers: {"Authorization": "JWT ${authController.token}"});

      final response = await _dio.put(
        ApiLink.editPlayer(slug),
        data: formData,
        options: options,
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          Get.back();
          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? "Player Profile edited");
          getAllPlayer(false); // Refresh the player list
        } else {
          handleError(
              responseData['message'] ?? "Failed to edit player profile");
        }
      } else if (response.statusCode == 401) {
        authController.refreshToken();
      } else {
        handleError(responseData['message'] ?? response.statusMessage);
      }
    } catch (error) {
      debugPrint("Error editing player: ${error.toString()}");
      handleError(error);
    }
  }

  Future deletePlayerProfile(String slug) async {
    try {
      final options = dio.Options(
          headers: {"Authorization": "JWT ${authController.token}"});

      final response = await _dio.delete(
        ApiLink.deletePlayer(slug),
        options: options,
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          Get.back();
          Helpers().showCustomSnackbar(
              message: responseData['message'] ?? "Player Profile Deleted");
          getAllPlayer(false); // Refresh the player list
        } else {
          handleError(
              responseData['message'] ?? "Failed to delete player profile");
        }
      } else if (response.statusCode == 401) {
        authController.refreshToken();
      } else {
        handleError(responseData['message'] ?? response.statusMessage);
      }
    } catch (error) {
      debugPrint("Error deleting player: ${error.toString()}");
      handleError(error);
    }
  }

  void handleError(dynamic error) {
    ApiHelpers.handleApiError(error);
  }

  Future pickImageFromCamera(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      mPlayerProfileImage(imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  Future pickImageFromGallery(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);

      mPlayerProfileImage(imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  void clearProfilePhoto() {
    debugPrint('image cleared');
    mPlayerProfileImage.value = null;
  }

  void clear() {
    clearProfilePhoto();
    gameIdController.clear();
    gameNameController.clear();
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
              playerProfileImage != null
                  ? Container(
                      height: Get.height * 0.08,
                      width: Get.height * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: FileImage(playerProfileImage!),
                            fit: BoxFit.cover),
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/images/svg/photo.svg',
                      height: Get.height * 0.08,
                    ),
              Gap(Get.height * 0.01),
              InkWell(
                onTap: onTap,
                child: CustomText(
                  title:
                      playerProfileImage == null ? 'Click to upload' : 'Cancel',
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
}
