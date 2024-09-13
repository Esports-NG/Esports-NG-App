import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/team/roaster_model.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/account_teams/account_teams_details.dart';
import 'package:e_sport/ui/components/participant_list.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TeamParticipantList extends StatefulWidget {
  const TeamParticipantList({super.key, required this.event});
  final EventModel event;

  @override
  State<TeamParticipantList> createState() => _TeamParticipantListState();
}

class _TeamParticipantListState extends State<TeamParticipantList> {
  final tournamentController = Get.put(TournamentRepository());
  final bool _isRegisterLoading = false;
  List<RoasterModel>? _participantList;
  final bool _isRegistered = false;

  Future getParticipants() async {
    List<RoasterModel> participantList = await tournamentController
        .getTeamTournamentParticipants(widget.event.id!);
    setState(() {
      _participantList = participantList;
      // if (participantList
      //     .where((element) => element. == authController.user!.id!)
      //     .isNotEmpty) {
      //   _isRegistered = true;
      // }
    });
  }

  @override
  void initState() {
    getParticipants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(children: [
            CachedNetworkImage(
              imageUrl: ApiLink.imageUrl + widget.event.banner!,
              imageBuilder: (context, imageProvider) => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageProvider,
                    ),
                    borderRadius: BorderRadius.circular(999)),
              ),
            ),
            Gap(Get.height * 0.01),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    title: widget.event.name,
                    color: AppColor().primaryWhite,
                    fontFamily: "InterSemiBold",
                    size: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                  CustomText(
                    title: "${_participantList?.length ?? ""} Team(s)",
                    color: AppColor().primaryWhite.withOpacity(0.5),
                    // fontFamily: "InterSemiBold",
                    size: 14,
                  )
                ],
              ),
            )
          ]),
          leading: GoBackButton(
            onPressed: () => Get.back(),
          ),
          actions: [
            InkWell(
              borderRadius: BorderRadius.circular(30),
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.height * 0.03,
                      vertical: Get.height * 0.015),
                  decoration: BoxDecoration(
                    border: !_isRegisterLoading
                        ? null
                        : Border.all(
                            width: 1,
                            color: AppColor().primaryColor.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(30),
                    color: _isRegisterLoading
                        ? Colors.transparent
                        : AppColor().primaryColor,
                  ),
                  child: _isRegisterLoading
                      ? Center(
                          child: SizedBox(
                            width: Get.height * 0.02,
                            height: Get.height * 0.02,
                            child: CircularProgressIndicator(
                              color: AppColor().primaryColor,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Center(
                          child: CustomText(
                          title: _isRegistered ? "Registered" : "Register",
                          color: AppColor().primaryWhite,
                          size: 12,
                          fontFamily: 'InterMedium',
                        )),
                ),
              ),
            ),
            Gap(Get.height * 0.02)
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "Participant List",
                  color: AppColor().secondaryGreenColor,
                  fontFamily: "InterSemiBold",
                  size: 20,
                ),
                CustomText(
                  title:
                      "${_participantList != null ? _participantList!.length : "0"} Team(s), ${_participantList != null ? _participantList!.fold(0, (sum, next) => sum + next.team!.playersCount!) : "0"} Players",
                  color: AppColor().primaryWhite,
                  size: 16,
                ),
                _participantList == null
                    ? SizedBox(
                        height: Get.height * 0.3,
                        child: const Center(child: ButtonLoader()))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(32),
                          ListView.separated(
                              itemBuilder: (context, index) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Get.to(AccountTeamsDetail(
                                            item: _participantList![index]
                                                .team!)),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          _participantList![
                                                                  index]
                                                              .team!
                                                              .profilePicture!)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          99)),
                                            ),
                                            Gap(Get.height * 0.015),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  title:
                                                      _participantList![index]
                                                          .team!
                                                          .name!
                                                          .toUpperCase(),
                                                  color:
                                                      AppColor().primaryWhite,
                                                  fontFamily: "InterSemiBold",
                                                  size: 16,
                                                ),
                                                CustomText(
                                                  title:
                                                      "${_participantList![index].players!.length} Players",
                                                  color: AppColor()
                                                      .primaryWhite
                                                      .withOpacity(0.6),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Gap(Get.height * 0.02),
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
                                                title:
                                                    "${_participantList![0].game!.abbrev!} IGN",
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
                                        thickness: 0.8,
                                        color: AppColor().primaryDark,
                                      ),
                                      ListView.separated(
                                          shrinkWrap: true,
                                          itemBuilder: (ctx, i) => PlayerRow(
                                              participant:
                                                  _participantList![index]
                                                      .players![i],
                                              index: i),
                                          separatorBuilder: (ctx, index) =>
                                              const Gap(10),
                                          itemCount: _participantList![index]
                                              .players!
                                              .length)
                                    ],
                                  ),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const Gap(50),
                              itemCount: _participantList!.length)
                        ],
                      )
              ],
            ),
          ),
        ));
  }
}
