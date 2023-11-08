import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'components/latest_news_item.dart';

class LatestNews extends StatefulWidget {
  const LatestNews({super.key});

  @override
  State<LatestNews> createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
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
          title: 'Suggested Profiles',
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
              GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1 * 0.8,
                  ),
                  itemCount: latestNewsItems.length,
                  itemBuilder: (context, index) {
                    var item = latestNewsItems[index];
                    return LatestNewsItem(item: item);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
