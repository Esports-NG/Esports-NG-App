import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/auth/register.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CreateEventSelection extends StatefulWidget {
  const CreateEventSelection({
    super.key,
  });

  @override
  State<CreateEventSelection> createState() => _CreateEventSelectionState();
}

class _CreateEventSelectionState extends State<CreateEventSelection> {
  final eventController = Get.put(EventRepository());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          title: 'Select your event type',
          color: AppColor().primaryWhite,
          textAlign: TextAlign.center,
          fontFamily: 'GilroyBold',
          size: Get.height * 0.024,
        ),
        Gap(Get.height * 0.05),
        ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            separatorBuilder: (context, index) => const Gap(20),
            itemCount: eventTypeCard.length,
            itemBuilder: (BuildContext context, int index) {
              var item = eventTypeCard[index];
              return CustomFillButtonOption(
                onTap: () {
                  eventController.changeEventType(index: index, item: item);
                  setState(() {
                    item.isSelected = !item.isSelected!;
                  });
                },
                height: Get.height * 0.06,
                buttonText: item.title,
                textColor: AppColor().primaryWhite,
                buttonColor: eventController.eventTypeCount.value == index
                    ? AppColor().primaryGreen
                    : AppColor().primaryBackGroundColor,
                boarderColor: eventController.eventTypeCount.value == index
                    ? AppColor().primaryGreen
                    : AppColor().primaryWhite,
                borderRadius: BorderRadius.circular(30),
                fontWeight: FontWeight.w400,
              );
            }),
        // Gap(pageCount == 0 ? Get.height * 0.5 : Get.height * 0.02),
        // CustomFillButton(
        //   onTap: () {
        //     if (widget.eventTypeCount == 0) {
        //       Get.to(() => const CreateTournamentView());
        //     } else {
        //       // Get.to(() => const CreateSocialEvent());
        //     }
        //   },
        //   buttonText: 'Next',
        //   fontWeight: FontWeight.w600,
        //   textSize: Get.height * 0.016,
        //   isLoading: false,
        // ),
        Gap(Get.height * 0.02),
      ],
    );
  }
}
