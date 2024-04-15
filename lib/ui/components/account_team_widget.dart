import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_details.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_item.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'error_page.dart';
import 'no_item_page.dart';

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
    if (teamController.teamStatus == TeamStatus.loading) {
      return LoadingWidget(color: AppColor().primaryColor);
    } else if (teamController.teamStatus == TeamStatus.available) {
      return ListView.separated(
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: teamController.allTeam.length,
        separatorBuilder: (context, index) => Gap(Get.height * 0.02),
        itemBuilder: (context, index) {
          var item = teamController.allTeam[index];
          return InkWell(
            onTap: () => Get.to(() => AccountTeamsDetail(item: item)),
            child: AccountTeamsItem(item: item),
          );
        },
      );
    } else if (teamController.teamStatus == TeamStatus.empty) {
      return const NoItemPage(title: 'Team');
    } else {
      return const ErrorPage();
    }
  }
}
