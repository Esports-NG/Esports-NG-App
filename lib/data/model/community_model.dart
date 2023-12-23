class CommunityModel {
  int? id;
  String? name;
  String? logo;
  String? cover;
  String? bio;
  Owner? owner;
  List<dynamic>? gamesPlayed;
  DateTime? createdAt;
  bool? enableTeamchat;
  List<Social>? socials;
  List<dynamic>? commStaffs;

  CommunityModel({
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

  factory CommunityModel.fromJson(Map<String, dynamic> json) => CommunityModel(
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

  Map<String, dynamic> toCreateCommunityJson() => {
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

class Social {
  Social();

  factory Social.fromJson(Map<String, dynamic> json) => Social();

  Map<String, dynamic> toJson() => {};
}
