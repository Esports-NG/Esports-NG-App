import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/ui/widgets/custom/error_page.dart';
import 'package:e_sport/ui/screens/extra/no_item_page.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../community_item.dart';

class TrendingCommunity extends StatefulWidget {
  const TrendingCommunity({super.key});

  @override
  State<TrendingCommunity> createState() => _TrendingCommunityState();
}

class _TrendingCommunityState extends State<TrendingCommunity> {
  final communityController = Get.put(CommunityRepository());
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
        leading: GoBackButton(onPressed: () => Get.back()),
        title: CustomText(
          title: 'Trending Communities',
          fontFamily: 'InterSemiBold',
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
                  fontFamily: 'InterMedium',
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: AppColor().lightItemsColor,
                  ),
                  textEditingController: communityController.searchController,
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
              (communityController.communityStatus == CommunityStatus.loading)
                  ? LoadingWidget(color: AppColor().primaryColor)
                  : (communityController.communityStatus ==
                          CommunityStatus.available)
                      ? ListView.separated(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              Gap(Get.height * 0.02),
                          itemCount: communityController.allCommunity.length,
                          itemBuilder: (context, index) {
                            var item = communityController.allCommunity[index];
                            return InkWell(
                                onTap: () => Get.to(
                                    () => AccountCommunityDetail(item: item)),
                                child: AllCommunityItem(item: item));
                          })
                      : (communityController.communityStatus ==
                              CommunityStatus.empty)
                          ? const NoItemPage(title: 'Communities')
                          : const ErrorPage(),
            ],
          ),
        ),
      ),
    );
  }
}
