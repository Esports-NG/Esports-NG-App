import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/fixture_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/components/account_tournament_detail.dart';
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

// BR Fixture for Tournament List
class BrFixtureCard extends StatefulWidget {
  const BrFixtureCard(
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
  State<BrFixtureCard> createState() => _BrFixtureCardState();
}

class _BrFixtureCardState extends State<BrFixtureCard> {
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
        "${int.parse(widget.fixture.fixtureTime!.split(":")[0]) > 12 ? (int.parse(widget.fixture.fixtureTime!.split(":")[0]) - 12).toString().padLeft(2, "0") : widget.fixture.fixtureTime!.split(":")[0]}:${widget.fixture.fixtureTime!.split(":")[1]} ${TimeOfDay(hour: int.parse(widget.fixture.fixtureTime!.split(":")[0]), minute: int.parse(widget.fixture.fixtureTime!.split(":")[1])).period.name.toUpperCase()}";
    return InkWell(
      onTap: () async {
        await Get.to(AccountTournamentDetail(item: widget.event));
      },
      child: Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
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
                                      height: 30,
                                      width: 30,
                                      image: "${ApiLink.imageUrl}${widget.fixture.tournament!.games![0].profilePicture}",
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
                                    Gap(Get.height * 0.0015),
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
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomText(
                              title: '${widget.fixture.tournament!.games![0].abbrev} Fixture',
                            ),
                            Gap(Get.height * 0.0025),
                            dateHasPassed(widget.fixture.fixtureDate!) == false && widget.fixture.livestreams!.isNotEmpty
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
                  ),
                  Gap(Get.height * 0.02),
                  widget.fixture.first != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              spacing: 8,
                              children: [
                                CustomText(
                                  title: "2nd Place",
                                ),
                                OtherImage(
                                    width: 50,
                                    height: 50,
                                    image: widget.event.tournamentType == "solo"
                                        ? widget.fixture.second!.player!.profile
                                        : widget.fixture.second!.team!
                                            .profilePicture),
                                CustomText(
                                    title: widget.event.tournamentType == "solo"
                                        ? widget
                                            .fixture.second!.player!.inGameName
                                        : widget.fixture.second!.team!.name)
                              ],
                            ),
                            Column(
                              spacing: 8,
                              children: [
                                CustomText(
                                  color: AppColor().secondaryGreenColor,
                                  fontFamily: "InterMedium",
                                  title: "1st Place",
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColor().secondaryGreenColor,
                                        width: 5),
                                    borderRadius: BorderRadius.circular(500),
                                  ),
                                  child: OtherImage(
                                      width: 55,
                                      height: 55,
                                      image: widget.event.tournamentType == "solo"
                                          ? widget.fixture.first!.player!.profile
                                          : widget.fixture.first!.team!
                                              .profilePicture),
                                ),
                                CustomText(
                                    fontFamily: "InterMedium",
                                    color: AppColor().secondaryGreenColor,
                                    title: widget.event.tournamentType == "solo"
                                        ? widget.fixture.first!.player!.inGameName
                                        : widget.fixture.first!.team!.name)
                              ],
                            ),
                            Column(
                              spacing: 8,
                              children: [
                                CustomText(
                                  title: "3rd Place",
                                  size: 13,
                                ),
                                OtherImage(
                                    width: 45,
                                    height: 45,
                                    image: widget.event.tournamentType == "solo"
                                        ? widget.fixture.third!.player!.profile
                                        : widget
                                            .fixture.third!.team!.profilePicture),
                                CustomText(
                                  title: widget.event.tournamentType == "solo"
                                      ? widget.fixture.third!.player!.inGameName
                                      : widget.fixture.third!.team!.name,
                                  size: 13,
                                )
                              ],
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            GestureDetector(
                              onTap: () => Helpers().showImagePopup(
                                        context,"${ApiLink.imageUrl}${widget.fixture.livestreams![0].banner}"),
                              child: OtherImage(
                                  width: 60,
                                  height: 60,
                                  image: widget.fixture.livestreams![0].banner != null
                                      ? "${ApiLink.imageUrl}${widget.fixture.livestreams![0].banner}"
                                      : widget.fixture.livestreams![0].banner),
                            ),
                            CustomText(
                                fontFamily: "InterSemiBold",
                                size: 24,
                                color: AppColor().secondaryGreenColor,
                                title:
                                    "${widget.fixture.tournament!.tournamentType == "solo" ? widget.fixture.players!.length : widget.fixture.teams!.length} ${widget.fixture.tournament!.tournamentType == "solo" ? "Players" : "Teams"}"
                                        .toUpperCase()),
                          ],
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
                        horizontal: Get.width * 0.3,
                        vertical: Get.width * 0.0001),
                    width: Get.width * 0.9,
                    child: InkWell(
                      onTap: () => launchUrl(
                          Uri.parse(widget.fixture.livestreams![0].link!)),
                      child: widget.fixture.livestreams!.isEmpty
                        ? SizedBox(height: Get.height * 0.035, child: Center(child: CustomText(title: "No Livestream")))
                        : ColorFiltered(
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
              if (widget.event.community != null)
                Visibility(
                  visible: widget.event!.community!.owner!.id ==
                      authController.user!.id,
                  child: Positioned(
                      right: 0,
                      child:
                          menuAnchor(widget.fixture, widget.fixture.tournament!)),
                )
            ],
          ),
        ),
      ),
    );
    ;
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

//Fixture Card For Tournament Screen

class BRFixtureCardScrollable extends StatefulWidget {
  const BRFixtureCardScrollable(
      {super.key,
      required this.fixture,
      required this.backgroundColor,
      required this.getFixtures,
      required this.event});

  final LinearGradient backgroundColor;
  final FixtureModel fixture;
  final Function getFixtures;
  final EventModel event;

  @override
  State<BRFixtureCardScrollable> createState() =>
      _BRFixtureCardScrollableState();
}

class _BRFixtureCardScrollableState extends State<BRFixtureCardScrollable> {
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
                      dateHasPassed(widget.fixture.fixtureDate!) == false //&& widget.fixture.livestreams!.isNotEmpty
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
                widget.fixture.first != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            spacing: 8,
                            children: [
                              CustomText(
                                title: "2nd Place",
                              ),
                              OtherImage(
                                  width: 40,
                                  height: 40,
                                  image: widget.fixture.livestreams![0].banner != null
                                  ? "${ApiLink.imageUrl}${widget.fixture.livestreams![0].banner}"
                                  : widget.fixture.livestreams![0].banner),
                              CustomText(
                                  title: widget.event.tournamentType == "solo"
                                      ? widget
                                          .fixture.second!.player!.inGameName
                                      : widget.fixture.second!.team!.name)
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.12,
                            child: Column(
                              spacing: 8,
                              children: [
                                CustomText(
                                  color: AppColor().secondaryGreenColor,
                                  fontFamily: "InterMedium",
                                  title: "1st Place",
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColor().secondaryGreenColor,
                                        width: 5),
                                    borderRadius: BorderRadius.circular(500),
                                  ),
                                  child: OtherImage(
                                      width: 45,
                                      height: 45,
                                      image:
                                          widget.event.tournamentType == "solo"
                                              ? widget.fixture.first!.player!
                                                  .profile
                                              : widget.fixture.first!.team!
                                                  .profilePicture),
                                ),
                                CustomText(
                                    fontFamily: "InterMedium",
                                    color: AppColor().secondaryGreenColor,
                                    title: widget.event.tournamentType == "solo"
                                        ? widget
                                            .fixture.first!.player!.inGameName
                                        : widget.fixture.first!.team!.name)
                              ],
                            ),
                          ),
                          Column(
                            spacing: 8,
                            children: [
                              CustomText(
                                title: "3rd Place",
                                size: 13,
                              ),
                              OtherImage(
                                  width: 30,
                                  height: 30,
                                  image: widget.event.tournamentType == "solo"
                                      ? widget.fixture.third!.player!.profile
                                      : widget
                                          .fixture.third!.team!.profilePicture),
                              CustomText(
                                title: widget.event.tournamentType == "solo"
                                    ? widget.fixture.third!.player!.inGameName
                                    : widget.fixture.third!.team!.name,
                                size: 13,
                              ),
                            ],
                          )
                        ],
                      )
                    : SizedBox(
                        height: Get.height * 0.12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            GestureDetector(
                              onTap: () => Helpers().showImagePopup(
                                      context,"${ApiLink.imageUrl}${widget.fixture.livestreams![0].banner}"),
                              child: OtherImage(
                                  width: 50,
                                  height: 50,
                                  image: widget.fixture.livestreams![0].banner != null
                                    ? "${ApiLink.imageUrl}${widget.fixture.livestreams![0].banner}"
                                    : widget.fixture.livestreams![0].banner),
                            ),
                            CustomText(
                                fontFamily: "InterSemiBold",
                                size: 24,
                                color: AppColor().secondaryGreenColor,
                                title:
                                    "${widget.fixture.tournament!.tournamentType == "solo" ? widget.fixture.players!.length : widget.fixture.teams!.length} ${widget.fixture.tournament!.tournamentType == "solo" ? "Players" : "Teams"}"
                                        .toUpperCase())
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
                    onTap: () => launchUrl(
                        Uri.parse(widget.fixture.livestreams![0].link!)),
                    child: widget.fixture.livestreams!.isEmpty
                        ? SizedBox(height: Get.height * 0.035, child: Center(child: CustomText(title: "No Livestream")))
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
