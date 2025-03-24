// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/user_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

class CommunityRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  late final communityNameController = TextEditingController();
  late final communityAbbrController = TextEditingController();
  late final communityBioController = TextEditingController();
  late final communityGameController = TextEditingController();
  late final communityChatController = TextEditingController();
  late final searchController = TextEditingController();

  final Rx<List<CommunityModel>> _allCommunity = Rx([]);
  final Rx<List<CommunityModel>> _myCommunity = Rx([]);
  List<CommunityModel> get allCommunity => _allCommunity.value;
  List<CommunityModel> get myCommunity => _myCommunity.value;

  final RxList<CommunityModel> searchedCommunities = <CommunityModel>[].obs;

  RxList<UserModel> suggestedProfiles = RxList([]);

  final _communityStatus = CommunityStatus.empty.obs;
  final _createCommunityStatus = CreateCommunityStatus.empty.obs;

  CommunityStatus get communityStatus => _communityStatus.value;
  CreateCommunityStatus get createCommunityStatus =>
      _createCommunityStatus.value;

  Rx<File?> mCommunityProfileImage = Rx(null);
  Rx<File?> mCommunityCoverImage = Rx(null);
  File? get communityProfileImage => mCommunityProfileImage.value;
  File? get communityCoverImage => mCommunityCoverImage.value;
  final RxList<OverlayPortalController> currentOverlay =
      <OverlayPortalController>[].obs;
  Rx<String> typeFilter = RxString("All");

  Rx<GamePlayed?> addToGamesPlayedValue = Rx(null);

  void hideAllOverlays() {
    if (currentOverlay.isNotEmpty) {
      for (var element in currentOverlay) {
        element.hide();
      }
      currentOverlay.clear();
    }
  }

  @override
  void onInit() {
    super.onInit();
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

  Future createCommunity(Map<String, dynamic> community) async {
    try {
      print(community);
      _createCommunityStatus(CreateCommunityStatus.loading);
      var headers = {"Authorization": 'JWT ${authController.token}'};
      var request =
          http.MultipartRequest("POST", Uri.parse(ApiLink.createCommunity))
            ..fields["name"] = communityNameController.text
            ..fields["bio"] = communityBioController.text
            ..fields["abbrev"] = communityAbbrController.text;
      if (communityProfileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'logo', communityProfileImage!.path));
      }

      if (communityCoverImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'cover', communityCoverImage!.path));
      }

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      // var res = await response.stream.bytesToString();
      // print(res);
      if (response.statusCode == 201) {
        _createCommunityStatus(CreateCommunityStatus.success);
        debugPrint(await response.stream.bytesToString());
        Get.to(() => const CreateSuccessPage(title: 'Community Created'))!
            .then((value) {
          getAllCommunity(false);
          clear();
        });
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _createCommunityStatus(CreateCommunityStatus.error);
      } else {
        _createCommunityStatus(CreateCommunityStatus.error);
        debugPrint(response.reasonPhrase);
        handleError(response.reasonPhrase);
      }
    } catch (error) {
      _createCommunityStatus(CreateCommunityStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      handleError(error);
    }
  }

  Future getAllCommunity(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        _communityStatus(CommunityStatus.loading);
      }

      debugPrint('getting all community...');
      var response =
          await http.get(Uri.parse(ApiLink.getAllCommunity), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });
      var json = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (json['detail']);
      }

      if (response.statusCode == 200) {
        var list = List.from(json);
        var communitys = list.map((e) => CommunityModel.fromJson(e)).toList();
        debugPrint("${communitys.length} communitys found");
        _allCommunity(communitys);
        _communityStatus(CommunityStatus.success);
        communitys.isNotEmpty
            ? _communityStatus(CommunityStatus.available)
            : _communityStatus(CommunityStatus.empty);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _communityStatus(CommunityStatus.error);
      }
      return response.body;
    } catch (error) {
      _communityStatus(CommunityStatus.error);
      debugPrint("getting all community: ${error.toString()}");
    }
  }

  Future<CommunityModel> getCommunityData(int id) async {
    var response = await http.get(
        Uri.parse(ApiLink.getDataWithFollowers(id: id, type: "community")),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT ${authController.token}'
        });

    var json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw (json['detail']);
    }

    return CommunityModel.fromJson(json);
  }

  Future<List<Map<String, dynamic>>> getCommunityFollowers(int id) async {
    var response =
        await http.get(Uri.parse(ApiLink.getCommunityFollowers(id)), headers: {
      "Content-Type": "application/json",
      "Authorization": 'JWT ${authController.token}'
    });

    List<dynamic> json = jsonDecode(response.body);

    return json.map((e) => e as Map<String, dynamic>).toList();
  }

  Future getSuggestedProfiles() async {
    var response =
        await http.get(Uri.parse(ApiLink.getSuggestedUsers), headers: {
      "Content-type": "application/json",
      "Authorization": "JWT ${authController.token}"
    });
    var json = jsonDecode(response.body);
    var list = List.from(json);

    suggestedProfiles
        .assignAll(list.map((e) => UserModel.fromJson(e)).toList());
  }

  Future addGameToCommunity(int commId) async {
    try {
      var response = await http.post(
          Uri.parse(ApiLink.addGameToCommunity(
              commId, addToGamesPlayedValue.value!.id!)),
          headers: {
            "Content-type": "application/json",
            "Authorization": "JWT ${authController.token}"
          });

      var json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Helpers().showCustomSnackbar(
            message: json['message'] != null
                ? "Game added to community"
                : json['error']);
        getAllCommunity(false);
      } else {}
    } catch (err) {
      debugPrint('adding game to community error: $err');
    }
  }

  Future blockCommunity(int id) async {
    var response =
        await http.post(Uri.parse(ApiLink.blockCommunity(id)), headers: {
      "Content-type": "application/json",
      "Authorization": "JWT ${authController.token}"
    });
    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Helpers().showCustomSnackbar(message: "Community blocked");
    } else {
      Helpers().showCustomSnackbar(message: json['error']);
    }
  }

  Future editCommunity(int id, Map<String, dynamic> data) async {
    try {
      var headers = {
        "Authorization": "JWT ${authController.token}",
        "Content-type": "application/json"
      };

      var request =
          http.MultipartRequest("PUT", Uri.parse(ApiLink.editCommunity(id)))
            ..fields["name"] = data["name"]
            ..fields["bio"] = data["bio"]
            ..fields["abbrev"] = data["abbrev"];

      if (communityProfileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_picture', communityProfileImage!.path));
      }
      if (communityCoverImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'cover', communityCoverImage!.path));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Get.back();
        Helpers().showCustomSnackbar(message: "Community edited successfully");
      } else {
        Helpers().showCustomSnackbar(
            message: "An error occurred. Please try again.");
      }
    } catch (err) {
      Helpers()
          .showCustomSnackbar(message: "An error occurred. Please try again.");
      print(err);
    }
  }

  void handleError(dynamic error) {
    debugPrint("error $error");
    Fluttertoast.showToast(
        fontSize: Get.height * 0.015,
        msg: (error.toString().contains("esports-ng.vercel.app") ||
                error.toString().contains("Network is unreachable"))
            ? 'Community like: No internet connection!'
            : (error.toString().contains("FormatException"))
                ? 'Community like: Internal server error, contact admin!'
                : error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  void clearProfilePhoto() {
    debugPrint('image cleared');
    mCommunityProfileImage.value = null;
  }

  void clearCoverPhoto() {
    debugPrint('image cleared');
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
