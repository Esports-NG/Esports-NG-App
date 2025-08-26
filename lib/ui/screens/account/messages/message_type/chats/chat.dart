import 'package:e_sport/data/db/chat_database.dart';
import 'package:e_sport/data/repository/chat_repository.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/messages/chat_box.dart';
import 'package:e_sport/ui/widgets/messages/chat_bubble.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/utils/profile_image.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chat});
  final Chat chat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatRepository chatController = Get.find<ChatRepository>();
  String? currentUserSlug;

  Future<void> getChat() async {
    try {
      // Get current user's slug for message comparison
      currentUserSlug = await chatController.getCurrentUserSlug();
      // var chat = await chatController.getChat(widget.chat.slug);
    } catch (err) {
      // Handle error appropriately
    }
    await chatController.getChatHistory(widget.chat.username!);
  }

  @override
  void initState() {
    getChat();
    super.initState();
  }

  @override
  void dispose() {
    chatController.disconnectFromWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(onPressed: () => Get.back()),
        title: Row(
          spacing: 8.w,
          children: [
            OtherImage(
              image: widget.chat.image,
              width: 32.r,
              height: 32.r,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: widget.chat.name,
                  size: 14,
                ),
                CustomText(
                  title: "Last seen recently",
                  size: 14,
                  color: AppColor().greySix,
                )
              ],
            )
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                  stream: chatController.watchMessages(widget.chat.slug),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No messages yet"));
                    }

                    final messages = snapshot.data!;
                    return ListView.builder(
                        padding: EdgeInsets.only(bottom: 12.r, top: 12.r),
                        reverse: true,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = currentUserSlug != null &&
                              message.senderSlug == currentUserSlug;

                          return ChatBubble(
                            message: message,
                            isMe: isMe,
                          );
                        },
                        itemCount: messages.length);
                  }),
            ),
            ChatBox()
          ],
        ),
      ),
    );
  }
}
