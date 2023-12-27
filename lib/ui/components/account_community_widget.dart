import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/account/account_community/account_community_item.dart';
import 'package:e_sport/ui/components/account_community_detail.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'error_page.dart';
import 'no_item_page.dart';

class AccountCommunityWidget extends StatefulWidget {
  const AccountCommunityWidget({
    super.key,
  });

  @override
  State<AccountCommunityWidget> createState() => _AccountCommunityWidgetState();
}

class _AccountCommunityWidgetState extends State<AccountCommunityWidget> {
  final communityController = Get.put(CommunityRepository());
  @override
  Widget build(BuildContext context) {
    if (communityController.communityStatus == CommunityStatus.loading) {
      return LoadingWidget(color: AppColor().primaryColor);
    } else if (communityController.communityStatus ==
        CommunityStatus.available) {
      return ListView.separated(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: communityController.allCommunity.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.02),
        itemBuilder: (context, index) {
          var item = communityController.allCommunity[index];
          return InkWell(
            onTap: () => Get.to(() => AccountCommunityDetail(item: item)),
            child: AccountCommunityItem(item: item),
          );
        },
      );
    } else if (communityController.communityStatus == CommunityStatus.empty) {
      return const NoItemPage(title: 'Community');
    } else {
      return const ErrorPage();
    }
  }
}
