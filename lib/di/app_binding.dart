import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/data/repository/message_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository(), permanent: true);
    Get.put(PostRepository(), permanent: true);
    Get.put(CommunityRepository(), permanent: true);
    Get.put(TeamRepository(), permanent: true);
    Get.put(PlayerRepository(), permanent: true);
    Get.put(MessageRepository(), permanent: true);
    Get.put(EventRepository(), permanent: true);
  }
}
