import 'package:e_sport/data/model/account_teams_model.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountTeamsWidget extends StatelessWidget {
  const AccountTeamsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: accountTeamItem.length,
      separatorBuilder: (context, index) => Gap(Get.height * 0.02),
      itemBuilder: (context, index) {
        var item = accountTeamItem[index];
        return InkWell(
          onTap: () {
            // Get.to(
            //   () => PostDetails(
            //     item: item,
            //   ),
            // );
          },
          child: AccountTeamsItem(item: item),
        );
      },
    );
  }
}
