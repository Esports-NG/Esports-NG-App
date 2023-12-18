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
  late final postTitleController = TextEditingController();
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

  @override
  void onInit() {
    super.onInit();
    authController.mToken.listen((p0) async {
      if (p0 != '0') {
        // getPosts(true);
      }
    });
  }

  //  Future createPost(PostModel post) async {
  //   try {
  //     _createPostStatus(CreatePostStatus.loading);
  //     var headers = {
  //       "Content-Type": "application/json",
  //       "Authorization": 'JWT ${authController.token}'
  //     };
  //     var request =
  //         http.MultipartRequest("POST", Uri.parse(ApiLink.createPost));

  //     request.fields.addAll(
  //         post.toCreatePostJson().map((key, value) => MapEntry(key, value)));
  //     request.files
  //         .add(await http.MultipartFile.fromPath('image', postImage!.path));
  //     request.headers.addAll(headers);

  //     http.StreamedResponse response = await request.send();
  //     if (response.statusCode == 201) {
  //       _createPostStatus(CreatePostStatus.success);
  //       debugPrint(await response.stream.bytesToString());
  //       Get.to(() => const CreateSuccessPage(title: 'Post Created'))!
  //           .then((value) {
  //         getPosts(false);
  //         clear();
  //       });
  //     } else {
  //       _createPostStatus(CreatePostStatus.error);
  //       debugPrint(response.reasonPhrase);
  //       handleError(response.reasonPhrase);
  //     }
  //   } catch (error) {
  //     _createPostStatus(CreatePostStatus.error);
  //     debugPrint("Error occurred ${error.toString()}");
  //     handleError(error);
  //   }
  // }

  void clearProfilePhoto() {
    debugPrint('image cleared');
    mCommunityProfileImage.value = null;
  }

  void clearCoverPhoto() {
    debugPrint('image cleared');
    mCommunityCoverImage.value = null;
  }
}
