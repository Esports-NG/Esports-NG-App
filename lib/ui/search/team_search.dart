import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_details.dart';
import 'package:e_sport/ui/home/community/components/trending_team_item.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TeamSearch extends StatefulWidget {
  const TeamSearch({super.key});

  @override
  State<TeamSearch> createState() => _TeamSearchState();
}

class _TeamSearchState extends State<TeamSearch> {
  final teamController = Get.put(TeamRepository());
  final authController = Get.put(AuthRepository());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Container(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: authController.searchLoading.value
              ? const Center(child: ButtonLoader())
              : teamController.searchedTeams.isEmpty
                  ? Center(
                      child: CustomText(
                        title: "No team found.",
                        color: AppColor().primaryWhite,
                      ),
                    )
                  : Column(
                      children: [
                        GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 1 * 0.7,
                            ),
                            itemCount: teamController.searchedTeams.length,
                            itemBuilder: (context, index) {
                              var item = teamController.searchedTeams[index];
                              return GestureDetector(
                                  onTap: () => Get.to(
                                      () => AccountTeamsDetail(item: item)),
                                  child: TrendingTeamsItem(item: item));
                            })
                      ],
                    ),
        ),
      ),
    );
  }
}
