import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/fixture_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/events/components/edit_fixture.dart';
import 'package:e_sport/ui/events/components/edit_fixture_team.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
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
            CustomText(
              title: widget.fixture.tournament!.name,
              color: AppColor().primaryWhite,
              fontFamily: 'Inter',
              textAlign: TextAlign.start,
              size: 14,
            ),
            CustomText(
              title: '${widget.fixture.tournament!.games![0].name}',
              color: AppColor().primaryWhite,
              fontFamily: 'InterSemiBold',
              textAlign: TextAlign.start,
              size: 14,
            ),
            Gap(Get.height * 0.01),
            SizedBox(
              width: Get.width * 0.9,
              child: CustomText(
                title: widget.fixture.title,
                color: AppColor().primaryWhite,
                fontFamily: 'Inter',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
            Gap(Get.height * 0.0015),
            SizedBox(
              width: Get.width * 0.9,
              child: CustomText(
                title: DateFormat.yMMMEd().format(widget.fixture.fixtureDate!),
                color: AppColor().primaryWhite,
                fontFamily: 'InterSemiBold',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
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
                          size: 13,
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
                          Gap(Get.height * 0.005),
                          CustomText(
                            title: formattedTime,
                            color: AppColor().primaryWhite,
                            fontFamily: 'InterMedium',
                            textAlign: TextAlign.center,
                            size: 14,
                            underline: TextDecoration.underline,
                            decorationColor: AppColor().primaryWhite,
                          )
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
            Gap(Get.height * 0.01),
            Divider(
              height: 0,
              color: AppColor().lightItemsColor,
              thickness: 0.2,
            ),
            Gap(Get.height * 0.02),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
                width: Get.width * 0.7,
                child: InkWell(
                  // onTap: () =>
                  //     launchUrl(Uri.parse(widget.fixture.livestreams![0].link!)),
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
            alignment: Alignment(Get.height * 0.004, 0),
            fit: BoxFit.fitHeight),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().darkGrey,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Get.height * 0.001, Get.height * 0.02,
            Get.height * 0.001, Get.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width * 0.9,
              child: CustomText(
                title: widget.fixture.title,
                color: AppColor().primaryWhite,
                fontFamily: 'Inter',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
            Gap(Get.height * 0.0015),
            SizedBox(
              width: Get.width * 0.9,
              child: CustomText(
                title: DateFormat.yMMMEd().format(widget.fixture.fixtureDate!),
                color: AppColor().primaryWhite,
                fontFamily: 'InterSemiBold',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.height * 0.01,
                vertical: Get.height * 0.01,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: Get.width * 0.13,
                        height: Get.width * 0.13,
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
                          size: 13,
                        ),
                      )
                    ],
                  ),
                  Column(
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
                      Gap(Get.height * 0.005),
                      CustomText(
                        title: formattedTime,
                        color: AppColor().primaryWhite,
                        fontFamily: 'InterMedium',
                        textAlign: TextAlign.center,
                        size: 14,
                        underline: TextDecoration.underline,
                        decorationColor: AppColor().primaryWhite,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: Get.width * 0.13,
                        height: Get.width * 0.13,
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
                          size: 13,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Gap(Get.height * 0.001),
            Divider(
              height: 0,
              color: AppColor().lightItemsColor,
              thickness: 0.2,
            ),
            Gap(Get.height * 0.015),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
              width: Get.width * 0.9,
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
      required this.getFixtures});

  final FixtureModel fixture;
  final LinearGradient backgroundColor;
  final Function getFixtures;

  @override
  State<FixtureCardTournament> createState() => _FixtureCardTournamentState();
}

class _FixtureCardTournamentState extends State<FixtureCardTournament> {
  final authController = Get.put(AuthRepository());
  final tournamentController = Get.put(TournamentRepository());

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
                  child: CustomText(
                    title: widget.fixture.title,
                    color: AppColor().primaryWhite,
                    fontFamily: 'Inter',
                    textAlign: TextAlign.center,
                    size: 14,
                  ),
                ),
                Gap(Get.height * 0.0015),
                SizedBox(
                  width: Get.width * 0.9,
                  child: CustomText(
                    title:
                        DateFormat.yMMMEd().format(widget.fixture.fixtureDate!),
                    color: AppColor().primaryWhite,
                    fontFamily: 'InterSemiBold',
                    textAlign: TextAlign.center,
                    size: 14,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.height * 0.01,
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
                          Gap(Get.height * 0.005),
                          SizedBox(
                            width: Get.width * 0.18,
                            child: CustomText(
                              title: widget.fixture.homePlayer?.inGameName ??
                                  widget.fixture.homeTeam!.name,
                              color: AppColor().primaryWhite,
                              fontFamily: 'InterMedium',
                              textAlign: TextAlign.center,
                              size: 13,
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
                              Gap(Get.height * 0.005),
                              CustomText(
                                title: formattedTime,
                                color: AppColor().primaryWhite,
                                fontFamily: 'InterMedium',
                                textAlign: TextAlign.center,
                                size: 14,
                                underline: TextDecoration.underline,
                                decorationColor: AppColor().primaryWhite,
                              )
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
                          Gap(Get.height * 0.005),
                          SizedBox(
                            width: Get.width * 0.17,
                            child: CustomText(
                              title: widget.fixture.awayPlayer?.inGameName ??
                                  widget.fixture.awayTeam!.name,
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
                Gap(Get.height * 0.01),
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
              visible: widget.fixture.tournament!.community!.owner!.id ==
                  authController.user!.id,
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
