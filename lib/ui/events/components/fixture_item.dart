import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/fixture_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/events/components/edit_fixture.dart';
import 'package:e_sport/ui/events/components/edit_fixture_team.dart';
import 'package:e_sport/ui/home/components/profile_image.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

//Fixture Card For Home Screen

class FixtureCard extends StatefulWidget {
  const FixtureCard(
      {super.key, required this.backgroundColor, required this.fixture});

  final LinearGradient backgroundColor;
  final FixtureModel fixture;

  @override
  State<FixtureCard> createState() => _FixtureCardState();
}

class _FixtureCardState extends State<FixtureCard> {
  bool dateHasPassed(DateTime itemDate) {
    final now = DateTime.now();
    final difference = now.difference(itemDate);

    if (difference.inDays > 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var formattedTime =
        "${int.parse(widget.fixture.fixtureTime!.split(":")[0]) > 12 ? (int.parse(widget.fixture.fixtureTime!.split(":")[0]) - 12).toString().padLeft(2, "0") : widget.fixture.fixtureTime!.split(":")[0]}:${widget.fixture.fixtureTime!.split(":")[1]} ${TimeOfDay(hour: int.parse(widget.fixture.fixtureTime!.split(":")[0]), minute: int.parse(widget.fixture.fixtureTime!.split(":")[1])).period.name.toUpperCase()}";
    return Container(
      width: Get.width * 0.9,
      decoration: BoxDecoration(
        gradient: widget.backgroundColor,
        image: DecorationImage(
            image: const AssetImage('assets/images/png/Fixture-zigzag.png'),
            alignment: Alignment(Get.width * -0.015, 0)),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().bgDark,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Get.height * 0.02, Get.height * 0.02,
            Get.height * 0.02, Get.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Helpers().showImagePopup(context,
                          "${ApiLink.imageUrl}${widget.fixture.tournament!.games![0].profilePicture}"),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Get.width * 1),
                        child: OtherImage(
                          width: 30,
                          image: widget
                              .fixture.tournament!.games![0].profilePicture,
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: widget.fixture.title,
                          color: AppColor().primaryWhite,
                          fontFamily: 'Inter',
                          textAlign: TextAlign.start,
                          size: 14,
                        ),
                        Gap(Get.height * 0.002),
                        CustomText(
                          title:
                              "${DateFormat.yMMMEd().format(widget.fixture.fixtureDate!)}, $formattedTime",
                          color: AppColor().primaryWhite,
                          fontFamily: 'InterSemiBold',
                          textAlign: TextAlign.start,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      title:
                          '${widget.fixture.tournament!.games![0].abbrev} Fixture',
                    ),
                    Gap(Get.height * 0.0025),
                    dateHasPassed(widget.fixture.fixtureDate!) == false
                        ? Stack(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColor().primaryWhite,
                                size: Get.height * 0.036,
                              ),
                              Positioned(
                                  top: Get.height * 0.006,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Icon(
                                    Icons.add,
                                    color: AppColor().primaryWhite,
                                    size: Get.height * 0.012,
                                    weight: 1000,
                                  )),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
            Gap(Get.height * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.height * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: Get.width * 0.15,
                        height: Get.width * 0.15,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  widget.fixture.homePlayer?.profile ??
                                      widget.fixture.homeTeam?.profilePicture ??
                                      "jhh")),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Get.width * 0.15)),
                          color: Colors.redAccent,
                          border: Border.all(
                              width: 2, color: AppColor().lightItemsColor),
                        ),
                      ),
                      Gap(Get.height * 0.005),
                      SizedBox(
                        width: Get.width * 0.18,
                        child: CustomText(
                          title: widget.fixture.homePlayer?.inGameName ??
                              widget.fixture.homeTeam?.name,
                          color: AppColor().primaryWhite,
                          fontFamily: 'InterMedium',
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          widget.fixture.homeScore != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      title:
                                          widget.fixture.homeScore.toString(),
                                      color: AppColor().secondaryGreenColor,
                                      fontFamily: 'InterMedium',
                                      textAlign: TextAlign.center,
                                      size: 28,
                                    ),
                                    CustomText(
                                      title: '-',
                                      color: AppColor().secondaryGreenColor,
                                      fontFamily: 'InterMedium',
                                      textAlign: TextAlign.center,
                                      size: 20,
                                    ),
                                    CustomText(
                                      title:
                                          widget.fixture.awayScore.toString(),
                                      color: AppColor().secondaryGreenColor,
                                      fontFamily: 'InterMedium',
                                      textAlign: TextAlign.center,
                                      size: 28,
                                    ),
                                  ],
                                )
                              : CustomText(
                                  title: 'VS',
                                  color: AppColor().secondaryGreenColor,
                                  fontFamily: 'InterMedium',
                                  textAlign: TextAlign.center,
                                  size: 20,
                                ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: Get.width * 0.15,
                        height: Get.width * 0.15,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  widget.fixture.awayPlayer?.profile ??
                                      widget.fixture.awayTeam?.profilePicture ??
                                      "jhh")),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Get.width * 0.15)),
                          color: Colors.redAccent,
                          border: Border.all(
                              width: 2, color: AppColor().lightItemsColor),
                        ),
                      ),
                      Gap(Get.height * 0.005),
                      SizedBox(
                        width: Get.width * 0.17,
                        child: CustomText(
                          title: widget.fixture.awayPlayer?.inGameName ??
                              widget.fixture.awayTeam?.name,
                          color: AppColor().primaryWhite,
                          fontFamily: 'InterMedium',
                          textAlign: TextAlign.center,
                          size: 13,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Gap(Get.height * 0.02),
            Divider(
              height: 0,
              color: AppColor().lightItemsColor,
              thickness: 0.2,
            ),
            Gap(Get.height * 0.02),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.24, vertical: Get.width * 0.0001),
                width: Get.width * 0.7,
                child: InkWell(
                  onTap: () => launchUrl(
                      Uri.parse(widget.fixture.livestreams![0].link!)),
                  child: widget.fixture.livestreams!.isEmpty
                      ? SizedBox()
                      : ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcATop,
                          ),
                          child: Image.network(
                            '${ApiLink.imageUrl}${widget.fixture.livestreams![0].platform!.secondaryImage}',
                            alignment: Alignment.center,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Fixture Card For Tournament Screen

class FixtureCardScrollable extends StatefulWidget {
  const FixtureCardScrollable(
      {super.key, required this.fixture, required this.backgroundColor});

  final LinearGradient backgroundColor;
  final FixtureModel fixture;

  @override
  State<FixtureCardScrollable> createState() => _FixtureCardScrollableState();
}

class _FixtureCardScrollableState extends State<FixtureCardScrollable> {
  bool dateHasPassed(DateTime itemDate) {
    final now = DateTime.now();
    final difference = now.difference(itemDate);

    if (difference.inDays > 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var formattedTime =
        "${TimeOfDay(hour: int.parse(widget.fixture.fixtureTime!.split(":")[0]), minute: int.parse(widget.fixture.fixtureTime!.split(":")[1])).hour}:${TimeOfDay(hour: int.parse(widget.fixture.fixtureTime!.split(":")[0]), minute: int.parse(widget.fixture.fixtureTime!.split(":")[1])).minute} ${TimeOfDay(hour: int.parse(widget.fixture.fixtureTime!.split(":")[0]), minute: int.parse(widget.fixture.fixtureTime!.split(":")[1])).period.name.toUpperCase()}";

    return Container(
      width: Get.width * 0.6,
      decoration: BoxDecoration(
        gradient: widget.backgroundColor,
        image: DecorationImage(
            image: const AssetImage('assets/images/png/Fixture-zigzag.png'),
            alignment: Alignment(Get.height * 0.002, 0),
            fit: BoxFit.fitHeight),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().darkGrey,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Get.height * 0.01, Get.height * 0.02,
            Get.height * 0.01, Get.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        //width: Get.width * 0.9,
                        child: CustomText(
                          title: widget.fixture.title!.capitalizeFirst,
                          color: AppColor().primaryWhite,
                          fontFamily: 'Inter',
                          textAlign: TextAlign.start,
                          size: 14,
                        ),
                      ),
                      Gap(Get.height * 0.0015),
                      SizedBox(
                        //width: Get.width * 0.9,
                        child: CustomText(
                          title:
                              "${DateFormat.yMMMEd().format(widget.fixture.fixtureDate!)}, $formattedTime",
                          color: AppColor().primaryWhite,
                          fontFamily: 'InterSemiBold',
                          textAlign: TextAlign.start,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  dateHasPassed(widget.fixture.fixtureDate!) == false
                      ? Stack(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppColor().primaryWhite,
                              size: Get.height * 0.036,
                            ),
                            Positioned(
                                top: Get.height * 0.006,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Icon(
                                  Icons.add,
                                  color: AppColor().primaryWhite,
                                  size: Get.height * 0.012,
                                )),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Gap(Get.height * 0.02),
            SizedBox(
              height: Get.height * 0.12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  widget.fixture.homePlayer?.profile ??
                                      widget.fixture.homeTeam?.profilePicture ??
                                      "jhh")),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Get.width * 0.15)),
                          color: Colors.redAccent,
                          border: Border.all(
                              width: 2, color: AppColor().lightItemsColor),
                        ),
                      ),
                      Gap(Get.height * 0.005),
                      SizedBox(
                        width: Get.width * 0.18,
                        child: CustomText(
                          title: widget.fixture.homePlayer?.inGameName ??
                              widget.fixture.homeTeam?.name,
                          color: AppColor().primaryWhite,
                          fontFamily: 'InterMedium',
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        title: widget.fixture.homeScore != null
                            ? "${widget.fixture.homeScore} - ${widget.fixture.awayScore}"
                            : 'VS',
                        color: AppColor().secondaryGreenColor,
                        fontFamily: 'InterMedium',
                        textAlign: TextAlign.center,
                        size: 20,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  widget.fixture.awayPlayer?.profile ??
                                      widget.fixture.awayTeam!.profilePicture)),
                          borderRadius: BorderRadius.all(
                              Radius.circular(Get.width * 0.15)),
                          color: Colors.redAccent,
                          border: Border.all(
                              width: 2, color: AppColor().lightItemsColor),
                        ),
                      ),
                      Gap(Get.height * 0.005),
                      SizedBox(
                        width: Get.width * 0.17,
                        child: CustomText(
                          title: widget.fixture.awayPlayer?.inGameName ??
                              widget.fixture.awayTeam!.name,
                          color: AppColor().primaryWhite,
                          fontFamily: 'InterMedium',
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Gap(Get.height * 0.01),
            Divider(
              height: 0,
              color: AppColor().lightItemsColor,
              thickness: 0.2,
            ),
            Gap(Get.height * 0.01),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
              width: Get.width * 0.9,
              height: Get.height * 0.035,
              child: InkWell(
                onTap: () =>
                    launchUrl(Uri.parse(widget.fixture.livestreams![0].link!)),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcATop,
                  ),
                  child: Image.network(
                    '${ApiLink.imageUrl}${widget.fixture.livestreams![0].platform!.secondaryImage}',
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Fixture Card For Tournament List

class FixtureCardTournament extends StatefulWidget {
  const FixtureCardTournament(
      {super.key,
      required this.backgroundColor,
      required this.fixture,
      required this.getFixtures,
      required this.event});

  final FixtureModel fixture;
  final LinearGradient backgroundColor;
  final Function getFixtures;
  final EventModel event;

  @override
  State<FixtureCardTournament> createState() => _FixtureCardTournamentState();
}

class _FixtureCardTournamentState extends State<FixtureCardTournament> {
  final authController = Get.put(AuthRepository());
  final tournamentController = Get.put(TournamentRepository());

  bool dateHasPassed(DateTime itemDate) {
    final now = DateTime.now();
    final difference = now.difference(itemDate);

    if (difference.inDays > 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var formattedTime =
        "${TimeOfDay(hour: int.parse(widget.fixture.fixtureTime!.split(":")[0]), minute: int.parse(widget.fixture.fixtureTime!.split(":")[1])).hour}:${TimeOfDay(hour: int.parse(widget.fixture.fixtureTime!.split(":")[0]), minute: int.parse(widget.fixture.fixtureTime!.split(":")[1])).minute} ${TimeOfDay(hour: int.parse(widget.fixture.fixtureTime!.split(":")[0]), minute: int.parse(widget.fixture.fixtureTime!.split(":")[1])).period.name.toUpperCase()}";
    return Container(
      width: Get.width * 0.9,
      decoration: BoxDecoration(
        gradient: widget.backgroundColor,
        image: DecorationImage(
            image: const AssetImage('assets/images/png/Fixture-zigzag.png'),
            alignment: Alignment(Get.width * -0.0025, 0)),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().bgDark,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Get.height * 0.02, Get.height * 0.02,
            Get.height * 0.02, Get.height * 0.01),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            //width: Get.width * 0.9,
                            child: CustomText(
                              title: widget.fixture.title!.capitalizeFirst,
                              color: AppColor().primaryWhite,
                              fontFamily: 'Inter',
                              textAlign: TextAlign.start,
                              size: 14,
                            ),
                          ),
                          Gap(Get.height * 0.0015),
                          SizedBox(
                            //width: Get.width * 0.9,
                            child: CustomText(
                              title:
                                  "${DateFormat.yMMMEd().format(widget.fixture.fixtureDate!)}, $formattedTime",
                              color: AppColor().primaryWhite,
                              fontFamily: 'InterSemiBold',
                              textAlign: TextAlign.start,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                      dateHasPassed(widget.fixture.fixtureDate!) == false
                          ? Stack(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: AppColor().primaryWhite,
                                  size: Get.height * 0.036,
                                ),
                                Positioned(
                                    top: Get.height * 0.006,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Icon(
                                      Icons.add,
                                      color: AppColor().primaryWhite,
                                      size: Get.height * 0.012,
                                    )),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                Gap(Get.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.height * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        spacing: 8,
                        children: [
                          Container(
                            width: Get.width * 0.15,
                            height: Get.width * 0.15,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget
                                          .fixture.homePlayer?.profile ??
                                      widget.fixture.homeTeam!.profilePicture)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Get.width * 0.15)),
                              color: Colors.redAccent,
                              border: Border.all(
                                  width: 2, color: AppColor().lightItemsColor),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.18,
                            child: CustomText(
                              title: widget.fixture.homePlayer?.inGameName ??
                                  widget.fixture.homeTeam!.name,
                              color: AppColor().primaryWhite,
                              fontFamily: 'InterMedium',
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              widget.fixture.homeScore != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          title: widget.fixture.homeScore
                                              .toString(),
                                          color: AppColor().secondaryGreenColor,
                                          fontFamily: 'InterMedium',
                                          textAlign: TextAlign.center,
                                          size: 28,
                                        ),
                                        CustomText(
                                          title: '-',
                                          color: AppColor().secondaryGreenColor,
                                          fontFamily: 'InterMedium',
                                          textAlign: TextAlign.center,
                                          size: 20,
                                        ),
                                        CustomText(
                                          title: widget.fixture.awayScore
                                              .toString(),
                                          color: AppColor().secondaryGreenColor,
                                          fontFamily: 'InterMedium',
                                          textAlign: TextAlign.center,
                                          size: 28,
                                        ),
                                      ],
                                    )
                                  : CustomText(
                                      title: 'VS',
                                      color: AppColor().secondaryGreenColor,
                                      fontFamily: 'InterMedium',
                                      textAlign: TextAlign.center,
                                      size: 20,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        spacing: 8,
                        children: [
                          Container(
                            width: Get.width * 0.15,
                            height: Get.width * 0.15,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget
                                          .fixture.awayPlayer?.profile ??
                                      widget.fixture.awayTeam!.profilePicture)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Get.width * 0.15)),
                              color: Colors.redAccent,
                              border: Border.all(
                                  width: 2, color: AppColor().lightItemsColor),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.17,
                            child: CustomText(
                              title: widget.fixture.awayPlayer?.inGameName ??
                                  widget.fixture.awayTeam!.name,
                              color: AppColor().primaryWhite,
                              fontFamily: 'InterMedium',
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Gap(Get.height * 0.02),
                Divider(
                  height: 0,
                  color: AppColor().lightItemsColor,
                  thickness: 0.2,
                ),
                Gap(Get.height * 0.01),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.3, vertical: Get.width * 0.01),
                  width: Get.width * 0.9,
                  child: InkWell(
                    onTap: () => launchUrl(
                        Uri.parse(widget.fixture.livestreams![0].link!)),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcATop,
                      ),
                      child: Image.network(
                        '${ApiLink.imageUrl}${widget.fixture.livestreams![0].platform!.secondaryImage}',
                        // height: 25,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible:
                  widget.event!.community!.owner!.id == authController.user!.id,
              child: Positioned(
                  right: 0,
                  child:
                      menuAnchor(widget.fixture, widget.fixture.tournament!)),
            )
          ],
        ),
      ),
    );
  }

  Widget menuAnchor(FixtureModel fixture, EventModel event) {
    Future<void> showDeleteDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Fixture'),
            titleTextStyle: TextStyle(
                color: AppColor().primaryWhite,
                fontFamily: "InterSemiBold",
                fontSize: 20),
            backgroundColor: AppColor().primaryMenu,
            content: Container(
              child: CustomText(
                  title: "Are you sure you want to delete this Fixture?",
                  color: AppColor().primaryWhite),
            ),
            actions: <Widget>[
              TextButton(
                child: CustomText(
                  title: 'Yes',
                  color: AppColor().primaryRed,
                ),
                onPressed: () async {
                  Get.back();
                  await tournamentController.deleteFixture(fixture.id!);
                  await widget.getFixtures();
                },
              ),
              TextButton(
                child: CustomText(
                  title: 'No',
                  color: AppColor().primaryWhite,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        },
      );
    }

    return MenuAnchor(
      style: MenuStyle(
        alignment: Alignment.bottomLeft,
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), side: BorderSide.none)),
        backgroundColor: WidgetStatePropertyAll(AppColor().primaryMenu),
      ),
      menuChildren: [
        MenuItemButton(
            leadingIcon: Icon(
              CupertinoIcons.pen,
              color: AppColor().primaryWhite,
              size: 18,
            ),
            onPressed: () {
              if (fixture.fixtureGroup == "player") {
                Get.to(() => EditFixture(fixture: fixture, event: event));
              } else {
                Get.to(() => EditFixtureTeam(fixture: fixture, event: event));
              }
            },
            child: Row(
              children: [
                CustomText(
                  title: "Edit Fixture",
                  fontFamily: 'InterMedium',
                  textAlign: TextAlign.start,
                  color: AppColor().primaryWhite,
                ),
              ],
            )),
        MenuItemButton(
            leadingIcon: Icon(
              CupertinoIcons.trash,
              color: AppColor().primaryRed,
              size: 18,
            ),
            onPressed: () {
              showDeleteDialog();
            },
            child: Row(
              children: [
                CustomText(
                  title: "Delete Fixture",
                  fontFamily: 'InterMedium',
                  textAlign: TextAlign.start,
                  color: AppColor().primaryRed,
                ),
              ],
            ))
      ],
      builder: (context, controller, child) => GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: Icon(Icons.more_vert, color: AppColor().primaryWhite)),
    );
  }
}
