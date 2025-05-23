import 'dart:convert';
import 'dart:io';

import 'package:e_sport/data/model/platform_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/tournament_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/utils/back_button.dart';
import 'package:e_sport/ui/widgets/utils/buttonLoader.dart';
import 'package:e_sport/ui/widgets/custom/custom_textfield.dart';
import 'package:e_sport/ui/widgets/custom/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateLivestream extends StatefulWidget {
  const CreateLivestream({super.key});

  @override
  State<CreateLivestream> createState() => _CreateLivestreamState();
}

class _CreateLivestreamState extends State<CreateLivestream> {
  TextEditingController streamTitleController = TextEditingController();
  TextEditingController streamDescriptionController = TextEditingController();
  TextEditingController streamImageController = TextEditingController();
  TextEditingController gameCoveredController = TextEditingController();
  TextEditingController streamLinkController = TextEditingController();
  File? imageFile;

  PlatformModel? _platform;
  DateTime? _streamDate;
  TimeOfDay? _streamTime;
  List<PlatformModel> _platforms = [];

  final authController = Get.put(AuthRepository());
  final tournamentController = Get.put(TournamentRepository());

  bool _loading = false;

  Future<void> getPlatforms() async {
    var response = await http.get(Uri.parse(ApiLink.getPlatforms),
        headers: {"Authorization": "JWT ${authController.token}"});

    var responseJson = jsonDecode(response.body);

    var platformsList = List<PlatformModel>.from(
        responseJson['data'].map((x) => PlatformModel.fromJson(x)));

    setState(() {
      _platforms = platformsList;
    });
  }

  Future<void> createLivestream() async {
    print("creating livestream");
    setState(() {
      _loading = true;
    });
    try {
      await tournamentController.createLivestream(
          streamTitleController.text,
          streamDescriptionController.text,
          streamLinkController.text,
          _platform!.id!,
          imageFile,
          _streamDate!,
          _streamTime!);
    } catch (err) {
      print(err);
    }
    print("finished creating livestream");
    setState(() {
      _loading = false;
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
    super.initState();
    getPlatforms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().primaryBackGroundColor,
        centerTitle: true,
        elevation: 0,
        title: CustomText(
          title: 'Create Livestream',
          fontFamily: "InterSemiBold",
          size: 18,
          color: AppColor().primaryWhite,
        ),
        leading: GoBackButton(onPressed: () => Get.back()),
      ),
      backgroundColor: AppColor().primaryBackGroundColor,
      body: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: 'Stream Title *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: 14,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  hint: "Enter stream title",
                  textEditingController: streamTitleController,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Stream Description *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: 14,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  minLines: 3,
                  maxLines: 5,
                  hint: "Enter stream description",
                  textEditingController: streamDescriptionController,
                ),
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Stream Image *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: 14,
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
                          title:
                              imageFile == null ? 'Click to upload' : 'Cancel',
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
                Gap(Get.height * 0.02),
                CustomText(
                  title: 'Stream Date *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: 14,
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
                          initialDate: _streamDate ?? initialDate,
                          firstDate: DateTime(DateTime.now().year - 40),
                          lastDate: DateTime(DateTime.now().year + 5),
                        );
                        setState(() {
                          _streamDate = date;
                        });
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
                            _streamDate != null
                                ? CustomText(
                                    title:
                                        DateFormat.yMMMd().format(_streamDate!),
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
                            initialTime: _streamTime ?? initialTime);
                        setState(() {
                          _streamTime = time;
                        });
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
                            _streamTime != null
                                ? CustomText(
                                    title:
                                        "${_streamTime!.hour}:${_streamTime!.minute}",
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
                  title: 'Stream Platform *',
                  color: AppColor().primaryWhite,
                  textAlign: TextAlign.center,
                  fontFamily: 'Inter',
                  size: 14,
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
                    child: DropdownButton<PlatformModel>(
                      dropdownColor: AppColor().primaryDark,
                      borderRadius: BorderRadius.circular(10),
                      value: _platform,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColor().lightItemsColor,
                      ),
                      items: _platforms
                          .where((_platform) =>
                              _platform.platformType!.contains('streaming'))
                          .map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Row(
                            children: [
                              Image.network(
                                "${value.logo}",
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
                        setState(() {
                          _platform = value;
                        });
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
                  title: "Stream link",
                  color: AppColor().primaryWhite,
                  size: 14,
                ),
                Gap(Get.height * 0.01),
                CustomTextField(
                  textEditingController: streamLinkController,
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
                CustomFillButton(
                  buttonText: "Create Livestream",
                  onTap: createLivestream,
                  isLoading: _loading,
                )
              ],
            ),
          )),
    );
  }
}
