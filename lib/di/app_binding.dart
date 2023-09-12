import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository(), permanent: true);
  }
}
