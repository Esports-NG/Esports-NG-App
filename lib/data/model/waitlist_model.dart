import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';

class WaitlistModel {
  int? id;
  List<PlayerModel>? players;
  List<TeamModel>? team;

  WaitlistModel({this.id, this.players, this.team});

  factory WaitlistModel.fromJson(Map<String, dynamic> json) => WaitlistModel(
        id: json["id"],
        players: json["players"] == null
            ? []
            : List<PlayerModel>.from(
                json["players"].map((e) => PlayerModel.fromJson(e))),
        team: json["team"] == null
            ? []
            : List<TeamModel>.from(
                json["team"].map((e) => TeamModel.fromJson(e))),
      );
}
