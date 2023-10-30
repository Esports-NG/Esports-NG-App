import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/data/repository/message_repository.dart';
import 'package:e_sport/data/repository/post_repository.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository(), permanent: true);
    Get.put(PostRepository(), permanent: true);
    Get.put(CommunityRepository(), permanent: true);
    Get.put(MessageRepository(), permanent: true);
  }
}
