import 'user_model.dart';

class PostModel {
  int? id;
  UserModel? author;
  String? title;
  String? body;
  int? likeCount;
  List<dynamic>? likes;
  List<Tag>? tags;
  List? iTags;
  List<dynamic>? viewers;
  dynamic image;
  List<dynamic>? comment;

  PostModel({
    this.id,
    this.author,
    this.title,
    this.body,
    this.likeCount,
    this.likes,
    this.iTags,
    this.tags,
    this.viewers,
    this.image,
    this.comment,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        author: json["author"] == null
            ? null
            : UserModel.fromPostJson(json["author"]),
        title: json["title"],
        body: json["body"],
        likeCount: json["like_count"],
        likes: json["likes"] == null
            ? []
            : List<dynamic>.from(json["likes"]!.map((x) => x)),
        iTags: json['tags'] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
        viewers: json["viewers"] == null
            ? []
            : List<dynamic>.from(json["viewers"]!.map((x) => x)),
        image: json["image"],
        comment: json["comment"] == null
            ? []
            : List<dynamic>.from(json["comment"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author?.toJson(),
        "title": title,
        "body": body,
        "like_count": likeCount,
        "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x)),
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "viewers":
            viewers == null ? [] : List<dynamic>.from(viewers!.map((x) => x)),
        "image": image,
        "comment":
            comment == null ? [] : List<dynamic>.from(comment!.map((x) => x)),
      };

  Map<String, dynamic> toCreatePostJson() => {
        "title": title,
        "body": body,
        "tags": iTags == null ? [] : List<dynamic>.from(iTags!.map((x) => x)),
        "viewers":
            viewers == null ? [] : List<dynamic>.from(viewers!.map((x) => x)),
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
