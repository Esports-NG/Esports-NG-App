import 'package:get/get.dart';

class NavRepository extends GetxController {
  var currentIndex = 0.obs;

  void setIndex(int value) {
    currentIndex.value = value;
  }
}
