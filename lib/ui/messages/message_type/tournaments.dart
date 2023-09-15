import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';

class Tournaments extends StatefulWidget {
  const Tournaments({super.key});

  @override
  State<Tournaments> createState() => _ChatsState();
}

class _ChatsState extends State<Tournaments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBgColor,
      body: Center(
        child: CustomText(
          title: 'Tournaments',
          weight: FontWeight.w500,
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
    );
  }
}
