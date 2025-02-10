import 'dart:convert';

import 'package:e_sport/data/model/fixture_model.dart';

List<ActivityModel> activityModelFromJson(String str) =>
    List<ActivityModel>.from(
        json.decode(str).map((x) => ActivityModel.fromJson(x)));

class ActivityModel {
  final LivestreamModel? livestream;
  final FixtureModel? fixture;

  ActivityModel({this.livestream, this.fixture});

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
      livestream: json["livestream"] == null
          ? null
          : LivestreamModel.fromJson(json["livestream"]),
      fixture: json["fixture"] == null
          ? null
          : FixtureModel.fromJson(json["fixture"]));
}
