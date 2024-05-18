import 'package:e_sport/ui/widget/coming_soon_popup.dart';
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

  void showComingSoonDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: AppColor().primaryBgColor,
              content: const ComingSoonPopup(),
            ));
  }

  void showImagePopup(BuildContext context, String imageUrl) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Image.network(
                imageUrl,
                width: Get.width,
                fit: BoxFit.cover,
              ),
            ));
  }
}
