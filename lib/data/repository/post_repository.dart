// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
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

  Future createPost(BuildContext context) async {
    try {
      _createPostStatus(CreatePostStatus.loading);
      var response = await http
          .post(Uri.parse(ApiLink.register), body: jsonEncode({}), headers: {
        "Content-Type": "application/json",
      });
      var json = jsonDecode(response.body);
      debugPrint(response.statusCode.toString() + response.body);

      if (response.statusCode != 201) {
        throw (json['profile'] != null
            ? json['profile'][0]
            : json.toString().replaceAll('{', '').replaceAll('}', ''));
      }

      if (response.statusCode == 201) {
        _createPostStatus(CreatePostStatus.success);
        EasyLoading.showInfo(
                'Account created successfully!\nConfirmation email sent, Please check your email for further instructions!',
                duration: const Duration(seconds: 2))
            .then((value) async {
          await Future.delayed(const Duration(seconds: 2));

          clearPhoto();
        });
      }

      return response.body;
    } catch (error) {
      _createPostStatus(CreatePostStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      noInternetError(context, error);
    }
  }

  void noInternetError(BuildContext context, var error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(
          title: (error.toString().contains("esports-ng.vercel.app") ||
                  error.toString().contains("Network is unreachable"))
              ? 'No internet connection!'
              : (error.toString().contains("FormatException"))
                  ? 'Internal server error, contact admin!'
                  : error.toString(),
          size: Get.height * 0.02,
          color: AppColor().primaryWhite,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  void clearPhoto() {
    debugPrint('image cleared');
    mPostImage.value = null;
  }
}
