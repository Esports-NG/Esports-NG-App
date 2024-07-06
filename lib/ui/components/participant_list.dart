import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/data/repository/player_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/account/user_details.dart';
import 'package:e_sport/ui/components/choose_team_dialog.dart';
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

class _ParticipantListState extends State<ParticipantList> {
  final tournamentController = Get.put(TournamentRepository());
  final playerController = Get.put(PlayerRepository());
  final authController = Get.put(AuthRepository());
  bool _isRegisterLoading = false;
  List<ParticipantModel>? _participantList;
  bool _isRegistered = false;

  Future getParticipants() async {
    List<ParticipantModel> participantList =
        await tournamentController.getTournamentParticipants(widget.event.id!);
    setState(() {
      _participantList = participantList;
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: widget.event.name,
                  color: AppColor().primaryWhite,
                  fontFamily: "GilroySemiBold",
                  size: 16,
                  overflow: TextOverflow.ellipsis,
                ),
                CustomText(
                  title:
                      "${_participantList != null ? _participantList!.length : " "} Participants",
                  color: AppColor().primaryWhite.withOpacity(0.5),
                  // fontFamily: "GilroySemiBold",
                  size: 14,
                )
              ],
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
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ChooseTeamDialog(id: widget.event.id!),
                  );
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
                          fontFamily: 'GilroyMedium',
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
                  fontFamily: "GilroySemiBold",
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
                                    fontFamily: "GilroyMedium"),
                              ),
                              const Spacer(),
                              Expanded(
                                flex: 2,
                                child: CustomText(
                                    title: "PP",
                                    color: AppColor()
                                        .primaryWhite
                                        .withOpacity(0.8),
                                    fontFamily: "GilroyMedium"),
                              ),
                              const Spacer(),
                              Expanded(
                                flex: 5,
                                child: CustomText(
                                    title: "${widget.event.gameMode} IGN",
                                    color: AppColor()
                                        .primaryWhite
                                        .withOpacity(0.8),
                                    fontFamily: "GilroyMedium"),
                              ),
                              const Spacer(),
                              Expanded(
                                flex: 6,
                                child: CustomText(
                                    title: "Username",
                                    color: AppColor()
                                        .primaryWhite
                                        .withOpacity(0.8),
                                    fontFamily: "GilroyMedium"),
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
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => PlayerRow(
                                  participant: _participantList![index],
                                  index: index),
                              separatorBuilder: (ctx, index) => const Gap(20),
                              itemCount: _participantList!.length)
                        ],
                      )
              ],
            ),
          ),
        ));
  }
}

class PlayerRow extends StatelessWidget {
  const PlayerRow({super.key, required this.participant, required this.index});
  final ParticipantModel participant;
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
            fontFamily: "GilroyMedium",
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: participant.player!.profile!.profilePicture != null
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
                              image: NetworkImage(participant
                                  .player!.profile!.profilePicture))),
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
        const Spacer(),
        Expanded(
          flex: 5,
          child: CustomText(
            title: participant.inGameName,
            color: AppColor().primaryWhite,
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
