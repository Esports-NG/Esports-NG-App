import 'package:e_sport/data/repository/event_repository.dart';
import 'package:e_sport/ui/auth/register.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'components/create_social_event.dart';
import 'components/create_tournament.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final eventController = Get.put(EventRepository());
  int eventTypeCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        elevation: 0,
        leading: GoBackButton(
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: CustomText(
          title: 'Create an Event',
          fontFamily: 'GilroySemiBold',
          size: 18,
          color: AppColor().primaryWhite,
        ),
        actions: [
          Center(
            child: Text.rich(TextSpan(
              text: '1',
              style: TextStyle(
                color: AppColor().primaryWhite,
                fontWeight: FontWeight.w600,
                fontFamily: 'GilroyBold',
                fontSize: Get.height * 0.017,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: eventTypeCount == 0 ? "/3" : "/2",
                  style: TextStyle(
                    color: AppColor().primaryWhite.withOpacity(0.5),
                  ),
                ),
              ],
            )),
          ),
          Gap(Get.height * 0.02),
        ],
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(Get.height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                title: 'Select your event type',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyBold',
                size: Get.height * 0.024,
              ),
              Gap(Get.height * 0.1),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  separatorBuilder: (context, index) => const Gap(20),
                  itemCount: eventTypeCard.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = eventTypeCard[index];
                    return CustomFillButtonOption(
                      onTap: () {
                        setState(() {
                          eventTypeCount = index;
                          item.isSelected = !item.isSelected!;
                          debugPrint('Type: ${item.title}');
                          eventController.eventTypeController.text =
                              item.title!;
                        });
                      },
                      height: Get.height * 0.06,
                      buttonText: item.title,
                      textColor: AppColor().primaryWhite,
                      buttonColor: eventTypeCount == index
                          ? AppColor().primaryGreen
                          : AppColor().primaryBackGroundColor,
                      boarderColor: eventTypeCount == index
                          ? AppColor().primaryGreen
                          : AppColor().primaryWhite,
                      borderRadius: BorderRadius.circular(30),
                      fontWeight: FontWeight.w400,
                    );
                  }),
              Gap(Get.height * 0.5),
              CustomFillButton(
                onTap: () {
                  if (eventTypeCount == 0) {
                    Get.to(() => const CreateTournamentEvent());
                  } else {
                    Get.to(() => const CreateSocialEvent());
                  }
                },
                buttonText: 'Next',
                fontWeight: FontWeight.w600,
                textSize: Get.height * 0.016,
                isLoading: false,
              ),
              Gap(Get.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
