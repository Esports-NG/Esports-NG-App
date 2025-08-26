import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/chat_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/dependency_injection.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize ApiService first to ensure a single Dio instance is available
    Get.put(ApiService(), permanent: true);

    // Initialize repositories
    Get.put(AuthRepository(), permanent: true);
    Get.put(PostRepository(), permanent: true);
    Get.put(CommunityRepository(), permanent: true);
    Get.put(TeamRepository(), permanent: true);
    Get.put(PlayerRepository(), permanent: true);
    Get.put(ChatRepository(), permanent: true);
    Get.put(EventRepository(), permanent: true);
  }
}
