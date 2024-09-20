import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/roaster_model.dart';

class WaitlistModel {
  int? id;
  PlayerModel? player;
  RoasterModel? team;

  WaitlistModel({this.id, this.player, this.team});

  factory WaitlistModel.fromJson(Map<String, dynamic> json) => WaitlistModel(
        id: json["id"],
        player: json["player"] == null
            ? null
            : PlayerModel.fromJson(json['player']),
        team: json["team"] == null ? null : RoasterModel.fromJson(json['team']),
      );
}
