import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String userName;
  String fullName;
  String email;
  String phoneNumber;
  String country;
  String state;
  String gender;
  String dOB;
  String? password;
  String? password2;
  String purpose;
  Profile? profile;
  Tokens? tokens;

  UserModel({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.state,
    required this.gender,
    required this.dOB,
    this.password,
    this.password2,
    required this.purpose,
    this.profile,
    this.tokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        country: json["country"],
        state: json["state"],
        gender: json["gender"],
        dOB: json["d_o_b"],
        purpose: json["purpose"],
        profile: Profile.fromJson(json["profile"]),
        tokens: Tokens.fromJson(json["tokens"]),
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "country": country,
        "state": state,
        "gender": gender,
        "d_o_b": dOB,
        "purpose": purpose,
        "profile": profile!.toJson(),
        "password": password,
        "password2": password2,
      };
}

class Profile {
  String? gameType;
  String? profilePicture;

  Profile({
    this.gameType,
    required this.profilePicture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        gameType: json["game_type"] ?? '',
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "game_type": gameType,
        "profile_picture": profilePicture,
      };
}

class Tokens {
  String refresh;
  String access;

  Tokens({
    required this.refresh,
    required this.access,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}
