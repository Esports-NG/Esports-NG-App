import 'package:e_sport/data/db/chat_database.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/chat_repository.dart';
import 'package:e_sport/ui/screens/account/messages/request.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../widgets/messages/chats_item.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final authController = Get.put(AuthRepository());
  int? longSelect;
  final chatController = Get.find<ChatRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: RefreshIndicator(
        onRefresh: () => chatController.getUserChats(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => const DMRequest());
                },
                child: Container(
                  color: AppColor().primaryLightColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: '4 Requests',
                        size: 14,
                        fontFamily: 'InterMedium',
                        color: AppColor().primaryLiteColor,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor().primaryLiteColor,
                        size: 20.r,
                      )
                    ],
                  ),
                ),
              ),
              StreamBuilder<List<Chat>>(
                  stream: chatController.watchChats(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: CustomText(
                        title: "No chats yet",
                      ));
                    }

                    final chats = snapshot.data!;
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: chats.length,
                      separatorBuilder: (context, index) => Divider(
                        color: AppColor().lightItemsColor.withOpacity(0.2),
                        height: 0,
                        thickness: 0,
                      ),
                      itemBuilder: (context, index) {
                        var item = chats[index];
                        return GestureDetector(
                          onTap: () {
                            // Get.to(
                            //   () => PostDetails(
                            //     item: item,
                            //   ),
                            // );
                          },
                          onLongPress: () {
                            setState(() {
                              if (longSelect == index) {
                                longSelect = null;
                              } else {
                                longSelect = index;
                              }
                            });
                          },
                          child: ChatsItem(
                            chat: item,
                          ),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
