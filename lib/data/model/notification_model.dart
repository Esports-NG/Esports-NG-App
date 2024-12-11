import 'dart:convert';

List<NotificationModel> notificationFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<String, List<NotificationModel>> groupNotifications(
    List<NotificationModel> notifications) {
  // Create a map to group notifications based on text and postId
  Map<String, List<NotificationModel>> grouped = {};

  for (var notification in notifications) {
    String key = '${notification.text}_${notification.postId}';
    if (!grouped.containsKey(key)) {
      grouped[key] = [];
    }
    grouped[key]?.add(notification);
  }

  return grouped;
}

class NotificationModel {
  final int? id;
  final int? groupId;
  final Group? group;
  final int? postId;
  final dynamic playerGame;
  final String? eventLabel;
  final String? name;
  final String? profile;
  final String? text;
  final DateTime? createdAt;
  final String? content;

  NotificationModel(
      {this.id,
      this.groupId,
      this.group,
      this.postId,
      this.playerGame,
      this.eventLabel,
      this.name,
      this.profile,
      this.text,
      this.createdAt,
      this.content});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        groupId: json["group_id"],
        group: groupValues.map[json["group"]]!,
        postId: json["post_id"],
        playerGame: json["player_game"],
        eventLabel: json["event_label"],
        name: json["name"],
        profile: json["profile"],
        text: json["text"],
        content: json['content'],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "group": groupValues.reverse[group],
        "post_id": postId,
        "player_game": playerGame,
        "event_label": eventLabel,
        "name": name,
        "profile": profile,
        "text": text,
        "created_at": createdAt?.toIso8601String(),
      };
}

enum Group { EVENT, TEAM, USER }

final groupValues =
    EnumValues({"event": Group.EVENT, "team": Group.TEAM, "user": Group.USER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
