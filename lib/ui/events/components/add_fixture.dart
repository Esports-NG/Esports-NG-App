import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/platform_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widget/back_button.dart';
import 'package:e_sport/ui/widget/buttonLoader.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/ui/widget/custom_textfield.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddFixture extends StatefulWidget {
  const AddFixture({super.key, required this.event});
  final EventModel event;

  @override
  State<AddFixture> createState() => _AddFixtureState();
}

class _AddFixtureState extends State<AddFixture> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final tournamentController = Get.put(TournamentRepository());
  final authController = Get.put(AuthRepository());

  bool _hasBeenPlayed = false;
  bool _isLoading = false;
  List<PlatformModel> _platforms = [];

  Future<void> getPlatforms() async {
    var response = await http.get(Uri.parse(ApiLink.getPlatforms),
        headers: {"Authorization": "JWT ${authController.token}"});

    print(response.body);

    setState(() {
      _platforms = platformModelFromJson(response.body);
    });
  }

  void close() {
    tournamentController.clearFixturesData();
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }

  @override
  void initState() {
    getPlatforms();
    super.initState();
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
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          title: "Add New Fixture ",
          color: AppColor().primaryWhite,
          size: 20,
          fontFamily: "GilroySemibold",
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
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
                      fillColor:
                          tournamentController.isCommunities.value == true
                              ? AppColor().primaryWhite
                              : AppColor().primaryDark,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().lightItemsColor, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<PlayerModel>(
                        dropdownColor: AppColor().primaryDark,
                        borderRadius: BorderRadius.circular(10),
                        value: tournamentController.selectedHomePlayer.value,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color:
                              tournamentController.isCommunities.value == true
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
                          color:
                              tournamentController.isCommunities.value == true
                                  ? AppColor().primaryBackGroundColor
                                  : AppColor().lightItemsColor,
                          fontFamily: 'GilroyMedium',
                          weight: FontWeight.w400,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  CustomText(
                    title: "Select Away Player",
                    color: AppColor().primaryWhite,
                    size: 16,
                  ),
                  Gap(Get.height * 0.01),
                  InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor().primaryDark,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().lightItemsColor, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<PlayerModel>(
                        dropdownColor: AppColor().primaryDark,
                        borderRadius: BorderRadius.circular(10),
                        value: tournamentController.selectedAwayPlayer.value,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color:
                              tournamentController.isCommunities.value == true
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
                          tournamentController.selectedAwayPlayer.value = value;
                        },
                        hint: CustomText(
                          title: "Away Player",
                          color: AppColor().lightItemsColor,
                          fontFamily: 'GilroyMedium',
                          weight: FontWeight.w400,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  CustomText(
                    title: "Fixture Name",
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
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () async {
                          final initialDate = DateTime.now();
                          var date = await showDatePicker(
                            context: context,
                            initialDate:
                                tournamentController.fixtureDate.value ??
                                    initialDate,
                            firstDate: DateTime(DateTime.now().year - 40),
                            lastDate: DateTime(DateTime.now().year + 5),
                          );
                          tournamentController.fixtureDate.value = date;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: AppColor().primaryDark,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: AppColor().lightItemsColor,
                                size: 24,
                              ),
                              const Gap(10),
                              tournamentController.fixtureDate.value != null
                                  ? CustomText(
                                      title: DateFormat.yMMMd().format(
                                          tournamentController
                                              .fixtureDate.value!),
                                      color: AppColor().lightItemsColor,
                                      size: 16,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )
                                  : CustomText(
                                      title: "Select Date",
                                      color: AppColor().lightItemsColor,
                                      size: 16,
                                    )
                            ],
                          ),
                        ),
                      )),
                      const Gap(10),
                      Expanded(
                          child: GestureDetector(
                        onTap: () async {
                          final initialTime = TimeOfDay.now();
                          var time = await showTimePicker(
                              context: context,
                              initialTime:
                                  tournamentController.fixtureTime.value ??
                                      initialTime);
                          tournamentController.fixtureTime.value = time;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: AppColor().primaryDark,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                color: AppColor().lightItemsColor,
                                size: 24,
                              ),
                              const Gap(10),
                              tournamentController.fixtureTime.value != null
                                  ? CustomText(
                                      title:
                                          "${tournamentController.fixtureTime.value!.hour}:${tournamentController.fixtureTime.value!.minute}",
                                      color: AppColor().lightItemsColor,
                                      size: 16,
                                    )
                                  : CustomText(
                                      title: "Select Time",
                                      color: AppColor().lightItemsColor,
                                      size: 16,
                                    )
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                  Gap(Get.height * 0.02),
                  CustomText(
                    title: "Streaming Platform",
                    color: AppColor().primaryWhite,
                    size: 16,
                  ),
                  Gap(Get.height * 0.01),
                  InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor().primaryDark,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().lightItemsColor, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<PlatformModel>(
                        dropdownColor: AppColor().primaryDark,
                        borderRadius: BorderRadius.circular(10),
                        value: tournamentController.fixturePlatform.value,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor().lightItemsColor,
                        ),
                        items: _platforms.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Row(
                              children: [
                                Image.network(
                                  "${ApiLink.imageUrl}${value.logo}",
                                  height: 35,
                                  fit: BoxFit.contain,
                                ),
                                const Gap(10),
                                CustomText(
                                  title: value.title,
                                  color: AppColor().lightItemsColor,
                                  fontFamily: 'GilroyMedium',
                                  weight: FontWeight.w400,
                                  size: 18,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          tournamentController.fixturePlatform.value = value;
                          print(value);
                        },
                        hint: CustomText(
                          title: "Select Platform",
                          color: AppColor().lightItemsColor,
                          fontFamily: 'GilroyMedium',
                          weight: FontWeight.w400,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
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
                  ),
                  Row(
                    children: [
                      Row(children: [
                        CustomText(
                            title: "Yes", color: AppColor().primaryWhite),
                        Radio<bool>(
                          value: true,
                          activeColor: AppColor().primaryColor,
                          groupValue: _hasBeenPlayed,
                          onChanged: (value) {
                            setState(() {
                              _hasBeenPlayed = true;
                            });
                          },
                        )
                      ]),
                      Row(children: [
                        CustomText(title: "No", color: AppColor().primaryWhite),
                        Radio<bool>(
                          value: false,
                          activeColor: AppColor().primaryColor,
                          groupValue: _hasBeenPlayed,
                          onChanged: (value) {
                            setState(() {
                              _hasBeenPlayed = false;
                            });
                          },
                        )
                      ])
                    ],
                  ),
                  Gap(Get.height * 0.02),
                  Visibility(
                    visible: _hasBeenPlayed,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: "Home Player Score",
                            color: AppColor().primaryWhite,
                            size: 16,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            textEditingController: tournamentController
                                .addFixturesHomePlayerScoreController,
                          ),
                          Gap(Get.height * 0.02),
                          CustomText(
                            title: "Away Player Score",
                            color: AppColor().primaryWhite,
                            size: 16,
                          ),
                          Gap(Get.height * 0.01),
                          CustomTextField(
                            textEditingController: tournamentController
                                .addFixturesAwayPlayerScoreController,
                          ),
                        ]),
                  ),
                  Gap(Get.height * 0.02),
                  GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await tournamentController
                            .createFixtureForPlayer(widget.event.id!);
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                              color: _isLoading
                                  ? Colors.transparent
                                  : AppColor().primaryColor,
                              borderRadius: BorderRadius.circular(90)),
                          child: _isLoading
                              ? const Center(child: ButtonLoader())
                              : Center(
                                  child: CustomText(
                                      title: "Add Fixture",
                                      size: 16,
                                      fontFamily: "GilroySemiBold",
                                      color: AppColor().primaryWhite))))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
