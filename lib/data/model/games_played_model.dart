import 'dart:convert';

class GamesPlayed {
  final String? image;
  final String? name, id, ign;

  GamesPlayed({
    this.image,
    this.name,
    this.id,
    this.ign,
  });
}

List<GameToPlay> gameToPlayFromJson(String str) =>
    List<GameToPlay>.from(json.decode(str).map((x) => GameToPlay.fromJson(x)));

String gameToPlayToJson(List<GameToPlay> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameToPlay {
  final int? id;
  final String? name;
  final String? profilePicture;
  final List<dynamic>? downloadLinks;
  final String? events;
  final int? players;

  GameToPlay({
    this.id,
    this.name,
    this.profilePicture,
    this.downloadLinks,
    this.events,
    this.players,
  });

  factory GameToPlay.fromJson(Map<String, dynamic> json) => GameToPlay(
        id: json["id"],
        name: json["name"],
        profilePicture: json["profile_picture"],
        downloadLinks: json["download_links"] == null
            ? []
            : List<dynamic>.from(json["download_links"]!.map((x) => x)),
        events: json["events"],
        players: json["players"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile_picture": profilePicture,
        "download_links": downloadLinks == null
            ? []
            : List<dynamic>.from(downloadLinks!.map((x) => x)),
        "events": events,
        "players": players,
      };
}
