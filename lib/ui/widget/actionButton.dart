import 'package:e_sport/data/model/category_model.dart';
import 'package:e_sport/ui/account/account_events/create_event.dart';
import 'package:e_sport/ui/home/post/create_community_page.dart';
import 'package:e_sport/ui/home/post/create_post.dart';
import 'package:e_sport/ui/home/post/create_post_item.dart';
import 'package:e_sport/ui/home/post/create_team.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({super.key});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  int? _selectedMenu;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showItemListDialog(context);
      },
      child: Container(
          // padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: AppColor().primaryColor,
              borderRadius: BorderRadius.circular(999)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              Icons.add,
              color: AppColor().primaryWhite,
              size: 30,
            ),
          )),
    );
  }

  void _showItemListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          color: AppColor().primaryWhite,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomText(
                    title: 'Select what you would like\nto create',
                    size: Get.height * 0.018,
                    fontFamily: 'GilroySemiBold',
                    textAlign: TextAlign.center,
                    color: AppColor().primaryWhite,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColor().primaryLightColor,
            content: Container(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                width: Get.width * 0.5,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: createMenu.length,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.03),
                  itemBuilder: (context, index) {
                    var item = createMenu[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMenu = index;
                        });
                        Get.back();
                        if (_selectedMenu == 0) {
                          Get.to(() => const CreatePost());
                        } else if (_selectedMenu == 1) {
                          Get.to(() => const CreateEvent());
                        } else if (_selectedMenu == 2) {
                          Get.to(() => const CreateTeamPage());
                        } else {
                          Get.to(() => const CreateCommunityPage());
                        }
                      },
                      child: CreateMenu(
                        item: item,
                        selectedItem: _selectedMenu,
                        index: index,
                      ),
                    );
                  },
                )),
          );
        });
      },
    );
  }
}
