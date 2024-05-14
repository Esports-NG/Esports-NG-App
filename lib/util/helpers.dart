import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helpers {
  void showCustomSnackbar({required String message}) {
    Get.rawSnackbar(
        message: message,
        backgroundColor: AppColor().primaryColor.withOpacity(0.5),
        margin: EdgeInsets.all(Get.height * 0.02),
        borderRadius: 10,
        barBlur: 3,
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 750));
  }
}
