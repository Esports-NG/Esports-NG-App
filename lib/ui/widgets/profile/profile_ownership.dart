import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/ui/screens/account/team/account_teams_details.dart';
import 'package:e_sport/ui/screens/community/account_community_detail.dart';
import 'package:e_sport/ui/screens/team/teams_owned_item.dart';
import 'package:e_sport/ui/widgets/community/community_owned_item.dart';

class ProfileOwnedTeams extends StatelessWidget {
  final List<TeamModel> teams;

  const ProfileOwnedTeams({
    Key? key,
    required this.teams,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: Get.height * 0.15,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: teams.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => Gap(10),
            itemBuilder: (context, index) => GestureDetector(
              child: TeamsOwnedItem(team: teams[index]),
              onTap: () => Get.to(() => AccountTeamsDetail(item: teams[index])),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileOwnedCommunities extends StatelessWidget {
  final List<CommunityModel> communities;

  const ProfileOwnedCommunities({
    Key? key,
    required this.communities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: Get.height * 0.15,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: communities.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => Gap(10),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Get.to(
                  () => AccountCommunityDetail(item: communities[index])),
              child: CommunityOwnedItem(community: communities[index]),
            ),
          ),
        ),
      ],
    );
  }
}
