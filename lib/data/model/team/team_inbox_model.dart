import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';

class TeamInboxModel {
  int? id;
  TeamModel? team;
  List<Message>? message;

  TeamInboxModel({
    this.id,
    this.team,
    this.message,
  });

  factory TeamInboxModel.fromJson(Map<String, dynamic> json) => TeamInboxModel(
        id: json["id"],
        team: json["team"] == null ? null : TeamModel.fromJson(json["team"]),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"]!.map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team": team?.toJson(),
        "message": message == null
            ? []
            : List<dynamic>.from(message!.map((x) => x.toJson())),
      };
}

class Message {
  int? id;
  String? name;
  String? text;

  Message({
    this.id,
    this.name,
    this.text,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        name: json["name"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "text": text,
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

class Owner {
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
  bool? isVerified;

  Owner({
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
    this.isVerified,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
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
        isVerified: json["is_verified"],
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
        "is_verified": isVerified,
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

class Member {
  int? id;
  Owner? player;
  dynamic profile;
  List<dynamic>? statistics;
  GamePlayed? gamePlayed;
  String? inGameId;
  String? inGameName;
  bool? isCaptain;

  Member({
    this.id,
    this.player,
    this.profile,
    this.statistics,
    this.gamePlayed,
    this.inGameId,
    this.inGameName,
    this.isCaptain,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        player: json["player"] == null ? null : Owner.fromJson(json["player"]),
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
}
