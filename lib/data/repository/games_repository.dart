import 'dart:convert';

import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GamesRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  RxList<GamePlayed> allGames = <GamePlayed>[].obs;
  RxList<GamePlayed> userGames = <GamePlayed>[].obs;
  Rx<GamePlayed?> selectedGame = Rx(null);
  RxString selectedGameName = "".obs;
  RxBool isLoading = true.obs;
  TextEditingController gameSearchText = TextEditingController();
  RxList<GamePlayed> filteredGames = <GamePlayed>[].obs;
  RxList<GamePlayed> filteredUserGames = <GamePlayed>[].obs;
  RxList<GamePlayed> searchedGames = <GamePlayed>[].obs;

  @override
  onInit() {
    super.onInit();
    authController.mToken.listen((p0) async {
      if (p0 != '0') {
        getAllGames();
        getUserGames();
      }
    });
  }

  Future<void> getAllGames() async {
    isLoading.value = true;
    try {
      var response = await http.get(Uri.parse(ApiLink.getAllGames), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });

      debugPrint(response.body);
      if (response.statusCode == 200) {
        var list = List.from(jsonDecode(response.body));
        var games = list.map((e) => GamePlayed.fromJson(e)).toList();
        allGames.assignAll(games);
        filteredGames.assignAll(games);
      }
    } catch (error) {
      debugPrint("getting all games: ${error.toString()}");
    }
    isLoading.value = false;
  }

  Future getUserGames() async {
    var response = await http.get(Uri.parse(ApiLink.getUserGames), headers: {
      "Content-type": "application/json",
      "Authorization": "JWT ${authController.token}"
    });

    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var list = List.from(jsonDecode(response.body));
      var games = list.map((e) => GamePlayed.fromJson(e)).toList();
      userGames.assignAll(games);
      filteredUserGames.assignAll(games);
    }
  }

  Future getGameDetails(int id) async {
    try {
      var response = await http.get(Uri.parse(ApiLink.getGame(id)), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });

      debugPrint(response.body);
      if (response.statusCode == 200) {
        return GamePlayed.fromJson(jsonDecode(response.body));
      }
    } catch (error) {
      debugPrint("getting game: ${error.toString()}");
    }
  }

  Future getGameFollower(int id) async {
    try {
      var response =
          await http.get(Uri.parse(ApiLink.getGameFollowers(id)), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });

      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return json;
      }
    } catch (error) {
      debugPrint("getting game error: ${error.toString()}");
    }
  }

  Future followGame(int id) async {
    try {
      var response =
          await http.put(Uri.parse(ApiLink.followGame(id)), headers: {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      });

      var json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (json["message"].toString().contains("unfollowed")) {
          return "unfollowed";
        } else {
          return "followed";
        }
      } else {
        return "error";
      }
    } catch (err) {}
  }

  Future searchForGames(String query) async {
    try {
      var response =
          await http.get(Uri.parse(ApiLink.searchForGames(query)), headers: {
        "Authorization": "JWT ${authController.token}",
        "Content-type": "application/json"
      });
      var list = List.from(jsonDecode(response.body));
      var games = list.map((e) => GamePlayed.fromJson(e)).toList();
      searchedGames.assignAll(games);
    } catch (err) {}
  }
}
