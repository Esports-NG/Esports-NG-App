import 'package:e_sport/data/repository/chat_repository.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:get/get.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatRepository>();
    final messageController = TextEditingController();
    Future<void> sendMessage() async {
      await chatController.sendMessage(
          message: messageController.text, chatSlug: slug);
      messageController.clear();
    }

    return Container(
      width: double.infinity,
      color: AppColor().primaryBackGroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Row(
        spacing: 16.w,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColor().bgDark),
              child: Row(
                children: [
                  GestureDetector(
                    child: Icon(
                      IconsaxPlusLinear.emoji_happy,
                      color: AppColor().greySix,
                      size: 20.r,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Write a message...',
                          hintStyle: TextStyle(
                            fontFamily: "InterMedium",
                            letterSpacing: -0.2,
                            color: AppColor().greySix,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    child: Icon(
                      IconsaxPlusLinear.camera,
                      color: AppColor().greySix,
                      size: 20.r,
                    ),
                  ),
                  Gap(16.r),
                  GestureDetector(
                    child: Transform.rotate(
                      angle: 45 * (3.1415926535 / 180),
                      child: Icon(
                        Icons.attach_file_rounded,
                        size: 20.r,
                        color: AppColor().greySix,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: sendMessage,
            child: Icon(
              IconsaxPlusBold.send_2,
              size: 30.r,
              color: AppColor().primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
