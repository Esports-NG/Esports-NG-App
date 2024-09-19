import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/model/waitlist_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/components/games_played_details.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ParticipantList extends StatefulWidget {
  const ParticipantList({super.key, required this.event});
  final EventModel event;

  @override
  State<ParticipantList> createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList>
    with SingleTickerProviderStateMixin {
  final tournamentController = Get.put(TournamentRepository());
  final playerController = Get.put(PlayerRepository());
  final authController = Get.put(AuthRepository());
  bool _isRegisterLoading = false;
  List<PlayerModel>? _participantList;
  List<WaitlistModel>? _waitlist;
  bool _isRegistered = false;
  bool _isTakingAction = false;
  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  Future getParticipants() async {
    List<PlayerModel> participantList =
        await tournamentController.getTournamentParticipants(widget.event.id!);
    List<WaitlistModel> waitlist =
        await tournamentController.getTournamentWaitlist(widget.event.id!);
    setState(() {
      _participantList = participantList;
      _waitlist = waitlist;
      if (participantList
          .where((element) => element.player!.id! == authController.user!.id!)
          .isNotEmpty) {
        _isRegistered = true;
      }
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
                    title:
                        "${_participantList != null ? _participantList!.length : " "} Participants",
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
              onTap: () async {
                if (widget.event.tournamentType == "team") {
                } else {
                  setState(() {
                    _isRegisterLoading = true;
                  });
                  await tournamentController
                      .registerForTournament(widget.event.id!);
                  await getParticipants();
                  setState(() {
                    _isRegisterLoading = false;
                  });
                }
              },
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
                          title: _isRegistered ? "Registered" : 'Register Now',
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
              child: TabBarView(controller: _tabController, children: [
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
                              "${_participantList != null ? _participantList!.length : " "} players",
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
                                                "${widget.event.games![0].abbrev} IGN",
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
                                      itemBuilder: (context, index) =>
                                          PlayerRow(
                                              participant:
                                                  _participantList![index],
                                              index: index),
                                      separatorBuilder: (ctx, index) =>
                                          const Gap(20),
                                      itemCount: _participantList!.length)
                                ],
                              )
                      ],
                    ),
                  ),
                ),
                authController.user!.id! != widget.event.community!.owner!.id!
                    ? Center(
                        child: CustomText(
                            title: "Sorry, you cannot view this page",
                            color: AppColor().lightItemsColor))
                    : _waitlist == null
                        ? Center(
                            child: ButtonLoader(),
                          )
                        : ListView.separated(
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
                                              "IGN: ${item.player!.inGameName}",
                                          color: AppColor().primaryWhite,
                                          size: 16,
                                        ),
                                        const Gap(5),
                                        CustomText(
                                            title:
                                                "Username: ${item.player!.player!.userName}",
                                            color: AppColor().lightItemsColor)
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
                                                    item.player!.id!,
                                                    "accept");
                                            setState(() {
                                              _isTakingAction = false;
                                              _participantList!
                                                  .add(item.player!);
                                              _waitlist!.removeWhere(
                                                  (element) =>
                                                      element.player!.id! ==
                                                      item.player!.id!);
                                            });
                                          },
                                          color:
                                              AppColor().primaryBackGroundColor,
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      AppColor()
                                                          .secondaryGreenColor))),
                                      const Gap(10),
                                      IconButton(
                                        icon: _isTakingAction
                                            ? ButtonLoader(
                                                color: AppColor().primaryWhite)
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
                                            _waitlist!.removeWhere((element) =>
                                                element.player!.id! ==
                                                item.player!.id!);
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
                            itemCount: _waitlist!.length)
              ]),
            ),
          ],
        ));
  }
}

class PlayerRow extends StatelessWidget {
  const PlayerRow({super.key, required this.participant, required this.index});
  final PlayerModel participant;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomText(
            title: (index + 1).toString(),
            color: AppColor().primaryWhite,
            fontFamily: "InterMedium",
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () => Get.to(GamesPlayedDetails(item: participant)),
            child: participant.profile != null
                ? Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(participant.profile!))),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/people.svg",
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 5,
          child: InkWell(
            onTap: () => Get.to(GamesPlayedDetails(item: participant)),
            child: CustomText(
              title: participant.inGameName,
              color: AppColor().primaryWhite,
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 6,
          child: InkWell(
            onTap: () => Get.to(UserDetails(id: participant.player!.id!)),
            child: CustomText(
              title: participant.player!.userName,
              color: AppColor().primaryWhite,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}
