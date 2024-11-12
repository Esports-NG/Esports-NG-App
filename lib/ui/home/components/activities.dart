import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/events/components/fixture_item.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  var tournamentController = Get.put(TournamentRepository());
  bool _isLoading = false;

  final _colors = [
    LinearGradient(
      colors: [
        AppColor().fixturePurple,
        AppColor().fixturePurple,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    LinearGradient(
      colors: [
        AppColor().darkGrey.withOpacity(0.8),
        AppColor().bgDark.withOpacity(0.005),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomCenter,
    ),
  ];

  void fetchFixtures() async {
    setState(() {
      _isLoading = true;
    });
    await tournamentController.getAllFixture();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    fetchFixtures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: ButtonLoader())
        : tournamentController.allFixtures.isEmpty
            ? Center(
                child: CustomText(
                title: "No fixtures",
                color: AppColor().primaryWhite,
              ))
            : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  var item = tournamentController.allFixtures[index];
                  return FixtureCard(
                      backgroundColor: _colors[index % _colors.length],
                      fixture: item);
                },
                separatorBuilder: (ctx, index) => Gap(20),
                itemCount: tournamentController.allFixtures.length);
  }
}
