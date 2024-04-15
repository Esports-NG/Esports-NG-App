// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      request.files.add(await http.MultipartFile.fromPath(
          'profile', playerProfileImage!.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        _createPlayerStatus(CreatePlayerStatus.success);
        debugPrint(await response.stream.bytesToString());
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

  void clearProfilePhoto() {
    debugPrint('image cleared');
    mPlayerProfileImage.value = null;
  }

  void clear() {
    gameIdController.clear();
    gameNameController.clear();
  }
}
