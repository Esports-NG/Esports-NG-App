import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/fixture_model.dart';
import 'package:e_sport/ui/widgets/events/tournament/br_fixture_card.dart';
import 'package:e_sport/ui/widgets/events/tournament/fixture_item.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TournamentFixturesSection extends StatelessWidget {
  final List<FixtureModel> fixturesList;
  final bool isFetchingFixtures;
  final EventModel event;
  final Function getFixtures;
  final List<LinearGradient> backgroundColors;

  const TournamentFixturesSection({
    Key? key,
    required this.fixturesList,
    required this.isFetchingFixtures,
    required this.event,
    required this.getFixtures,
    required this.backgroundColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height:
          isFetchingFixtures || fixturesList.isEmpty ? 50 : Get.height * 0.285,
      child: isFetchingFixtures
          ? const Center(child: ButtonLoader())
          : fixturesList.isEmpty
              ? Center(
                  child: CustomText(
                    title: "No fixtures",
                    size: 16,
                    fontFamily: "InterMedium",
                    color: AppColor().lightItemsColor,
                  ),
                )
              : ListView.separated(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => Gap(Get.height * 0.02),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {},
                    child: fixturesList[index].fixtureType == "BR"
                        ? BRFixtureCardScrollable(
                            event: event,
                            getFixtures: getFixtures,
                            fixture: fixturesList[index],
                            backgroundColor: backgroundColors[
                                index % backgroundColors.length],
                          )
                        : FixtureCardScrollable(
                            fixture: fixturesList[index],
                            backgroundColor: backgroundColors[
                                index % backgroundColors.length],
                          ),
                  ),
                  itemCount: fixturesList.take(10).length,
                ),
    );
  }
}
