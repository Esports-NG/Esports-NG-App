import 'package:e_sport/data/model/post_model.dart';
import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'components/trending_community_item.dart';

class TrendingCommunity extends StatefulWidget {
  const TrendingCommunity({super.key});

  @override
  State<TrendingCommunity> createState() => _TrendingCommunityState();
}

class _TrendingCommunityState extends State<TrendingCommunity> {
  final eventController = Get.put(EventRepository());
  bool? isSearch = false;
  final FocusNode _searchFocusNode = FocusNode();
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
          title: 'Trending Communities',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
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
              ListView.separated(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                  itemCount: trendingCommunitiesItems.length,
                  itemBuilder: (context, index) {
                    var item = trendingCommunitiesItems[index];
                    return TrendingCommunityItem(item: item, index: 0);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
