// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum LikePostStatus { loading, success, error, empty }

enum CreatePostStatus { loading, success, error, empty }

enum PostStatus { loading, success, error, empty, available }

enum GetPostStatus { loading, success, error, empty, available }

class PostRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  late final postTitleController = TextEditingController();
  late final postBodyController = TextEditingController();
  late final seeController = TextEditingController();
  late final engageController = TextEditingController();
  late final gameTagController = TextEditingController();
  late final accountTypeController = TextEditingController();

  final Rx<List<PostModel>> _allPost = Rx([]);
  final Rx<List<PostModel>> _myPost = Rx([]);
  List<PostModel> get allPost => _allPost.value;
  List<PostModel> get myPost => _myPost.value;

  final _postStatus = PostStatus.empty.obs;
  final _createPostStatus = CreatePostStatus.empty.obs;
  final _likePostStatus = LikePostStatus.empty.obs;
  final _getPostStatus = GetPostStatus.empty.obs;

  GetPostStatus get getPostStatus => _getPostStatus.value;
  LikePostStatus get likePostStatus => _likePostStatus.value;
  PostStatus get postStatus => _postStatus.value;
  CreatePostStatus get createPostStatus => _createPostStatus.value;

  Rx<File?> mPostImage = Rx(null);
  File? get postImage => mPostImage.value;

  @override
  void onInit() {
    super.onInit();
    authController.mToken.listen((p0) async {
      if (p0 != '0') {
        getPosts(true);
      }
    });
  }

  Future createPost(PostModel post) async {
    try {
      _createPostStatus(CreatePostStatus.loading);
      var headers = {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      };
      var request =
          http.MultipartRequest("POST", Uri.parse(ApiLink.createPost));

      request.fields.addAll(
          post.toCreatePostJson().map((key, value) => MapEntry(key, value)));
      request.files
          .add(await http.MultipartFile.fromPath('image', postImage!.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        _createPostStatus(CreatePostStatus.success);
        debugPrint(await response.stream.bytesToString());
        Get.to(() => const CreateSuccessPage(title: 'Post Created'))!
            .then((value) {
          getPosts(false);
          clear();
        });
      } else if (response.statusCode == 401) {
        debugPrint(response.reasonPhrase);
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _createPostStatus(CreatePostStatus.error);
      } else {
        _createPostStatus(CreatePostStatus.error);
        debugPrint(response.reasonPhrase);
        handleError(response.reasonPhrase);
      }
    } catch (error) {
      _createPostStatus(CreatePostStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      handleError(error);
    }
  }

  Future editPost(int postId) async {
    try {
      debugPrint('editing post...');
      var body = {
        "title": postTitleController.text.trim(),
        "body": postBodyController.text.trim()
      };
      _createPostStatus(CreatePostStatus.loading);
      var response = await http.put(
        Uri.parse("${ApiLink.editPost}$postId/"),
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT ${authController.token}'
        },
      );

      if (response.statusCode != 200) {
        throw ('An error occurred');
      }
      debugPrint(response.body);
      if (response.statusCode == 200) {
        _createPostStatus(CreatePostStatus.success);
        Get.to(() => const CreateSuccessPage(title: 'Post Updated'))!
            .then((value) {
          getPosts(false);
        });
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _createPostStatus(CreatePostStatus.error);
      }
      return response.body;
    } catch (error) {
      _createPostStatus(CreatePostStatus.error);
      debugPrint("edit post error: ${error.toString()}");
      handleError(error);
    }
  }

  Future deletePost(int postId) async {
    try {
      EasyLoading.show(status: 'Deleting post...');
      _postStatus(PostStatus.loading);
      var response = await http.post(
        Uri.parse("${ApiLink.deletePost}$postId/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT ${authController.token}'
        },
      );

      debugPrint(response.body);
      if (response.statusCode == 200) {
        _postStatus(PostStatus.success);
        EasyLoading.dismiss();
        Get.to(() => const CreateSuccessPage(title: 'Post Deleted'))!
            .then((value) {
          getPosts(false);
        });
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _postStatus(PostStatus.error);
      }
      return response.body;
    } catch (error) {
      _postStatus(PostStatus.error);
      EasyLoading.dismiss();
      debugPrint("delete post error: ${error.toString()}");
      handleError(error);
    }
  }

  Future rePost(int postId) async {
    try {
      EasyLoading.show(status: 'Reposting...');
      var body = {"body": 'repost!'};
      _postStatus(PostStatus.loading);
      var response = await http.post(
        Uri.parse("${ApiLink.post}$postId/repost/"),
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT ${authController.token}'
        },
      );

      debugPrint(response.body);
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 201) {
        _postStatus(PostStatus.success);
        EasyLoading.showInfo('Success').then((value) => getPosts(false));
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _postStatus(PostStatus.error);
      }
      return response.body;
    } catch (error) {
      _postStatus(PostStatus.error);
      EasyLoading.dismiss();
      debugPrint("Repost error: ${error.toString()}");
      handleError(error);
    }
  }

  Future<bool> likePost(int postId) async {
    _likePostStatus(LikePostStatus.loading);
    try {
      debugPrint('liking post...');
      var response = await http.post(
        Uri.parse('${ApiLink.likePost}$postId/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT ${authController.token}'
        },
      );
      var json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['message'] == 'Post liked') {
        getPosts(false);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      _likePostStatus(LikePostStatus.error);
      debugPrint("like post error: $error");
      handleError(error);
      return false;
    }
  }

  Future getMyPost(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        _getPostStatus(GetPostStatus.loading);
      }
      debugPrint('getting my post...');
      var response = await http.get(Uri.parse(ApiLink.getMyPost), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });
      var json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw (json['detail']);
      }

      if (response.statusCode == 200) {
        var list = List.from(json);
        var myPosts = list.map((e) => PostModel.fromJson(e)).toList();
        debugPrint("${myPosts.length} my posts found");
        _myPost(myPosts.reversed.toList());
        _getPostStatus(GetPostStatus.success);
        myPosts.isNotEmpty
            ? _getPostStatus(GetPostStatus.available)
            : _getPostStatus(GetPostStatus.empty);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _getPostStatus(GetPostStatus.error);
      }
      return response.body;
    } catch (error) {
      _getPostStatus(GetPostStatus.error);
      debugPrint("getting my post: ${error.toString()}");
    }
  }

  Future getAllPost(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        _postStatus(PostStatus.loading);
      }

      debugPrint('getting all post...');
      var response = await http.get(Uri.parse(ApiLink.getAllPost), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });
      var json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw (json['detail']);
      }

      if (response.statusCode == 200) {
        var list = List.from(json);
        var posts = list.map((e) => PostModel.fromJson(e)).toList();
        debugPrint("${posts.length} posts found");
        _allPost(posts.reversed.toList());
        _postStatus(PostStatus.success);
        posts.isNotEmpty
            ? _postStatus(PostStatus.available)
            : _postStatus(PostStatus.empty);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _postStatus(PostStatus.error);
      }
      return response.body;
    } catch (error) {
      _postStatus(PostStatus.error);
      debugPrint("getting all post: ${error.toString()}");
    }
  }

  void handleError(dynamic error) {
    debugPrint("error $error");
    Fluttertoast.showToast(
        fontSize: Get.height * 0.015,
        msg: (error.toString().contains("esports-ng.vercel.app") ||
                error.toString().contains("Network is unreachable"))
            ? 'Post like: No internet connection!'
            : (error.toString().contains("FormatException"))
                ? 'Post like: Internal server error, contact admin!'
                : error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  void getPosts(bool isFirstTime) {
    getAllPost(isFirstTime);
    getMyPost(isFirstTime);
  }

  void clearPhoto() {
    debugPrint('image cleared');
    mPostImage.value = null;
  }

  void clear() {
    postTitleController.clear();
    postBodyController.clear();
    gameTagController.clear();
    seeController.clear();
  }
}
