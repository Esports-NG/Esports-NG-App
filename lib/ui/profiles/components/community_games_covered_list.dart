import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/games_repository.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/profiles/components/community_add_game.dart';
import 'package:e_sport/ui/profiles/components/community_games_covered_item.dart';
import 'package:e_sport/ui/profiles/components/team_add_game.dart';
import 'package:e_sport/ui/profiles/components/team_games_played_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// There are 2 classes in this folder namely "CommunityGamesCoveredItem" For Scrollable
// and "CommunityGamesCoveredItemForList" For List

class CommunityGamesCoveredList extends StatefulWidget {
  final CommunityModel community;
  const CommunityGamesCoveredList({super.key, required this.community});

  @override
  State<CommunityGamesCoveredList> createState() =>
      _CommunityGamesCoveredListState();
}

class _CommunityGamesCoveredListState extends State<CommunityGamesCoveredList> {
  final gamesController = Get.put(GamesRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: CustomText(
            title: 'Games Covered',
            fontFamily: 'GilroySemiBold',
            size: 18,
            color: AppColor().primaryWhite,
          ),
          leading: GoBackButton(onPressed: () => Get.back()),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: AppColor().primaryWhite,
              ),
            ),
          ],
        ),
        backgroundColor: AppColor().primaryBackGroundColor,
        floatingActionButton: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: AppColor().primaryColor),
          child: IconButton(
            onPressed: () {
              Get.to(() => CommunityAddGame(community: widget.community));
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: Get.height * 0.02,
                  top: Get.height * 0.02,
                  bottom: Get.height * 0.01),
              child: CustomText(
                title: 'Games Covered By ${widget.community.name}:',
                size: 14,
                fontFamily: 'GilroyBold',
                textAlign: TextAlign.start,
                color: AppColor().greyTwo,
              ),
            ),
            widget.community.gamesPlayed!.isEmpty
                ? Expanded(
                    child: Center(
                      child: CustomText(
                        title: "No games added yet",
                        color: AppColor().primaryWhite,
                        // fontFamily: "GilroyMedium",
                        size: 16,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(Get.height * 0.02),
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var item = widget.community.gamesPlayed![index];
                      return InkWell(
                        onTap: () => Get.to(() => GameProfile(game: item)),
                        child: CommunityGamesCoveredItemForList(
                          game: item,
                          community: CommunityModel(),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        Gap(Get.height * 0.02),
                    itemCount: widget.community.gamesPlayed!.length,
                  ),
          ],
        ));
  }
}
