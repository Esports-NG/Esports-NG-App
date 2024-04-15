// To parse this JSON data, do
//
//     final playerModel = playerModelFromJson(jsonString);

import 'dart:convert';

PlayerModel playerModelFromJson(String str) =>
    PlayerModel.fromJson(json.decode(str));

String playerModelToJson(PlayerModel data) => json.encode(data.toJson());

class PlayerModel {
  int? id;
  Player? player;
  dynamic profile;
  List<dynamic>? statistics;
  GamePlayed? gamePlayed;
  String? inGameId;
  String? inGameName;
  bool? isCaptain;

  PlayerModel({
    this.id,
    this.player,
    this.profile,
    this.statistics,
    this.gamePlayed,
    this.inGameId,
    this.inGameName,
    this.isCaptain,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) => PlayerModel(
        id: json["id"],
        player: json["player"] == null ? null : Player.fromJson(json["player"]),
        profile: json["profile"],
        statistics: json["statistics"] == null
            ? []
            : List<dynamic>.from(json["statistics"]!.map((x) => x)),
        gamePlayed: json["game_played"] == null
            ? null
            : GamePlayed.fromJson(json["game_played"]),
        inGameId: json["in_game_id"],
        inGameName: json["in_game_name"],
        isCaptain: json["is_captain"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "player": player?.toJson(),
        "profile": profile,
        "statistics": statistics == null
            ? []
            : List<dynamic>.from(statistics!.map((x) => x)),
        "game_played": gamePlayed?.toJson(),
        "in_game_id": inGameId,
        "in_game_name": inGameName,
        "is_captain": isCaptain,
      };

  Map<String, dynamic> toCreatePlayerJson() => {
        "id": id,
        "in_game_id": inGameId,
        "in_game_name": inGameName,
      };
}

class GamePlayed {
  int? id;
  String? name;
  String? abbrev;
  String? profilePicture;
  String? cover;
  int? communities;
  int? teams;
  int? players;
  List<Category>? categories;
  List<GameMode>? gameModes;
  List<Player>? contributors;

  GamePlayed({
    this.id,
    this.name,
    this.abbrev,
    this.profilePicture,
    this.cover,
    this.communities,
    this.teams,
    this.players,
    this.categories,
    this.gameModes,
    this.contributors,
  });

  factory GamePlayed.fromJson(Map<String, dynamic> json) => GamePlayed(
        id: json["id"],
        name: json["name"],
        abbrev: json["abbrev"],
        profilePicture: json["profile_picture"],
        cover: json["cover"],
        communities: json["communities"],
        teams: json["teams"],
        players: json["players"],
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        gameModes: json["game_modes"] == null
            ? []
            : List<GameMode>.from(
                json["game_modes"]!.map((x) => GameMode.fromJson(x))),
        contributors: json["contributors"] == null
            ? []
            : List<Player>.from(
                json["contributors"]!.map((x) => Player.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "abbrev": abbrev,
        "profile_picture": profilePicture,
        "cover": cover,
        "communities": communities,
        "teams": teams,
        "players": players,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "game_modes": gameModes == null
            ? []
            : List<dynamic>.from(gameModes!.map((x) => x.toJson())),
        "contributors": contributors == null
            ? []
            : List<dynamic>.from(contributors!.map((x) => x.toJson())),
      };
}

class Category {
  int? id;
  String? type;

  Category({
    this.id,
    this.type,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
      };
}

class Player {
  int? id;
  String? userName;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? country;
  String? state;
  String? gender;
  DateTime? dOB;
  String? referralCode;
  List<Purpose>? purpose;
  Profile? profile;

  Player({
    this.id,
    this.userName,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.country,
    this.state,
    this.gender,
    this.dOB,
    this.referralCode,
    this.purpose,
    this.profile,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json["id"],
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        country: json["country"],
        state: json["state"],
        gender: json["gender"],
        dOB: json["d_o_b"] == null ? null : DateTime.parse(json["d_o_b"]),
        referralCode: json["referral_code"],
        purpose: json["purpose"] == null
            ? []
            : List<Purpose>.from(
                json["purpose"]!.map((x) => Purpose.fromJson(x))),
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "country": country,
        "state": state,
        "gender": gender,
        "d_o_b":
            "${dOB!.year.toString().padLeft(4, '0')}-${dOB!.month.toString().padLeft(2, '0')}-${dOB!.day.toString().padLeft(2, '0')}",
        "referral_code": referralCode,
        "purpose": purpose == null
            ? []
            : List<dynamic>.from(purpose!.map((x) => x.toJson())),
        "profile": profile?.toJson(),
      };
}

class Profile {
  List<Category>? gameType;
  String? profilePicture;

  Profile({
    this.gameType,
    this.profilePicture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        gameType: json["game_type"] == null
            ? []
            : List<Category>.from(
                json["game_type"]!.map((x) => Category.fromJson(x))),
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "game_type": gameType == null
            ? []
            : List<dynamic>.from(gameType!.map((x) => x.toJson())),
        "profile_picture": profilePicture,
      };
}

class Purpose {
  int? id;
  String? purpose;

  Purpose({
    this.id,
    this.purpose,
  });

  factory Purpose.fromJson(Map<String, dynamic> json) => Purpose(
        id: json["id"],
        purpose: json["purpose"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "purpose": purpose,
      };
}

class GameMode {
  int? id;
  String? name;
  String? subCategories;

  GameMode({
    this.id,
    this.name,
    this.subCategories,
  });

  factory GameMode.fromJson(Map<String, dynamic> json) => GameMode(
        id: json["id"],
        name: json["name"],
        subCategories: json["sub_categories"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sub_categories": subCategories,
      };
}
