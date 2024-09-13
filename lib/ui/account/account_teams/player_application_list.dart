import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/team_repository.dart';
import 'package:e_sport/ui/account/account_teams/player_application.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PlayerApplicationList extends StatefulWidget {
  const PlayerApplicationList({super.key, required this.item});
  final TeamModel item;

  @override
  State<PlayerApplicationList> createState() => _PlayerApplicationListState();
}

class _PlayerApplicationListState extends State<PlayerApplicationList> {
  late final List<TeamApplicationModel>? _teamApplications;
  final teamController = Get.put(TeamRepository());
  bool _isLoading = false;

  Future getTeamApplications() async {
    setState(() {
      _isLoading = true;
    });
    var teamApplications =
        await teamController.getTeamApplications(widget.item.id!);
    setState(() {
      _isLoading = false;
      _teamApplications = teamApplications;
    });
  }

  @override
  void initState() {
    getTeamApplications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(children: [
            CachedNetworkImage(
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
                  title: "Player Applications",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.height * 0.02, vertical: Get.height * 0.04),
          child: _isLoading
              ? SizedBox(
                  height: Get.height * 0.6,
                  child: const Center(child: ButtonLoader()),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Player Applications",
                      color: AppColor().primaryWhite,
                      fontFamily: "InterMedium",
                      size: 16,
                    ),
                    Gap(Get.height * 0.02),
                    ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: GestureDetector(
                                onTap: () => Get.to(PlayerApplication(
                                    application: _teamApplications.reversed
                                        .toList()[index])),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 0,
                                      child: CustomText(
                                        title: _teamApplications.reversed
                                            .toList()[index]
                                            .role,
                                        color: AppColor()
                                            .primaryWhite
                                            .withOpacity(0.7),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    Visibility(
                                        visible: _teamApplications.reversed
                                                .toList()[index]
                                                .accepted ==
                                            false,
                                        child: Chip(
                                            backgroundColor: Colors.red,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(99)),
                                            label: CustomText(
                                              title: "Rejected",
                                              fontFamily: "InterSemiBold",
                                              size: 12,
                                              color: AppColor().primaryWhite,
                                            ))),
                                    Visibility(
                                        visible: _teamApplications.reversed
                                                .toList()[index]
                                                .accepted ==
                                            true,
                                        child: Chip(
                                            backgroundColor:
                                                AppColor().secondaryGreenColor,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(99)),
                                            label: const CustomText(
                                              title: "Accepted",
                                              fontFamily: "InterSemiBold",
                                              size: 12,
                                            ))),
                                    Icon(
                                      Icons.chevron_right,
                                      color: AppColor()
                                          .primaryColor
                                          .withOpacity(0.7),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        separatorBuilder: (context, index) => Divider(
                              color: AppColor().primaryDark,
                            ),
                        itemCount: _teamApplications!.length)
                  ],
                ),
        ),
      ),
    );
  }
}
