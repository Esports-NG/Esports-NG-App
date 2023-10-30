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

  Rx<File?> mCommunityImage = Rx(null);
  File? get postImage => mCommunityImage.value;

  void clearPhoto() {
    debugPrint('image cleared');
    mCommunityImage.value = null;
  }
}
