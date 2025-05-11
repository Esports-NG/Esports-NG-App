import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/screens/account/team/account_teams_details.dart';
import 'package:e_sport/ui/screens/account/team/account_teams_item.dart';
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
  final authController = Get.put(AuthRepository());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: teamController.myTeam.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.02),
        itemBuilder: (context, index) {
          var item = teamController.myTeam[index];
          return InkWell(
            onTap: () => Get.to(() => AccountTeamsDetail(item: item)),
            child: AccountTeamsItem(item: item),
          );
        },
      ),
    );
  }
}
