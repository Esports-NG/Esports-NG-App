import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/user_model.dart';

class CommunityModel {
  int? id;
  String? name;
  dynamic logo;
  dynamic cover;
  String? bio;
  String? abbrev;
  UserModel? owner;
  String? slug;
  List<GamePlayed>? gamesPlayed;
  DateTime? createdAt;
  bool? enableTeamchat;
  List<Social>? socials;
  List<dynamic>? commStaffs;
  int? followers;
  int? following;
  bool? isVerified;

  CommunityModel(
      {this.id,
      this.name,
      this.logo,
      this.cover,
      this.bio,
      this.owner,
      this.gamesPlayed,
      this.createdAt,
      this.enableTeamchat,
      this.socials,
      this.commStaffs,
      this.followers,
      this.abbrev,
      this.following,
      this.slug,
      this.isVerified});

  factory CommunityModel.fromJson(Map<String, dynamic> json) => CommunityModel(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
        cover: json["cover"],
        bio: json["bio"],
        slug: json["slug"],
        isVerified: json['is_verified'],
        abbrev: json["abbrev"],
        owner: json["owner"] == null ? null : UserModel.fromJson(json["owner"]),
        gamesPlayed: json["games_played"] == null
            ? []
            : List<GamePlayed>.from(
                json["games_played"]!.map((x) => GamePlayed.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        followers: json["followers"],
        following: json["following"],
        enableTeamchat: json["enable_teamchat"],
        socials: json["socials"] == null
            ? []
            : List<Social>.from(
                json["socials"]!.map((x) => Social.fromJson(x))),
        commStaffs: json["comm_staffs"] == null
            ? []
            : List<dynamic>.from(json["comm_staffs"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
        "cover": cover,
        "bio": bio,
        "abbrev": abbrev,
        "owner": owner?.toJson(),
        "games_played": gamesPlayed == null
            ? []
            : List<GamePlayed>.from(gamesPlayed!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "enable_teamchat": enableTeamchat,
        "socials": socials == null
            ? []
            : List<dynamic>.from(socials!.map((x) => x.toJson())),
        "following": following,
        "followers": followers,
        "comm_staffs": commStaffs == null
            ? []
            : List<dynamic>.from(commStaffs!.map((x) => x)),
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

class Social {
  Social();

  factory Social.fromJson(Map<String, dynamic> json) => Social();

  Map<String, dynamic> toJson() => {};
}
