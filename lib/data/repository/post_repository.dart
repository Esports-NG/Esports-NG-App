// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:e_sport/data/model/news_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum LikePostStatus { loading, success, error, empty }

enum BookmarkPostStatus { loading, success, error, empty }

enum BlockPostStatus { loading, success, error, empty }

enum BookmarkStatus { loading, success, error, empty, available }

enum CreatePostStatus { loading, success, error, empty }

enum PostStatus { loading, success, error, empty, available }

enum GetPostStatus { loading, success, error, empty, available }

class PostRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  late final postBodyController = TextEditingController();
  late final seeController = TextEditingController();
  late final engageController = TextEditingController();
  late final gameTagController = TextEditingController();
  late final accountTypeController = TextEditingController();

  RxList<GamePlayed> gameTags = <GamePlayed>[].obs;

  final Rx<List<PostModel>> _allPost = Rx([]);
  final Rx<List<PostModel>> _myPost = Rx([]);
  final Rx<List<PostModel>> _bookmarkedPost = Rx([]);
  final Rx<List<PostModel>> _followingPost = Rx([]);
  final Rx<List<PostModel>> _forYouPosts = Rx([]);
  final Rx<List<NewsModel>> _news = Rx([]);

  List<PostModel> get allPost => _allPost.value;
  List<PostModel> get myPost => _myPost.value;
  List<PostModel> get bookmarkedPost => _bookmarkedPost.value;
  List<PostModel> get followingPost => _followingPost.value;
  List<PostModel> get forYouPosts => _forYouPosts.value;
  List<NewsModel> get news => _news.value;
  RxList<PostModel> searchedPosts = <PostModel>[].obs;

  final _postStatus = PostStatus.empty.obs;
  final _bookmarkStatus = BookmarkStatus.empty.obs;
  final _createPostStatus = CreatePostStatus.empty.obs;
  final _likePostStatus = LikePostStatus.empty.obs;
  final _bookmarkPostStatus = BookmarkPostStatus.empty.obs;
  final _getPostStatus = GetPostStatus.empty.obs;
  final _blockPostStatus = BlockPostStatus.empty.obs;

  GetPostStatus get getPostStatus => _getPostStatus.value;
  BookmarkStatus get bookmarkStatus => _bookmarkStatus.value;
  LikePostStatus get likePostStatus => _likePostStatus.value;
  BookmarkPostStatus get bookmarkPostStatus => _bookmarkPostStatus.value;
  PostStatus get postStatus => _postStatus.value;
  CreatePostStatus get createPostStatus => _createPostStatus.value;
  BlockPostStatus get blockPostStatus => _blockPostStatus.value;

  Rx<File?> mPostImage = Rx(null);
  File? get postImage => mPostImage.value;

  void addToGameTags(GamePlayed game) {
    if (gameTags.contains(game)) {
      gameTags.remove(game);
    } else {
      gameTags.add(game);
    }
    print("added game ${game.abbrev}");
  }

  @override
  void onInit() {
    super.onInit();
    authController.mToken.listen((p0) {
      if (p0 != '0') {
        getAllPost(true);
        getBookmarkedPost(true);
        getMyPost(true);
        getPostForYou(true);
        getNews();
      }
    });
  }

  Future getPostDetails(int postId) async {
    try {
      var response = await http.get(
        Uri.parse(ApiLink.getPostDetails(postId)),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT ${authController.token}'
        },
      );

      debugPrint(response.body);
      var json = jsonDecode(response.body);
      print(json['comment']);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
      }
      return response.body;
    } catch (error) {
      debugPrint("get post details error: ${error.toString()}");
      handleError(error);
    }
  }

  Future createPost(PostModel post) async {
    try {
      _createPostStatus(CreatePostStatus.loading);
      var headers = {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      };
      var request = http.MultipartRequest("POST", Uri.parse(ApiLink.createPost))
        ..fields["body"] = postBodyController.text;
      for (int i = 0; i < gameTags.length; i++) {
        request.fields['itags[$i]'] = '${gameTags[i].abbrev}';
      }

      if (postImage != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', postImage!.path));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        _createPostStatus(CreatePostStatus.success);
        debugPrint(await response.stream.bytesToString());
        getAllPost(true);
        clear();
        Get.to(() => const CreateSuccessPage(title: 'Post Created'));
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
      var body = {"body": postBodyController.text.trim()};
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
          getAllPost(true);
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
          getAllPost(true);
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

  Future rePost(int postId, String title) async {
    try {
      EasyLoading.show(status: 'Reposting...');
      _postStatus(PostStatus.loading);

      http.Response response;
      if (title == 'quote') {
        var body = {"body": authController.commentController.text};
        response = await http.post(
          Uri.parse("${ApiLink.post}$postId/quote/"),
          body: jsonEncode(body),
          headers: {
            "Content-Type": "application/json",
            "Authorization": 'JWT ${authController.token}'
          },
        );
      } else {
        response = await http.post(
          Uri.parse("${ApiLink.post}$postId/repost/"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": 'JWT ${authController.token}'
          },
        );
      }

      debugPrint(response.body);
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 201) {
        _postStatus(PostStatus.success);
        EasyLoading.showInfo('Success').then((value) => getAllPost(true));
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

  Future bookmarkPost(int postId) async {
    try {
      EasyLoading.show(status: 'processing...');
      _bookmarkPostStatus(BookmarkPostStatus.loading);

      var response = await http.put(
        Uri.parse("${ApiLink.post}$postId/bookmark/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT ${authController.token}'
        },
      );

      var json = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showInfo(json['message'])
            .then((value) => getPostsWithBookmark(true));

        _bookmarkPostStatus(BookmarkPostStatus.success);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _bookmarkPostStatus(BookmarkPostStatus.error);
      }
      return response.body;
    } catch (error) {
      _bookmarkPostStatus(BookmarkPostStatus.error);
      EasyLoading.dismiss();
      debugPrint("bookmark error: ${error.toString()}");
      handleError(error);
    }
  }

  Future commentOnPost(int postId) async {
    try {
      EasyLoading.show(status: 'commenting...');
      var body = {
        "name": authController.user!.fullName,
        "body": authController.chatController.text.trim(),
        "itags": ['community']
      };
      _postStatus(PostStatus.loading);
      var response = await http.post(
        Uri.parse("${ApiLink.post}$postId/comment/"),
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
        EasyLoading.showInfo('Success').then((value) => getAllPost(true));
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

  Future blockUserOrPost(int postId, String title) async {
    try {
      _blockPostStatus(BlockPostStatus.loading);
      EasyLoading.show(status: 'please wait...');

      _postStatus(PostStatus.loading);
      var response = await http.post(
        Uri.parse(title == 'block'
            ? "${ApiLink.post}block/?pk=$postId"
            : "${ApiLink.post}uninterested/$postId/team/1/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT ${authController.token}'
        },
      );

      debugPrint(response.body);
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        _blockPostStatus(BlockPostStatus.success);
        EasyLoading.showInfo('Success').then((value) async {
          getAllPost(true);
        });
      } else if (response.statusCode == 401) {
        _blockPostStatus(BlockPostStatus.error);
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
      } else {
        EasyLoading.dismiss();
        _blockPostStatus(BlockPostStatus.error);
      }
      return response.body;
    } catch (error) {
      EasyLoading.dismiss();
      _blockPostStatus(BlockPostStatus.error);
      debugPrint("block error: ${error.toString()}");
      handleError(error);
    }
  }

  Future<bool> likePost(int postId) async {
    _likePostStatus(LikePostStatus.loading);
    try {
      debugPrint('liking $postId post...');
      var response = await http.post(
        Uri.parse('${ApiLink.post}$postId/like/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'JWT ${authController.token}'
        },
      );
      var json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['message'] == 'success') {
        getBookmarkedPost(false);
        getAllPost(false);
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
      authController.setLoading(true);
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
        authController.setLoading(false);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _getPostStatus(GetPostStatus.error);
        authController.setLoading(false);
      }
      return response.body;
    } catch (error) {
      _getPostStatus(GetPostStatus.error);
      authController.setLoading(false);
      debugPrint("getting my post: ${error.toString()}");
    }
  }

  Future getAllPost(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        authController.setLoading(true);
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
        authController.setLoading(false);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _postStatus(PostStatus.error);
        authController.setLoading(false);
      }
      return response.body;
    } catch (error) {
      _postStatus(PostStatus.error);
      authController.setLoading(false);
      debugPrint("getting all post: ${error.toString()}");
    }
  }

  Future getPostForYou(bool isFirstTime) async {
    // try {
    if (isFirstTime == true) {
      authController.setLoading(true);
      _bookmarkStatus(BookmarkStatus.loading);
    }

    debugPrint('getting all for you post...');
    var response = await http.get(Uri.parse(ApiLink.getPostsForYou), headers: {
      "Content-Type": "application/json",
      "Authorization": 'JWT ${authController.token}'
    });

    print(response.body);
    var json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw (json['detail']);
    }

    if (response.statusCode == 200) {
      var list = List.from(json);
      var posts = list.map((e) => PostModel.fromJson(e)).toList();
      debugPrint("${posts.length} for you posts found");
      _forYouPosts(posts.reversed.toList());
      // _bookmarkStatus(BookmarkStatus.success);
      // posts.isNotEmpty
      //     ? _bookmarkStatus(BookmarkStatus.available)
      //     : _bookmarkStatus(BookmarkStatus.empty);
      authController.setLoading(false);
    } else if (response.statusCode == 401) {
      authController
          .refreshToken()
          .then((value) => EasyLoading.showInfo('try again!'));
      // _bookmarkStatus(BookmarkStatus.error);
      authController.setLoading(false);
    }
    return response.body;
    // } catch (error) {
    //   // _bookmarkStatus(BookmarkStatus.error);
    //   authController.setLoading(false);
    //   debugPrint("getting for you post: ${error.toString()}");
    // }
  }

  Future getBookmarkedPost(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        authController.setLoading(true);
        _bookmarkStatus(BookmarkStatus.loading);
      }

      debugPrint('getting all bookmark post...');
      var response =
          await http.get(Uri.parse(ApiLink.getBookmarkedPost), headers: {
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
        debugPrint("${posts.length} bookmarked posts found");
        _bookmarkedPost(posts.reversed.toList());
        _bookmarkStatus(BookmarkStatus.success);
        posts.isNotEmpty
            ? _bookmarkStatus(BookmarkStatus.available)
            : _bookmarkStatus(BookmarkStatus.empty);
        authController.setLoading(false);
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        _bookmarkStatus(BookmarkStatus.error);
        authController.setLoading(false);
      }
      return response.body;
    } catch (error) {
      _bookmarkStatus(BookmarkStatus.error);
      authController.setLoading(false);
      debugPrint("getting bookmarked post: ${error.toString()}");
    }
  }

  Future likeComment(int commentId) async {
    try {
      var response =
          await http.put(Uri.parse(ApiLink.likeComment(commentId)), headers: {
        "Content-type": "application/json",
        "Authorization": "JWT ${authController.token}"
      });

      print(response.body);
    } catch (err) {}
  }

  Future reportPost(
      int reportee,
      int reported,
      String offenseTitle,
      String offenseDescription,
      String reportedTitle,
      String reporteeTitle) async {
    try {
      var body = {
        "title": offenseTitle,
        "offense": offenseDescription,
        "reported_title": reportedTitle,
        "reported_id": reported,
        "reportee_title": reporteeTitle,
        "reportee_id": reportee
      };

      var response = await http.post(Uri.parse(ApiLink.report),
          headers: {
            "Content-type": "application/json",
            "Authorization": "JWT ${authController.token}"
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        Get.back(closeOverlays: true);
        Helpers().showCustomSnackbar(
            message: "${reportedTitle.toCapitalCase()} reported");
      } else {
        print(response.body);
      }
    } catch (err) {}
  }

  Future getNews() async {
    var response = await http.get(Uri.parse(ApiLink.getNews), headers: {
      "Authorization":
          "Basic ${base64.encode(utf8.encode("zillalikestogame:zillalikesnexal"))}"
    });

    log(response.body);
    var newsFromJson = newsModelFromJson(response.body);
    _news.value = newsFromJson;
  }

  Future searchForPosts(String query) async {
    var response = await http
        .get(Uri.parse(ApiLink.searchForPostsorUsers(query, "post")), headers: {
      "Authorization": "JWT ${authController.token}",
      "Content-type": "application/json"
    });
    log(response.body);
    var json = jsonDecode(response.body);
    var list = List.from(json);
    var posts = list.map((e) => PostModel.fromJson(e)).toList();
    searchedPosts.assignAll(posts);
  }

  void handleError(dynamic error) {
    debugPrint("error $error");
    Fluttertoast.showToast(
        fontSize: Get.height * 0.015,
        msg: (error.toString().contains("esports-ng.vercel.app") ||
                error.toString().contains("Network is unreachable"))
            ? 'No internet connection!'
            : (error.toString().contains("FormatException"))
                ? 'Internal server error, contact admin!'
                : error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  void getPosts(bool isFirstTime) {
    getAllPost(isFirstTime);
    getBookmarkedPost(isFirstTime);
    getMyPost(isFirstTime);
  }

  void getPostsWithBookmark(bool isFirstTime) {
    getAllPost(isFirstTime);
    getBookmarkedPost(isFirstTime);
  }

  void clearPhoto() {
    debugPrint('image cleared');
    mPostImage.value = null;
  }

  void clear() {
    postBodyController.clear();
    gameTagController.clear();
    seeController.clear();
  }
}
