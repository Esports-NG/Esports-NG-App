import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/posts/activities.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(onPressed: () => Get.back()),
        title: CustomText(
          title: "Activities on ENGY",
          size: 16,
          weight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Activities())),
    );
  }
}
