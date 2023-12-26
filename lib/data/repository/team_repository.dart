// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:e_sport/data/model/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

enum TeamStatus {
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
  late final teamTitleController = TextEditingController();
  late final seeController = TextEditingController();
  late final engageController = TextEditingController();
  late final gameTagController = TextEditingController();
  late final accountTypeController = TextEditingController();

  final Rx<List<TeamModel>> _allTeam = Rx([]);
  final Rx<List<TeamModel>> _myTeam = Rx([]);
  List<TeamModel> get allTeam => _allTeam.value;
  List<TeamModel> get myTeam => _myTeam.value;

  final _teamStatus = TeamStatus.empty.obs;
  final _createTeamStatus = CreateTeamStatus.empty.obs;

  TeamStatus get teamStatus => _teamStatus.value;
  CreateTeamStatus get createTeamStatus => _createTeamStatus.value;

  Rx<File?> mTeamProfileImage = Rx(null);
  Rx<File?> mTeamCoverImage = Rx(null);
  File? get teamProfileImage => mTeamProfileImage.value;
  File? get teamCoverImage => mTeamCoverImage.value;

  @override
  void onInit() {
    super.onInit();
    authController.mToken.listen((p0) async {
      if (p0 != '0') {
        getAllTeam(true);
      }
    });
  }

  Future createTeam(TeamModel team) async {
    try {
      _createTeamStatus(CreateTeamStatus.loading);
      var headers = {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      };
      var request =
          http.MultipartRequest("POST", Uri.parse(ApiLink.createTeam));

      request.files.add(await http.MultipartFile.fromPath(
          'profile_picture', teamProfileImage!.path));
      request.files.add(
          await http.MultipartFile.fromPath('cover', teamCoverImage!.path));

      request.fields.addAll(
          team.toCreateTeamJson().map((key, value) => MapEntry(key, value)));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        _createTeamStatus(CreateTeamStatus.success);
        debugPrint(await response.stream.bytesToString());
        Get.to(() => const CreateSuccessPage(title: 'Team Created'))!
            .then((value) {
          getAllTeam(false);
          clear();
        });
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _createTeamStatus(CreateTeamStatus.error);
      } else {
        _createTeamStatus(CreateTeamStatus.error);
        debugPrint(response.reasonPhrase);
        handleError(response.reasonPhrase);
      }
    } catch (error) {
      _createTeamStatus(CreateTeamStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      handleError(error);
    }
  }

  Future getAllTeam(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        _teamStatus(TeamStatus.loading);
      }

      debugPrint('getting all team...');
      var response = await http.get(Uri.parse(ApiLink.getAllTeam), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (json['detail']);
      }

      if (response.statusCode == 200) {
        var list = List.from(json);
        var teams = list.map((e) => TeamModel.fromJson(e)).toList();
        debugPrint("${teams.length} teams found");
        _allTeam(teams);
        _teamStatus(TeamStatus.success);
        teams.isNotEmpty
            ? _teamStatus(TeamStatus.available)
            : _teamStatus(TeamStatus.empty);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _teamStatus(TeamStatus.error);
      }
      return response.body;
    } catch (error) {
      _teamStatus(TeamStatus.error);
      debugPrint("getting all team: ${error.toString()}");
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
    mTeamProfileImage.value = null;
  }

  void clearCoverPhoto() {
    debugPrint('image cleared');
    mTeamCoverImage.value = null;
  }

  void clear() {
    teamTitleController.clear();
    gameTagController.clear();
    seeController.clear();
  }
}
