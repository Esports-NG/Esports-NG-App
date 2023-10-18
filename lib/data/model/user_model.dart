class UserModel {
  String userName;
  String fullName;
  String email;
  String phoneNumber;
  String? country;
  String? state;
  String gender;
  String dOB;
  String? password;
  String? password2;
  List<String>? iPurpose;
  Profile? profile;
  Tokens? tokens;

  UserModel({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.country,
    this.state,
    required this.gender,
    required this.dOB,
    this.password,
    this.password2,
    required this.iPurpose,
    this.profile,
    this.tokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        country: json["country"] ?? '',
        state: json["state"] ?? '',
        gender: json["gender"],
        dOB: json["d_o_b"],
        iPurpose: json["ipurpose"] == null
            ? []
            : List<String>.from(json["ipurpose"]!.map((x) => x)),
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "country": country ?? '',
        "state": state ?? '',
        "gender": gender,
        "d_o_b": dOB,
        "ipurpose":
            iPurpose == null ? [] : List<dynamic>.from(iPurpose!.map((x) => x)),
        "profile": profile!.toJson(),
        "password": password,
        "password2": password2,
      };
}

class Profile {
  List<String>? iGameType;
  String? profilePicture;

  Profile({
    this.iGameType,
    required this.profilePicture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        iGameType: json["igame_type"] == null
            ? []
            : List<String>.from(json["igame_type"]!.map((x) => x)),
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "igame_type": iGameType == null
            ? []
            : List<dynamic>.from(iGameType!.map((x) => x)),
        "profile_picture": profilePicture,
      };
}

class Tokens {
  String? refresh;
  String? access;

  Tokens({
    this.refresh,
    this.access,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
        refresh: json["refresh"] ?? '',
        access: json["access"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };
}
