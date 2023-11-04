import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
  int? eventType = 0;
  final eventController = Get.put(EventRepository());
  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void handleTap() {
    setState(() {
      isSearch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          title: 'Community',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.06,
                child: CustomTextField(
                  hint: "Search for gaming news, competitions...",
                  fontFamily: 'GilroyMedium',
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: AppColor().lightItemsColor,
                  ),
                  textEditingController: eventController.searchController,
                  hasText: isSearch!,
                  focusNode: _searchFocusNode,
                  onTap: handleTap,
                  onSubmited: (_) {
                    _searchFocusNode.unfocus();
                  },
                  onChanged: (value) {
                    setState(() {
                      isSearch = value.isNotEmpty;
                    });
                  },
                ),
              ),
              Gap(Get.height * 0.025),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(Get.height * 0.02),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColor().primaryWhite, width: 0.8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: 'Filter by Category:',
                        fontFamily: 'GilroyMedium',
                        size: 12,
                        color: AppColor().primaryWhite,
                      ),
                      Gap(Get.height * 0.01),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor().primaryColor,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ),
              Gap(Get.height * 0.03),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    title: 'Suggested profiles',
                    fontFamily: 'GilroySemiBold',
                    size: 16,
                    color: AppColor().primaryWhite,
                  ),
                  Row(
                    children: [
                      CustomText(
                        title: 'See all',
                        fontFamily: 'GilroyMedium',
                        size: 16,
                        color: AppColor().primaryColor,
                      ),
                      Gap(Get.height * 0.01),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor().primaryColor,
                        size: 18,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
