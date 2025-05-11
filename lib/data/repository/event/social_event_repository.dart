import 'dart:io';

import 'package:e_sport/data/model/community_model.dart';
import 'package:e_sport/data/model/player_model.dart';
import 'package:e_sport/data/repository/auth_repository.dart';
import 'package:e_sport/data/repository/event/event_repository.dart';
import 'package:e_sport/di/api_link.dart';
import 'package:e_sport/ui/widgets/utils/create_success_page.dart';
import 'package:e_sport/ui/widgets/custom/custom_text.dart';
import 'package:e_sport/util/colors.dart';
import 'package:e_sport/util/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// Response model to handle the new backend structure
class ApiResponse<T> {
  final String? message;
  final bool success;
  final T? data;

  ApiResponse({
    this.message,
    required this.success,
    this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>)? fromJson) {
    return ApiResponse(
      message: json['message'],
      success: json['success'] ?? false,
      data: json['data'] != null && fromJson != null
          ? fromJson(json['data'])
          : null,
    );
  }
}

class SocialEventRepository extends GetxController {
  final eventController = Get.put(EventRepository());
  final authController = Get.put(AuthRepository());
  final Rx<CommunityModel?> organizingCommunity = Rx(null);
  late final dio.Dio _dio;

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
  final TextEditingController eventHashtagController = TextEditingController();

  Rx<GamePlayed?> gameValue = Rx(null);
  Rx<DateTime?> date = Rx(null);
  Rx<File?> mEventCoverImage = Rx(null);
  File? get eventCoverImage => mEventCoverImage.value;

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    _dio = dio.Dio(dio.BaseOptions(
      baseUrl: ApiLink.baseurl,
      contentType: 'application/json',
      responseType: dio.ResponseType.json,
    ));

    // Add an interceptor to handle authentication
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token to header if it exists
        if (authController.token.isNotEmpty && authController.token != "0") {
          options.headers['Authorization'] = 'JWT ${authController.token}';
        }
        return handler.next(options);
      },
      onError: (dio.DioException error, handler) async {
        // Handle token refresh if 401 error occurs
        if (error.response?.statusCode == 401) {
          try {
            await authController.refreshToken();
            // Retry the request with updated token
            final opts = dio.Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers
                ..['Authorization'] = 'JWT ${authController.token}',
            );
            final response = await _dio.request(
              error.requestOptions.path,
              options: opts,
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
            );
            return handler.resolve(response);
          } catch (e) {
            // If refresh token fails, proceed with original error
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

  // Safe API call method
  Future<T?> _safeApiCall<T>(Future<dio.Response> Function() apiCall,
      {T Function(Map<String, dynamic>)? fromJson,
      Function(bool)? setStatus,
      Function(T?)? onSuccess}) async {
    try {
      if (setStatus != null) setStatus(true);
      final response = await apiCall();

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final apiResponse = ApiResponse.fromJson(
            response.data is Map<String, dynamic>
                ? response.data
                : {'success': true, 'data': response.data},
            fromJson);

        if (apiResponse.message != null) {
          Helpers().showCustomSnackbar(message: apiResponse.message!);
        }

        if (onSuccess != null) {
          onSuccess(apiResponse.data);
        }

        return apiResponse.data;
      } else {
        throw dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Unexpected status code: ${response.statusCode}');
      }
    } catch (error) {
      handleError(error);
      return null;
    } finally {
      if (setStatus != null) setStatus(false);
    }
  }

  void handleError(dynamic error) {
    debugPrint("error $error");
    String errorMessage = 'An error occurred';

    if (error is dio.DioException) {
      if (error.type == dio.DioExceptionType.connectionTimeout ||
          error.type == dio.DioExceptionType.connectionError ||
          error.type == dio.DioExceptionType.unknown) {
        errorMessage = 'No internet connection!';
      } else if (error.response != null) {
        final responseData = error.response?.data;
        if (responseData != null && responseData is Map) {
          errorMessage =
              responseData['message'] ?? error.message ?? 'Server error';
        }
      }
    } else {
      errorMessage = error.toString();
    }

    Fluttertoast.showToast(
        fontSize: Get.height * 0.015,
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

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
    eventHashtagController.clear();
    partnersController.clear();
  }

  Future<void> pickImageFromGallery(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      mEventCoverImage(File(image.path));
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  Future<void> pickImageFromCamera(String? title) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      mEventCoverImage(File(image.path));
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
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
      ),
    );
  }

  Future<void> createSocialEvent() async {
    return _safeApiCall(() async {
      eventController.createEventStatus(CreateEventStatus.loading);

      // Prepare form data
      final formData = dio.FormData();
      formData.fields.addAll([
        MapEntry('name', eventNameController.text),
        MapEntry('description', eventDescController.text),
        MapEntry('entry_fee',
            eventController.currency.value + entryFeeController.text),
        MapEntry('igames', gameValue.value!.id!.toString()),
        MapEntry('reg_start', regStartDateController.text),
        MapEntry('reg_end', regEndDateController.text),
        MapEntry('hashtag', eventHashtagController.text),
        MapEntry('event_type', 'social'),
        MapEntry('venue', eventVenueController.text),
        MapEntry('link', eventLinkController.text),
      ]);

      // Format date and time fields
      var startTime = DateFormat.jm().parse(startTimeController.text);
      var endTime = DateFormat.jm().parse(endTimeController.text);
      formData.fields.addAll([
        MapEntry('start',
            "${eventDateController.text}T${DateFormat("HH:mm").format(startTime)}"),
        MapEntry('end',
            "${eventDateController.text}T${DateFormat("HH:mm").format(endTime)}"),
        MapEntry('start_date', eventDateController.text),
        MapEntry('end_date', eventDateController.text),
      ]);

      // Add image if available
      if (eventCoverImage != null) {
        formData.files.add(MapEntry(
          'banner',
          await dio.MultipartFile.fromFile(eventCoverImage!.path),
        ));
      }

      // Configure headers
      final options = dio.Options(
        headers: {
          "Content-Type": "multipart/form-data",
        },
      );

      return _dio.post(
        ApiLink.createTournament(organizingCommunity.value!.slug!),
        data: formData,
        options: options,
      );
    }, setStatus: (loading) {
      if (!loading) {
        eventController.createEventStatus(CreateEventStatus.success);
      }
    }, onSuccess: (_) {
      Get.to(() => const CreateSuccessPage(title: 'Event Created'))!
          .then((value) {
        eventController.getAllEvents(false);
        clear();
      });
    });
  }

  Future<void> registerForSocialEvent(int id) async {
    return _safeApiCall(
        () => _dio.put(
              ApiLink.registerForSocialEvent(id),
              options: dio.Options(
                headers: {
                  "Content-Type": "application/json",
                },
              ),
            ), onSuccess: (data) {
      // Success is already handled by showing message in _safeApiCall
    });
  }
}
