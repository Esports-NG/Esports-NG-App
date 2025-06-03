// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:dio/dio.dart';
import 'package:e_sport/data/model/news_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/utils/create_success_page.dart';
import 'package:e_sport/util/api_helpers.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Get;
import 'package:multi_dropdown/multi_dropdown.dart';

enum LikePostStatus { loading, success, error, empty }

enum BookmarkPostStatus { loading, success, error, empty }

enum BlockPostStatus { loading, success, error, empty }

enum BookmarkStatus { loading, success, error, empty, available }

enum CreatePostStatus { loading, success, error, empty }

enum PostStatus { loading, success, error, empty, available }

enum GetPostStatus { loading, success, error, empty, available }

class PostRepository extends Get.GetxController {
  final authController = Get.Get.put(AuthRepository());
  late final postBodyController = TextEditingController();
  late final seeController = TextEditingController();
  late final engageController = TextEditingController();
  late final gameTagController = TextEditingController();
  late final accountTypeController = TextEditingController();

  final isEventAnnouncement = Get.RxBool(false);
  final isParticipantAnnouncement = Get.RxBool(false);

  Get.RxList<GamePlayed> gameTags = <GamePlayed>[].obs;
  MultiSelectController<GamePlayed> gameTagsController =
      MultiSelectController<GamePlayed>();
  final Get.Rx<List<PostModel>> _allPost = Get.Rx([]);
  final Get.RxList<PostModel> _myPost = Get.RxList([]);
  final Get.Rx<List<PostModel>> _bookmarkedPost = Get.Rx([]);
  final Get.RxList<PostModel> _followingPost = Get.RxList([]);
  final Get.RxList<PostModel> _forYouPosts = Get.RxList([]);
  final Get.Rx<List<NewsModel>> _news = Get.Rx([]);
  final Get.Rx<String> postId = "".obs;
  final Get.RxString postAs = "user".obs;
  final Get.RxString postName = "".obs;

  Get.RxString forYouPrevLink = "".obs;
  Get.RxString forYouNextlink = "".obs;

  Get.RxString followingPrevLink = "".obs;
  Get.RxString followingNextLink = "".obs;

  List<PostModel> get allPost => _allPost.value;
  List<PostModel> get myPost => _myPost;
  List<PostModel> get bookmarkedPost => _bookmarkedPost.value;
  List<PostModel> get followingPost => _followingPost;
  List<PostModel> get forYouPosts => _forYouPosts;
  List<NewsModel> get news => _news.value;
  Get.RxList<PostModel> searchedPosts = <PostModel>[].obs;

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

  Get.Rx<File?> mPostImage = Get.Rx(null);
  File? get postImage => mPostImage.value;

  // Dio instance
  late Dio _dio;

  // Initialize Dio with auth interceptor
  void _initDio() {
    _dio = Dio(BaseOptions(
        baseUrl: ApiLink.baseurl,
        contentType: 'application/json',
        responseType: ResponseType.json,
        receiveTimeout: Duration(seconds: 90)));

    // Add an interceptor to handle authentication
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token to header if it exists
        if (authController.token.isNotEmpty && authController.token != "0") {
          options.headers['Authorization'] = 'JWT ${authController.token}';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // Handle token refresh if 401 error occurs
        if (error.response?.statusCode == 401) {
          try {
            await authController.refreshToken();
            // Retry the request with updated token
            final opts = Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers
                ..['Authorization'] = 'JWT ${authController.token}',
            );
            final response = await _dio.request(
              error.requestOptions.path,
              options: opts,
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
            );
            return handler.resolve(response);
          } catch (e) {
            // If refresh token fails, proceed with original error
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

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
    _initDio();

    authController.mToken.listen((p0) {
      if (p0 != '0') {
        getNews();
      }
    });
  }

  // Handle API errors consistently
  void _handleApiError(dynamic error) {
    ApiHelpers.handleApiError(error);
  }

  // Safe API call wrapper
  Future<T?> _safeApiCall<T>(Future<Response> Function() apiCall,
      {T Function(Map<String, dynamic>)? fromJson,
      Function(dynamic)? setLoading,
      Function(T?)? onSuccess}) async {
    return ApiHelpers.safeApiCall(
      apiCall,
      fromJson: fromJson,
      setStatus: setLoading,
      onSuccess: onSuccess,
    );
  }

  // Convert file to MultipartFile for uploads
  Future<MultipartFile?> _fileToMultipart(File? file, String name) async {
    return ApiHelpers.fileToMultipart(file, name);
  }

  Future getPostDetails(String slug) async {
    try {
      final response = await _dio.get(ApiLink.getPostDetails(slug));
      print(response.data['data']);

      return response.data['data'];
    } catch (error) {
      debugPrint("get post details error: ${error.toString()}");
      _handleApiError(error);
      return null;
    }
  }

  Future createPost(PostModel post) async {
    _createPostStatus(CreatePostStatus.loading);

    try {
      var postUrl = postAs.value == "user"
          ? ApiLink.createPost
          : postAs.value == "community"
              ? "${ApiLink.createPost}?c_s=${postId.value}"
              : "${ApiLink.createPost}?t_s=${postId.value}";

      final formData = FormData.fromMap({
        "body": postBodyController.text,
      });
      // Add game tags
      for (int i = 0; i < gameTagsController.selectedItems.length; i++) {
        formData.fields.add(MapEntry('itags[$i].title',
            gameTagsController.selectedItems[i].value.abbrev!));
        // formData.fields.add(MapEntry('itags[$i].event_id', ''));
      }

      // Add image if exists
      if (postImage != null) {
        formData.files.add(
            MapEntry('image', await MultipartFile.fromFile(postImage!.path)));
      }

      final response = await _dio.post(postUrl, data: formData);

      if (response.statusCode == 201) {
        _createPostStatus(CreatePostStatus.success);
        getPostForYou(true);
        clear();
        Get.Get.off(() => const CreateSuccessPage(title: 'Post Created'));
      } else {
        _createPostStatus(CreatePostStatus.error);
        throw 'Failed to create post';
      }

      return response.data;
    } on DioException catch (error) {
      print(error.response?.data);
      _createPostStatus(CreatePostStatus.error);
      _handleApiError(error);
      return null;
    }
  }

  Future editPost(String postSlug) async {
    try {
      debugPrint('editing post...');
      _createPostStatus(CreatePostStatus.loading);

      final data = {"body": postBodyController.text.trim()};
      final response =
          await _dio.put("${ApiLink.editPost}$postSlug/", data: data);

      if (response.statusCode == 200) {
        _createPostStatus(CreatePostStatus.success);
        Get.Get.off(() => const CreateSuccessPage(title: 'Post Updated'))!
            .then((value) {
          getPostForYou(true);
        });
      } else {
        _createPostStatus(CreatePostStatus.error);
        throw 'Failed to edit post';
      }

      return response.data;
    } catch (error) {
      _createPostStatus(CreatePostStatus.error);
      debugPrint("edit post error: ${error.toString()}");
      _handleApiError(error);
      return null;
    }
  }

  Future deletePost(String slug) async {
    try {
      EasyLoading.show(status: 'Deleting post...');
      _postStatus(PostStatus.loading);

      final response = await _dio.delete("${ApiLink.deletePost}$slug/");

      if (response.statusCode == 200) {
        _postStatus(PostStatus.success);
        EasyLoading.dismiss();
        Helpers().showCustomSnackbar(message: "Post deleted");
        await getPostForYou(false);
      } else {
        _postStatus(PostStatus.error);
        throw 'Failed to delete post';
      }

      return response.data;
    } catch (error) {
      _postStatus(PostStatus.error);
      EasyLoading.dismiss();
      _handleApiError(error);
      return null;
    }
  }

  Future rePost(String slug, String title) async {
    try {
      EasyLoading.show(status: 'Reposting...');
      _postStatus(PostStatus.loading);
      print(slug);

      Response response;
      if (title == 'quote') {
        final data = {"body": authController.commentController.text};
        response = await _dio.post("${ApiLink.post}$slug/quote/", data: data);
      } else {
        response = await _dio.post("${ApiLink.post}$slug/repost/");
      }

      if (response.statusCode == 201) {
        _postStatus(PostStatus.success);
        EasyLoading.showInfo('Success').then((value) => getAllPost(true));
      } else {
        _postStatus(PostStatus.error);
        throw 'Failed to repost';
      }

      return response.data;
    } catch (error) {
      _postStatus(PostStatus.error);
      EasyLoading.dismiss();
      _handleApiError(error);
      return null;
    }
  }

  Future bookmarkPost(int postId) async {
    try {
      EasyLoading.show(status: 'processing...');
      _bookmarkPostStatus(BookmarkPostStatus.loading);

      final response = await _dio.put("${ApiLink.post}$postId/bookmark/");
      final responseData = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        var message = 'Post bookmarked';
        if (responseData is Map<String, dynamic> &&
            responseData['message'] != null) {
          message = responseData['message'];
        }

        EasyLoading.showInfo(message)
            .then((value) => getPostsWithBookmark(true));

        _bookmarkPostStatus(BookmarkPostStatus.success);
      } else {
        _bookmarkPostStatus(BookmarkPostStatus.error);
        throw 'Failed to bookmark post';
      }

      return response.data;
    } catch (error) {
      _bookmarkPostStatus(BookmarkPostStatus.error);
      EasyLoading.dismiss();
      _handleApiError(error);
      return null;
    }
  }

  Future commentOnPost(String slug) async {
    try {
      _postStatus(PostStatus.loading);

      final data = {
        "name": authController.user!.fullName,
        "body": authController.chatController.text.trim(),
        "itags": ['community']
      };

      final response =
          await _dio.post("${ApiLink.post}$slug/comment/", data: data);

      if (response.statusCode == 201) {
        _postStatus(PostStatus.success);
      } else {
        _postStatus(PostStatus.error);
        throw 'Failed to comment on post';
      }

      return response.data;
    } catch (error) {
      _postStatus(PostStatus.error);
      EasyLoading.dismiss();
      _handleApiError(error);
      return null;
    }
  }

  Future blockUserOrPost(int postId, String title) async {
    try {
      _blockPostStatus(BlockPostStatus.loading);
      EasyLoading.show(status: 'please wait...');

      final endpoint = title == 'block'
          ? "${ApiLink.post}block/?pk=$postId"
          : "${ApiLink.post}uninterested/$postId/team/1/";

      final response = await _dio.post(endpoint);

      if (response.statusCode == 200) {
        _blockPostStatus(BlockPostStatus.success);
        EasyLoading.showInfo('Success').then((value) async {
          getAllPost(true);
        });
      } else {
        EasyLoading.dismiss();
        _blockPostStatus(BlockPostStatus.error);
        throw 'Operation failed';
      }

      return response.data;
    } catch (error) {
      EasyLoading.dismiss();
      _blockPostStatus(BlockPostStatus.error);
      _handleApiError(error);
      return null;
    }
  }

  Future<bool> likePost(String slug) async {
    _likePostStatus(LikePostStatus.loading);
    try {
      debugPrint('liking $slug post...');
      final response = await _dio.post('${ApiLink.post}$slug/like/');

      return true;
    } on DioException catch (error) {
      // print(error.response?.body);
      _likePostStatus(LikePostStatus.error);
      debugPrint("like post error: $error");
      _handleApiError(error);
      return false;
    }
  }

  Future getMyPost(bool isFirstTime) async {
    try {
      debugPrint('getting my post...');
      if (isFirstTime == true) {
        authController.setLoading(true);
        _getPostStatus(GetPostStatus.loading);
      }

      final response = await _dio.get(ApiLink.getMyPost);
      final responseData = response.data['data']['results'];
      print(response);

      if (responseData is List) {
        var myPosts = responseData.map((e) => PostModel.fromJson(e)).toList();
        debugPrint("${myPosts.length} my posts found");
        _myPost(myPosts.reversed.toList());
        _getPostStatus(GetPostStatus.success);
        myPosts.isNotEmpty
            ? _getPostStatus(GetPostStatus.available)
            : _getPostStatus(GetPostStatus.empty);
        authController.setLoading(false);
        return myPosts;
      } else {
        throw 'Unexpected response format';
      }
    } catch (error) {
      _getPostStatus(GetPostStatus.error);
      authController.setLoading(false);
      _handleApiError(error);
      return null;
    }
  }

  Future getAllPost(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        authController.setLoading(true);
        _postStatus(PostStatus.loading);
      }

      debugPrint('getting all post...');
      final response = await _dio.get(ApiLink.getAllPost);
      final responseData = response.data;

      if (responseData is List) {
        var posts = responseData.map((e) => PostModel.fromJson(e)).toList();
        debugPrint("${posts.length} posts found");
        _allPost(posts.reversed.toList());
        _postStatus(PostStatus.success);
        posts.isNotEmpty
            ? _postStatus(PostStatus.available)
            : _postStatus(PostStatus.empty);
      } else {
        throw 'Unexpected response format';
      }

      authController.setLoading(false);
      return responseData;
    } catch (error) {
      _postStatus(PostStatus.error);
      authController.setLoading(false);
      _handleApiError(error);
      return null;
    }
  }

  Future getPostForYou(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        authController.setLoading(true);
        _bookmarkStatus(BookmarkStatus.loading);
      }

      debugPrint('getting all for you post...');
      final response = await _dio.get(ApiLink.getPostsForYou);
      final responseData = response.data["data"];
      print(responseData);

      if (responseData is Map<String, dynamic> &&
          responseData['results'] is List) {
        forYouNextlink.value = responseData['next'] ?? "";
        var list = List.from(responseData['results']);
        var posts = list.map((e) => PostModel.fromJson(e)).toList();
        debugPrint("${posts.length} for you posts found");
        _forYouPosts.assignAll(posts);
        authController.setLoading(false);
        return posts;
      } else {
        throw 'Unexpected response format';
      }
    } catch (error) {
      authController.setLoading(false);
      _handleApiError(error);
      return null;
    }
  }

  Future getNextForYou() async {
    try {
      debugPrint('getting next for you post...');

      final response = await _dio.get(forYouNextlink.value);
      final responseData = response.data["data"];

      if (responseData is Map<String, dynamic> &&
          responseData['results'] is List) {
        forYouNextlink.value = responseData['next'] ?? "";
        var list = List.from(responseData['results']);
        var posts = list.map((e) => PostModel.fromJson(e)).toList();
        debugPrint("${posts.length} more for you posts found");
        _forYouPosts.addAll(posts);
        return posts;
      } else {
        throw 'Unexpected response format';
      }
    } catch (error) {
      _handleApiError(error);
      return null;
    }
  }

  Future getFollowingPost(bool isFirstTime) async {
    try {
      if (isFirstTime == true) {
        authController.setLoading(true);
        _bookmarkStatus(BookmarkStatus.loading);
      }

      debugPrint('getting all following post...');
      final response = await _dio.get(ApiLink.getFollowingPost);
      final responseData = response.data;

      if (responseData is Map<String, dynamic> &&
          responseData['results'] is List) {
        followingNextLink.value = responseData['next'] ?? "";
        var list = List.from(responseData['results']);
        var posts = list.map((e) => PostModel.fromJson(e)).toList();
        debugPrint("${posts.length} following posts found");
        _followingPost.assignAll(posts);
        authController.setLoading(false);
        return posts;
      } else {
        throw 'Unexpected response format';
      }
    } catch (error) {
      authController.setLoading(false);
      _handleApiError(error);
      return null;
    }
  }

  Future getNextFollowing() async {
    try {
      debugPrint('getting next following post...');

      final response = await _dio.get(followingNextLink.value);
      final responseData = response.data;

      if (responseData is Map<String, dynamic> &&
          responseData['results'] is List) {
        followingNextLink.value = responseData['next'] ?? "";
        var list = List.from(responseData['results']);
        var posts = list.map((e) => PostModel.fromJson(e)).toList();
        debugPrint("${posts.length} more following posts found");
        _followingPost.addAll(posts);
        return posts;
      } else {
        throw 'Unexpected response format';
      }
    } catch (error) {
      _handleApiError(error);
      return null;
    }
  }

  Future getBookmarkedPost(bool isFirstTime) async {
    return _safeApiCall(
      () => _dio.get(ApiLink.getBookmarkedPost),
      setLoading: (loading) {
        if (isFirstTime) {
          authController.setLoading(loading);
          if (loading) _bookmarkStatus(BookmarkStatus.loading);
        }
      },
      onSuccess: (data) {
        if (data is List) {
          var posts = data.map((e) => PostModel.fromJson(e)).toList();
          debugPrint("${posts.length} bookmarked posts found");
          _bookmarkedPost(posts.reversed.toList());
          _bookmarkStatus(BookmarkStatus.success);
          posts.isNotEmpty
              ? _bookmarkStatus(BookmarkStatus.available)
              : _bookmarkStatus(BookmarkStatus.empty);
          return posts;
        }
      },
    );
  }

  Future likeComment(String slug) async {
    return _safeApiCall(
      () => _dio.put(ApiLink.likeComment(slug)),
    );
  }

  Future reportPost(
      int reportee,
      int reported,
      String offenseTitle,
      String offenseDescription,
      String reportedTitle,
      String reporteeTitle) async {
    final data = {
      "title": offenseTitle,
      "offense": offenseDescription,
      "reported_title": reportedTitle,
      "reported_id": reported,
      "reportee_title": reporteeTitle,
      "reportee_id": reportee
    };

    return _safeApiCall(
      () => _dio.post(ApiLink.report, data: data),
      onSuccess: (data) {
        Get.Get.back(closeOverlays: true);
        Helpers().showCustomSnackbar(
            message: "${reportedTitle.toCapitalCase()} reported");
        return data;
      },
    );
  }

  Future getNews() async {
    // Create a custom Dio instance for this request since it needs different auth
    print("getting news");
    final newsClient = Dio(BaseOptions(
        baseUrl: ApiLink.baseurl,
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: {
          "Authorization":
              "Basic ${base64.encode(utf8.encode("zillalikestogame:zillalikesnexal"))}"
        }));

    var response = await newsClient.get(ApiLink.getNews);
    print(response.data);
    var newsList =
        List<NewsModel>.from(response.data.map((x) => NewsModel.fromJson(x)));
    news.assignAll(newsList);
  }

  Future searchForPosts(String query) async {
    return _safeApiCall(
      () => _dio.get(ApiLink.searchForPostsorUsers(query, "post")),
      onSuccess: (responseData) {
        if (responseData is List) {
          var posts = responseData.map((e) => PostModel.fromJson(e)).toList();
          searchedPosts.assignAll(posts);
          return posts;
        }
      },
    );
  }

  Future createEventPost(int eventId, String hashtag) async {
    _createPostStatus(CreatePostStatus.loading);

    try {
      var postUrl = postAs.value == "user"
          ? ApiLink.createPost
          : postAs.value == "community"
              ? "${ApiLink.createPost}?comm_pk=${postId.value}"
              : "${ApiLink.createPost}?team_pk=${postId.value}";

      final formData = FormData.fromMap({
        "body": postBodyController.text,
        "annoucement": isEventAnnouncement.value.toString(),
        "participant_annoucement": isParticipantAnnouncement.value.toString(),
        "itags[0].title": hashtag,
        "itags[0].event_id": eventId.toString(),
      });

      // Add game tags
      for (int i = 0; i < gameTags.length; i++) {
        formData.fields
            .add(MapEntry('itags[${i + 1}].title', gameTags[i].abbrev!));
      }

      // Add image if exists
      if (postImage != null) {
        formData.files.add(MapEntry('image',
            await _fileToMultipart(postImage, 'post_image') as MultipartFile));
      }

      return _safeApiCall(
        () => _dio.post(postUrl, data: formData),
        setLoading: (loading) {
          if (!loading)
            _createPostStatus(
                loading ? CreatePostStatus.loading : CreatePostStatus.success);
        },
        onSuccess: (data) {
          getPostForYou(true);
          clear();
          Get.Get.off(() => const CreateSuccessPage(title: 'Post Created'));
          return data;
        },
      );
    } catch (error) {
      _createPostStatus(CreatePostStatus.error);
      _handleApiError(error);
      return null;
    }
  }

  Future<List<PostModel>?> getEventPosts(String slug) async {
    var response = await _safeApiCall(
      () => _dio.get(ApiLink.getEventPosts(slug)),
      fromJson: (value) {
        return value['results'];
      },
      onSuccess: (responseData) {
        if (responseData is List) {
          var list = List.from(responseData!.toList());
          var posts = list.map((e) => PostModel.fromJson(e)).toList();
          return posts;
        }
      },
    );
    var list = List.from(response!.toList());
    var posts =
        List<PostModel>.from(list.map((e) => PostModel.fromJson(e)).toList());

    return posts;
  }

  Future getAdverts() async {
    return _safeApiCall(
      () => _dio.get(ApiLink.getAds),
    );
  }

  void handleError(dynamic error) {
    debugPrint("error $error");
    Fluttertoast.showToast(
        fontSize: Get.Get.height * 0.015,
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
    isEventAnnouncement.value = false;
    isParticipantAnnouncement.value = false;
  }
}
