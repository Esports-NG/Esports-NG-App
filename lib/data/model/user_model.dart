import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String email;
  String phoneNo;
  String password;
  String password2;
  String country;
  String state;
  String gender;
  DateTime dOB;
  String purpose;
  Profile profile;

  UserModel({
    required this.email,
    required this.phoneNo,
    required this.password,
    required this.password2,
    required this.country,
    required this.state,
    required this.gender,
    required this.dOB,
    required this.purpose,
    required this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json["email"],
        phoneNo: json["phone_no"],
        password: json["password"],
        password2: json["password2"],
        country: json["country"],
        state: json["state"],
        gender: json["gender"],
        dOB: DateTime.parse(json["d_o_b"]),
        purpose: json["purpose"],
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone_no": phoneNo,
        "password": password,
        "password2": password2,
        "country": country,
        "state": state,
        "gender": gender,
        "d_o_b":
            "${dOB.year.toString().padLeft(4, '0')}-${dOB.month.toString().padLeft(2, '0')}-${dOB.day.toString().padLeft(2, '0')}",
        "purpose": purpose,
        "profile": profile.toJson(),
      };
}

class Profile {
  String gameType;
  ProfilePicture profilePicture;

  Profile({
    required this.gameType,
    required this.profilePicture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        gameType: json["game_type"],
        profilePicture: ProfilePicture.fromJson(json["profile_picture"]),
      );

  Map<String, dynamic> toJson() => {
        "game_type": gameType,
        "profile_picture": profilePicture.toJson(),
      };
}

class ProfilePicture {
  String title;
  String imageUrl;

  ProfilePicture({
    required this.title,
    required this.imageUrl,
  });

  factory ProfilePicture.fromJson(Map<String, dynamic> json) => ProfilePicture(
        title: json["title"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image_url": imageUrl,
      };
}
