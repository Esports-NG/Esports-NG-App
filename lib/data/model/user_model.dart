import 'dart:convert';

List<UserModel> userModelListFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

class UserModel {
  int? id;
  String? email;
  String? fullName;
  String? userName;
  String? phoneNumber;
  String? password;
  String? password2;
  String? country;
  String? state;
  String? gender;
  String? bio;
  String? dOB;
  List<String>? ipurpose;
  Profile? profile;
  UserProfile? userProfile;
  String? referralCode;
  List<Purpose>? purpose;
  bool? isVerified;
  Tokens? tokens;
  List<dynamic>? following;
  List<dynamic>? followers;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.userName,
    this.phoneNumber,
    this.password,
    this.password2,
    this.country,
    this.state,
    this.gender,
    this.dOB,
    this.ipurpose,
    this.profile,
    this.userProfile,
    this.referralCode,
    this.purpose,
    this.isVerified,
    this.tokens,
    this.following,
    this.followers,
    this.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"],
        bio: json["bio"],
        fullName: json["full_name"],
        userName: json["user_name"],
        phoneNumber: json["phone_number"],
        country: json["country"],
        state: json["state"],
        gender: json["gender"],
        dOB: json["d_o_b"],
        ipurpose: json["ipurpose"] == null
            ? []
            : List<String>.from(json["ipurpose"]!.map((x) => x)),
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        referralCode: json["referral_code"],
        purpose: json["purpose"] == null
            ? []
            : List<Purpose>.from(
                json["purpose"]!.map((x) => Purpose.fromJson(x))),
        userProfile: json["profile"] == null
            ? null
            : UserProfile.fromJson(json["profile"]),
        isVerified: json["is_verified"] ?? false,
        tokens: json["tokens"] == null ? null : Tokens.fromJson(json["tokens"]),
        following: json["following"] == null
            ? []
            : List<dynamic>.from(json["following"]!.map((x) => x)),
        followers: json["followers"] == null
            ? []
            : List<dynamic>.from(json["followers"]!.map((x) => x)),
      );

  factory UserModel.fromPostJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        bio: json["bio"],
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        country: json["country"],
        state: json["state"],
        gender: json["gender"],
        dOB: json["d_o_b"],
        referralCode: json["referral_code"],
        purpose: json["purpose"] == null
            ? []
            : List<Purpose>.from(
                json["purpose"]!.map((x) => Purpose.fromJson(x))),
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
      );

  Map<String, String> toRequestJson() => {
        "email": email!,
        "full_name": fullName!,
        "user_name": userName!,
        "bio": bio!,
        "phone_number": phoneNumber!,
        "password": password!,
        "password2": password2!,
        "country": country!,
        "state": state!,
        "gender": gender!,
        "d_o_b": dOB!,
        // "ipurpose":
        //     ipurpose == null ? [] : List<dynamic>.from(ipurpose!.map((x) => x)),
        // "profile": profile?.toJson()
      };

  Map<String, dynamic> toJson() => {
        "email": email,
        "full_name": fullName,
        "user_name": userName,
        "bio": bio,
        "phone_number": phoneNumber,
        "password": password,
        "password2": password2,
        "country": country,
        "state": state,
        "gender": gender,
        "d_o_b": dOB,
        "ipurpose":
            ipurpose == null ? [] : List<dynamic>.from(ipurpose!.map((x) => x)),
        "profile": profile?.toJson(),
      };

  Map<String, dynamic> toUser() => {
        "id": id,
        "email": email,
        "full_name": fullName,
        "user_name": userName,
        "bio": bio,
        "phone_number": phoneNumber,
        "country": country,
        "state": state,
        "gender": gender,
        "d_o_b": dOB,
        "referral_code": referralCode,
        "purpose": purpose == null
            ? []
            : List<dynamic>.from(purpose!.map((x) => x.toJson())),
        "profile": userProfile?.toJson(),
        "is_verified": isVerified,
        "following": following == null
            ? []
            : List<dynamic>.from(following!.map((x) => x)),
        "followers": followers == null
            ? []
            : List<dynamic>.from(followers!.map((x) => x)),
      };

  Map<String, dynamic> toPostUser() => {
        "id": id,
        "email": email,
        "bio": bio,
        "full_name": fullName,
        "user_name": userName,
        "phone_number": phoneNumber,
        "country": country,
        "state": state,
        "gender": gender,
        "d_o_b": dOB,
        "referral_code": referralCode,
        "purpose": purpose == null
            ? []
            : List<dynamic>.from(purpose!.map((x) => x.toJson())),
        "profile": userProfile?.toJson(),
      };
}

class Profile {
  List<String>? igameType;
  dynamic profilePicture;
  dynamic cover;

  Profile({
    this.igameType,
    this.profilePicture,
    this.cover,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      igameType: json["igame_type"] == null
          ? []
          : List<String>.from(json["igame_type"]!.map((x) => x)),
      profilePicture: json["profile_picture"],
      cover: json["cover"]);

  Map<String, dynamic> toJson() => {
        "igame_type": igameType == null
            ? []
            : List<dynamic>.from(igameType!.map((x) => x)),
        "profile_picture": profilePicture,
      };
}

class UserProfile {
  List<GameType>? gameType;
  dynamic profilePicture;

  UserProfile({this.gameType, this.profilePicture});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
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

  GameType({this.id, this.type});

  factory GameType.fromJson(Map<String, dynamic> json) =>
      GameType(id: json["id"], type: json["type"]);

  Map<String, dynamic> toJson() => {"id": id, "type": type};
}

class Purpose {
  int? id;
  String? purpose;

  Purpose({this.id, this.purpose});

  factory Purpose.fromJson(Map<String, dynamic> json) =>
      Purpose(id: json["id"], purpose: json["purpose"]);

  Map<String, dynamic> toJson() => {"id": id, "purpose": purpose};
}

class Tokens {
  String? refresh;
  String? access;

  Tokens({this.refresh, this.access});

  factory Tokens.fromJson(Map<String, dynamic> json) =>
      Tokens(refresh: json["refresh"], access: json["access"]);

  Map<String, dynamic> toJson() => {"refresh": refresh, "access": access};
}
