import 'dart:io';

import 'package:e_sport/data/model/events_model.dart';
import 'package:e_sport/data/model/platform_model.dart';
import 'package:e_sport/data/model/team/team_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddOneVOneFixtureTeam extends StatefulWidget {
  const AddOneVOneFixtureTeam({super.key, required this.event});
  final EventModel event;

  @override
  State<AddOneVOneFixtureTeam> createState() => _AddOneVOneFixtureTeamState();
}

class _AddOneVOneFixtureTeamState extends State<AddOneVOneFixtureTeam> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final tournamentController = Get.put(TournamentRepository());
  final authController = Get.put(AuthRepository());

  bool _hasBeenPlayed = false;
  bool _hasLivestream = false;
  bool _isLoading = false;
  List<PlatformModel> _platforms = [];
  File? imageFile;

  Future<void> getPlatforms() async {
    var response = await http.get(Uri.parse(ApiLink.getPlatforms),
        headers: {"Authorization": "JWT ${authController.token}"});

    print(response.body);

    setState(() {
      _platforms = platformModelFromJson(response.body);
    });
  }

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  void clearPhoto() {
    setState(() {
      imageFile = null;
    });
  }

  @override
  void initState() {
    getPlatforms();
    super.initState();
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
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: "Select Home Team",
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
                  child: DropdownButton<TeamModel>(
                    dropdownColor: AppColor().primaryDark,
                    borderRadius: BorderRadius.circular(10),
                    value: tournamentController.selectedHomeTeam.value,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: tournamentController.isCommunities.value == true
                          ? AppColor().primaryBackGroundColor
                          : AppColor().lightItemsColor,
                    ),
                    items: widget.event.teams!.map((value) {
                      return DropdownMenuItem<TeamModel>(
                        value: value,
                        child: CustomText(
                          title: value.name,
                          color: AppColor().lightItemsColor,
                          fontFamily: 'InterMedium',
                          size: 15,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      tournamentController.selectedHomeTeam.value = value;
                    },
                    hint: CustomText(
                      title: "Home Team",
                      color: tournamentController.isCommunities.value == true
                          ? AppColor().primaryBackGroundColor
                          : AppColor().lightItemsColor,
                      fontFamily: 'InterMedium',
                      size: 15,
                    ),
                  ),
                ),
              ),
              const Gap(20),
              CustomText(
                title: "Select Away Team",
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TeamModel>(
                    dropdownColor: AppColor().primaryDark,
                    borderRadius: BorderRadius.circular(10),
                    value: tournamentController.selectedAwayTeam.value,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: tournamentController.isCommunities.value == true
                          ? AppColor().primaryBackGroundColor
                          : AppColor().lightItemsColor,
                    ),
                    items: widget.event.teams!.map((value) {
                      return DropdownMenuItem<TeamModel>(
                        value: value,
                        child: CustomText(
                          title: value.name,
                          color: AppColor().lightItemsColor,
                          fontFamily: 'InterMedium',
                          size: 15,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      tournamentController.selectedAwayTeam.value = value;
                    },
                    hint: CustomText(
                      title: "Away Team",
                      color: AppColor().lightItemsColor,
                      fontFamily: 'InterMedium',
                      size: 15,
                    ),
                  ),
                ),
              ),
              const Gap(20),
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
              Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      final initialDate = DateTime.now();
                      var date = await showDatePicker(
                        context: context,
                        initialDate: tournamentController.fixtureDate.value ??
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
                                      tournamentController.fixtureDate.value!),
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
                          initialTime: tournamentController.fixtureTime.value ??
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
                title: "Fixture banner",
                color: AppColor().primaryWhite,
                size: 16,
              ),
              Gap(Get.height * 0.01),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(Get.height * 0.04),
                decoration: BoxDecoration(
                    color: AppColor().bgDark,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    imageFile == null
                        ? SvgPicture.asset(
                            'assets/images/svg/photo.svg',
                            height: Get.height * 0.08,
                          )
                        : Container(
                            height: Get.height * 0.08,
                            width: Get.height * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: FileImage(imageFile!),
                                  fit: BoxFit.cover),
                            ),
                          ),
                    Gap(Get.height * 0.01),
                    InkWell(
                      onTap: () {
                        if (imageFile == null) {
                          debugPrint('pick image');
                          Get.defaultDialog(
                            title: "Select your image",
                            backgroundColor: AppColor().primaryLightColor,
                            titlePadding: const EdgeInsets.only(top: 30),
                            contentPadding: const EdgeInsets.only(
                                top: 5, bottom: 30, left: 25, right: 25),
                            middleText: "Upload your profile picture",
                            titleStyle: TextStyle(
                                color: AppColor().primaryWhite,
                                fontSize: 15,
                                fontFamily: "InterSemiBold"),
                            radius: 10,
                            confirm: Column(
                              children: [
                                CustomFillButton(
                                  onTap: () {
                                    pickImageFromGallery();
                                    Get.back();
                                  },
                                  height: 45,
                                  width: Get.width * 0.5,
                                  buttonText: 'Upload from gallery',
                                  textColor: AppColor().primaryWhite,
                                  buttonColor: AppColor().primaryColor,
                                  boarderColor: AppColor().primaryColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                const Gap(10),
                                CustomFillButton(
                                  onTap: () {
                                    pickImageFromCamera();
                                    Get.back();
                                  },
                                  height: 45,
                                  width: Get.width * 0.5,
                                  buttonText: 'Upload from camera',
                                  textColor: AppColor().primaryWhite,
                                  buttonColor: AppColor().primaryColor,
                                  boarderColor: AppColor().primaryColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ],
                            ),
                            middleTextStyle: TextStyle(
                              color: AppColor().primaryWhite,
                              fontFamily: 'Inter',
                              fontSize: 14,
                            ),
                          );
                        } else {
                          clearPhoto();
                        }
                      },
                      child: CustomText(
                        title: imageFile == null ? 'Click to upload' : 'Cancel',
                        size: 15,
                        fontFamily: 'InterMedium',
                        color: AppColor().primaryColor,
                        underline: TextDecoration.underline,
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: 'Max file size: 4MB',
                      color: AppColor().primaryWhite,
                      textAlign: TextAlign.center,
                      fontFamily: 'Inter',
                      size: 12,
                    ),
                  ],
                ),
              ),
              const Gap(20),
              CustomText(
                title: "Has livestream?",
                color: AppColor().primaryWhite,
              ),
              Row(
                children: [
                  Row(children: [
                    CustomText(title: "Yes", color: AppColor().primaryWhite),
                    Radio<bool>(
                      value: true,
                      activeColor: AppColor().primaryColor,
                      groupValue: _hasLivestream,
                      onChanged: (value) {
                        setState(() {
                          _hasLivestream = true;
                        });
                      },
                    )
                  ]),
                  Row(children: [
                    CustomText(title: "No", color: AppColor().primaryWhite),
                    Radio<bool>(
                      value: false,
                      activeColor: AppColor().primaryColor,
                      groupValue: _hasLivestream,
                      onChanged: (value) {
                        setState(() {
                          _hasLivestream = false;
                        });
                      },
                    )
                  ])
                ],
              ),
              if (_hasLivestream)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    fontFamily: 'InterMedium',
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
                            fontFamily: 'InterMedium',
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    Gap(Get.height * 0.02),
                    CustomText(
                      title: "Streaming Platform link",
                      color: AppColor().primaryWhite,
                      size: 16,
                    ),
                    Gap(Get.height * 0.01),
                    CustomTextField(
                      textEditingController: tournamentController
                          .addFixtureStreamingLinkController,
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
                  ],
                ),
              Gap(Get.height * 0.02),
              CustomText(
                title: "Has the fixture been played?",
                color: AppColor().primaryWhite,
              ),
              Row(
                children: [
                  Row(children: [
                    CustomText(title: "Yes", color: AppColor().primaryWhite),
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
                        title: "Home Team Score",
                        color: AppColor().primaryWhite,
                        size: 16,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        textEditingController: tournamentController
                            .addFixturesHomeTeamScoreController,
                      ),
                      Gap(Get.height * 0.02),
                      CustomText(
                        title: "Away Team Score",
                        color: AppColor().primaryWhite,
                        size: 16,
                      ),
                      Gap(Get.height * 0.01),
                      CustomTextField(
                        textEditingController: tournamentController
                            .addFixturesAwayTeamScoreController,
                      ),
                    ]),
              ),
              Gap(Get.height * 0.02),
              GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await tournamentController.createFixtureForTeam(
                        widget.event.id!,
                        widget.event.community!.id!,
                        imageFile,
                        _hasLivestream);
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
                                  fontFamily: "InterSemiBold",
                                  color: AppColor().primaryWhite))))
            ],
          ),
        ),
      ),
    );
  }
}
