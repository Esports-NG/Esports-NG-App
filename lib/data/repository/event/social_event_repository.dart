import 'dart:io';

import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/home/components/create_success_page.dart';
import 'package:e_sport/ui/widget/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SocialEventRepository extends GetxController {
  final eventController = Get.put(EventRepository());
  final authController = Get.put(AuthRepository());

  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController regStartDateController = TextEditingController();
  final TextEditingController regEndDateController = TextEditingController();
  final TextEditingController communitiesOwnedController =
      TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescController = TextEditingController();
  final TextEditingController entryFeeController = TextEditingController();
  final TextEditingController gameCoveredController = TextEditingController();
  final TextEditingController eventVenueController = TextEditingController();
  final TextEditingController eventLinkController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController partnersController = TextEditingController();

  Rx<DateTime?> date = Rx(null);

  // Rx<File?> mEventProfileImage = Rx(null);
  Rx<File?> mEventCoverImage = Rx(null);
  // File? get eventProfileImage => mEventProfileImage.value;
  File? get eventCoverImage => mEventCoverImage.value;

  void clearPhoto() {
    debugPrint('image cleared');
    mEventCoverImage.value = null;
  }

  void clear() {
    eventNameController.clear();
    eventDescController.clear();
    entryFeeController.clear();
    regStartDateController.clear();
    regEndDateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    eventVenueController.clear();
    eventLinkController.clear();
    eventDateController.clear();
  }

  void handleError(dynamic error) {
    debugPrint("error $error");
    Fluttertoast.showToast(
        fontSize: Get.height * 0.015,
        msg: (error.toString().contains("esports-ng.vercel.app") ||
                error.toString().contains("Network is unreachable"))
            ? 'Event like: No internet connection!'
            : (error.toString().contains("FormatException"))
                ? 'Event like: Internal server error, contact admin!'
                : error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  Future pickImageFromGallery(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);

      mEventCoverImage(imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  Future pickImageFromCamera(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);

      mEventCoverImage(imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('$e');
    }
  }

  Widget pickCoverImage({VoidCallback? onTap}) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(Get.height * 0.04),
        decoration: BoxDecoration(
            color: AppColor().bgDark, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              eventCoverImage == null
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
                            image: FileImage(eventCoverImage!),
                            fit: BoxFit.cover),
                      ),
                    ),
              Gap(Get.height * 0.01),
              InkWell(
                onTap: onTap,
                child: CustomText(
                  title: eventCoverImage == null ? 'Click to upload' : 'Cancel',
                  weight: FontWeight.w400,
                  size: 15,
                  fontFamily: 'GilroyMedium',
                  color: AppColor().primaryColor,
                  underline: TextDecoration.underline,
                ),
              ),
              Gap(Get.height * 0.02),
              CustomText(
                title: 'Max file size: 4MB',
                color: AppColor().primaryWhite,
                textAlign: TextAlign.center,
                fontFamily: 'GilroyRegular',
                size: Get.height * 0.014,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createSocialEvent() async {
    try {
      eventController.createEventStatus(CreateEventStatus.loading);
      var headers = {
        "Content-Type": "application/json",
        "Authorization": 'JWT ${authController.token}'
      };
      var startTime = DateFormat.jm().parse(startTimeController.text);
      var endTime = DateFormat.jm().parse(endTimeController.text);

      var request =
          http.MultipartRequest("POST", Uri.parse(ApiLink.createSocialEvent))
            ..fields["name"] = eventNameController.text
            ..fields["description"] = eventDescController.text
            ..fields["entry_fee"] = entryFeeController.text
            ..fields["igames"] = gameCoveredController.text
            ..fields["registration_start"] = regStartDateController.text
            ..fields["registration_end"] = regEndDateController.text
            ..fields["start"] =
                "${eventDateController.text}T${DateFormat("HH:mm").format(startTime)}"
            ..fields["end"] =
                "${eventDateController.text}T${DateFormat("HH:mm").format(endTime)}"
            ..fields["venue"] = eventVenueController.text
            ..fields["link"] = eventLinkController.text;

      request.files.add(
          await http.MultipartFile.fromPath('image', eventCoverImage!.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        eventController.createEventStatus(CreateEventStatus.success);
        debugPrint(await response.stream.bytesToString());
        Get.to(() => const CreateSuccessPage(title: 'Event Created'))!
            .then((value) {
          eventController.getAllSocialEvents(false);
          clear();
        });
      } else if (response.statusCode == 401) {
        authController
            .refreshToken()
            .then((value) => EasyLoading.showInfo('try again!'));
        eventController.createEventStatus(CreateEventStatus.error);
      } else {
        eventController.createEventStatus(CreateEventStatus.error);
        debugPrint(response.reasonPhrase);
        handleError(response.reasonPhrase);
      }
    } catch (error) {
      eventController.createEventStatus(CreateEventStatus.error);
      debugPrint("Error occurred ${error.toString()}");
      handleError(error);
    }
  }
}
