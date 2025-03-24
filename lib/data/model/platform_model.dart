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
  final String? platformType;

  PlatformModel(
      {this.id, this.title, this.abbrev, this.logo, this.secondaryImage, this.platformType});

  factory PlatformModel.fromJson(Map<String, dynamic> json) => PlatformModel(
      id: json["id"],
      title: json["title"],
      abbrev: json["abbrev"],
      logo: json["logo"],
      secondaryImage: json["secondary_image"],
      platformType: json["platform_type"],
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "abbrev": abbrev,
        "logo": logo,
        "platform_type": platformType,
      };
}
