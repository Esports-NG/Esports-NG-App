// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/games_repository.dart';
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

  final Rx<List<PlayerModel>> _allPlayer = Rx([]);
  final Rx<List<PlayerModel>> _myPlayer = Rx([]);
  List<PlayerModel> get allPlayer => _allPlayer.value;
  List<PlayerModel> get myPlayer => _myPlayer.value;

  final _playerStatus = PlayerStatus.empty.obs;
  final _createPlayerStatus = CreatePlayerStatus.empty.obs;

  PlayerStatus get playerStatus => _playerStatus.value;
  CreatePlayerStatus get createPlayerStatus => _createPlayerStatus.value;

  Rx<File?> mPlayerProfileImage = Rx(null);
  File? get playerProfileImage => mPlayerProfileImage.value;

  @override
  void onInit() {
    super.onInit();
    authController.mToken.listen((p0) async {
      if (p0 != '0') {
        getAllPlayer(true);
      }
    });
  }

  Future createPlayer(PlayerModel player) async {
    try {
      _createPlayerStatus(CreatePlayerStatus.loading);
      var headers = {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      };
      var request =
          http.MultipartRequest("POST", Uri.parse(ApiLink.createPlayer));

      request.fields.addAll(player
          .toCreatePlayerJson()
          .map((key, value) => MapEntry(key, value)));
      request.fields['igames'] = player.gamePlayed!.id.toString();
      if (playerProfileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile', playerProfileImage!.path));
        request.headers.addAll(headers);
      }
      EasyLoading.show();
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        _createPlayerStatus(CreatePlayerStatus.success);
        debugPrint(await response.stream.bytesToString());
        EasyLoading.showSuccess("Player Created");
        Get.to(() => const CreateSuccessPage(title: 'Player Created'))!
            .then((value) {
          getAllPlayer(false);
          clear();
        });
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _createPlayerStatus(CreatePlayerStatus.error);
      } else {
        _createPlayerStatus(CreatePlayerStatus.error);
        debugPrint(response.reasonPhrase);
        handleError(response.reasonPhrase);
      }
    } catch (error) {
      _createPlayerStatus(CreatePlayerStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      handleError(error);
    }
  }

  Future getAllPlayer(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        _playerStatus(PlayerStatus.loading);
      }

      debugPrint('getting all player...');
      var response = await http.get(Uri.parse(ApiLink.getAllPlayer), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (json['detail']);
      }

      if (response.statusCode == 200) {
        var list = List.from(json);
        var players = list.map((e) => PlayerModel.fromJson(e)).toList();
        debugPrint("${players.length} players found");
        _allPlayer(players);
        _playerStatus(PlayerStatus.success);
        players.isNotEmpty
            ? _playerStatus(PlayerStatus.available)
            : _playerStatus(PlayerStatus.empty);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _playerStatus(PlayerStatus.error);
      }
      return response.body;
    } catch (error) {
      _playerStatus(PlayerStatus.error);
      debugPrint("getting all player: ${error.toString()}");
    }
  }

  Future editPlayerProfile(int id, Map<String, dynamic> data) async {
    var headers = {
      "Authorization": "JWT ${authController.token}",
      "Content-type": "application/json"
    };
    try {
      var request =
          http.MultipartRequest("PUT", Uri.parse(ApiLink.editPlayer(id)))
            ..fields["in_game_id"] = data["in_game_id"]
            ..fields["in_game_name"] = data["in_game_name"];

      if (playerProfileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile', playerProfileImage!.path));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      // var body = await http.Response.fromStream(response);
      // print(body.body);
      if (response.statusCode == 200) {
        Get.back();
        Helpers().showCustomSnackbar(message: "Player Profile edited");
      }
    } catch (error) {
      print(error);
    }
  }

  void handleError(dynamic error) {
    debugPrint("error $error");
    Fluttertoast.showToast(
        fontSize: Get.height * 0.015,
        msg: (error.toString().contains("esports-ng.vercel.app") ||
                error.toString().contains("Network is unreachable"))
            ? 'Team like: No internet connection!'
            : (error.toString().contains("FormatException"))
                ? 'Team like: Internal server error, contact admin!'
                : error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
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
}
