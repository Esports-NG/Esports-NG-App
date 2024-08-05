import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';


//Fixture Card For Home Screen

class FixtureCard extends StatefulWidget {
  const FixtureCard({super.key, required this.backgroundColor});

  final LinearGradient backgroundColor;

  @override
  State<FixtureCard> createState() => _FixtureCardState();
}

class _FixtureCardState extends State<FixtureCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.9,
      decoration: BoxDecoration(
        gradient: widget.backgroundColor,
        image: DecorationImage(
          image: const AssetImage('assets/images/png/Fixture-zigzag.png'),
          alignment: Alignment(Get.width * -0.015, 0)
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().lightItemsColor,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Get.height * 0.02, Get.height * 0.02, Get.height * 0.02, Get.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: 'TOURNAMENT NAME',
              color: AppColor().primaryWhite,
              fontFamily: 'GilroyRegular',
              textAlign: TextAlign.start,
              size: 14,
            ),
            CustomText(
              title: 'GAME NAME - GAME MODE(S)',
              color: AppColor().primaryWhite,
              fontFamily: 'GilroySemiBold',
              textAlign: TextAlign.start,
              size: 14,
            ),
            Gap(Get.height * 0.01),
            SizedBox(
              width: Get.width * 0.9,
              child: CustomText(
                title: 'ROUND NAME',
                color: AppColor().primaryWhite,
                fontFamily: 'GilroyRegular',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
            Gap(Get.height * 0.0015),
            SizedBox(
              width: Get.width * 0.9,
              child: CustomText(
                title: '25th, Dec 2023',
                color: AppColor().primaryWhite,
                fontFamily: 'GilroySemiBold',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: Get.width * 0.15,
                        height: Get.width * 0.15,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/png/tournament_cover.png')),
                          borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.15)),
                          color: Colors.redAccent,
                          border: Border.all(width: 2, color: AppColor().lightItemsColor),
                        ),
                      ),
                      Gap(Get.height * 0.005),
                      SizedBox(
                        width: Get.width * 0.18,
                        child: CustomText(
                          title: 'Name of home team',
                          color: AppColor().primaryWhite,
                          fontFamily: 'GilroyMedium',
                          textAlign: TextAlign.center,
                          size: 13,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CustomText(
                        title: 'VS',
                        color: AppColor().secondaryGreenColor,
                        fontFamily: 'GilroyMedium',
                        textAlign: TextAlign.center,
                        size: 20,
                      ),
                      Gap(Get.height * 0.005),
                      CustomText(
                        title: '08:00',
                        color: AppColor().primaryWhite,
                        fontFamily: 'GilroyMedium',
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
                        width: Get.width * 0.15,
                        height: Get.width * 0.15,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/png/tournament_cover.png')),
                          borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.15)),
                          color: Colors.redAccent,
                          border: Border.all(width: 2, color: AppColor().lightItemsColor),
                        ),
                      ),
                      Gap(Get.height * 0.005),
                      SizedBox(
                        width: Get.width * 0.17,
                        child: CustomText(
                          title: 'Name of away team',
                          color: AppColor().primaryWhite,
                          fontFamily: 'GilroyMedium',
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
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.3),
              width: Get.width * 0.9,
              child: Image.asset(
                'assets/images/png/twitch_logo.png',
                width: Get.width * 0.25,
                alignment: Alignment.center,
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
  const FixtureCardScrollable({super.key, required this.backgroundColor});

  final LinearGradient backgroundColor;

  @override
  State<FixtureCardScrollable> createState() => _FixtureCardScrollableState();
}

class _FixtureCardScrollableState extends State<FixtureCardScrollable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.6,
      decoration: BoxDecoration(
        gradient: widget.backgroundColor,
        image: DecorationImage(
          image: const AssetImage('assets/images/png/Fixture-zigzag.png'),
          alignment: Alignment(Get.height * 0.004, 0),
          fit: BoxFit.fitHeight
        ),
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
                title: 'ROUND NAME',
                color: AppColor().primaryWhite,
                fontFamily: 'GilroyRegular',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
            Gap(Get.height * 0.0015),
            SizedBox(
              width: Get.width * 0.9,
              child: CustomText(
                title: '25th, Dec 2023',
                color: AppColor().primaryWhite,
                fontFamily: 'GilroySemiBold',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.height * 0.02,
                vertical: Get.height * 0.01,
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
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/png/tournament_cover.png')),
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
                          title: 'Name of home team',
                          color: AppColor().primaryWhite,
                          fontFamily: 'GilroyMedium',
                          textAlign: TextAlign.center,
                          size: 13,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CustomText(
                        title: 'VS',
                        color: AppColor().secondaryGreenColor,
                        fontFamily: 'GilroyMedium',
                        textAlign: TextAlign.center,
                        size: 20,
                      ),
                      Gap(Get.height * 0.005),
                      CustomText(
                        title: '08:00',
                        color: AppColor().primaryWhite,
                        fontFamily: 'GilroyMedium',
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
                        width: Get.width * 0.15,
                        height: Get.width * 0.15,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/png/tournament_cover.png')),
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
                          title: 'Name of away team',
                          color: AppColor().primaryWhite,
                          fontFamily: 'GilroyMedium',
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
              child: Image.asset(
                'assets/images/png/twitch_logo.png',
                width: Get.width * 0.25,
                alignment: Alignment.center,
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
  const FixtureCardTournament({super.key, required this.backgroundColor});

  final LinearGradient backgroundColor;

  @override
  State<FixtureCardTournament> createState() => _FixtureCardTournamentState();
}

class _FixtureCardTournamentState extends State<FixtureCardTournament> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.9,
      decoration: BoxDecoration(
        gradient: widget.backgroundColor,
        image: DecorationImage(
          image: const AssetImage('assets/images/png/Fixture-zigzag.png'),
          alignment: Alignment(Get.width * -0.0025, 0)
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColor().lightItemsColor,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Get.height * 0.02, Get.height * 0.02, Get.height * 0.02, Get.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width * 0.9,
              child: CustomText(
                title: 'ROUND NAME',
                color: AppColor().primaryWhite,
                fontFamily: 'GilroyRegular',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
            Gap(Get.height * 0.0015),
            SizedBox(
              width: Get.width * 0.9,
              child: CustomText(
                title: '25th, Dec 2023',
                color: AppColor().primaryWhite,
                fontFamily: 'GilroySemiBold',
                textAlign: TextAlign.center,
                size: 14,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: Get.width * 0.15,
                        height: Get.width * 0.15,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/png/tournament_cover.png')),
                          borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.15)),
                          color: Colors.redAccent,
                          border: Border.all(width: 2, color: AppColor().lightItemsColor),
                        ),
                      ),
                      Gap(Get.height * 0.005),
                      SizedBox(
                        width: Get.width * 0.18,
                        child: CustomText(
                          title: 'Name of home team',
                          color: AppColor().primaryWhite,
                          fontFamily: 'GilroyMedium',
                          textAlign: TextAlign.center,
                          size: 13,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      CustomText(
                        title: 'VS',
                        color: AppColor().secondaryGreenColor,
                        fontFamily: 'GilroyMedium',
                        textAlign: TextAlign.center,
                        size: 20,
                      ),
                      Gap(Get.height * 0.005),
                      CustomText(
                        title: '08:00',
                        color: AppColor().primaryWhite,
                        fontFamily: 'GilroyMedium',
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
                        width: Get.width * 0.15,
                        height: Get.width * 0.15,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/png/tournament_cover.png')),
                          borderRadius: BorderRadius.all(Radius.circular(Get.width * 0.15)),
                          color: Colors.redAccent,
                          border: Border.all(width: 2, color: AppColor().lightItemsColor),
                        ),
                      ),
                      Gap(Get.height * 0.005),
                      SizedBox(
                        width: Get.width * 0.17,
                        child: CustomText(
                          title: 'Name of away team',
                          color: AppColor().primaryWhite,
                          fontFamily: 'GilroyMedium',
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
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.3),
              width: Get.width * 0.9,
              child: Image.asset(
                'assets/images/png/twitch_logo.png',
                width: Get.width * 0.25,
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}