import 'dart:convert';

import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GamesRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  RxList<GamePlayed> allGames = <GamePlayed>[].obs;
  Rx<GamePlayed?> selectedGame = Rx(null);
  RxString selectedGameName = "".obs;
  RxBool isLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    getAllGames();
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
      }
    } catch (error) {
      debugPrint("getting all games: ${error.toString()}");
    }
    isLoading.value = false;
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
}
