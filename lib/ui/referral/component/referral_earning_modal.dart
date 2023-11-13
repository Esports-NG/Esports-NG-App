import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferralEarningModal extends StatelessWidget {
  const ReferralEarningModal({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
       padding: EdgeInsets.all(Get.height * 0.02),
        decoration: BoxDecoration(
          color: AppColor().primaryBackGroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
    );
  }
}