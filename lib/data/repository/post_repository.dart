import 'dart:io';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PostStatus {
  loading,
  success,
  error,
  empty,
  available,
}

enum CreatePostStatus {
  loading,
  success,
  error,
  empty,
}

class PostRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  late final postTextController = TextEditingController();
  late final seeController = TextEditingController();
  late final engageController = TextEditingController();
  late final gameTagController = TextEditingController();
  late final accountTypeController = TextEditingController();

  final _postStatus = PostStatus.empty.obs;
  final _createPostStatus = CreatePostStatus.empty.obs;

  PostStatus get postStatus => _postStatus.value;
  CreatePostStatus get createPostStatus => _createPostStatus.value;

  Rx<File?> mPostImage = Rx(null);
  File? get postImage => mPostImage.value;

  void clearPhoto() {
    debugPrint('image cleared');
    mPostImage.value = null;
  }
}
