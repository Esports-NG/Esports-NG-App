import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddFixture extends StatefulWidget {
  const AddFixture({super.key, required this.event});
  final EventModel event;

  @override
  State<AddFixture> createState() => _AddFixtureState();
}

class _AddFixtureState extends State<AddFixture> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final tournamentController = Get.put(TournamentRepository());

  bool _beenPlayed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape:
            Border(bottom: BorderSide(color: AppColor().primaryDark, width: 1)),
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        leading: GoBackButton(
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          title: "Add New Fixture ",
          color: AppColor().primaryWhite,
          size: 20,
          fontFamily: "GilroySemibold",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(Get.height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "Select Home Player",
                  color: AppColor().primaryWhite,
                  size: 16,
                ),
                Gap(Get.height * 0.01),
                InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: tournamentController.isCommunities.value == true
                        ? AppColor().primaryWhite
                        : AppColor().primaryDark,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().lightItemsColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<PlayerModel>(
                      dropdownColor: AppColor().primaryDark,
                      borderRadius: BorderRadius.circular(10),
                      value: tournamentController.selectedHomePlayer.value,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: tournamentController.isCommunities.value == true
                            ? AppColor().primaryBackGroundColor
                            : AppColor().lightItemsColor,
                      ),
                      items: widget.event.players!.map((value) {
                        return DropdownMenuItem<PlayerModel>(
                          value: value,
                          child: CustomText(
                            title: value.inGameName,
                            color: AppColor().lightItemsColor,
                            fontFamily: 'GilroyMedium',
                            weight: FontWeight.w400,
                            size: 15,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        tournamentController.selectedHomePlayer.value = value;
                      },
                      hint: CustomText(
                        title: "Home Player",
                        color: tournamentController.isCommunities.value == true
                            ? AppColor().primaryBackGroundColor
                            : AppColor().lightItemsColor,
                        fontFamily: 'GilroyMedium',
                        weight: FontWeight.w400,
                        size: 15,
                      ),
                    ),
                  ),
                ),
                CustomText(
                  title: "Select Away Player",
                  color: AppColor().primaryWhite,
                  size: 16,
                ),
                Gap(Get.height * 0.01),
                CustomText(
                  title: "Fixture round name",
                  color: AppColor().primaryWhite,
                  size: 16,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  textEditingController:
                      tournamentController.addFixtureRoundNameController,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: "Fixture date",
                  color: AppColor().primaryWhite,
                  size: 16,
                ),
                Gap(Get.height * 0.01),
                CustomText(
                  title: "Streaming Platform",
                  color: AppColor().primaryWhite,
                  size: 16,
                ),
                Gap(Get.height * 0.01),
                CustomText(
                  title: "Streaming Platform link",
                  color: AppColor().primaryWhite,
                  size: 16,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  textEditingController:
                      tournamentController.addFixtureStreamingLinkController,
                  prefixIcon: IntrinsicWidth(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: CustomText(
                          title: "https://",
                          color: AppColor().greyFour,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: "Has the fixture been played?",
                  color: AppColor().primaryWhite,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
