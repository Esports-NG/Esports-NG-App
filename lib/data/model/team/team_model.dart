import 'dart:convert';

import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/user_model.dart';

import 'team_inbox_model.dart';

List<TeamModel> teamModelListFromJson(String str) =>
    List<TeamModel>.from(json.decode(str).map((x) => TeamModel.fromJson(x)));

class TeamModel {
  int? id;
  Author? owner;
  String? abbrev;
  String? name;
  String? profilePicture;
  String? cover;
  List<GamePlayed>? gamesPlayed;
  String? bio;
  dynamic manager;
  List<Member>? members;
  List<UserModel>? players;
  String? membersCount;
  int? playersCount;

  TeamModel(
      {this.id,
      this.owner,
      this.name,
      this.profilePicture,
      this.cover,
      this.gamesPlayed,
      this.bio,
      this.manager,
      this.members,
      this.playersCount,
      this.membersCount,
      this.abbrev,
      this.players});

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
      id: json["id"],
      owner: json["owner"] == null ? null : Author.fromJson(json["owner"]),
      name: json["name"],
      profilePicture: json["profile_picture"],
      cover: json["cover"],
      abbrev: json["abbrev"],
      gamesPlayed: json["games_played"] == null
          ? []
          : List<GamePlayed>.from(
              json["games_played"]!.map((x) => GamePlayed.fromJson(x))),
      bio: json["bio"],
      manager: json["manager"],
      players: json["players"] == null
          ? []
          : List<UserModel>.from(
              json["players"]!.map((x) => UserModel.fromJson(x))),
      members: json["members"] == null
          ? []
          : List<Member>.from(json["members"]!.map((x) => Member.fromJson(x))),
      membersCount: json["members_count"],
      playersCount: json["players_count"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner?.toJson(),
        "name": name,
        "profile_picture": profilePicture,
        "cover": cover,
        "games_played": gamesPlayed,
        "bio": bio,
        "abbrev": abbrev,
        "manager": manager,
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "members_count": membersCount,
      };

  Map<String, dynamic> toCreateTeamJson() => {
        "id": id,
        "name": name,
        "bio": bio,
        "members":
            members == null ? [] : List<dynamic>.from(members!.map((x) => x)),
        "members_count": membersCount,
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
  List<GameType>? gameType;
  String? profilePicture;

  Profile({
    this.gameType,
    this.profilePicture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        gameType: json["game_type"] == null
            ? []
            : List<GameType>.from(
                json["game_type"]!.map((x) => GameType.fromJson(x))),
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "game_type": gameType == null
            ? []
            : List<dynamic>.from(gameType!.map((x) => x.toJson())),
        "profile_picture": profilePicture,
      };
}

class GameType {
  int? id;
  String? type;

  GameType({
    this.id,
    this.type,
  });

  factory GameType.fromJson(Map<String, dynamic> json) => GameType(
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
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

List<TeamApplicationModel> teamApplicationModelFromJson(String str) =>
    List<TeamApplicationModel>.from(
        json.decode(str).map((x) => TeamApplicationModel.fromJson(x)));

String teamApplicationModelToJson(List<TeamApplicationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TeamApplicationModel {
  final int? id;
  final Team? team;
  final String? message;
  final List<PlayerModel>? playerProfiles;
  final String? role;
  final bool? accepted;
  final UserModel? applicant;

  TeamApplicationModel(
      {this.id,
      this.team,
      this.message,
      this.playerProfiles,
      this.role,
      this.accepted,
      this.applicant});

  factory TeamApplicationModel.fromJson(Map<String, dynamic> json) =>
      TeamApplicationModel(
          id: json["id"],
          team: json["team"] == null ? null : Team.fromJson(json["team"]),
          message: json["message"],
          playerProfiles: json["player_profiles"] == null
              ? []
              : List<PlayerModel>.from(
                  json["player_profiles"]!.map((x) => PlayerModel.fromJson(x))),
          role: json["role"],
          applicant: json["applicant"] == null
              ? null
              : UserModel.fromJson(json["applicant"]),
          accepted: json['accepted']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "team": team?.toJson(),
        "message": message,
        "player_profiles": playerProfiles == null
            ? []
            : List<dynamic>.from(playerProfiles!.map((x) => x.toJson())),
        "role": role,
      };
}
