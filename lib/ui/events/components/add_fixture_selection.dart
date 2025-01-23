import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/ui/auth/register.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_widgets.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CreateFixtureSelection extends StatefulWidget {
  const CreateFixtureSelection({
    super.key,
  });

  @override
  State<CreateFixtureSelection> createState() => _CreateFixtureSelectionState();
}

class _CreateFixtureSelectionState extends State<CreateFixtureSelection> {
  final eventController = Get.put(EventRepository());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          title: 'Select your fixture type',
          color: AppColor().primaryWhite,
          textAlign: TextAlign.center,
          fontFamily: 'InterBold',
          size: Get.height * 0.024,
        ),
        Gap(Get.height * 0.05),
        ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            separatorBuilder: (context, index) => const Gap(20),
            itemCount: fixtureTypeCard.length,
            itemBuilder: (BuildContext context, int index) {
              var item = fixtureTypeCard[index];
              return CustomFillButtonOption(
                onTap: () {
                  eventController.changeFixtureType(index: index, item: item);
                  setState(() {
                    item.isSelected = !item.isSelected!;
                  });
                },
                height: Get.height * 0.06,
                buttonText: item.title,
                textColor: AppColor().primaryWhite,
                buttonColor: eventController.fixtureTypeCount.value == index
                    ? AppColor().primaryGreen
                    : AppColor().primaryBackGroundColor,
                boarderColor: eventController.fixtureTypeCount.value == index
                    ? AppColor().primaryGreen
                    : AppColor().primaryWhite,
                borderRadius: BorderRadius.circular(30),
              );
            }),
        Gap(Get.height * 0.02),
      ],
    );
  }
}
