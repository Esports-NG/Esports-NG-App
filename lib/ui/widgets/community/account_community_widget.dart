import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/community_repository.dart';
import 'package:e_sport/ui/widgets/account/community/account_community_item.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../custom/error_page.dart';
import '../../screens/extra/no_item_page.dart';

class AccountCommunityWidget extends StatefulWidget {
  const AccountCommunityWidget({
    super.key,
  });

  @override
  State<AccountCommunityWidget> createState() => _AccountCommunityWidgetState();
}

class _AccountCommunityWidgetState extends State<AccountCommunityWidget> {
  final communityController = Get.put(CommunityRepository());
  final authController = Get.put(AuthRepository());

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: communityController.myCommunity.length,
      separatorBuilder: (context, index) => Gap(Get.height * 0.02),
      itemBuilder: (context, index) {
        var item = communityController.myCommunity[index];
        return InkWell(
          onTap: () => Get.to(() => AccountCommunityDetail(item: item)),
          child: AccountCommunityItem(item: item),
        );
      },
    );
  }
}
