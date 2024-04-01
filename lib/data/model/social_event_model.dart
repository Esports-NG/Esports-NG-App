// To parse this JSON data, do
//
//     final socialEventModel = socialEventModelFromJson(jsonString);

import 'dart:convert';

SocialEventModel socialEventModelFromJson(String str) =>
    SocialEventModel.fromJson(json.decode(str));

String socialEventModelToJson(SocialEventModel data) =>
    json.encode(data.toJson());

class SocialEventModel {
  final int? id;
  final Creator? creator;
  final DateTime? createdAt;
  final String? name;
  final String? description;
  final String? entryFee;
  final List<GamesCovered>? gamesCovered;
  final DateTime? registrationStart;
  final DateTime? registrationEnd;
  final DateTime? start;
  final DateTime? end;
  final String? image;
  final String? venue;
  final String? link;

  SocialEventModel({
    this.id,
    this.creator,
    this.createdAt,
    this.name,
    this.description,
    this.entryFee,
    this.gamesCovered,
    this.registrationStart,
    this.registrationEnd,
    this.start,
    this.end,
    this.image,
    this.venue,
    this.link,
  });

  factory SocialEventModel.fromJson(Map<String, dynamic> json) =>
      SocialEventModel(
        id: json["id"],
        creator:
            json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        name: json["name"],
        description: json["description"],
        entryFee: json["entry_fee"],
        gamesCovered: json["games_covered"] == null
            ? []
            : List<GamesCovered>.from(
                json["games_covered"]!.map((x) => GamesCovered.fromJson(x))),
        registrationStart: json["registration_start"] == null
            ? null
            : DateTime.parse(json["registration_start"]),
        registrationEnd: json["registration_end"] == null
            ? null
            : DateTime.parse(json["registration_end"]),
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        image: json["image"],
        venue: json["venue"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creator": creator?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "name": name,
        "description": description,
        "entry_fee": entryFee,
        "games_covered": gamesCovered == null
            ? []
            : List<dynamic>.from(gamesCovered!.map((x) => x.toJson())),
        "registration_start": registrationStart?.toIso8601String(),
        "registration_end": registrationEnd?.toIso8601String(),
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "image": image,
        "venue": venue,
        "link": link,
      };
}

class Creator {
  final int? id;
  final String? name;
  final dynamic logo;
  final dynamic cover;
  final String? bio;
  final Owner? owner;
  final List<dynamic>? gamesPlayed;
  final DateTime? createdAt;
  final bool? enableTeamchat;
  final List<Social>? socials;
  final List<dynamic>? commStaffs;

  Creator({
    this.id,
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
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
        cover: json["cover"],
        bio: json["bio"],
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        gamesPlayed: json["games_played"] == null
            ? []
            : List<dynamic>.from(json["games_played"]!.map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
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
        "owner": owner?.toJson(),
        "games_played": gamesPlayed == null
            ? []
            : List<dynamic>.from(gamesPlayed!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "enable_teamchat": enableTeamchat,
        "socials": socials == null
            ? []
            : List<dynamic>.from(socials!.map((x) => x.toJson())),
        "comm_staffs": commStaffs == null
            ? []
            : List<dynamic>.from(commStaffs!.map((x) => x)),
      };
}

class Owner {
  final int? id;
  final String? userName;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? country;
  final String? state;
  final String? gender;
  final DateTime? dOB;
  final String? referralCode;
  final List<Purpose>? purpose;
  final Profile? profile;
  final bool? isVerified;

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
  final List<Category>? gameType;
  final String? profilePicture;

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

class Category {
  final int? id;
  final String? type;

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

class Purpose {
  final int? id;
  final String? purpose;

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

class GamesCovered {
  final int? id;
  final String? name;
  final String? abbrev;
  final String? profilePicture;
  final String? cover;
  final int? communities;
  final int? teams;
  final int? players;
  final List<Category>? categories;
  final List<GameMode>? gameModes;
  final List<Owner>? contributors;

  GamesCovered({
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

  factory GamesCovered.fromJson(Map<String, dynamic> json) => GamesCovered(
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
            : List<Owner>.from(
                json["contributors"]!.map((x) => Owner.fromJson(x))),
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

class GameMode {
  final int? id;
  final String? name;
  final String? subCategories;

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
