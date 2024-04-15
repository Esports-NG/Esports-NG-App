// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  int? id;
  Author? author;
  List<dynamic>? reposts;
  dynamic community;
  String? body;
  int? likeCount;
  List<Author>? likes;
  int? viewCount;
  List<dynamic>? views;
  List<dynamic>? tags;
  int? repostCount;
  List<dynamic>? viewers;
  String? image;
  List<dynamic>? comment;
  DateTime? createdAt;
  DateTime? updatedAt;

  PostModel({
    this.id,
    this.author,
    this.reposts,
    this.community,
    this.body,
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
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        reposts: json["reposts"] == null
            ? []
            : List<dynamic>.from(json["reposts"]!.map((x) => x)),
        community: json["community"],
        body: json["body"],
        likeCount: json["like_count"],
        likes: json["likes"] == null
            ? []
            : List<Author>.from(json["likes"]!.map((x) => Author.fromJson(x))),
        viewCount: json["view_count"],
        views: json["views"] == null
            ? []
            : List<dynamic>.from(json["views"]!.map((x) => x)),
        tags: json["tags"] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        repostCount: json["repost_count"],
        viewers: json["viewers"] == null
            ? []
            : List<dynamic>.from(json["viewers"]!.map((x) => x)),
        image: json["image"],
        comment: json["comment"] == null
            ? []
            : List<dynamic>.from(json["comment"]!.map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author?.toJson(),
        "reposts":
            reposts == null ? [] : List<dynamic>.from(reposts!.map((x) => x)),
        "community": community,
        "body": body,
        "like_count": likeCount,
        "likes": likes == null
            ? []
            : List<dynamic>.from(likes!.map((x) => x.toJson())),
        "view_count": viewCount,
        "views": views == null ? [] : List<dynamic>.from(views!.map((x) => x)),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "repost_count": repostCount,
        "viewers":
            viewers == null ? [] : List<dynamic>.from(viewers!.map((x) => x)),
        "image": image,
        "comment":
            comment == null ? [] : List<dynamic>.from(comment!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
