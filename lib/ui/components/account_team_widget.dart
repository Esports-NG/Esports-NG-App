import 'package:e_sport/data/model/account_teams_model.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_item.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AccountTeamsWidget extends StatefulWidget {
  const AccountTeamsWidget({
    super.key,
  });

  @override
  State<AccountTeamsWidget> createState() => _AccountTeamsWidgetState();
}

class _AccountTeamsWidgetState extends State<AccountTeamsWidget> {
  final teamController = Get.put(TeamRepository());
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: teamController.allTeam.length,
      separatorBuilder: (context, index) => Gap(Get.height * 0.02),
      itemBuilder: (context, index) {
        var item = teamController.allTeam[index];
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
