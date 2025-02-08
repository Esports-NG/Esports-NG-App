// To parse this JSON data, do
//
//     final fixtureModel = fixtureModelFromJson(jsonString);

import 'dart:convert';

import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/platform_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';

List<FixtureModel> fixtureModelFromJson(String str) => List<FixtureModel>.from(
    json.decode(str).map((x) => FixtureModel.fromJson(x)));

String fixtureModelToJson(List<FixtureModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FixtureModel {
  final int? id;
  final String? title;
  final String? fixtureRound;
  final EventModel? tournament;
  final List<GameMode>? gameMode;
  final PlayerModel? homePlayer;
  final TeamModel? homeTeam;
  final int? homeScore;
  final List<PlayerModel>? players;
  final List<TeamModel>? teams;
  final PlayerModel? awayPlayer;
  final TeamModel? awayTeam;
  final int? awayScore;
  final DateTime? fixtureDate;
  final String? fixtureTime;
  final String? fixtureType;
  final String? fixtureGroup;
  final String? streamingLink;
  final String? streamingPlatform;
  final List<LivestreamModel>? livestreams;

  FixtureModel(
      {this.id,
      this.title,
      this.fixtureRound,
      this.tournament,
      this.gameMode,
      this.homePlayer,
      this.homeTeam,
      this.homeScore,
      this.players,
      this.teams,
      this.awayPlayer,
      this.awayTeam,
      this.awayScore,
      this.fixtureDate,
      this.fixtureTime,
      this.fixtureType,
      this.fixtureGroup,
      this.streamingLink,
      this.streamingPlatform,
      this.livestreams});

  factory FixtureModel.fromJson(Map<String, dynamic> json) => FixtureModel(
        id: json["id"],
        title: json["title"],
        fixtureRound: json["fixture_round"],
        tournament: json["tournament"] == null
            ? null
            : EventModel.fromJson(json["tournament"]),
        gameMode: json["game_mode"] == null
            ? null
            : List<GameMode>.from(
                json["livestreams"]!.map((x) => GameMode.fromJson(x))),
        homePlayer: json["home_player"] == null
            ? null
            : PlayerModel.fromJson(json["home_player"]),
        homeTeam: json["home_team"] == null
            ? null
            : TeamModel.fromJson(json["home_team"]),
        homeScore: json["home_score"],
        players: json["players"] == null
            ? []
            : List<PlayerModel>.from(
                json["players"]!.map((x) => PlayerModel.fromJson(x))),
        teams: json["teams"] == null
            ? []
            : List<TeamModel>.from(
                json["teams"]!.map((x) => TeamModel.fromJson(x))),
        awayPlayer: json["away_player"] == null
            ? null
            : PlayerModel.fromJson(json["away_player"]),
        awayTeam: json["away_team"] == null
            ? null
            : TeamModel.fromJson(json["away_team"]),
        awayScore: json["away_score"],
        fixtureDate: json["fixture_date"] == null
            ? null
            : DateTime.parse(json["fixture_date"]),
        fixtureTime: json["fixture_time"],
        fixtureType: json["fixture_type"],
        fixtureGroup: json["fixture_group"],
        streamingLink: json["streaming_link"],
        streamingPlatform: json["streaming_platform"],
        livestreams: json["livestreams"] == null
            ? []
            : List<LivestreamModel>.from(
                json["livestreams"]!.map((x) => LivestreamModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "fixture_round": fixtureRound,
        "tournament": tournament?.toJson(),
        // "game_mode": gameMode?.toJson(),
        "home_player": homePlayer?.toJson(),
        "home_team": homeTeam,
        "home_score": homeScore,
        "players":
            players == null ? [] : List<dynamic>.from(players!.map((x) => x)),
        "teams": teams == null ? [] : List<dynamic>.from(teams!.map((x) => x)),
        "away_player": awayPlayer?.toJson(),
        "away_team": awayTeam,
        "away_score": awayScore,
        "fixture_date":
            "${fixtureDate!.year.toString().padLeft(4, '0')}-${fixtureDate!.month.toString().padLeft(2, '0')}-${fixtureDate!.day.toString().padLeft(2, '0')}",
        "fixture_time": fixtureTime,
        "fixture_type": fixtureType,
        "fixture_group": fixtureGroup,
        "streaming_link": streamingLink,
        "streaming_platform": streamingPlatform,
      };
}

class LivestreamModel {
  final int? id;
  final String? title;
  final String? description;
  final DateTime? date;
  final String? time;
  final PlatformModel? platform;
  final String? link;

  LivestreamModel({
    this.id,
    this.title,
    this.description,
    this.date,
    this.time,
    this.platform,
    this.link,
  });

  factory LivestreamModel.fromJson(Map<String, dynamic> json) =>
      LivestreamModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        time: json["time"],
        platform: json["platform"] == null
            ? null
            : PlatformModel.fromJson(json["platform"]),
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "time": time,
        "platform": platform?.toJson(),
        "link": link,
      };
}
