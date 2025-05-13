import 'package:dio/dio.dart';
import 'package:e_sport/data/model/games_played_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class GamesRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  final Dio _dio = Dio();

  RxList<GamePlayed> allGames = <GamePlayed>[].obs;
  RxList<GamePlayed> userGames = <GamePlayed>[].obs;
  Rx<GamePlayed?> selectedGame = Rx(null);
  RxString selectedGameName = "".obs;
  RxBool isLoading = true.obs;
  TextEditingController gameSearchText = TextEditingController();
  RxList<GamePlayed> filteredGames = <GamePlayed>[].obs;
  RxList<GamePlayed> filteredUserGames = <GamePlayed>[].obs;
  RxList<GamePlayed> searchedGames = <GamePlayed>[].obs;
  RxString feedNextlink = "".obs;
  RxList<GameToPlay> gameFeed = RxList([]);

  @override
  onInit() {
    super.onInit();
    _initDio();
    authController.mToken.listen((p0) async {
      if (p0 != '0') {
        getAllGames();
        getUserGames();
      }
    });
  }

  void _initDio() {
    _dio.options.headers = {
      "Content-Type": "application/json",
    };

    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers["Authorization"] = "JWT ${authController.token}";
      return handler.next(options);
    }, onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        authController.refreshToken().then((_) {
          EasyLoading.showInfo('Session refreshed. Please try again.');
        });
      }
      return handler.next(error);
    }));
  }

  Future<void> getAllGames() async {
    isLoading.value = true;
    try {
      final response = await _dio.get(ApiLink.getAllGames);
      print("games response: $response");

      if (response.statusCode == 200 && response.data['success'] == true) {
        final list = List.from(response.data['data']['results']);
        final games = list.map((e) => GamePlayed.fromJson(e)).toList();
        allGames.assignAll(games);
        filteredGames.assignAll(games);
      } else {
        debugPrint("Error: ${response.data['message']}");
      }
    } on DioException catch (error) {
      print("games error: ${error.response?.data}");
      debugPrint("Getting all games error: ${error.message}");
    } catch (error) {
      debugPrint("Unexpected error: $error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserGames() async {
    try {
      final response = await _dio.get(ApiLink.getUserGames);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final list = List.from(response.data['data']);
        final games = list.map((e) => GamePlayed.fromJson(e)).toList();
        userGames.assignAll(games);
        filteredUserGames.assignAll(games);
      } else {
        debugPrint("Error: ${response.data['message']}");
      }
    } on DioException catch (error) {
      debugPrint("Getting user games error: ${error.message}");
    }
  }

  Future<GamePlayed?> getGameDetails(int id) async {
    try {
      final response = await _dio.get(ApiLink.getGame(id));

      if (response.statusCode == 200 && response.data['success'] == true) {
        return GamePlayed.fromJson(response.data['data']);
      } else {
        debugPrint("Error: ${response.data['message']}");
      }
    } on DioException catch (error) {
      debugPrint("Getting game details error: ${error.message}");
    }
    return null;
  }

  Future<dynamic> getGameFollower(int id) async {
    try {
      final response = await _dio.get(ApiLink.getGameFollowers(id));

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'];
      } else {
        debugPrint("Error: ${response.data['message']}");
      }
    } on DioException catch (error) {
      debugPrint("Getting game followers error: ${error.message}");
    }
    return null;
  }

  Future<String> followGame(int id) async {
    try {
      final response = await _dio.put(ApiLink.followGame(id));

      if (response.statusCode == 200 && response.data['success'] == true) {
        final message = response.data['message'].toString();
        if (message.contains("unfollowed")) {
          return "unfollowed";
        } else {
          return "followed";
        }
      } else {
        debugPrint("Error: ${response.data['message']}");
      }
    } on DioException catch (error) {
      debugPrint("Follow game error: ${error.message}");
    }
    return "error";
  }

  Future<void> searchForGames(String query) async {
    try {
      final response = await _dio.get(ApiLink.searchForGames(query));

      if (response.statusCode == 200 && response.data['success'] == true) {
        final list = List.from(response.data['data']);
        final games = list.map((e) => GamePlayed.fromJson(e)).toList();
        searchedGames.assignAll(games);
      } else {
        debugPrint("Error: ${response.data['message']}");
      }
    } on DioException catch (error) {
      debugPrint("Search for games error: ${error.message}");
    }
  }

  Future<List<GameToPlay>?> getGameFeed(bool isFirstTime) async {
    debugPrint('Getting game feed...');
    try {
      final response = await _dio.get(ApiLink.getGamesToPlay);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        feedNextlink.value = data['next'] ?? "";
        final list = List.from(data['results']);
        final feed = list.map((e) => GameToPlay.fromJson(e)).toList();
        gameFeed.assignAll(feed);
        authController.setLoading(false);
        return feed;
      } else {
        debugPrint("Error: ${response.data['message']}");
      }
    } on DioException catch (error) {
      print(error.response?.data);
      if (error.response?.statusCode == 401) {
        // 401 is already handled in the interceptor
      } else {
        debugPrint("Getting game feed error: ${error.message}");
      }
    } finally {
      authController.setLoading(false);
    }
    return null;
  }

  Future<List<GameToPlay>?> getNextFeed() async {
    try {
      if (feedNextlink.value.isEmpty) {
        return [];
      }

      final response = await _dio.get(feedNextlink.value);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        feedNextlink.value = data['next'] ?? "";
        final list = List.from(data['results']);
        final feed = list.map((e) => GameToPlay.fromJson(e)).toList();
        debugPrint("${feed.length} for you feed found");
        gameFeed.addAll(feed);
        return feed;
      } else {
        debugPrint("Error: ${response.data['message']}");
      }
    } on DioException catch (error) {
      debugPrint("Getting next feed error: ${error.message}");
    } finally {
      authController.setLoading(false);
    }
    return null;
  }
}
