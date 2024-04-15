import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';

class Communities extends StatefulWidget {
  const Communities({super.key});

  @override
  State<Communities> createState() => _ChatsState();
}

class _ChatsState extends State<Communities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Center(
        child: CustomText(
          title: 'Communities',
          weight: FontWeight.w500,
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
    );
  }
}
