import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/account/account_events/components/create_event_selection.dart';
import 'package:e_sport/ui/account/account_events/components/create_social_event.dart';
import 'package:e_sport/ui/account/account_events/components/create_tournament_form.dart';
import 'package:e_sport/ui/account/account_events/components/create_tournament_next.dart';
// import 'package:e_sport/ui/auth/register.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent>
    with TickerProviderStateMixin {
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
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Text.rich(TextSpan(
                text: '${_currentPageIndex + 1}',
                style: TextStyle(
                  color: AppColor().primaryWhite,
                  fontFamily: "InterSemiBold",
                  fontSize: Get.height * 0.017,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "/${eventController.maxTabs.value}",
                    style: TextStyle(
                      color: AppColor().primaryWhite.withOpacity(0.5),
                    ),
                  ),
                ],
              )),
            )
          ],
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
                "Create ${eventController.eventTypeController.text != "" ? eventController.eventTypeController.text : "Event"}",
            size: 18,
            fontFamily: "InterSemiBold",
            color: AppColor().primaryWhite,
          ),
          centerTitle: true,
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
                      const Expanded(child: CreateEventSelection()),
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
                    child: Padding(
                  padding: EdgeInsets.all(Get.height * 0.02),
                  child: Column(
                    children: [
                      eventController.eventTypeCount.value == 0
                          ? const CreateTournamentForm()
                          : const CreateSocialEvent(),
                      Gap(eventController.eventTypeCount.value == 0
                          ? Get.height * 0.04
                          : 0),
                      Visibility(
                        visible: eventController.eventTypeCount.value == 0,
                        child: GestureDetector(
                          onTap: () {
                            _pageViewController.animateToPage(
                              _currentPageIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.linear,
                            );
                          },
                          child: Container(
                            height: Get.height * 0.07,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppColor().primaryColor,
                            ),
                            child: Center(
                                child: CustomText(
                              title: 'Next',
                              color: AppColor().primaryWhite,
                              fontFamily: "InterSemiBold",
                              size: Get.height * 0.018,
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
                SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.all(Get.height * 0.02),
                  child: Column(
                    children: [
                      const CreateTournamentNext(),
                      Gap(Get.height * 0.02),
                      Obx(() {
                        return GestureDetector(
                          onTap: () async {
                            await tournamentController.createTournament();
                          },
                          child: Container(
                            height: Get.height * 0.07,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: eventController.createEventStatus.value ==
                                      CreateEventStatus.loading
                                  ? null
                                  : AppColor().primaryColor,
                            ),
                            child: Center(
                                child:
                                    eventController.createEventStatus.value ==
                                            CreateEventStatus.loading
                                        ? const ButtonLoader()
                                        : CustomText(
                                            title: 'Submit',
                                            color: AppColor().primaryWhite,
                                            fontFamily: "InterSemiBold",
                                            size: Get.height * 0.018,
                                          )),
                          ),
                        );
                      }),
                      Gap(Get.height * 0.02),
                    ],
                  ),
                )),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: _currentPageIndex == 0
                  ? Get.width * 1 / eventController.maxTabs.value
                  : _currentPageIndex == 1
                      ? Get.width * 2 / eventController.maxTabs.value
                      : Get.width * 1,
              height: 2,
              decoration: BoxDecoration(color: AppColor().primaryColor),
            )
          ],
        ),
      ),
    );
  }
}
