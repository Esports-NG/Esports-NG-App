import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBgColor,
      body: Center(
        child: CustomText(
          title: 'Chats',
          weight: FontWeight.w500,
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
    );
  }
}
