import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/db/chat_database.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.imageUrls != null)
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 200.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                (jsonDecode(message.imageUrls!)
                                    as List<dynamic>)[index]),
                            fit: BoxFit.cover)),
                  );
                },
                separatorBuilder: (context, index) => Gap(6.h),
                itemCount:
                    (jsonDecode(message.imageUrls!) as List<dynamic>).length,
              ),
            if (message.imageUrls != null) Gap(6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isMe ? AppColor().primaryColor : AppColor().bgDark,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft:
                      isMe ? Radius.circular(16.r) : Radius.circular(4.r),
                  bottomRight:
                      isMe ? Radius.circular(4.r) : Radius.circular(16.r),
                ),
              ),
              child: CustomText(
                title: message.content,
                color: Colors.white,
                size: 14,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.h, left: 8.w, right: 8.w),
              child: CustomText(
                title: _formatTime(message.createdAt),
                color: AppColor().greySix,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
