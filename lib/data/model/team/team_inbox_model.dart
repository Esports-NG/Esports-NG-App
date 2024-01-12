class TeamInboxModel {
  int? id;
  Team? team;
  List<Message>? message;

  TeamInboxModel({
    this.id,
    this.team,
    this.message,
  });

  factory TeamInboxModel.fromJson(Map<String, dynamic> json) => TeamInboxModel(
        id: json["id"],
        team: json["team"] == null ? null : Team.fromJson(json["team"]),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"]!.map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team": team?.toJson(),
        "message": message == null
            ? []
            : List<dynamic>.from(message!.map((x) => x.toJson())),
      };
}

class Message {
  int? id;
  String? name;
  String? text;

  Message({
    this.id,
    this.name,
    this.text,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        name: json["name"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "text": text,
      };
}

class Team {
  int? id;
  Owner? owner;
  String? name;
  String? profilePicture;
  String? cover;
  GamePlayed? gamePlayed;
  String? bio;
  dynamic manager;
  List<Member>? members;
  List<dynamic>? teamStaffs;
  String? membersCount;

  Team({
    this.id,
    this.owner,
    this.name,
    this.profilePicture,
    this.cover,
    this.gamePlayed,
    this.bio,
    this.manager,
    this.members,
    this.teamStaffs,
    this.membersCount,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"],
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        name: json["name"],
        profilePicture: json["profile_picture"],
        cover: json["cover"],
        gamePlayed: json["game_played"] == null
            ? null
            : GamePlayed.fromJson(json["game_played"]),
        bio: json["bio"],
        manager: json["manager"],
        members: json["members"] == null
            ? []
            : List<Member>.from(
                json["members"]!.map((x) => Member.fromJson(x))),
        teamStaffs: json["team_staffs"] == null
            ? []
            : List<dynamic>.from(json["team_staffs"]!.map((x) => x)),
        membersCount: json["members_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner?.toJson(),
        "name": name,
        "profile_picture": profilePicture,
        "cover": cover,
        "game_played": gamePlayed?.toJson(),
        "bio": bio,
        "manager": manager,
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "team_staffs": teamStaffs == null
            ? []
            : List<dynamic>.from(teamStaffs!.map((x) => x)),
        "members_count": membersCount,
      };
}

class GamePlayed {
  int? id;
  String? name;
  String? abbrev;
  String? profilePicture;
  String? cover;
  int? communities;
  int? teams;
  int? players;
  List<Category>? categories;
  List<GameMode>? gameModes;
  List<Owner>? contributors;

  GamePlayed({
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

  factory GamePlayed.fromJson(Map<String, dynamic> json) => GamePlayed(
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

class Category {
  int? id;
  String? type;

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
  bool? isVerified;

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
  List<Category>? gameType;
  String? profilePicture;

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

class GameMode {
  int? id;
  String? name;
  String? subCategories;

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

class Member {
  int? id;
  Owner? player;
  dynamic profile;
  List<dynamic>? statistics;
  GamePlayed? gamePlayed;
  String? inGameId;
  String? inGameName;
  bool? isCaptain;

  Member({
    this.id,
    this.player,
    this.profile,
    this.statistics,
    this.gamePlayed,
    this.inGameId,
    this.inGameName,
    this.isCaptain,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        player: json["player"] == null ? null : Owner.fromJson(json["player"]),
        profile: json["profile"],
        statistics: json["statistics"] == null
            ? []
            : List<dynamic>.from(json["statistics"]!.map((x) => x)),
        gamePlayed: json["game_played"] == null
            ? null
            : GamePlayed.fromJson(json["game_played"]),
        inGameId: json["in_game_id"],
        inGameName: json["in_game_name"],
        isCaptain: json["is_captain"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "player": player?.toJson(),
        "profile": profile,
        "statistics": statistics == null
            ? []
            : List<dynamic>.from(statistics!.map((x) => x)),
        "game_played": gamePlayed?.toJson(),
        "in_game_id": inGameId,
        "in_game_name": inGameName,
        "is_captain": isCaptain,
      };
}
