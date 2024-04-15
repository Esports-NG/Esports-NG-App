import 'package:e_sport/data/model/message_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'chats/chats_item.dart';

class Tournaments extends StatefulWidget {
  const Tournaments({super.key});

  @override
  State<Tournaments> createState() => _TournamentsState();
}

class _TournamentsState extends State<Tournaments> {
  final authController = Get.put(AuthRepository());
  int? longSelect;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().primaryBackGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(Get.height * 0.02),
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: tournaments.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColor().lightItemsColor.withOpacity(0.3),
                height: Get.height * 0.05,
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                var item = tournaments[index];
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
                      authController.mOnSelect.value =
                          !authController.mOnSelect.value;
                    });
                  },
                  child: ChatsItem(
                    item: item,
                    index: index,
                    count: longSelect,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
