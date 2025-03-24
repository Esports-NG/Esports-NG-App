// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/model/user_model.dart';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  final List<CommunityModel>? communityActors;
  final List<TeamModel>? teamActors;
  final List<UserModel>? userActors;
  final String? actionType;
  final PostModel? targetPost;
  final NotificationComment? targetComment;
  final int? totalCount;
  final int? id;
  final int? groupId;
  final String? group;
  final int? postId;
  final dynamic playerGame;
  final dynamic eventLabel;
  final String? name;
  final String? profile;
  final String? text;
  final String? content;
  final bool? seen;
  final DateTime? createdAt;
  final DateTime? lastUpdated;
  final int? user;

  NotificationModel({
    this.communityActors,
    this.teamActors,
    this.userActors,
    this.actionType,
    this.targetPost,
    this.targetComment,
    this.totalCount,
    this.id,
    this.groupId,
    this.group,
    this.postId,
    this.playerGame,
    this.eventLabel,
    this.name,
    this.profile,
    this.text,
    this.content,
    this.seen,
    this.createdAt,
    this.lastUpdated,
    this.user,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        communityActors: json["community_actors"] == null
            ? []
            : List<CommunityModel>.from(json["community_actors"]!
                .map((x) => CommunityModel.fromJson(x))),
        teamActors: json["team_actors"] == null
            ? []
            : List<TeamModel>.from(
                json["team_actors"]!.map((x) => (x) => TeamModel.fromJson(x))),
        userActors: json["user_actors"] == null
            ? []
            : List<UserModel>.from(
                json["user_actors"]!.map((x) => UserModel.fromJson(x))),
        actionType: json["action_type"],
        targetPost: json["target_post"] == null
            ? null
            : PostModel.fromJson(json["target_post"]),
        targetComment: json["target_comment"] == null
            ? null
            : NotificationComment.fromJson(json["target_comment"]),
        totalCount: json["total_count"],
        id: json["id"],
        groupId: json["group_id"],
        group: json["group"],
        postId: json["post_id"],
        playerGame: json["player_game"],
        eventLabel: json["event_label"],
        name: json["name"],
        profile: json["profile"],
        text: json["text"],
        content: json["content"],
        seen: json["seen"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        lastUpdated: json["last_updated"] == null
            ? null
            : DateTime.parse(json["last_updated"]),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "community_actors": communityActors == null
            ? []
            : List<dynamic>.from(communityActors!.map((x) => x)),
        "team_actors": teamActors == null
            ? []
            : List<dynamic>.from(teamActors!.map((x) => x)),
        "user_actors": userActors == null
            ? []
            : List<dynamic>.from(userActors!.map((x) => x)),
        "action_type": actionType,
        "target_post": targetPost?.toJson(),
        "target_comment": targetComment,
        "total_count": totalCount,
        "id": id,
        "group_id": groupId,
        "group": group,
        "post_id": postId,
        "player_game": playerGame,
        "event_label": eventLabel,
        "name": name,
        "profile": profile,
        "text": text,
        "content": content,
        "seen": seen,
        "created_at": createdAt?.toIso8601String(),
        "last_updated": lastUpdated?.toIso8601String(),
        "user": user,
      };
}

class Profile {
  final String? profilePicture;

  Profile({
    this.profilePicture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "profile_picture": profilePicture,
      };
}

class NotificationComment {
  final int? id;
  final NotificationComment? post;
  final String? body;
  final List<Tag>? tags;
  final List<dynamic>? viewers;

  NotificationComment({
    this.id,
    this.post,
    this.body,
    this.tags,
    this.viewers,
  });

  factory NotificationComment.fromJson(Map<String, dynamic> json) =>
      NotificationComment(
        id: json["id"],
        post: json["post"] == null
            ? null
            : NotificationComment.fromJson(json["post"]),
        body: json["body"],
        tags: json["tags"] == null
            ? []
            : List<Tag>.from(json["tags"]!.map((x) => Tag.fromJson(x))),
        viewers: json["viewers"] == null
            ? []
            : List<dynamic>.from(json["viewers"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post": post?.toJson(),
        "body": body,
        "tags": tags == null
            ? []
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "viewers":
            viewers == null ? [] : List<dynamic>.from(viewers!.map((x) => x)),
      };
}

class Tag {
  final int? id;
  final String? title;
  final int? eventId;
  final bool? byEvent;

  Tag({
    this.id,
    this.title,
    this.eventId,
    this.byEvent,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        title: json["title"],
        eventId: json["event_id"],
        byEvent: json["by_event"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "event_id": eventId,
        "by_event": byEvent,
      };
}
