import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/fixture_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/events/components/add_fixture.dart';
import 'package:e_sport/ui/events/components/br_fixture_card.dart';
import 'package:e_sport/ui/events/components/fixture_item.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FixturesAndResults extends StatefulWidget {
  const FixturesAndResults({super.key, required this.event});
  final EventModel event;

  @override
  State<FixturesAndResults> createState() => _FixturesAndResultsState();
}

class _FixturesAndResultsState extends State<FixturesAndResults> {
  final tournamentController = Get.put(TournamentRepository());
  final authController = Get.put(AuthRepository());
  var eventController = Get.put(EventRepository());
  List<FixtureModel> _fixturesList = [];
  bool _isLoading = true;

  Future getFixtures() async {
    setState(() {
      _isLoading = true;
    });
    var fixturesList = await tournamentController.getFixtures(widget.event.id!);
    setState(() {
      _fixturesList = fixturesList;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getFixtures();
    super.initState();
  }

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
              ],
            ),
          )
        ]),
        leading: GoBackButton(
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton:
          authController.user!.id == widget.event.community!.owner!.id
              ? FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: AppColor().primaryColor,
                  onPressed: () {
                    Get.to(() => AddFixture(event: widget.event))!
                        .whenComplete(() async {
                      await getFixtures();
                    });
                  },
                  child: Icon(
                    Icons.add,
                    color: AppColor().primaryWhite,
                  ),
                )
              : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
            children: [
              Gap(Get.height * 0.01),
              CustomText(
                  title: 'Tournament/Bracket Link: ',
                  size: Get.height * 0.017,
                  fontFamily: 'InterMedium',
                  underline: TextDecoration.underline,
                  color: AppColor().primaryWhite),
              Gap(Get.height * 0.01),
              GestureDetector(
                onTap: () => launchUrl(Uri.parse(widget.event.linkForBracket!)),
                child: CustomText(
                  title: widget.event.linkForBracket,
                  size: Get.height * 0.017,
                  fontFamily: 'InterMedium',
                  underline: TextDecoration.underline,
                  color: AppColor().primaryColor,
                  textAlign: TextAlign.center,
                ),
              ),
              Gap(Get.height * 0.01),
              Divider(
                height: 30,
                thickness: 1,
                color: AppColor().lightItemsColor.withOpacity(0.3),
              ),
              Gap(Get.height * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: 'Fixtures and Results:',
                    size: Get.height * 0.017,
                    fontFamily: 'InterMedium',
                    color: AppColor().primaryWhite,
                  ),
                  Gap(Get.height * 0.02),
                  _isLoading
                      ? Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: const Center(child: ButtonLoader()))
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => GestureDetector(
                              onTap: () {},
                              child: _fixturesList[index].fixtureType == "BR"
                                  ? BrFixtureCard(
                                      event: widget.event,
                                      getFixtures: getFixtures,
                                      fixture: _fixturesList[index],
                                      backgroundColor:
                                          _colors[index % _colors.length])
                                  : FixtureCardTournament(
                                      event: widget.event,
                                      getFixtures: getFixtures,
                                      fixture: _fixturesList[index],
                                      backgroundColor:
                                          _colors[index % _colors.length])),
                          separatorBuilder: (context, index) =>
                              Gap(Get.height * 0.02),
                          itemCount: _fixturesList.length),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
