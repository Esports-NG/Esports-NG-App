import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/screens/event/creation/single/1v1_fixture.dart';
import 'package:e_sport/ui/screens/event/creation/team/1v1_fixture_team.dart';
import 'package:e_sport/ui/widgets/events/tournament/add_fixture_selection.dart';
import 'package:e_sport/ui/screens/event/creation/br_fixture.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFixture extends StatefulWidget {
  const AddFixture({super.key, required this.event});
  final EventModel event;

  @override
  State<AddFixture> createState() => _AddFixtureState();
}

class _AddFixtureState extends State<AddFixture> {
  late PageController _pageViewController;
  final eventController = Get.put(EventRepository());
  final tournamentController = Get.put(TournamentRepository());

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    close();
    _pageViewController.dispose();
  }

  void close() {
    tournamentController.clearFixturesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape:
            Border(bottom: BorderSide(color: AppColor().primaryDark, width: 1)),
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        leading: GoBackButton(
          onPressed: () {
            if (_currentPageIndex == 0) {
              Get.back();
            } else {
              _pageViewController.animateToPage(
                _currentPageIndex - 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear,
              );
            }
          },
        ),
        title: CustomText(
          title:
              "Add New ${_currentPageIndex == 0 ? "" : eventController.fixtureTypeCount.value == 0 ? "1V1" : "Leaderboard/BR"} Fixture",
          color: AppColor().primaryWhite,
          size: 20,
          fontFamily: "InterSemibold",
        ),
      ),
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageViewController,
            onPageChanged: (value) {
              setState(() {
                _currentPageIndex = value;
              });
            },
            children: [
              Padding(
                padding: EdgeInsets.all(Get.height * 0.02),
                child: Column(
                  children: [
                    Expanded(child: CreateFixtureSelection()),
                    CustomFillButton(
                      buttonText: "Next",
                      onTap: () {
                        _pageViewController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.linear,
                        );
                      },
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                  child: eventController.fixtureTypeCount.value == 0
                      ? widget.event.tournamentType == "team"
                          ? AddOneVOneFixtureTeam(event: widget.event)
                          : AddOneVOneFixture(event: widget.event)
                      : AddBRFixture(event: widget.event))
            ],
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: _currentPageIndex == 0
                ? Get.width * 1 / 2
                : _currentPageIndex == 1
                    ? Get.width * 2 / 2
                    : Get.width * 1,
            height: 2,
            decoration: BoxDecoration(color: AppColor().primaryColor),
          )
        ],
      ),
    );
  }
}
