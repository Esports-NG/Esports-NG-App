// To parse this JSON data, do
//
//     final roasterModel = roasterModelFromJson(jsonString);

import 'dart:convert';

import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';

List<RoasterModel> roasterModelFromJson(String str) => List<RoasterModel>.from(
    json.decode(str).map((x) => RoasterModel.fromJson(x)));

String roasterModelToJson(List<RoasterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoasterModel {
  final int? id;
  final TeamModel? team;
  final GamePlayed? game;
  final List<PlayerModel>? players;
  final bool? isRoster;

  RoasterModel({
    this.id,
    this.team,
    this.game,
    this.players,
    this.isRoster,
  });

  factory RoasterModel.fromJson(Map<String, dynamic> json) => RoasterModel(
        id: json["id"],
        team: json["team"] == null ? null : TeamModel.fromJson(json["team"]),
        game: json["game"] == null ? null : GamePlayed.fromJson(json["game"]),
        players: json["players"] == null
            ? []
            : List<PlayerModel>.from(
                json["players"]!.map((x) => PlayerModel.fromJson(x))),
        isRoster: json["is_roster"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team": team?.toJson(),
        "game": game?.toJson(),
        "players": players == null
            ? []
            : List<dynamic>.from(players!.map((x) => x.toJson())),
        "is_roster": isRoster,
      };
}
