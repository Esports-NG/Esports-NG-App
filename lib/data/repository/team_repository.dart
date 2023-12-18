import 'dart:io';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:flutter/material.dart';
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
        // getTeams(true);
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

      request.fields.addAll(
          team.toCreateTeamJson().map((key, value) => MapEntry(key, value)));
      request.files.add(
          await http.MultipartFile.fromPath('image', teamProfileImage!.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        _createTeamStatus(CreateTeamStatus.success);
        debugPrint(await response.stream.bytesToString());
        Get.to(() => const CreateSuccessPage(title: 'Team Created'))!
            .then((value) {
          // getTeams(false);
          clear();
        });
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
