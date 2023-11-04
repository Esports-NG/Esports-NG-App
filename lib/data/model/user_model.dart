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
  List<Purpose>? purpose;
  SignUpProfile? iProfile;
  Profile? profile;
  Tokens? tokens;
  List<dynamic>? following;
  List<dynamic>? followers;

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
    this.purpose,
    this.iProfile,
    this.profile,
    this.tokens,
    this.following,
    this.followers,
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
        purpose: json["purpose"] == null
            ? []
            : List<Purpose>.from(
                json["purpose"]!.map((x) => Purpose.fromJson(x))),
        iProfile: json["profile"] == null
            ? null
            : SignUpProfile.fromJson(json["profile"]),
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        following: json["following"] == null
            ? []
            : List<dynamic>.from(json["following"]!.map((x) => x)),
        followers: json["followers"] == null
            ? []
            : List<dynamic>.from(json["followers"]!.map((x) => x)),
        // tokens: json["tokens"] == null ? null : Tokens.fromJson(json["tokens"]),
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
        "ipurpose":
            iPurpose == null ? [] : List<dynamic>.from(iPurpose!.map((x) => x)),
        "profile": iProfile!.toJson(),
        "password": password,
        "password2": password2,
      };

  Map<String, dynamic> toUser() => {
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "country": country,
        "state": state,
        "gender": gender,
        "d_o_b": dOB,
        "purpose": purpose == null
            ? []
            : List<dynamic>.from(purpose!.map((x) => x.toJson())),
        "profile": profile?.toJson(),
        "following": following == null
            ? []
            : List<dynamic>.from(following!.map((x) => x)),
        "followers": followers == null
            ? []
            : List<dynamic>.from(followers!.map((x) => x)),
        // "tokens": tokens?.toJson(),
      };
}

class SignUpProfile {
  List<String>? iGameType;
  String? profilePicture;

  SignUpProfile({
    this.iGameType,
    required this.profilePicture,
  });

  factory SignUpProfile.fromJson(Map<String, dynamic> json) => SignUpProfile(
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
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
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

class Profile {
  List<GameType>? gameType;
  dynamic profilePicture;

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
