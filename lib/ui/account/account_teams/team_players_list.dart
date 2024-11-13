import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/team/roaster_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account_teams/add_to_roster.dart';
import 'package:e_sport/ui/components/participant_list.dart';
import 'package:e_sport/ui/home/community/components/game_profile.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TeamPlayersList extends StatefulWidget {
  const TeamPlayersList({super.key, required this.item});

  final TeamModel item;

  @override
  State<TeamPlayersList> createState() => _TeamPlayersListState();
}

class _TeamPlayersListState extends State<TeamPlayersList> {
  late List<bool> _isOpen;
  List<RoasterModel>? _roasterList;
  final teamController = Get.put(TeamRepository());
  final authController = Get.put(AuthRepository());

  Future getTeamRoster() async {
    List<RoasterModel> roasterList =
        await teamController.getTeamRoster(widget.item.id!);
    setState(() {
      _roasterList = roasterList;
      _isOpen = List.filled(roasterList.length, true);
    });
  }

  @override
  initState() {
    getTeamRoster();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(children: [
            (widget.item.profilePicture == null)
                ? Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor().primaryWhite)),
                    child: SvgPicture.asset(
                      'assets/images/svg/people.svg',
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: widget.item.profilePicture!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                          ),
                          borderRadius: BorderRadius.circular(999)),
                    ),
                  ),
            Gap(Get.height * 0.01),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: widget.item.name,
                  color: AppColor().primaryWhite,
                  fontFamily: "InterSemiBold",
                  size: 16,
                ),
                CustomText(
                  title: "Squad",
                  color: AppColor().primaryWhite.withOpacity(0.5),
                  // fontFamily: "InterSemiBold",
                  size: 14,
                )
              ],
            )
          ]),
          leading: GoBackButton(
            onPressed: () => Get.back(),
          )),
      floatingActionButton: authController.user!.id == widget.item.owner!.id
          ? FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90)),
              backgroundColor: AppColor().primaryColor,
              onPressed: () {
                Get.to(() => AddToRoster(
                      team: widget.item,
                      roasterList: _roasterList!,
                    ));
              },
              child: Icon(
                Icons.add,
                color: AppColor().primaryWhite,
              ),
            )
          : null,
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.height * 0.02, vertical: Get.height * 0.02),
        child: _roasterList == null
            ? const SizedBox(height: 50, child: Center(child: ButtonLoader()))
            : Column(
                children: [
                  ExpansionPanelList(
                    dividerColor: AppColor().primaryDark,
                    expansionCallback: (panelIndex, isExpanded) => setState(() {
                      _isOpen[panelIndex] = isExpanded;
                    }),
                    expandIconColor: AppColor().primaryColor,
                    children: _roasterList!
                        .map((e) => ExpansionPanel(
                            isExpanded: _isOpen[_roasterList!.indexOf(e)],
                            backgroundColor: AppColor().primaryBackGroundColor,
                            headerBuilder: (context, isExpanded) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: GestureDetector(
                                    onTap: () => Get.to(
                                        () => GameProfile(game: e.game!)),
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: ApiLink.imageUrl +
                                              e.game!.profilePicture!,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                                border: Border.all(
                                                    color: AppColor()
                                                        .primaryWhite
                                                        .withOpacity(0.5)),
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                        Gap(Get.height * 0.02),
                                        CustomText(
                                          title: e.game!.name!,
                                          color: AppColor().primaryWhite,
                                          fontFamily: "InterSemiBold",
                                          size: 16,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                          title: "S/N",
                                          color: AppColor()
                                              .primaryWhite
                                              .withOpacity(0.8),
                                          fontFamily: "InterMedium"),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      flex: 2,
                                      child: CustomText(
                                          title: "PP",
                                          color: AppColor()
                                              .primaryWhite
                                              .withOpacity(0.8),
                                          fontFamily: "InterMedium"),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      flex: 5,
                                      child: CustomText(
                                          title: "${e.game!.abbrev} IGN",
                                          color: AppColor()
                                              .primaryWhite
                                              .withOpacity(0.8),
                                          fontFamily: "InterMedium"),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      flex: 6,
                                      child: CustomText(
                                          title: "Username",
                                          color: AppColor()
                                              .primaryWhite
                                              .withOpacity(0.8),
                                          fontFamily: "InterMedium"),
                                    )
                                  ],
                                ),
                                Divider(
                                  height: 30,
                                  thickness: 0.5,
                                  color: AppColor().primaryDark,
                                ),
                                ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => PlayerRow(
                                        participant: e.players![index],
                                        index: index),
                                    separatorBuilder: (ctx, index) =>
                                        const Gap(20),
                                    itemCount: e.players!.length)
                              ],
                            )))
                        .toList(),
                  )
                ],
              ),
      )),
    );
  }
}
