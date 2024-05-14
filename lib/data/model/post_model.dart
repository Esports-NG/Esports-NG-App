import 'package:e_sport/data/model/user_model.dart';

class PostModel {
  int? id;
  Author? author;
  String? title;
  PostModel? repost;
  dynamic community;
  String? body;
  List<String>? iTags;
  List<String>? iViewers;
  int? likeCount;
  List<Author>? likes;
  int? viewCount;
  List<Author>? views;
  List<Tag>? tags;
  int? repostCount;
  List<Viewer>? viewers;
  String? image;
  List<Comment>? comment;
  DateTime? createdAt;
  DateTime? updatedAt;

  PostModel({
    this.title,
    this.id,
    this.author,
    this.repost,
    this.community,
    this.body,
    this.iTags,
    this.iViewers,
    this.likeCount,
    this.likes,
    this.viewCount,
    this.views,
    this.tags,
    this.repostCount,
    this.viewers,
    this.image,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        title: json["title"],
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        repost:
            json["repost"] == null ? null : PostModel.fromJson(json['repost']),
        community: json["community"],
        body: json["body"],
        likeCount: json["like_count"],
        likes: json["likes"] == null
            ? []
            : List<Author>.from(json["likes"]!.map((x) => Author.fromJson(x))),
        viewCount: json["view_count"],
        views: json["views"] == null
            ? []
            : List<Author>.from(json["views"]!.map((x) => Author.fromJson(x))),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
        repostCount: json["repost_count"],
        viewers: json["viewers"] == null
            ? []
            : List<Viewer>.from(
                json["viewers"]!.map((x) => Viewer.fromJson(x))),
        image: json["image"],
        comment: json["comment"] == null
            ? []
            : List<Comment>.from(
                json["comment"]!.map((x) => Comment.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author?.toJson(),
        "repost": repost?.toJson(),
        "community": community,
        "body": body,
        "like_count": likeCount,
        "likes": likes == null
            ? []
            : List<dynamic>.from(likes!.map((x) => x.toJson())),
        "view_count": viewCount,
        "views": views == null
            ? []
            : List<dynamic>.from(views!.map((x) => x.toJson())),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "repost_count": repostCount,
        "viewers": viewers == null
            ? []
            : List<dynamic>.from(viewers!.map((x) => x.toJson())),
        "image": image,
        "comment": comment == null
            ? []
            : List<dynamic>.from(comment!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  Map<String, dynamic> toCreatePostJson() => {
        "title": title,
        "body": body,
        "itags": iTags,
        "iviewers": iViewers,
      };
}

class Author {
  int? id;
  String? email;
  String? fullName;
  String? userName;
  String? phoneNumber;
  String? country;
  String? state;
  String? gender;
  DateTime? dOB;
  List<Purpose>? purpose;
  Profile? profile;

  Author({
    this.id,
    this.email,
    this.fullName,
    this.userName,
    this.phoneNumber,
    this.country,
    this.state,
    this.gender,
    this.dOB,
    this.purpose,
    this.profile,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        email: json["email"],
        fullName: json["full_name"],
        userName: json["user_name"],
        phoneNumber: json["phone_number"],
        country: json["country"],
        state: json["state"],
        gender: json["gender"],
        dOB: json["d_o_b"] == null ? null : DateTime.parse(json["d_o_b"]),
        purpose: json["purpose"] == null
            ? []
            : List<Purpose>.from(
                json["purpose"]!.map((x) => Purpose.fromJson(x))),
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "full_name": fullName,
        "user_name": userName,
        "phone_number": phoneNumber,
        "country": country,
        "state": state,
        "gender": gender,
        "d_o_b":
            "${dOB!.year.toString().padLeft(4, '0')}-${dOB!.month.toString().padLeft(2, '0')}-${dOB!.day.toString().padLeft(2, '0')}",
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

class Comment {
  int? id;
  String? body;
  int? likes;
  List<Tag>? tags;
  dynamic image;
  UserModel? user;

  Comment({this.id, this.body, this.likes, this.tags, this.image, this.user});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        body: json["body"],
        user: UserModel.fromJson(json["user"]),
        likes: json["likes"],
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "likes": likes,
        "user": user,
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "image": image,
      };
}

class Tag {
  int? id;
  String? title;

  Tag({
    this.id,
    this.title,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}

class Viewer {
  int? id;
  String? name;

  Viewer({
    this.id,
    this.name,
  });

  factory Viewer.fromJson(Map<String, dynamic> json) => Viewer(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Posts {
  final String? image, pImage;
  final String? name, uName, postedBy;
  final String? time;
  final List? genre;
  final String? details;
  final String? likes;
  final String? comment;
  final String? views;
  final String? repost;

  Posts(
      {this.image,
      this.pImage,
      this.name,
      this.uName,
      this.time,
      this.genre,
      this.details,
      this.likes,
      this.comment,
      this.postedBy,
      this.views,
      this.repost});
}

var postItem = [
  Posts(
    image: 'assets/images/png/postImage1.png',
    pImage: 'assets/images/png/postDImage.png',
    name: 'CODM',
    uName: 'Empire#2245',
    time: '2hours ago',
    genre: ['Arcade', 'Strategy'],
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... ',
    likes: '5',
    comment: '32',
    views: '126',
    repost: '17',
  ),
  Posts(
    image: 'assets/images/png/postImage2.png',
    pImage: 'assets/images/png/postDImage.png',
    name: 'CODM',
    uName: 'Empire#2245',
    time: '2hours ago',
    genre: ['Arcade', 'Action', 'Strategy'],
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... ',
    likes: '5',
    comment: '32',
    views: '126',
    repost: '17',
  ),
  Posts(
    image: 'assets/images/png/postImage3.png',
    pImage: 'assets/images/png/postDImage.png',
    name: 'CODM',
    uName: 'Empire#2245',
    time: '2hours ago',
    genre: ['Arcade', 'Action', 'Strategy'],
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... ',
    likes: '5',
    comment: '32',
    views: '126',
    repost: '17',
  ),
];

var suggestedProfileItems = [
  Posts(
    image: 'assets/images/png/suggested-profile1.png',
    pImage: 'assets/images/png/suggested-profile.png',
    name: 'Michael Jay White',
    uName: 'captainbarbosa',
  ),
  Posts(
    image: 'assets/images/png/suggested-profile2.png',
    pImage: 'assets/images/png/suggested-profile.png',
    name: 'Michael Jay White',
    uName: 'captainbarbosa',
  ),
  Posts(
    image: 'assets/images/png/suggested-profile1.png',
    pImage: 'assets/images/png/suggested-profile.png',
    name: 'Michael Jay White',
    uName: 'captainbarbosa',
  ),
  Posts(
    image: 'assets/images/png/suggested-profile2.png',
    pImage: 'assets/images/png/suggested-profile.png',
    name: 'Michael Jay White',
    uName: 'captainbarbosa',
  ),
];

var latestNewsItems = [
  Posts(
    image: 'assets/images/png/newsImage1.png',
    name: 'AFRICA COMICADE SUCCESSFULLY RAISES THE BAR FOR GAMING IN AFRICA',
    uName: 'Powered by Nexal Gaming',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... New quest unlocked: Get a chance to win 5 new skins.',
    time: '2hours ago',
    postedBy: 'Linda Kareem',
  ),
  Posts(
    image: 'assets/images/png/newsImage1.png',
    name: 'AFRICA COMICADE SUCCESSFULLY RAISES THE BAR FOR GAMING IN AFRICA',
    uName: 'Powered by Nexal Gaming',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... New quest unlocked: Get a chance to win 5 new skins.',
    time: '2hours ago',
    postedBy: 'Linda Kareem',
  ),
  Posts(
    image: 'assets/images/png/newsImage1.png',
    name: 'AFRICA COMICADE SUCCESSFULLY RAISES THE BAR FOR GAMING IN AFRICA',
    uName: 'Powered by Nexal Gaming',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... New quest unlocked: Get a chance to win 5 new skins.',
    time: '2hours ago',
    postedBy: 'Linda Kareem',
  ),
  Posts(
    image: 'assets/images/png/newsImage1.png',
    name: 'AFRICA COMICADE SUCCESSFULLY RAISES THE BAR FOR GAMING IN AFRICA',
    uName: 'Powered by Nexal Gaming',
    details:
        'New quest unlocked: Get a chance to win 5 new skins by taking new challenge unlocked in the jungle terrain... New quest unlocked: Get a chance to win 5 new skins.',
    time: '2hours ago',
    postedBy: 'Linda Kareem',
  ),
];

var trendingGamesItems = [
  Posts(
    image: 'assets/images/png/trending-games1.png',
    pImage: 'assets/images/png/trending-games.png',
    name: 'Call of Duty (COD)',
    uName: '32,000 Players',
  ),
  Posts(
    image: 'assets/images/png/trending-games1.png',
    pImage: 'assets/images/png/trending-games.png',
    name: 'Call of Duty (COD)',
    uName: '32,000 Players',
  ),
  Posts(
    image: 'assets/images/png/trending-games1.png',
    pImage: 'assets/images/png/trending-games.png',
    name: 'Call of Duty (COD)',
    uName: '32,000 Players',
  ),
  Posts(
    image: 'assets/images/png/trending-games1.png',
    pImage: 'assets/images/png/trending-games.png',
    name: 'Call of Duty (COD)',
    uName: '32,000 Players',
  ),
];

var trendingCommunitiesItems = [
  Posts(
    image: 'assets/images/png/trending-community1.png',
    pImage: 'assets/images/png/trending-community.png',
    name: 'Kuzio Gaming Community',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/trending-community1.png',
    pImage: 'assets/images/png/trending-community.png',
    name: 'Kuzio Gaming Community',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/trending-community1.png',
    pImage: 'assets/images/png/trending-community.png',
    name: 'Kuzio Gaming Community',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/trending-community1.png',
    pImage: 'assets/images/png/trending-community.png',
    name: 'Kuzio Gaming Community',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/trending-community1.png',
    pImage: 'assets/images/png/trending-community.png',
    name: 'Kuzio Gaming Community',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/trending-community1.png',
    pImage: 'assets/images/png/trending-community.png',
    name: 'Kuzio Gaming Community',
    uName: '2,000 Members',
  ),
];

var trendingTeamsItems = [
  Posts(
    image: 'assets/images/png/trending-team.png',
    pImage: 'assets/images/png/trending-team1.png',
    name: 'Team Levi',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/trending-team.png',
    pImage: 'assets/images/png/trending-team1.png',
    name: 'Team Levi',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/trending-team.png',
    pImage: 'assets/images/png/trending-team1.png',
    name: 'Team Levi',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/trending-team.png',
    pImage: 'assets/images/png/trending-team1.png',
    name: 'Team Levi',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/trending-team.png',
    pImage: 'assets/images/png/trending-team1.png',
    name: 'Team Levi',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/trending-team.png',
    pImage: 'assets/images/png/trending-team1.png',
    name: 'Team Levi',
    uName: '2,000 Members',
  ),
];

var mediaItems = [
  Posts(
    image: 'assets/images/png/media1.png',
    pImage: 'assets/images/png/trending-team1.png',
    name: 'Team Levi',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/media2.png',
    pImage: 'assets/images/png/trending-team1.png',
    name: 'Team Levi',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/media3.png',
    pImage: 'assets/images/png/trending-team1.png',
    name: 'Team Levi',
    uName: '2,000 Members',
  ),
  Posts(
    image: 'assets/images/png/media1.png',
    pImage: 'assets/images/png/trending-team1.png',
    name: 'Team Levi',
    uName: '2,000 Members',
  ),
];
