// To parse this JSON data, do
//
//     final platformModel = platformModelFromJson(jsonString);

import 'dart:convert';

List<PlatformModel> platformModelFromJson(String str) =>
    List<PlatformModel>.from(
        json.decode(str).map((x) => PlatformModel.fromJson(x)));

String platformModelToJson(List<PlatformModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlatformModel {
  final int? id;
  final String? title;
  final String? abbrev;
  final String? logo;
  final String? secondaryImage;

  PlatformModel(
      {this.id, this.title, this.abbrev, this.logo, this.secondaryImage});

  factory PlatformModel.fromJson(Map<String, dynamic> json) => PlatformModel(
      id: json["id"],
      title: json["title"],
      abbrev: json["abbrev"],
      logo: json["logo"],
      secondaryImage: json["secondary_image"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "abbrev": abbrev,
        "logo": logo,
      };
}
