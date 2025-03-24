import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/team/roaster_model.dart';
import 'package:e_sport/data/model/waitlist_model.dart';
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

class _TeamParticipantListState extends State<TeamParticipantList>
    with SingleTickerProviderStateMixin {
  final tournamentController = Get.put(TournamentRepository());
  final bool _isRegisterLoading = false;
  List<RoasterModel>? _participantList;
  final bool _isRegistered = false;
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  List<WaitlistModel>? _waitlist;
  bool _isTakingAction = false;

  Future getParticipants() async {
    List<RoasterModel> participantList = await tournamentController
        .getTeamTournamentParticipants(widget.event.id!);
    List<WaitlistModel> waitlist =
        await tournamentController.getTournamentWaitlist(widget.event.id!);
    setState(() {
      _participantList = participantList;
      _waitlist = waitlist;
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
        body: Column(
          children: [
            Container(
              color: AppColor().primaryBackGroundColor,
              child: TabBar(
                  labelColor: AppColor().secondaryGreenColor,
                  indicatorColor: AppColor().secondaryGreenColor,
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(
                    fontFamily: 'InterMedium',
                    fontSize: 13,
                  ),
                  unselectedLabelColor: AppColor().lightItemsColor,
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                  ),
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Approved Participants'),
                    Tab(
                      text: 'Registrations',
                    ),
                  ]),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
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
                                                  onTap: () => Get.to(
                                                      AccountTeamsDetail(
                                                          item:
                                                              _participantList![
                                                                      index]
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
                                                                BorderRadius
                                                                    .circular(
                                                                        99)),
                                                      ),
                                                      Gap(Get.height * 0.015),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomText(
                                                            title: _participantList![
                                                                    index]
                                                                .team!
                                                                .name!
                                                                .toUpperCase(),
                                                            color: AppColor()
                                                                .primaryWhite,
                                                            fontFamily:
                                                                "InterSemiBold",
                                                            size: 16,
                                                          ),
                                                          CustomText(
                                                            title:
                                                                "${_participantList![index].players!.length} Players",
                                                            color: AppColor()
                                                                .primaryWhite
                                                                .withOpacity(
                                                                    0.6),
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
                                                          fontFamily:
                                                              "InterMedium"),
                                                    ),
                                                    const Spacer(),
                                                    Expanded(
                                                      flex: 2,
                                                      child: CustomText(
                                                          title: "PP",
                                                          color: AppColor()
                                                              .primaryWhite
                                                              .withOpacity(0.8),
                                                          fontFamily:
                                                              "InterMedium"),
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
                                                          fontFamily:
                                                              "InterMedium"),
                                                    ),
                                                    const Spacer(),
                                                    Expanded(
                                                      flex: 6,
                                                      child: CustomText(
                                                          title: "Username",
                                                          color: AppColor()
                                                              .primaryWhite
                                                              .withOpacity(0.8),
                                                          fontFamily:
                                                              "InterMedium"),
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
                                                    itemBuilder: (ctx, i) =>
                                                        PlayerRow(
                                                            participant:
                                                                _participantList![
                                                                            index]
                                                                        .players![
                                                                    i],
                                                            index: i),
                                                    separatorBuilder:
                                                        (ctx, index) =>
                                                            const Gap(10),
                                                    itemCount:
                                                        _participantList![index]
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
                  ),
                  _waitlist == null
                      ? const Center(
                          child: ButtonLoader(),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: Get.height * 0.02,
                                    left: Get.height * 0.02,
                                    right: Get.height * 0.02),
                                child: CustomText(
                                  title: "Registered Teams",
                                  color: AppColor().secondaryGreenColor,
                                  fontFamily: "InterSemiBold",
                                  size: 20,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.height * 0.02),
                                child: CustomText(
                                  title:
                                      "${_waitlist != null ? _waitlist!.length : " "} players",
                                  color: AppColor().primaryWhite,
                                  size: 16,
                                ),
                              ),
                              const Gap(20),
                              ListView.separated(
                                itemBuilder: (context, index) {
                                  WaitlistModel item = _waitlist![index];
                                  return Container(
                                    padding: EdgeInsets.all(Get.height * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              title:
                                                  "Team Name: ${item.team!.team!.name!}",
                                              color: AppColor().primaryWhite,
                                              size: 16,
                                            ),
                                            const Gap(5),
                                            CustomText(
                                                title:
                                                    "${item.team!.players!.length} player(s)",
                                                color:
                                                    AppColor().lightItemsColor)
                                          ],
                                        ),
                                        Row(children: [
                                          IconButton(
                                              icon: _isTakingAction
                                                  ? ButtonLoader(
                                                      color: AppColor()
                                                          .primaryBackGroundColor)
                                                  : const Icon(Icons.check),
                                              onPressed: () async {
                                                setState(() {
                                                  _isTakingAction = true;
                                                });
                                                await tournamentController
                                                    .takeActionOnWaitlist(
                                                        widget.event.id!,
                                                        item.team!.team!.id!,
                                                        "accept");
                                                setState(() {
                                                  _isTakingAction = false;
                                                  _participantList!
                                                      .add(item.team!);
                                                  _waitlist!.removeWhere(
                                                      (element) =>
                                                          element.team!.id! ==
                                                          item.team!.id!);
                                                });
                                              },
                                              color: AppColor()
                                                  .primaryBackGroundColor,
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                          AppColor()
                                                              .secondaryGreenColor))),
                                          const Gap(10),
                                          IconButton(
                                            icon: _isTakingAction
                                                ? ButtonLoader(
                                                    color:
                                                        AppColor().primaryWhite)
                                                : const Icon(Icons.close),
                                            onPressed: () async {
                                              setState(() {
                                                _isTakingAction = true;
                                              });
                                              await tournamentController
                                                  .takeActionOnWaitlist(
                                                      widget.event.id!,
                                                      item.player!.id!,
                                                      "reject");
                                              setState(() {
                                                _isTakingAction = false;
                                                _waitlist!.removeWhere(
                                                    (element) =>
                                                        element.team!.id! ==
                                                        item.team!.id!);
                                              });
                                            },
                                            color: AppColor().primaryWhite,
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        AppColor().primaryRed)),
                                          )
                                        ])
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(
                                  color: AppColor().bgDark,
                                ),
                                itemCount: _waitlist!.length,
                                shrinkWrap: true,
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ],
        ));
  }
}
