import 'dart:io';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
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
  late final postTitleController = TextEditingController();
  late final seeController = TextEditingController();
  late final engageController = TextEditingController();
  late final gameTagController = TextEditingController();
  late final accountTypeController = TextEditingController();

  final _postStatus = TeamStatus.empty.obs;
  final _createTeamStatus = CreateTeamStatus.empty.obs;

  TeamStatus get postStatus => _postStatus.value;
  CreateTeamStatus get createTeamStatus => _createTeamStatus.value;

  Rx<File?> mTeamProfileImage = Rx(null);
  Rx<File?> mTeamCoverImage = Rx(null);
  File? get teamProfileImage => mTeamProfileImage.value;
  File? get teamCoverImage => mTeamCoverImage.value;

  void clearProfilePhoto() {
    debugPrint('image cleared');
    mTeamProfileImage.value = null;
  }

  void clearCoverPhoto() {
    debugPrint('image cleared');
    mTeamCoverImage.value = null;
  }
}
