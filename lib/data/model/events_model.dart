class EventModel {
  int? id;
  String? profile;
  String? banner;
  String? name;
  String? type;
  Community? community;
  String? linkForBracket;
  String? gameMode;
  String? tournamentType;
  String? knockoutType;
  String? rankType;
  DateTime? regStart;
  DateTime? regEnd;
  DateTime? startDate;
  DateTime? endDate;
  String? prizePool;
  String? summary;
  String? entryFee;
  int? maxNo;
  String? description;
  String? requirements;
  String? structure;
  List<dynamic>? teams;
  List<dynamic>? players;
  String? rulesRegs;
  PrizePoolDistribution? prizePoolDistribution;

  EventModel({
    this.id,
    this.profile,
    this.banner,
    this.name,
    this.community,
    this.linkForBracket,
    this.gameMode,
    this.tournamentType,
    this.knockoutType,
    this.rankType,
    this.regStart,
    this.regEnd,
    this.startDate,
    this.endDate,
    this.prizePool,
    this.summary,
    this.entryFee,
    this.maxNo,
    this.description,
    this.requirements,
    this.structure,
    this.teams,
    this.players,
    this.rulesRegs,
    this.prizePoolDistribution,
    this.type,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        profile: json["profile"],
        banner: json["banner"],
        name: json["name"],
        type: json["type"],
        community: json["community"] == null
            ? null
            : Community.fromJson(json["community"]),
        linkForBracket: json["link_for_bracket"],
        gameMode: json["game_mode"],
        tournamentType: json["tournament_type"],
        knockoutType: json["knockout_type"],
        rankType: json["rank_type"],
        regStart: json["reg_start"] == null
            ? null
            : DateTime.parse(json["reg_start"]),
        regEnd:
            json["reg_end"] == null ? null : DateTime.parse(json["reg_end"]),
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        prizePool: json["prize_pool"],
        summary: json["summary"],
        entryFee: json["entry_fee"],
        maxNo: json["max_no"],
        description: json["description"],
        requirements: json["requirements"],
        structure: json["structure"],
        teams: json["teams"] == null
            ? []
            : List<dynamic>.from(json["teams"]!.map((x) => x)),
        players: json["players"] == null
            ? []
            : List<dynamic>.from(json["players"]!.map((x) => x)),
        rulesRegs: json["rules_regs"],
        prizePoolDistribution: json["prize_pool_distribution"] == null
            ? null
            : PrizePoolDistribution.fromJson(json["prize_pool_distribution"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile,
        "banner": banner,
        "name": name,
        "type": type,
        "community": community?.toJson(),
        "link_for_bracket": linkForBracket,
        "game_mode": gameMode,
        "tournament_type": tournamentType,
        "knockout_type": knockoutType,
        "rank_type": rankType,
        "reg_start":
            "${regStart!.year.toString().padLeft(4, '0')}-${regStart!.month.toString().padLeft(2, '0')}-${regStart!.day.toString().padLeft(2, '0')}",
        "reg_end":
            "${regEnd!.year.toString().padLeft(4, '0')}-${regEnd!.month.toString().padLeft(2, '0')}-${regEnd!.day.toString().padLeft(2, '0')}",
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "prize_pool": prizePool,
        "summary": summary,
        "entry_fee": entryFee,
        "max_no": maxNo,
        "description": description,
        "requirements": requirements,
        "structure": structure,
        "teams": teams == null ? [] : List<dynamic>.from(teams!.map((x) => x)),
        "players":
            players == null ? [] : List<dynamic>.from(players!.map((x) => x)),
        "rules_regs": rulesRegs,
        "prize_pool_distribution": prizePoolDistribution?.toJson(),
      };

  Map<String, dynamic> toCreateEventJson() => {
        "id": id,
        "name": name,
        // "bio": bio,
        // "members":
        //     members == null ? [] : List<dynamic>.from(members!.map((x) => x)),
        // "members_count": membersCount,
      };
}

class Community {
  int? id;
  String? name;
  dynamic logo;
  dynamic cover;
  String? bio;
  Owner? owner;
  List<dynamic>? gamesPlayed;
  DateTime? createdAt;
  bool? enableTeamchat;
  List<Social>? socials;
  List<dynamic>? commStaffs;
  int? followers;
  int? following;

  Community(
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
      this.following});

  factory Community.fromJson(Map<String, dynamic> json) => Community(
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
        "owner": owner?.toJson(),
        "games_played": gamesPlayed == null
            ? []
            : List<dynamic>.from(gamesPlayed!.map((x) => x)),
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

class Owner {
  int? id;
  String? userName;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? bio;
  String? country;
  String? state;
  String? gender;
  DateTime? dOB;
  String? referralCode;
  List<Purpose>? purpose;
  Profile? profile;

  Owner(
      {this.id,
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
      this.bio});

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"],
        bio: json["bio"],
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
        "bio": bio,
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

class PrizePoolDistribution {
  String? first;
  String? second;
  String? third;

  PrizePoolDistribution({
    this.first,
    this.second,
    this.third,
  });

  factory PrizePoolDistribution.fromJson(Map<String, dynamic> json) =>
      PrizePoolDistribution(
        first: json["first"],
        second: json["second"],
        third: json["third"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "second": second,
        "third": third,
      };
}
