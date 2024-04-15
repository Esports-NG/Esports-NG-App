// To parse this JSON data, do
//
//     final userDataWithFollowers = userDataWithFollowersFromJson(jsonString);

import 'dart:convert';

UserDataWithFollowers userDataWithFollowersFromJson(String str) =>
    UserDataWithFollowers.fromJson(json.decode(str));

String userDataWithFollowersToJson(UserDataWithFollowers data) =>
    json.encode(data.toJson());

class UserDataWithFollowers {
  final int? id;
  final String? userName;
  final String? fullName;
  final String? email;
  final String? bio;
  final String? phoneNumber;
  final String? country;
  final String? state;
  final String? gender;
  final DateTime? dOB;
  final String? referralCode;
  final List<Purpose>? purpose;
  final Profile? profile;
  final bool? isVerified;
  final int? followers;
  final int? following;

  UserDataWithFollowers({
    this.id,
    this.userName,
    this.fullName,
    this.bio,
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
    this.followers,
    this.following,
  });

  factory UserDataWithFollowers.fromJson(Map<String, dynamic> json) =>
      UserDataWithFollowers(
        id: json["id"],
        userName: json["user_name"],
        fullName: json["full_name"],
        bio: json["bio"],
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
        followers: json["followers"],
        following: json["following"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "full_name": fullName,
        "bio": bio,
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
        "followers": followers,
        "following": following,
      };
}

class Profile {
  final List<GameType>? gameType;
  final dynamic profilePicture;

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
  final int? id;
  final String? type;

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
