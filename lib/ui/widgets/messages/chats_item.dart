// ignore_for_file: prefer_const_constructors

import 'package:e_sport/data/db/chat_database.dart';
import 'package:e_sport/data/repository/chat_repository.dart';
import 'package:e_sport/ui/screens/account/messages/message_type/chats/chat.dart';

import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatsItem extends StatefulWidget {
  final Chat chat;
  const ChatsItem({super.key, required this.chat});

  @override
  State<ChatsItem> createState() => _ChatsItemState();
}

class _ChatsItemState extends State<ChatsItem> {
  final chatController = Get.find<ChatRepository>();
  Message? lastMessage;
  @override
  void initState() {
    super.initState();
    getLastMessage();
  }

  Future<void> getLastMessage() async {
    if (widget.chat.lastMessageSlug == null) {
      return null;
    }
    var message = await chatController.getMessage(widget.chat.lastMessageSlug!);
    setState(() {
      lastMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ChatPage(chat: widget.chat)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
        child: Row(
          spacing: 12.r,
          children: [
            OtherImage(
              image: widget.chat.image,
              height: 48.r,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: widget.chat.name,
                    color: AppColor().primaryWhite,
                    textAlign: TextAlign.start,
                    fontFamily: 'InterMedium',
                    size: 14,
                  ),
                  if (lastMessage != null)
                    CustomText(
                      title: lastMessage?.content,
                      size: 14,
                      fontFamily: 'InterMedium',
                      color: AppColor().lightItemsColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
