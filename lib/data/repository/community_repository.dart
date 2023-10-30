import 'dart:io';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  late final postTextController = TextEditingController();
  late final seeController = TextEditingController();
  late final engageController = TextEditingController();
  late final gameTagController = TextEditingController();
  late final accountTypeController = TextEditingController();

  final _postStatus = CommunityStatus.empty.obs;
  final _createCommunityStatus = CreateCommunityStatus.empty.obs;

  CommunityStatus get postStatus => _postStatus.value;
  CreateCommunityStatus get createCommunityStatus =>
      _createCommunityStatus.value;

  Rx<File?> mCommunityProfileImage = Rx(null);
  Rx<File?> mCommunityCoverImage = Rx(null);
  File? get communityProfileImage => mCommunityProfileImage.value;
  File? get communityCoverImage => mCommunityCoverImage.value;

  void clearProfilePhoto() {
    debugPrint('image cleared');
    mCommunityProfileImage.value = null;
  }

  void clearCoverPhoto() {
    debugPrint('image cleared');
    mCommunityCoverImage.value = null;
  }
}
