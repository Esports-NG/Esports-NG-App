import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:get/get.dart';

enum MessageStatus {
  loading,
  success,
  error,
  empty,
  available,
}

class MessageRepository extends GetxController {
  final authController = Get.put(AuthRepository());
  RxBool mOnSelect = false.obs;
}
